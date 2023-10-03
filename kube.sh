NAME=$(whoami)

alias dp-auth='dp auth login $NAME'  # dp auth login also works
alias kaqa='dp auth configure-kubeconfig --cluster-name ya-ruc1-dev1.dev --account-name $NAME@tinkoff.ru'
alias kaprod='dp auth configure-kubeconfig --cluster-name ds-prod2.prod --account-name $NAME@tinkoff.ru'
alias kaprod_m1='dp auth configure-kubeconfig --cluster-name m1-prod2.prod --account-name $NAME@tinkoff.ru'
alias k='kubectl'
alias kan='k config set-context --current --namespace'
