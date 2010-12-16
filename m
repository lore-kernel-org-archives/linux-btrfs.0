From: "Michael Niederle" <mniederle@gmx.at>
Subject: A rescue tool for btrfs
Date: Fri, 17 Dec 2010 00:18:49 +0100
Message-ID: <20101217001849.1b5f4c28@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Last week I crashed a btrfs file system. I didn't lose a lot of data because I
had current backups of most data and a full backup from a month ago.

But I thought it would be a nice idea to have a rescue tool! Currently I have a
first release of this tool (surely buggy and runnning on little endian
architectures only).

The tool is written in C using the header files from the btrfs userland tools.
I use a wrapper (written in a script language) to restore whole directories.
Such a wrapper could also detect hard links and handle them correctly.

btrfs_rescue implements all disk accesses itself and tries to access only the
absolute minimum of necessary data structures to avoid the pitfalls that lurk
somewhere in the destroyed file system. So you can rescue parts of a destroyed
file system even if the file system driver cannot mount it anymore.

The source code is available under

http://simplux.org/downloads/btrfs_rescue.c

Here is a short overview of the tool's usage:

Usage:

  btrfs_rescue --help
        shows this short description of available commands

  btrfs_rescue volumes <device>
        displays a list of all subvolumes

  btrfs_rescue dir <device> <volume>
        shows the contents of the root directory

  btrfs_rescue dir <device> <volume> <inode>
        shows the contents of the directory with the specified inode number

  btrfs_rescue stat <device> <volume> <inode>
        displays the status of the file with the specified inode

  btrfs_rescue cp [--preserve] [--large] <device> <volume> <inode> <filename>
        creates a copy of the file specified by the inode number under the
        specified file name

The cp-command can copy regular files as well as symbolic links, block and
character devices. When copying a directory, only the directory node itself is
copied but not its contents!

The "--preserve" option preserves access rights, ownership, access time and
modification time of the file.

The "--large" option allows copying of files larger than 100MB.
(A very large file size could stem from the filesystem destruction.)

An example output of the above commands:

# btrfs_rescue volumes /dev/sde2
5 (generation 227542)
256 (generation 227106)
257 (generation 227553)
258 (generation 227105)
259 (generation 227506)
260 (generation 225276)
261 (generation 224231)
...
314 (generation 226751)
315 (generation 226752)
316 (generation 227104)
317 (generation 227105)
318 (generation 227106)

# btrfs_rescue dir /dev/sde2 5
dev: 584 (directory)
.backups: 256 (directory)
downloads: 259 (directory)
boot: 381 (directory)
lib: 3504 (directory)
sbin: 18685 (directory)
save2: 260 (directory)
usr: 75153 (directory)
opt: 14258 (directory)
destination: 1056921 (directory)
.joe_state: 1122321 (regular file)
data: 583 (directory)
bin: 263 (directory)
initrd: 257 (directory)
save: 259 (directory)
home: 258 (directory)
net: 14257 (directory)
.bash_history: 1325987 (regular file)
etc: 585 (directory)
source: 1056920 (directory)
var: 18959 (directory)
tmp: 262 (directory)
sys: 261 (directory)
mnt: 14256 (directory)
proc: 258 (directory)
root: 257 (directory)
cmds: 408 (directory)

# btrfs_rescue dir /dev/sde2 5 584
vbi: 362470 (symbolic link)
dri: 1320381 (directory)
dmfm2: 361934 (character device)
mixer1: 362155 (character device)
sequencer: 362269 (character device)
hdb4: 361984 (block device)
hdc7: 361997 (block device)
hda1: 361964 (block device)
...
loop0: 362037 (block device)
sda9: 362218 (block device)
parport0: 362166 (character device)
ippp2: 362026 (character device)
nvram: 362165 (character device)
midi03: 362152 (character device)
pts: 362176 (directory)

# btrfs_rescue stat /dev/sde2 5 362152
type: 21b0
character device
major: 0xe
minor: 0x32
size: 0
allocated: 0
links: 1
uid: 17
gid: 0
mode: 0660
access: 2007-07-17 18:58:42.000000000 +0200
modify: 2007-07-17 18:58:42.000000000 +0200
change: 2010-05-17 23:33:23.720827790 +0200

Greetings, Michael
