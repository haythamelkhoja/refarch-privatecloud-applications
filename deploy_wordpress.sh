./create_namespace.sh wordpress

NAME=wordpress

helm delete --purge $NAME
helm install --name $NAME --set ingress.enable=true stable/wordpress