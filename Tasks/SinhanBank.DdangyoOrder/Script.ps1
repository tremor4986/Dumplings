$Object1 = Invoke-WebRequest -Uri 'http://down.fingerservice.co.kr/' | ConvertFrom-Html

# Version

$this.CurrentState.Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/div/div[3]/a').Attributes['href'].Value, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "http://down.fingerservice.co.kr/SHAgent-$($this.CurrentState.Version)-Setup.exe"
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