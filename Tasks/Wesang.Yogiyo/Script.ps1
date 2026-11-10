$Client = [System.Net.Http.HttpClient]::new()

try {
  $Response = $Client.GetAsync(
    'https://partner.yogiyo.co.kr/download/partner/order_program',
    [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead
  ).GetAwaiter().GetResult()
  $Object1 = $Response.Content.Headers.ContentDisposition.ToString()
}
finally {
  if ($Response) { $Response.Dispose() }
  $Client.Dispose()
}

# Version
$this.CurrentState.Version = $Version = [regex]::Match(
  $Object1, '(\d+\.\d+\.\d+)'
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
