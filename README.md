# Searchbins
Offline command line tool that searches for [GTFOBins](https://gtfobins.github.io/) binaries that can be used to bypass local security restrictions in misconfigured systems.

The main purpose of the tool is to give you the possibility to search for GTBOBins binaries offline and from the terminal.

The tool is able to:
- List the functions of a specific binary which can be abused
- Show the commands to abuse a specific function or all functions of a binary
- List all binaries available in GTFOBins
- List the binaries associated with a specific function
- List all the functions available in GTFOBins
- Search GTBOBins binaries from a file and list their respective functions

## Demo
![demo](https://github.com/r1vs3c/searchbins/assets/80863982/ec64de80-88a5-4e63-9e0f-9432c09097c1)

## Dependencies
For the tool to work properly, the following dependencies need to be installed:
```
sudo apt install yq jq -y
```

## Installation
```
git clone https://github.com/r1vs3c/searchbins.git
cd searchbins
./searchbins.sh -h
```

If you want to run the tool from any path on your system, you can run the following script:
```
sudo ./install.sh 
```

## Options
```
____ ____ ____ ____ ____ _  _ ___  _ _  _ ____
[__  |___ |__| |__/ |    |__| |__] | |\ | [__
___] |___ |  | |  \ |___ |  | |__] | | \| ___]  by Juan Rivas (@r1vs3c)

[!] Use: searchbins 
================================================================================
        [-b] Binary to enumerate
                Example: searchbins -b docker

        [-f] Specific function of the binary or binaries
                Example: searchbins -b docker -f shell

        [-a] All available functions of the binary
                Example: searchbins -b docker -a

        [-l] List all available binaries or functions 
                Example: searchbins -l <bins/functions>
                         searchbins -l bins -f suid

        [-s] File to search for binaries 
                Example: searchbins -s <path_to_file>

        [-h] Show this panel
```

## Examples
### List the functions of a binary
```
searchbins -b docker
```

### Display commands to abuse a specific function of the binary
```
searchbins -b docker -f shell
```

### Display commands to abuse all functions associated with the binary
```
searchbins -b docker -a
```

### List all available binaries
```
searchbins -l bins
```

### List all available binaries associated with a specific function
```
searchbins -l bins -f file-download
```

### List of all available functions
```
searchbins -l functions
```

### Search for potential binaries from a file
```
searchbins -s bins.txt
```

## Uninstall
```
sudo rm /usr/local/bin/searchbins
sudo rm -rf /usr/local/share/bins
```

## Credits
Thanks to [norbemi](https://twitter.com/norbemi) and [cyrus_and](https://twitter.com/cyrus_and) for creating [GTFOBins](https://gtfobins.github.io/) without that this project won't be in existence.
