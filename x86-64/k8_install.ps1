#start vms
echo "Starting VMs"
function mac_random {
  $mac = (0..5 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15), (Get-Random -Minimum 0 -Maximum 15) }) -join ':'
  return $mac

}

echo "Starting ControlPane"
$subnet="10.0.0"
$i = 1
$control = 1
for (; $i -le $control; $i++) {
  $MACADDR = mac_random
  $ip = "${subnet}.11${i}"
  # Write-Host $MACADDR
  multipass launch --disk 20G --memory 2G --cpus 2 --name control0${i} --cloud-init cloud-init-win.yaml --network name=multipass,mode=manual,mac="${MACADDR}" noble
$yamlContent = @"
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses: [$ip/20]
"@
  Set-Content -Path "10-custom_control0${i}.yaml" -Value $yamlContent
  Start-Sleep -s 10
  multipass transfer 10-custom_control0${i}.yaml control0${i}:10-custom.yaml
  multipass exec control0${i} -- sudo cp 10-custom.yaml /etc/netplan/
  multipass exec control0${i} -- sudo chmod 600 /etc/netplan/10-custom.yaml 
  # multipass restart control0${i}
  Start-Sleep -s 10
}

echo "Starting Worker"
$i = 1
$worker = 3
for (; $i -le $worker; $i++) {
  $MACADDR = mac_random
  $ip = "${subnet}.20${i}"
  # Write-Host $MACADDR
  multipass launch --disk 20G --memory 1G --cpus 1 --name worker0${i} --cloud-init cloud-init-win.yaml --network name=multipass,mode=manual,mac="${MACADDR}" noble
$yamlContent = @"
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses: [$ip/20]
"@
  Set-Content -Path "10-custom_worker0${i}.yaml" -Value $yamlContent
  Start-Sleep -s 10
  multipass transfer 10-custom_worker0${i}.yaml worker0${i}:10-custom.yaml
  multipass exec worker0${i} -- sudo cp 10-custom.yaml /etc/netplan/
  multipass exec worker0${i} -- sudo chmod 600 /etc/netplan/10-custom.yaml 
  # multipass restart worker0${i}
  Start-Sleep -s 10
}



echo "Starting NFS"
$i = 1
$nfs = 1
for (; $i -le $nfs; $i++) {
  $MACADDR = mac_random
  $ip = "${subnet}.199"
  # Write-Host $MACADDR
  multipass launch --disk 20G --memory 1G --cpus 1 --name nfsserver --cloud-init cloud-init-win-nfs.yaml --network name=multipass,mode=manual,mac="${MACADDR}" noble

$yamlContent = @"
network:
  version: 2
  ethernets:
    eth1:
      dhcp4: no
      addresses: [$ip/20]
"@
  Set-Content -Path "10-custom_nfsserver.yaml" -Value $yamlContent
  Start-Sleep -s 10
  multipass transfer 10-custom_nfsserver.yaml nfsserver:10-custom.yaml
  multipass exec nfsserver -- sudo cp 10-custom.yaml /etc/netplan/
  multipass exec nfsserver -- sudo chmod 600 /etc/netplan/10-custom.yaml 
  # multipass restart nfsserver
  Start-Sleep -s 10
}

multipass restart --all