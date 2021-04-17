param (
    [Parameter(Mandatory=$false)]
    [string]$FolderPath = "./",
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "./"
)

$Mp4FilePaths = Get-ChildItem -Path $FolderPath -Include "*.mp4" -Recurse

foreach($Mp4FilePath in $Mp4FilePaths) {
    $FileName = (Get-Item $Mp4FilePath).Basename
    $FileInfo = "$FileName" -Split ","
    $VideoName = $FileInfo[0].Trim()
    $Start = "00:" + $FileInfo[1].Trim().Replace(".", ":")
    $End = "00:" + $FileInfo[2].Trim().Replace(".", ":")

    $OutputFilePath = "$OutputFolder/$VideoName.mp4"

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
