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
       #Write-Host $disk.Id
       $snapshotName=-join($disk.Name,"_snapshot")
       #Write-Host $newname

       $snapshotConfig = New-AzSnapshotConfig -SourceUri $disk.Id -Location $location -CreateOption copy
       New-AzSnapshot -Snapshot $snapshotConfig -SnapshotName $snapshotName -ResourceGroupName $rgName

    }

}

