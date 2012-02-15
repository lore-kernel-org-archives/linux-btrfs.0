From: Chester <somethingsome2000@gmail.com>
Subject: Consistent error on loop device
Date: Wed, 15 Feb 2012 02:30:01 -0600
Message-ID: <CAAE6i0iQpEdozDcE+0Vmbd8ZFrcqCXGhJ3J9Mp46X7QW+w6ooA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

$ cd btrfs-progs
$ git branch
* dangerdonteveruse
  master

$ dd if=/dev/zero of=../btrfsvol bs=1 count=0 seek=10G
0+0 records in
0+0 records out
0 bytes (0 B) copied, 1.7086e-05 s, 0.0 kB/s

$ du -h --apparent-size ../btrfsvol
10G     ../btrfsvol
$ losetup /dev/loop1 ../btrfsvol
$ ./mkfs.btrfs /dev/loop1

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/loop1
        nodesize 4096 leafsize 4096 sectorsize 4096 size 10.00GB
Btrfs Btrfs v0.19

$ ./btrfsck /dev/loop1
checking extents
checking fs roots
checking root refs
found 28672 bytes used err is 0
total csum bytes: 0
total tree bytes: 28672
total fs tree bytes: 8192
btree space waste bytes: 23875
file data blocks allocated: 0
 referenced 0
Btrfs Btrfs v0.19

$ mount /dev/loop1 /mnt
$ cp -r ../btrfs-progs /mnt

$ btrfs fi sync /mnt
FSSync '/mnt'
$ umount /mnt

$ ./btrfsck /dev/loop1
checking extents
checking fs roots
checking root refs
found 14983168 bytes used err is 0
total csum bytes: 14112
total tree bytes: 401408
total fs tree bytes: 339968
btree space waste bytes: 104131
file data blocks allocated: 14581760
 referenced 14581760
Btrfs Btrfs v0.19

$ mount -o autodefrag,inode_cache /dev/loop1 /mnt
$ rm -rf /mnt/*
zsh: sure you want to delete all the files in /mnt [yn]? y

$ cp -r ../btrfs-progs /mnt
$ btrfs fi sync /mnt
FSSync '/mnt'
$ umount /mnt

$ ./btrfsck /dev/loop1
checking extents
checking fs roots
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
found 15060992 bytes used err is 1
total csum bytes: 14148
total tree bytes: 442368
total fs tree bytes: 372736
btree space waste bytes: 142523
file data blocks allocated: 14618624
 referenced 14618624
Btrfs Btrfs v0.19


If it means anything, the loop file is located on a btrfs volume as well.
This error keeps showing up when copying files to a mounted loop dev
with -o autodefrag,inode_cache

Also, this is on Chris's for-linus branch

Ahh I just tested one last time before committing to send the email.
The problem only shows up when using inode_cache
