#!/bin/bash
multipass transfer -v -r configfiles/09* 169.254.124.199:/tmp/
multipass exec -n nfsserver -- bash /tmp/configfiles/09_1_install_nfs.sh
multipass exec -n kubemaster1 -- bash /tmp/configfiles/09_2_install_nfs.sh
