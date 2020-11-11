docker build -t leinadmahpel/multi-client:latest -t leinadmahpel/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t leinadmahpel/multi-server:latest -t leinadmahpel/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t leinadmahpel/multi-worker:latest -f -t leinadmahpel/multi-worker:$SHA ./worker/Dockerfile ./worker

docker push leinadmahpel/multi-client:latest
docker push leinadmahpel/multi-server:latest
docker push leinadmahpel/multi-worker:latest

docker push leinadmahpel/multi-client:$SHA
docker push leinadmahpel/multi-server:$SHA
docker push leinadmahpel/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=leinadmahpel/multi-server:$SHA
kubectl set image deployments/client-deployment client=leinadmahpel/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=leinadmahpel/multi-worker:$SHA