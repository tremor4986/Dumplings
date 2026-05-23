$Url = 'https://boss.ddangyo.com/o2o/shop/cm/requestPcaInstallURL'
$Response = Invoke-RestMethod -Uri $Url

$DownloadUrl = $Response.dwUrl.download_url
$FileName = $Response.dwUrl.exe_file_nm

# Version
$this.CurrentState.Version = [regex]::Match(
  $FileName, '(\d+\.\d+\.\d+)'
).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $DownloadUrl
}

switch -Regex ($this.Check()) {
  'New|Changed|Updated' {
    $this.Print()
    $this.Write()
  }
  'Changed|Updated' {
    $this.Message()
  }
  'Updated' {
    $this.Submit()
  }
}