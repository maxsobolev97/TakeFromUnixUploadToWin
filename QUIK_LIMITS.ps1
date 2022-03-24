Import-Module Posh-SSH

$IN_X = "X:\"
$ARC_X = "X:\arc\"

while($true){

    Write-Host("$(Get-Date)    Открываю сессию к example")

    $User = "example"
    $PWord = ConvertTo-SecureString -String "example" -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
    New-SFTPSession -ComputerName 172.16.100.18 -Credential ($Credential) -Verbose | fl
    Get-SFTPSession -SessionId 0

    if(Test-SFTPPath -Path /home/example/example/example/example/example/example/example/ -SessionId 0){
        Write-Host "Поиск файлов"
        $files = Get-SFTPChildItem -SessionId 0 -Path /home/example/example/example/example/example/example/example/
    
        foreach($file in $files){
    
            $correctLCI = Get-ChildItem $IN_X -Filter "Correct.lci"

            if($correctLCI -eq $null){

                if($file.FullName -like "*.lci"){
                    $fileName = $file.FullName
                    Write-Host("$(Get-Date)    Перенос файла $fileName")
                    Get-SFTPFile -LocalPath $IN_X -RemoteFile $file.FullName -SessionId 0 -Overwrite
                    $file_lci = Get-ChildItem $IN_X -Filter '*.lci'
                    Rename-Item -Path $file_lci.FullName -NewName "Correct.lci"
                    Get-SFTPFile -LocalPath $ARC_X -RemoteFile $file.FullName -SessionId 0 -Overwrite
                    Write-Host("$(Get-Date)    Удаление перенесенного файла")
                    Remove-SFTPItem -Path $file.FullName -SessionId 0 -Force

                }

            } else {
                Write-Host("$(Get-Date)    Обнаружен не забранный файл")
                Start-Sleep 5
        
            }

        }

    }
    Write-Host("$(Get-Date)    Закрываю сессию к example")
    Remove-SFTPSession -SessionId 0
    Write-Host("$(Get-Date)    Пауза 30 секунд")
    [System.GC]::Collect()
    Start-Sleep 30

}



