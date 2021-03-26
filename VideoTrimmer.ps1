param (
    [Parameter(Mandatory=$false)]
    [string]$FolderPath = "./",
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "./"
)

$mp4FilePaths = Get-ChildItem -Path $FolderPath -Include "*.mp4" -Recurse

foreach($mp4FilePath in $mp4FilePaths) {
    $fileName = (Get-Item $mp4FilePath).Basename
    $createdAt = (Get-Item $mp4FilePath).CreationTime.ToString("yyyy-MM-dd_")
    $fileInfo = "$fileName" -Split "\+"
    $videoName = $fileInfo[0]
    $start = "00:" + $fileInfo[1].Replace("-", ":")
    $end = "00:" + $fileInfo[2].Replace("-", ":")
    
    ffmpeg -ss $start -to $end -i $mp4FilePath -vcodec libx265 -crf 28 "$OutputPath/$createdAt$videoName.mp4"
}
