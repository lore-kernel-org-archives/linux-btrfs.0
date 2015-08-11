Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35927 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620AbbHKJSs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 05:18:48 -0400
Received: by ioeg141 with SMTP id g141so195842647ioe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 02:18:48 -0700 (PDT)
MIME-Version: 1.0
From: Catalin <zrianc@gmail.com>
Date: Tue, 11 Aug 2015 12:18:28 +0300
Message-ID: <CAJwcFg-Y5q2xBGnoohy0zSzpjtFZAq9U+HWS+erTcskUDgdWRw@mail.gmail.com>
Subject: btrfs-progs: btrfs balance returns enospc error on a system with 80%
 free space
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a recently installed an Arch Linux x86_64 system on a 50GB
btrfs partition and every time I try btrfs balance start it gives me
an enospc error even though I have less than 20% of the available
space full.

I have tried the recommended method (from
https://btrfs.wiki.kernel.org/index.php/Balance_Filters) and with
-dusage I can go up to -dusage=100 with no problems but with -musage
it works until 34 and then at musage=35 it fails with the enospc
error.

I tested if that free space is "real" by mounting the system without
compression and filling the free space with a file written by dd from
/dev/zero and the maximum size is exactly the size of the free space
that is reported.
I have tried deleting all my snapshots and deleting things until I was
only using 6 GB out of 50 GB  and the exact same errors.
I have tried adding more files until I reached 11 GB to see if get
write errors when I add lots of small files and no problems and also
still the same error (like I said above I have also filled all the
free space with one single large file).

Here is more detailed information about my setup and output of several commands:

uname -a
Linux ArchLinux 4.1.4-1-ARCH #1 SMP PREEMPT Mon Aug 3 21:30:37 UTC
2015 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.1.2

btrfs fi show
Label: 'ArchLinux'  uuid: 6816726f-71ed-4b64-9071-60684a445e71
    Total devices 1 FS bytes used 9.86GiB
    devid    1 size 50.00GiB used 12.31GiB path /dev/sda2

btrfs fi df /
Data, single: total=10.00GiB, used=9.52GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.12GiB, used=354.31MiB
GlobalReserve, single: total=128.00MiB, used=0.00B

lsblk -o NAME,SIZE,FSTYPE,UUID,PARTLABEL
NAME    SIZE FSTYPE UUID                                 PARTLABEL
sda      50G
   sda1    2M                                             BIOS boot partition
   sda2   50G btrfs  6816726f-71ed-4b64-9071-60684a445e71 Linux x86-64 root (/)
sr0    1024M

btrfs filesystem usage /

Overall:
    Device size:          50.00GiB
    Device allocated:          12.31GiB
    Device unallocated:          37.68GiB
    Device missing:             0.00B
    Used:              10.21GiB
    Free (estimated):          38.17GiB    (min: 19.33GiB)
    Data ratio:                  1.00
    Metadata ratio:              2.00
    Global reserve:         128.00MiB    (used: 0.00B)

Data,single: Size:10.00GiB, Used:9.52GiB
   /dev/sda2      10.00GiB

Metadata,DUP: Size:1.12GiB, Used:354.16MiB
   /dev/sda2       2.25GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda2      64.00MiB

Unallocated:
   /dev/sda2      37.68GiB

-This is the maximum size I have, I have also tested with only 6 GiB used
-I suspected that there is a problem with the metadata so I added in
fstab metadata_ratio=20 to all subvolumes rebooted and nothing
changed.

sudo btrfs scrub start -B /
scrub done for 6816726f-71ed-4b64-9071-60684a445e71
    scrub started at Tue Aug 11 11:07:36 2015 and finished after 00:01:42
    total bytes scrubbed: 10.21GiB with 0 errors

btrfs check output when run from the rescue cd with the partition unmounted:

Checking filesystem on /dev/sda2
UUID: 6816726f-71ed-4b64-9071-60684a445e71
found 10541920267 bytes used err is 0
total csum bytes: 9906264
total tree bytes: 370245632
total fs tree bytes: 337903616
total extent tree bytes: 20758528
btree space waste bytes: 63326339
file data blocks allocated: 10473455616
referenced 14596616192
btrfs-progs v4.1.2

btrfs balance start output with the following options:

-dusage 100:
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=100
Done, had to relocate 2 out of 13 chunks

-dusage 100, second, third, ... run:
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=100
Done, had to relocate 1 out of 13 chunks

-musage 33, first run:
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=33
  SYSTEM (flags 0x2): balancing, usage=33
Done, had to relocate 2 out of 13 chunks

-musage 33, second, third,.... run:
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=33
  SYSTEM (flags 0x2): balancing, usage=33
Done, had to relocate 1 out of 12 chunks

-musage 35 always gives an error:
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=35
  SYSTEM (flags 0x2): balancing, usage=35
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail

output of dmesg | tail (after repeated trying):
[ 2481.262199] BTRFS info (device sda2): found 1 extents
[ 2487.331921] BTRFS info (device sda2): relocating block group
683432476672 flags 34
[ 2498.583018] BTRFS info (device sda2): relocating block group
683466031104 flags 34
[ 2503.843304] BTRFS info (device sda2): relocating block group
683499585536 flags 34
[ 2511.407124] BTRFS info (device sda2): relocating block group
683533139968 flags 34
[ 2511.444678] BTRFS info (device sda2): 1 enospc errors during balance
[ 2528.820892] BTRFS info (device sda2): relocating block group
683600248832 flags 36
[ 2528.888670] BTRFS info (device sda2): relocating block group
683566694400 flags 34
[ 2528.915590] BTRFS info (device sda2): found 1 extents
[ 2528.936589] BTRFS info (device sda2): 1 enospc errors during balance

cat /etc/fstab
# /dev/sda2 LABEL=ArchLinux
UUID=6816726f-71ed-4b64-9071-60684a445e71    /
btrfs         rw,noatime,compress-force=lzo,space_cache,autodefrag
0 0
UUID=6816726f-71ed-4b64-9071-60684a445e71    /var/abs
btrfs         rw,noatime,compress-force=lzo,space_cache,autodefrag,subvol=subvolume_abs
   0 0
UUID=6816726f-71ed-4b64-9071-60684a445e71    /var/cache/pacman/pkg
btrfs         rw,noatime,compress-force=lzo,space_cache,autodefrag,subvol=subvolume_pkg
   0 0
UUID=6816726f-71ed-4b64-9071-60684a445e71    /.snapshots
btrfs         rw,noatime,compress-force=lzo,space_cache,autodefrag,noauto,subvol=subvolume_snapshots
   0 0
UUID=6816726f-71ed-4b64-9071-60684a445e71    /mnt/btrfs_zero
btrfs         defaults,noatime,noauto,subvolid=0    0 0

(this is just one of the different combinations of mount options I have tried)

btrfs subvolume list -a -t --sort=-gen /
ID    gen    top level    path
--    ---    ---------    ----
257    71683    5        <FS_TREE>/subvolume_root
258    71679    5        <FS_TREE>/subvolume_snapshots
326    71679    5        <FS_TREE>/subvolume_abs
327    71679    5        <FS_TREE>/subvolume_pkg
678    71677    258        <FS_TREE>/subvolume_snapshots/snapshot_root_1
677    71653    258        <FS_TREE>/subvolume_snapshots/snapshot_login
660    71600    258        <FS_TREE>/subvolume_snapshots/snapshot_root_3
661    71600    258        <FS_TREE>/subvolume_snapshots/snapshot_root_2
663    71600    258        <FS_TREE>/subvolume_snapshots/snapshot_daily
262    39    257        subvolume_root/var/lib/machines

(like I said I have also tried with all the snapshots deleted)

I have tried running the command both from inside the system and
mounted from a rescue cd with different combinations of mount options
like enabling and disabling space-cache / nospace_cache , clear_cache,
enospc_debug, enable and disable compression or autodefrag.
I have tried defragmenting everything, filling all the space, adding
files, deleting files, making snapshots, deleting snapshots still the
same problem.
I have run the balance command on both the root subvolume and on subvolid=0.
I have tried putting the balance commands with options that work
inside a for to run 1000 times hoping that maybe that one relocated
chunk it says about might actually solve something in time but it
doesn't (I am new to btrfs and not 100% about how balance works).

Everything else works fine, the system is very fast, good compression,
no other errors and I have no other problems but the fact that I have
this error means something is wrong and I don't know what is the
problem and how to solve it.
