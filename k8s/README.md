To collocate multiple separate k8s config files into one file, just paste it into one file separated by three hyphens i.e. ---

Create a new file and call it something descriptive like server-config.yml

apiVersion: apps/v1
kind: Deployment
metadata: server-deployment
    replicas: 3 # this is the number of pods we are going to setup
    selector: # this is the selector that the Deployment service will use to find the set of pods created by master that it's going to control
        matchLabels:
            component: server # for the label, it doesnt have to be component : server, it could be partOfApi : asdf
    template: # this is our pod template
        metadata:
            labels: # this must matchup with whatever we have under matchLabels
                component: server
        spec: # this will customize the behavior of each pod that gets created
            containers: # provide a list of containers that this pod is supposed to run
                - name: server
                  image: danwithaplan112/multi-server # note: the express api server expects env variables to be set within the container so it can use it to connect to redis and postgres
                  ports:
                    - containerPort: 5000

---
apiVerson: v1
kind: Service
metadata:
    name: server-cluster-ip-service
spec: # spec specifies how the service behaves
    type: ClusterIP
    selector: # need to provide a selector to tell the service what set of pods it needs to provide access to
        component: server # this is derived from server-deployment.yml under the template property
    ports:
        - port: 5000
          targetPort: 5000
