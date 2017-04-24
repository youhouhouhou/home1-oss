#!/usr/bin/env bash

### OSS CI CONTEXT VARIABLES BEGIN
if [ -n "${CI_BUILD_REF_NAME}" ] && ([ "${CI_BUILD_REF_NAME}" == "master" ] || [ "${CI_BUILD_REF_NAME}" == "develop" ]); then BUILD_SCRIPT_REF="${CI_BUILD_REF_NAME}"; else BUILD_SCRIPT_REF="develop"; fi
if [ -z "${GIT_SERVICE}" ]; then
    if [ -n "${CI_PROJECT_URL}" ]; then INFRASTRUCTURE="internal"; GIT_SERVICE=$(echo "${CI_PROJECT_URL}" | sed 's,/*[^/]\+/*$,,' | sed 's,/*[^/]\+/*$,,'); else INFRASTRUCTURE="local"; GIT_SERVICE="${LOCAL_GIT_SERVICE}"; fi
fi
if [ -z "${GIT_REPO_OWNER}" ]; then
    if [ -n "${TRAVIS_REPO_SLUG}" ]; then
        GIT_REPO_OWNER=$(echo ${TRAVIS_REPO_SLUG} | awk -F/ '{print $1}');
    else
        if [ -z "${INTERNAL_GIT_SERVICE_USER}" ]; then GIT_REPO_OWNER="infra"; else GIT_REPO_OWNER="${INTERNAL_GIT_SERVICE_USER}"; fi
    fi
fi
### OSS CI CONTEXT VARIABLES END

export BUILD_PUBLISH_DEPLOY_SEGREGATION="true"
export BUILD_SITE="true"
export BUILD_SITE_PATH_PREFIX="oss"


export BUILD_TEST_FAILURE_IGNORE="false"
export BUILD_TEST_SKIP="false"



### OSS CI CALL REMOTE CI SCRIPT BEGIN
echo "eval \$(curl -s -L ${GIT_SERVICE}/${GIT_REPO_OWNER}/oss-build/raw/${BUILD_SCRIPT_REF}/src/main/ci-script/ci.sh)"
eval "$(curl -s -L ${GIT_SERVICE}/${GIT_REPO_OWNER}/oss-build/raw/${BUILD_SCRIPT_REF}/src/main/ci-script/ci.sh)"
### OSS CI CALL REMOTE CI SCRIPT END

if [ "${1}" != "test_and_build" ] && ([ "${GIT_REPO_OWNER}" != "home1-oss" ] || [ "pull_request" == "${TRAVIS_EVENT_TYPE}" ]); then
    echo "skip deploy/publish on forked repo or which trigger by pull request "
else
    $@
fi

function get_git_domain() {
  local git_service="${1}"
  local git_host_port=$(echo ${git_service} | awk -F/ '{print $3}')
  if [[ "${git_service}" == *local-git:* ]]; then
    echo ${git_host_port} | sed -E 's#:[0-9]+$##'
  else
    echo ${git_host_port}
  fi
}

eval "$(curl -s -L ${GIT_SERVICE}/${GIT_REPO_OWNER}/oss-build/raw/${BUILD_SCRIPT_REF}/src/main/install/oss_repositories.sh)"
if [ "test_and_build" == "${1}" ]; then
  echo "build gitbook"
  if [ ! -d src/gitbook/oss-workspace ]; then
        mkdir -p src/gitbook/oss-workspace
  fi
  echo "GIT_SERVICE: ${GIT_SERVICE}"
  source_git_domain="$(get_git_domain "${GIT_SERVICE}")"
  (cd src/gitbook/oss-workspace; clone_oss_repositories "${source_git_domain}")
  for repository in ${!OSS_REPOSITORIES_DICT[@]}; do
    source_git_branch=""
    if [ "release" == "${BUILD_PUBLISH_CHANNEL}" ]; then source_git_branch="master"; else source_git_branch="develop"; fi
    echo "git checkout ${source_git_branch} of ${repository}"
    (cd src/gitbook/oss-workspace/${repository}; git checkout ${source_git_branch} && git pull)
  done
  (cd src/gitbook; ./book.sh "build" "oss-workspace")
else
  echo "upload gitbook"
  (cd src/gitbook; ./book.sh "deploy" "${INFRASTRUCTURE}")
fi
