#!/bin/sh
mkdir -p /var/lib/rancher/rke2/server/manifests

cat > /var/lib/rancher/rke2/server/manifests/setup.yaml << EOF
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: backups
  namespace: fleet-local
spec:
  branch: master
  paths:
  - rancher-backup
  - rancher-backup-crd
  repo: https://github.com/ibrokethecloud/core-bundles
  targets:
  - clusterSelector: {}
---      
apiVersion: fleet.cattle.io/v1alpha1
kind: ClusterGroup
metadata:
  name: dev
  namespace: fleet-default
spec:
  selector:
    matchLabels:
      clusterType: dev
---
apiVersion: fleet.cattle.io/v1alpha1
kind: ClusterGroup
metadata:
  name: test
  namespace: fleet-default
spec:
  selector:
    matchLabels:
      clusterType: test
---
apiVersion: fleet.cattle.io/v1alpha1
kind: ClusterGroup
metadata:
  name: prod
  namespace: fleet-default
spec:
  selector:
    matchLabels:
      clusterType: prod 
---
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: monitoring
  namespace: fleet-default
spec:
  branch: master
  paths:
  - monitoring
  - monitoring-crd
  repo: https://github.com/ibrokethecloud/core-bundles
  targets:
  - clusterSelector: {} 
---
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: logging
  namespace: fleet-default
spec:
  branch: master
  paths:
  - logging
  - logging-crd
  repo: https://github.com/ibrokethecloud/core-bundles
  targets:
  - clusterSelector: {}   
---
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: loki
  namespace: fleet-default
spec:
  branch: master
  paths:
  - loki
  repo: https://github.com/ibrokethecloud/user-bundles
  targets:
  - clusterSelector: {}  
---      
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: simpleapp-dev
  namespace: fleet-default
spec:
  branch: dev
  paths:
  - manifests
  repo: https://github.com/ibrokethecloud/fleet-simple-app
  targets:
  - clusterGroup: dev
---
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: simpleapp-test
  namespace: fleet-default
spec:
  branch: test
  paths:
  - manifests
  repo: https://github.com/ibrokethecloud/fleet-simple-app
  targets:
  - clusterGroup: test
---
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: simpleapp-prod
  namespace: fleet-default
spec:
  branch: master
  paths:
  - manifests
  repo: https://github.com/ibrokethecloud/fleet-simple-app
  targets:
  - clusterGroup: prod
---
apiVersion: fleet.cattle.io/v1alpha1
kind: ClusterGroup
metadata:
  name: longhorn
  namespace: fleet-default
spec:
  selector:
    matchLabels:
      longhorn: true
---
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: longhorn
  namespace: fleet-default
spec:
  branch: master
  paths:
  - longhorn
  - longhorn-crd
  repo: https://github.com/ibrokethecloud/core-bundles
  targets:
  - clusterGroup: longhorn
EOF

## Appending some defaults to help manage rancherd
echo 'export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/var/lib/rancher/rke2/bin' >> /root/.bashrc