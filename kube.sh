alias dp-auth="dp auth login \$(whoami)" # dp auth login also works

function k-activate-cluster() {
    CLUSTER=$1
    ME=$(whoami)
    dp auth configure-kubeconfig --cluster-name "${CLUSTER}" --account-name "$ME"@tinkoff.ru
}

alias k-activate-cluster-qa='k-activate-cluster ya-ruc1-dev1.dev'
alias k-activate-cluster-prod='k-activate-cluster ds-prod2.prod'
alias k-activate-cluster-prod-m1='k-activate-cluster m1-prod2.prod'
alias k-activate-cluster-prod-m2='k-activate-cluster ix-m2-prod2.prod'

alias k='kubectl'

function k-activate-ns() {
  NS=$(k get ns --output=custom-columns=NAME:.metadata.name | find_entity "$@") || return 1
  k config set-context --current --namespace "$NS"
}

alias kan='k-activate-ns'
