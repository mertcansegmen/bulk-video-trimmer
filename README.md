# bulk-video-trimmer

```bulk-video-trimmer``` is a PowerShell cmdlet that trims and compresses videos using the command line program ```ffmpeg```. It is created to trim/compress large amounts of videos easily. How it works is that it takes multiple video files in a folder and puts them in another folder after trimming/compressing them. The cmdlet uses the file name to decide how to trim the video, check the [File Names section](#file-names) for details. It does not take any parameters for the compression.

## Requirements

```video-trimmer``` requires the following to run:

- [FFmpeg](https://github.com/FFmpeg/FFmpeg) must be installed and added to the PATH.

## Usage

### Parameters

| Parameter &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | Description                                                                                                                    | Mandatory | Type           | Default Value   |
|------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----------|----------------|-----------------------|
| ```-SourceFolder```          | Path to the folder where the input videos are kept.                                                                            | No        | ```String```   | ```"./"```            |
| ```-OutputFolderLocation```  | Path to the folder where the output folder will be placed into.                                                                | No        | ```String```   | ```"$SourceFolder"``` |
| ```-OutputFolderName```      | Name of the folder containing output videos.                                                                                   | No        | ```String```   | ```output```          |
| ```-DeleteSources```         | Whether or not the converted videos will be deleted after the conversion is completed.                                         | No        | ```Switch```   |                       |
| ```-InputFormats```          | File formats that will be taken into account when finding videos inside the source folder.                                     | No        | ```String[]``` | ```@("*.mp4")```      |
| ```-OutputFormat```          | File format that the videos will be outputted as. If not given, the output format will be the same as the source video.        | No        | ```String```   |                       |
| ```-DontOverwrite```         | If an output file already exists, the cmdlet will automatically overwrite it. If ```-DontOverwrite``` is set, it will skip it. | No        | ```Switch```   |                       |

### File Names

You need to define the output file name, the start time, and the end time of the video using the source file name. The format is: ```<filename>,<starting-point>,<ending-point>``` where starting and ending point is not mandatory.

#### File Name Examples

| File Name            | Start Time | End Time         | Output File Name |
|----------------------|------------|------------------|------------------|
| filename,02.00       | 02:00      | End of the video | filename         |
| filename,02.00,04.34 | 02:00      | 04:34            | filename         |
| filename             | 00:00      | End of the video | filename         |

### Usage Examples

```powershell
# Gets mp4 and flv files from C:/Users/mertc/Desktop/mert/videos/games folder, trims 
# them according to info from their file name, puts the output files into 
# C:/Users/mertc/Desktop/mert/videos/games-compressed folder.
./Trim-Videos.ps1 `
    -SourceFolder "C:/Users/mertc/Desktop/mert/videos/games" `
    -OutputFolderLocation "C:/Users/mertc/Desktop/mert/videos" `
    -OutputFolderName "games-compressed" `
    -InputFormats "*.mp4", "*.flv"

# Gets mp4 and flv files from C:/Users/mertc/Desktop/mert/videos/games folder, trims 
# them according to info from their file name, puts the output files into 
# C:/Users/mertc/Desktop/mert/videos/games-compressed folder as mp4 file format.
./Trim-Videos.ps1 `
    -SourceFolder "C:/Users/mertc/Desktop/mert/videos/games" `
    -OutputFolderLocation "C:/Users/mertc/Desktop/mert/videos" `
    -OutputFolderName "games-compressed" `
    -InputFormats "*.mp4", "*.flv" `
    -OutputFormat ".mp4"

# Gets mp4 files from C:/Users/mertc/Desktop/mert/videos/games folder(because default 
# source file format is mp4), trims them according to info from their file name, puts 
# the output files into C:/Users/mertc/Desktop/mert/videos/games-compressed folder and
# deletes the videos it trimmed. If there is any existing file with the output file
# name, it skips them.
./Trim-Videos.ps1 `
    -SourceFolder "C:/Users/mertc/Desktop/mert/videos/games" `
    -OutputFolderLocation "C:/Users/mertc/Desktop/mert/videos" `
    -OutputFolderName "games-compressed" `
    -DeleteSources `
    -DontOverwrite
```
## TODO

- Add a param for compressing
- Add actions for converting the script to exe file
- Check for output folder name and location if they exist
