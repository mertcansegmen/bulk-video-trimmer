param (
    [Parameter(Mandatory=$false)]
    [string]$SourceFolder = "./",
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "./",
    [Parameter(Mandatory=$false)]
    [switch]$DeleteSources,
    [Parameter(Mandatory=$false)]
    [string[]]$InputFormats = "*mp4",
    [Parameter(Mandatory=$false)]
    [string[]]$OutputFormat,
    [Parameter(Mandatory=$false)]
    [switch]$DontOverwrite
)

$FilePaths = Get-ChildItem -Path $SourceFolder -Include $InputFormats -Recurse

foreach ($FilePath in $FilePaths) {
    $FileName = (Get-Item $FilePath).Basename
    $FileInfo = "$FileName" -Split ","

    $VideoName = $FileInfo[0].Trim()
    If ($FileInfo[2]) {
        $Start = $FileInfo[1].Trim().Replace(".", ":")
        $End = $FileInfo[2].Trim().Replace(".", ":")
    } ElseIf ($FileInfo[1]) {
        $Start = $FileInfo[1].Trim().Replace(".", ":")
        $End = "99:59:59"
    } Else {
        $Start = "00:00"
        $End = "99:59:59"
    }
    $Format = If ($OutputFormat) {".$OutputFormat"} Else {(Get-Item $FilePath).Extension}
    $Overwrite = If ($DontOverwrite) {"-n"} Else {"-y"}

    $OutputFilePath = "$OutputFolder/$VideoName$Format"

    ffmpeg -ss $Start `
            -to $End `
            -i "$FilePath" `
            -vcodec libx265 `
            -crf 28 $OutputFilePath `
            $Overwrite

    $CreationTime = (Get-Item $FilePath).CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
    $LastAccessTime = (Get-Item $FilePath).LastAccessTime.ToString("yyyy-MM-dd HH:mm:ss")
    $LastWriteTime = (Get-Item $FilePath).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")

    (Get-Item $OutputFilePath).CreationTime = $CreationTime
    (Get-Item $OutputFilePath).LastAccessTime = $LastAccessTime
    (Get-Item $OutputFilePath).LastWriteTime = $LastWriteTime
}

if ($DeleteSources) {
    foreach($FilePath in $FilePaths) {
        Remove-Item $FilePath
    }
}
