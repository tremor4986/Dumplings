$Object1 = Invoke-WebRequest -Uri 'http://down.fingerservice.co.kr/' | ConvertFrom-Html

# Version
$this.CurrentState.Version = $Object1.Product.Version.Dir

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.SelectSingleNode('/html/body/div/div[3]/a').Attributes['href'].Value
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