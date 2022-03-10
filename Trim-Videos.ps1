param (
    [Parameter(Mandatory=$false)]
    [string]$SourceFolder = "./",
    [Parameter(Mandatory=$false)]
    [string]$OutputFolderLocation = $SourceFolder,
    [Parameter(Mandatory=$false)]
    [string]$OutputFolderName = "output",
    [Parameter(Mandatory=$false)]
    [switch]$DeleteSources,
    [Parameter(Mandatory=$false)]
    [string[]]$InputFormats = "*mp4",
    [Parameter(Mandatory=$false)]
    [string[]]$OutputFormat,
    [Parameter(Mandatory=$false)]
    [switch]$DontOverwrite
)

$filePaths = Get-ChildItem -Path $SourceFolder -Include $InputFormats -Recurse

foreach ($filePath in $filePaths) {
    $fileName = (Get-Item $filePath).Basename
    $fileInfo = "$fileName" -Split ","

    $videoName = $fileInfo[0].Trim()
    If ($fileInfo[2]) {
        $start = $fileInfo[1].Trim().Replace(".", ":")
        $end = $fileInfo[2].Trim().Replace(".", ":")
    } ElseIf ($fileInfo[1]) {
        $start = $fileInfo[1].Trim().Replace(".", ":")
        $end = "99:59:59"
    } Else {
        $start = "00:00"
        $end = "99:59:59"
    }
    $format = If ($OutputFormat) {".$OutputFormat"} Else {(Get-Item $filePath).Extension}
    $overwrite = If ($DontOverwrite) {"-n"} Else {"-y"}

    $outputFolder = "$OutputFolderLocation/$OutputFolderName"
    $outputFilePath = "$outputFolder/$videoName$format"
    
    New-Item -Path "$OutputFolderLocation" -Name "$OutputFolderName" -ItemType "directory"

    ffmpeg -ss $start `
            -to $end `
            -i "$filePath" `
            -vcodec libx265 `
            -crf 28 $outputFilePath `
            $overwrite

    $creationTime = (Get-Item $filePath).CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
    $lastAccessTime = (Get-Item $filePath).LastAccessTime.ToString("yyyy-MM-dd HH:mm:ss")
    $lastWriteTime = (Get-Item $filePath).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")

    (Get-Item $outputFilePath).CreationTime = $creationTime
    (Get-Item $outputFilePath).LastAccessTime = $lastAccessTime
    (Get-Item $outputFilePath).LastWriteTime = $lastWriteTime
}

if ($DeleteSources) {
    foreach($filePath in $filePaths) {
        Remove-Item $filePath
    }
}
