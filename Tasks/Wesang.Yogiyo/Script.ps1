$Client = [System.Net.Http.HttpClient]::new()

try {
  $JsContent = $Client.GetStringAsync(
    'https://partner.yogiyo.co.kr/js/yo_common.js'
  ).GetAwaiter().GetResult()
}
finally {
  $Client.Dispose()
}

$VersionMatch = [regex]::Match(
  $JsContent,
  'GoYogiyo_Setup_(\d+\.\d+\.\d+)\.exe'
)

$this.CurrentState.Version = $Version = $VersionMatch.Groups[1].Value

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
