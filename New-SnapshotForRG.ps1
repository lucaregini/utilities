
#take a snapshot of all VMs in a given Resource Group.
#Invoke it like this: New-SnapshotForRG <Azure Subscription Name> <Resource Group Name>
function New-SnapshotForRG
{
    Param ([string]$subName,[string]$rgName)
    Connect-AzAccount
    $subscription=Get-AzSubscription -SubscriptionName $subName

    Set-AzContext -Subscription $subscription.SubscriptionId

    $disks=Get-AzResource -ResourceType Microsoft.Compute/Disks -ResourceGroupName $rgName 
    $location = 'WestEurope'

    Foreach ($disk in $disks)
    {
       $snapshotName=-join($disk.Name,"_snapshot")
       
       $snapshotConfig = New-AzSnapshotConfig -SourceUri $disk.Id -Location $location -CreateOption copy
       New-AzSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $rgName
    }
}

