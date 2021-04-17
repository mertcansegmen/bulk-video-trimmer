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
    [string[]]$OutputFormat = "mp4"
)

$Mp4FilePaths = Get-ChildItem -Path $FolderPath -Include $InputFormats -Recurse

foreach($Mp4FilePath in $Mp4FilePaths) {
    $FileName = (Get-Item $Mp4FilePath).Basename
    $FileInfo = "$FileName" -Split ","
    $VideoName = $FileInfo[0].Trim()
    $Start = "00:" + $FileInfo[1].Trim().Replace(".", ":")
    $End = "00:" + $FileInfo[2].Trim().Replace(".", ":")

    $OutputFilePath = "$OutputFolder/$VideoName.$OutputFormat"

    ffmpeg -ss $Start `
            -to $End `
            -i "$Mp4FilePath" `
            -vcodec libx265 `
            -crf 28 $OutputFilePath

    $CreationTime = (Get-Item $Mp4FilePath).CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
    $LastAccessTime = (Get-Item $Mp4FilePath).LastAccessTime.ToString("yyyy-MM-dd HH:mm:ss")
    $LastWriteTime = (Get-Item $Mp4FilePath).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")

    $(Get-Item $OutputFilePath).CreationTime = $CreationTime
    $(Get-Item $OutputFilePath).LastAccessTime = $LastAccessTime
    $(Get-Item $OutputFilePath).LastWriteTime = $LastWriteTime
}

If($DeleteAfterGeneration) {
    foreach($Mp4FilePath in $Mp4FilePaths) {
        Remove-Item $Mp4FilePath
    }
}
