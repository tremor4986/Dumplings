$Object1 = Invoke-RestMethod -Uri 'https://flow.team/FLOW_UPDATE_R001.jct' -Headers @{
  'referer'    = 'pc'
  'Content-Type' = 'application/x-www-form-urlencoded; charset=UTF-8'
} -Body @{
  _json_ = '{"PCK_NM":"team.flow.flowMiniRenewal","GB":"WINDOWS"}'
}

# Version
$this.CurrentState.Version = [regex]::Match(
  $Object1.flow_rec[1].LINK_URL, '(\d+\.\d+\.\d+)'
  ).Groups[1].Value

# Installer
$this.CurrentState.Installer += [ordered]@{
  InstallerUrl = $Object1.flow_rec[1].LINK_URL
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