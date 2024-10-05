$Object1 = Invoke-WebRequest -Uri 'https://syncroom.yamaha.com/global/v2/play/dl/' | ConvertFrom-Html

# Version

$this.CurrentState.Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div/main/div/div[2]/div/div[1]/div/a[1]').Attributes['href'].Value, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://syncroom.yamaha.com" + $Object1.SelectSingleNode('/html/body/div/main/div/div[2]/div/div[1]/div/a[1]').Attributes['href'].Value
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