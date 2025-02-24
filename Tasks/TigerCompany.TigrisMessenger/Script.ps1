$Object1 = Invoke-WebRequest -Uri 'https://www.tigrison.com/home' | ConvertFrom-Html

# Version
$this.CurrentState.Version = $Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/script[10]').innerHTML, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = 'https://www.tigrison.com/store/messenger/update/packages/' + $Version + '/TigrisMessenger-' + $Version + '%20Setup.exe'
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