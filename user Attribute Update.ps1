#import csv
$csv = import-csv -path 
#iterate through each
$output = @()
$userImport = @()
$Errors = @()
$csv | foreach-object {
	$user = ($_.mail -split '@')[0]
	$ADUser = get-aduser -filter {samaccountname -like $user} -Properties:*
	$userImport = @{
		title = if ($_.title -like $null){$null}else{$_.title}
		streetaddress = if ($_.streetaddress -like $null){$null}else{$_.streetaddress}
		city = if ($_.city -like $null){$null}else{$_.city}
		state = if ($_.state -like $null){$null}else{$_.state}
		postalcode = if ($_.postalcode -like $null){$null}else{$_.postalcode}
		country = if ($_.country -like $null){$null}else{$_.country}
		telephonenumber = if ($_.telephonenumber -like $null){$null}else{$_.telephonenumber}
		mobile = if ($_.mobile -like $null){$null}else{$_.mobile}
		department = if ($_.department -like $null){$null}else{$_.department}
		Company = if ($_.Company -like $null){$null}else{$_.Company}
		mail = if ($_.mail -like $null){$null}else{$_.mail}
	}
	if ($aduser -ne $null)
	{
		Write-Host "$user was found" -ForegroundColor Green 
		set-aduser -identity $aduser.samaccountname -title $userImport.title -streetaddress $userImport.streetaddress -city $userImport.city -state $userImport.state -postalcode $userImport.postalcode 
		set-aduser -identity $aduser.samaccountname -OfficePhone $userImport.telephonenumber -MobilePhone $userImport.mobile -department $userImport.department -Company $userImport.company
		$userImport.add('status','Success')
	}
	else 
	{
		Write-Host "$user was not found" -ForegroundColor Red
		$userImport.add('status','Failed')
		$errors += New-Object PSObject -Property $userImport
	}
	$output += New-Object PSObject -Property $userImport
}

$output | export-csv -NoTypeInformation -Path c:\temp\output.csv