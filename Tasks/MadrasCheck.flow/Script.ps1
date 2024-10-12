$Object1 = Invoke-RestMethod `
  -Uri 'https://flow.team/FLOW_UPDATE_R001.jct' `
  -Method Post `
  -Headers @{ 
    Referer = 'https://flow.team/kr/download'; 'Content-Type' = 'application/x-www-form-urlencoded' } `
  -Body '_JSON_=%257B%2522USER_ID%2522%253A%2522%2522%252C%2522RGSN_DTTM%2522%253A%2522%2522%252C%2522PCK_NM%2522%253A%2522team.flow.flowMiniRenewal%2522%252C%2522GB%2522%253A%2522WINDOWS%2522%257D'

# Version
$this.CurrentState.Version = [regex]::Match(
  $Object1.flow_rec.LINK_URL, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.flow_rec.LINK_URL
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