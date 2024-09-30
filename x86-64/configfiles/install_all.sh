#!/bin/bash
chmod 755 *
sh configfiles/00_dns_records.sh
sh configfiles/01_update_ip_tables.sh
sh configfiles/02_install_containerd.sh
sh configfiles/03_install_runc.sh
sh configfiles/04_install_cni.sh
sh configfiles/05_install_kube.sh
sh configfiles/06_crictl.sh