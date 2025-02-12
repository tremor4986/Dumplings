$Domain = 'https://www.aladin.co.kr/m/mevent.aspx?EventId=212360'
$Object1 = Invoke-WebRequest -Uri $Domain | ConvertFrom-Html
$DownloadUrl = $Object1.SelectSingleNode('/html/body/div[5]/div[3]/div/ul[1]/li[1]/a').Attributes['href'].Value

# Version
$this.CurrentState.Version = [regex]::Match(
  $DownloadUrl, '(\d+.\d+.\d+.\d+)'
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
