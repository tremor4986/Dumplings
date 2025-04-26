$Object1 = Invoke-RestMethod -Uri 'https://ebook-sync.aladin.co.kr/Service/Application/Secure/GetApplicationUpdate' `
  -Method Post -Headers @{ 'Content-Type' = 'application/json' } -Body '{}'

# Version
$this.CurrentState.Version = [regex]::Match(
  $Object1.DownloadUrl, '(\d+.\d+.\d+.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.DownloadUrl
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
