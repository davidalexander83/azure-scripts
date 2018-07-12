
$vms = get-azurermvm -resourcegroupname DAVIDALEXANDER | where Name -Like "da-w2012-0*"
foreach ($vm in $vms) {
  write-output $VM.Name 
  $location = $vm.Location
  $vmName = read-host -prompt "Enter the new server name for this server"
  $osDisk = get-azurermdisk | where { $_.ManagedBy -eq $vm.Id }
  $osDisk
  $nic = get-azurermnetworkinterface | where { $_.VirtualMachine.Id -eq $vm.Id }
  $nic
  $vmConfig = new-azurermvmconfig -VMName $vmName -VMSize "Standard_B2s"
  $newVM = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id
  $newVM = Set-AzureRmVMOSDisk -VM $newVM -ManagedDiskId $osDisk.Id -CreateOption Attach -Windows
  $newVM = Set-AzureRmVMBootDiagnostics -disable -VM $newVM
  remove-azurermvm -resourcegroupname DAVIDALEXANDER -name $vm.Name
  New-AzureRmVM -resourcegroupname DAVIDALEXANDER -Location $location -VM $newVM
}