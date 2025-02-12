$Domain = 'https://www.checkmal.com/notice/read/11/'
$Object1 = Invoke-WebRequest -Uri $Domain | ConvertFrom-Html

# Version
$this.CurrentState.Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/head/title').innerHTML, '(\d+.\d+.\d+.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = "https://www.checkmal.com/download/appcheckv3.0/AppCheckSetup.exe"
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
