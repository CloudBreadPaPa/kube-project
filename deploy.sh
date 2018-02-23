#! /bin/sh

# deploy storage
kubectl create -f deployment-storage.yaml
#kubectl get pv        # 동작 안함
kubectl get pvc         # 동작함

kubectl describe pvc    # 이 커맨드를 이용하는 것도 가능하다

# add secret for MySQL
kubectl create secret generic mysql-pass --from-literal=password=P@ssw0rd1234
kubectl get secrets

# deploy MySQL
kubectl create -f deployment-mysql.yaml

# deploy Wordpress
kubectl create -f deployment-wordpress.yaml

kubectl get pods
kubectl get services wordpress


