$Object1 = Invoke-WebRequest -Uri 'https://www.tigrison.com/home'

# Version

$this.CurrentState.Version = [regex]::Match(
  $Object1.SelectSingleNode('/html/body/script[9]'), '.*TigrisMessenger.*(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = 'https://www.tigrison.com/store/messenger/update/packages/' + 
  [regex]::Match(
  $Object1.SelectSingleNode('/html/body/script[9]'), '.*TigrisMessenger.*(\d+\.\d+\.\d+)'
  ).Groups[1].Value + '/TigrisMessenger-' + [regex]::Match(
  $Object1.SelectSingleNode('/html/body/script[9]'), '.*TigrisMessenger.*(\d+\.\d+\.\d+)'
  ).Groups[1].Value + '%20Setup.exe'
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