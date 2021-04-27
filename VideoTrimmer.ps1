param (
    [Parameter(Mandatory=$false)]
    [string]$FolderPath = "./",
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "./",
    [Parameter(Mandatory=$false)]
    [switch]$DeleteAfterGeneration,
    [Parameter(Mandatory=$false)]
    [string[]]$InputFormats = "*mp4",
    [Parameter(Mandatory=$false)]
    [string[]]$OutputFormat,
    [Parameter(Mandatory=$false)]
    [switch]$DontOverwrite
)

$Mp4FilePaths = Get-ChildItem -Path $FolderPath -Include $InputFormats -Recurse

foreach ($Mp4FilePath in $Mp4FilePaths) {
    $FileName = (Get-Item $Mp4FilePath).Basename
    $FileInfo = "$FileName" -Split ","
    $VideoName = $FileInfo[0].Trim()
    $Start = $FileInfo[1].Trim().Replace(".", ":")
    $End = $FileInfo[2].Trim().Replace(".", ":")
    $Format = If ($OutputFormat) {".$OutputFormat"} Else {(Get-Item $Mp4FilePath).Extension}
    $Overwrite = If ($DontOverwrite) {"-n"} Else {"-y"}

    $OutputFilePath = "$OutputFolder/$VideoName$Format"

    ffmpeg -ss $Start `
            -to $End `
            -i "$Mp4FilePath" `
            -vcodec libx265 `
            -crf 28 $OutputFilePath `
            $Overwrite

    $CreationTime = (Get-Item $Mp4FilePath).CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
    $LastAccessTime = (Get-Item $Mp4FilePath).LastAccessTime.ToString("yyyy-MM-dd HH:mm:ss")
    $LastWriteTime = (Get-Item $Mp4FilePath).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")

    (Get-Item $OutputFilePath).CreationTime = $CreationTime
    (Get-Item $OutputFilePath).LastAccessTime = $LastAccessTime
    (Get-Item $OutputFilePath).LastWriteTime = $LastWriteTime
}

if ($DeleteAfterGeneration) {
    foreach($Mp4FilePath in $Mp4FilePaths) {
        Remove-Item $Mp4FilePath
    }
}
