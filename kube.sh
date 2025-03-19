alias dp-auth="dp auth login \$(whoami)" # dp auth login also works

function k-activate-cluster() {
    local CLUSTER=$1
    local ME=$(whoami)
    dp auth configure-kubeconfig --cluster-name "${CLUSTER}" --account-name "$ME"@tinkoff.ru
}

# `kubectl config view` to see where cluster names come from
alias kc-qa='k-activate-cluster ya-ruc1-dev1.dev'
alias kc-ds='k-activate-cluster ds-prod2.prod'
alias kc-m1='k-activate-cluster m1-prod2.prod'
alias kc-ix='k-activate-cluster ix-m2-prod2.prod'

alias k='kubectl'

function k-activate-ns() {
  local NS=$(k get ns --output=custom-columns=NAME:.metadata.name | find_entity "$@") || return 1
  k config set-context --current --namespace "$NS"
}

alias kan='k-activate-ns'

function k-get-pods-image() {
  local pattern="$1"
  if [[ -z $pattern ]]; then
    echo "usage: k-get-pod-image <pattern>" >&2
    return 1
  fi

  k get pods -o custom-columns=NAME:.metadata.name | grep $pattern | while read -r line; do
    local image=$(k get pod $line -o jsonpath='{.spec.containers[*].image}')
    echo $line "    " $image
  done
}

function klogs() {
  local pattern=$1
  shift
  if [[ -z $pattern ]]; then
    echo "usage: k-get-pod-image <pattern>" >&2
    return 1
  fi

  local pod=$(k get po -o=custom-columns=NAME:.metadata.name | find_entity "$pattern") || return 1
  k logs $pod "$@"
}

function k-get-deployment-config() {
  local pattern="$1"
  shift
  if [[ -z $pattern ]]; then
    echo "usage: k-get-pod-image <pattern>" >&2
    return 1
  fi
  local deployment=$(k get deployment -o=custom-columns=NAME:.metadata.name | find_entity "$pattern") || return 1
  local config_map=$(k get deployment "$deployment" -o jsonpath="{.spec.template.spec.containers[*].envFrom[*].configMapRef.name}")

  k get configmap "$config_map" -o yaml
}
