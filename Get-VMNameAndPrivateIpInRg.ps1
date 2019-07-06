#List all the VMs in a give RG together with their private IP
#Invoke it like this: Get-VMNameAndPrivateIpInRG <Azure Subscription Name> <Resource Group Name>

function Get-VMNameAndPrivateIpInRG
{
	Param ([string]$subName,[string]$rgName)
	Connect-AzAccount
    $subscription=Get-AzSubscription -SubscriptionName $subName
	Set-AzContext -Subscription $subscription.SubscriptionId
    $vms=Get-AzResource -ResourceType Microsoft.Compute/virtualMachines -ResourceGroupName $rgName 

    $nics = get-aznetworkinterface -ResourceGroupName $rgName| where VirtualMachine -NE $null #skip Nics with no VM

    foreach($nic in $nics)
    {
        $vm = $vms | where-object -Property Id -EQ $nic.VirtualMachine.id
        $prv =  $nic.IpConfigurations | select-object -ExpandProperty PrivateIpAddress
        Write-Output "$($vm.Name) : $prv"
	}
}