docker build -t danwithaplan112/multi-client:latest -t danwithaplan112/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t danwithaplan112/multi-server:latest -t danwithaplan112/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t danwithaplan112/multi-worker:latest -f -t danwithaplan112/multi-worker:$SHA ./worker/Dockerfile ./worker

docker push danwithaplan112/multi-client:latest
docker push danwithaplan112/multi-server:latest
docker push danwithaplan112/multi-worker:latest

docker push danwithaplan112/multi-client:$SHA
docker push danwithaplan112/multi-server:$SHA
docker push danwithaplan112/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=danwithaplan112/multi-server:$SHA
kubectl set image deployments/client-deployment client=danwithaplan112/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=danwithaplan112/multi-worker:$SHA