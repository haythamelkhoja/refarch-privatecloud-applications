function deploy_ldap {
	echo Deploying LDAP chart
	helm repo add cnct http://atlas.cnct.io
	helm install --name ldap cnct/openldap
}

./create_namespace.sh ldap

#deploy_ldap

PASSWORD=testuser
USER="uid=testuser,ou=people,dc=local,dc=io"

echo Testing connection
POD_ID=$(kubectl get po | grep ldap | grep -v admin | awk '{print $1}')
echo Pod: $POD_ID

kubectl exec $POD_ID -- ldapsearch -x -h localhost -b dc=local,dc=io -D "$USER" -w $PASSWORD

echo Copying file
kubectl cp ldap_config/default.ldif $POD_ID:/container/service/slapd/assets/test/

echo Importing LDIF
kubectl exec $POD_ID --  ldapadd -x -h localhost -D "$USER" -w $PASSWORD -f /container/service/slapd/assets/test/default.ldif

echo Testing user
kubectl exec $POD_ID -- ldapsearch -x -LLL -D "$USER" -w $PASSWORD -b "uid=testuser,ou=people,dc=local,dc=io" -s sub "(objectClass=person)" uid

echo ==========================
echo 
echo LDAP admin available at http://169.45.207.215:31080/
echo user: $USER, pwd: $PASSWORD
