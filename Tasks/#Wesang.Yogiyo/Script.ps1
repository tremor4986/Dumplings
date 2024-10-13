$Object1 = Invoke-WebRequest -Uri 'https://partner.yogiyo.co.kr/download/partner/order_program'

# Version
$this.CurrentState.Version = $Version = [regex]::Match(
  $Object1.Headers.'Content-Disposition', '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = 'https://apps.rpsyogiyo.io/win/go/' + $Version + '/GoYogiyo_Light_Installer_' + $Version + '.exe'
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