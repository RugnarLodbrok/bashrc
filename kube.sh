alias dp-auth="dp auth login \$(whoami)" # dp auth login also works
alias kaqa="dp auth configure-kubeconfig --cluster-name ya-ruc1-dev1.dev --account-name \$(whoami)@tinkoff.ru"
alias kaprod="dp auth configure-kubeconfig --cluster-name ds-prod2.prod --account-name \$(whoami)@tinkoff.ru"
alias kaprod_m1="dp auth configure-kubeconfig --cluster-name m1-prod2.prod --account-name \$(whoami)@tinkoff.ru"
alias kaprod_m2="dp auth configure-kubeconfig --cluster-name ix-m2-prod2.prod --account-name \$(whoami)@tinkoff.ru"
alias k="kubectl"

function kan() {
  NS=$(k get ns --output=custom-columns=NAME:.metadata.name | find_entity "$@") || return 1
  k config set-context --current --namespace "$NS"
}
