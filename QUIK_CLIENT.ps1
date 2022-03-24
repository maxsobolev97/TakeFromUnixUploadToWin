Import-Module Posh-SSH

$IN_Z = "Z:\example\"
$ARC_Z = "Z:\example\"
$IN_V = "V:\example\"
$ARC_V = "V:\example\arc\"

while($true){

    Write-Host("$(Get-Date)    Открываю сессию к example")
    $User = "example"
    $PWord = ConvertTo-SecureString -String "example" -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
    New-SFTPSession -ComputerName *ip* -Credential ($Credential) -Verbose | fl
    Get-SFTPSession -SessionId 0

    if(Test-SFTPPath -Path /home/example/example/example/example/example/example/example/ -SessionId 0){

        $files = Get-SFTPChildItem -SessionId 0 -Path /home/example/example/example/example/example/example/example/
    
        foreach($file in $files){
    
            if($file.FullName -like "*.xml"){

                Write-Host("$(Get-Date)    Копирование файлов")

                Get-SFTPFile -LocalPath $IN_Z -RemoteFile $file.FullName -SessionId 0 -Overwrite
                Get-SFTPFile -LocalPath $ARC_Z -RemoteFile $file.FullName -SessionId 0 -Overwrite
                Remove-SFTPItem -Path $file.FullName -SessionId 0 -Force

            }

        }

    }

    if(Test-SFTPPath -Path /example/example/example/example/example/example/example/example/example/ -SessionId 0){

        $files = Get-SFTPChildItem -SessionId 0 -Path /example/example/example/example/example/example/example/example/example/
    
        foreach($file in $files){

                if($file.FullName -like "*.sql"){
            
                    Write-Host("$(Get-Date)    Попытка копирование файлов")

                    $files_V = Get-ChildItem $IN_V -Filter "*.sql"
                
                    if($files_V -eq $null){
                
                        $fileName = $file.FullName
                        Write-Host("$(Get-Date)    Перенос файла $fileName")
                        Get-SFTPFile -LocalPath $IN_V -RemoteFile $file.FullName -SessionId 0 -Overwrite
                        $file_sql = Get-ChildItem $IN_V -Filter '*.sql'
                        Rename-Item -Path $file_sql.FullName -NewName "TTT0.sql"
                        Get-SFTPFile -LocalPath $ARC_V -RemoteFile $file.FullName -SessionId 0 -Overwrite
                        Write-Host("$(Get-Date)    Удаление перенесенного файла")
                        Remove-SFTPItem -Path $file.FullName -SessionId 0 -Force                
                
                    } else {
                
                        Write-Host("$(Get-Date)    Обнаружен не загруженный файл *.sql")
                
                    }
            
            }
            
        }
        
    }

    

    Write-Host("$(Get-Date)    Закрываю сессию к example")
    Remove-SFTPSession -SessionId 0

    [System.GC]::Collect()

    Write-Host("$(Get-Date)    Пауза 1 минута")
    Start-Sleep 60

}

