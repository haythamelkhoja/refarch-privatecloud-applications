echo Creating namespace...
./create_namespace.sh mq

echo Destroying IBM MQ...
helm delete --purge mq

echo Deploying IBM MQ...
helm install -n mq --set license=accept ibm/ibm-mqadvanced-server-dev 
