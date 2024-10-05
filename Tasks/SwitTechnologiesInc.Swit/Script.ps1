$Object1 = Invoke-WebRequest -Uri 'https://swit.io/desktop' | ConvertFrom-Html

# Version

$this.CurrentState.Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/app-root/swit-home-new/swit-desktop/div[2]/div[1]/ul/li[1]/a').Attributes['href'].Value, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.SelectSingleNode('/html/body/app-root/swit-home-new/swit-desktop/div[2]/div[1]/ul/li[1]/a').Attributes['href'].Value
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