$Domain = 'http://down.fingerservice.co.kr/'
$Object1 = Invoke-WebRequest -Uri $Domain | ConvertFrom-Html
$DownloadUrl = $Domain + $Object1.SelectSingleNode('/html/body/div/div[3]/a').Attributes['href'].Value

# Version

$this.CurrentState.Version = [regex]::Match(
  $DownloadUrl, '(\d+\.\d+\.\d+)'
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