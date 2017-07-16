Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36263 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdGPN4O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Jul 2017 09:56:14 -0400
Received: by mail-wm0-f42.google.com with SMTP id 62so55565490wmw.1
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Jul 2017 06:56:13 -0700 (PDT)
From: =?UTF-8?Q?Andr=c3=a9-Sebastian_Liebe?= <andre@lianse.eu>
Subject: Re: Unable to mount filesystem
To: Wictor Lund <wlund@abo.fi>, linux-btrfs@vger.kernel.org
References: <20170702212133.59ddb448@wdesk.local>
Message-ID: <c14669ba-fe67-cf7e-8b2b-80c2af8c7796@lianse.eu>
Date: Sun, 16 Jul 2017 15:55:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170702212133.59ddb448@wdesk.local>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wictor, Hi List

I'm more or less stuck with the same problem as you. Btrfs on my
external drive got corrupted after I moved a lot of files to it and
would'n mount anymore.
This happened to me in november 2015 and I haven't tried again since
today, as tools and code have matured eventually.

I tried a lot of things, but nothing helped yet :-/

$ uname -a
> Linux apc01 4.10.13-1-ARCH #1 SMP PREEMPT Thu Apr 27 12:15:09 CEST
2017 x86_64 GNU/Linux

$ [root@apc01 ~]# btrfs --version
> btrfs-progs v4.11.1

$ btrfs fi sh
> Label: 'external_0001'  uuid: 6acf5972-91a8-49a1-a5a1-2bcd86b8eb8b
>         Total devices 1 FS bytes used 2.18TiB
>         devid    1 size 3.64TiB used 2.19TiB path /dev/mapper/roverlay

1. cloned the drive with dd
2. attached the cloned drive to my computer and created an writable
overlay (with losetup and dmsetup), so I can test many things without
changing one bit on the cloned drive
3. tried recovery

3a) `mount -t btrfs /dev/mapper/roverlay /mnt`
> BTRFS info (device dm-0): disk space caching is enabled
> BTRFS info (device dm-0): has skinny extents
> BTRFS error (device dm-0): bad tree block start 11851697049360863559
21053440
> BTRFS error (device dm-0): bad tree block start 7989935996922551463
21053440
> BTRFS error (device dm-0): failed to read chunk tree: -5
> BTRFS error (device dm-0): open_ctree failed

3b) `mount -t btrfs -o ro,recovery /dev/mapper/roverlay /mnt`
same as 3a)

3c) `btrfs rescue zero-log /dev/mapper/roverlay`
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> ERROR: cannot open ctree

3d) `btrfs restore /dev/mapper/roverlay /data/recovery`
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> Could not open root, trying backup super
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> Could not open root, trying backup super
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> Could not open root, trying backup super

3e) `btrfs check -s 0 /dev/mapper/roverlay`
> using SB copy 0, bytenr 65536
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> ERROR: cannot open file system

3f) `btrfs check -s 1 /dev/mapper/roverlay`
> using SB copy 1, bytenr 67108864
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> ERROR: cannot open file system

3g) `btrfs check -s 2 /dev/mapper/roverlay`
> using SB copy 2, bytenr 274877906944
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> checksum verify failed on 21053440 found CF3B13F9 wanted 4A9A0385
> checksum verify failed on 21053440 found 42E96418 wanted 277C3E6A
> bytenr mismatch, want=21053440, have=11851697049360863559
> Couldn't read chunk tree
> ERROR: cannot open file system

3h) `btrfs rescue super-recover -v /dev/mapper/roverlay`
> All Devices:
>         Device: id = 1, name = /dev/mapper/roverlay
>
> Before Recovering:
>         [All good supers]:
>                 device name = /dev/mapper/roverlay
>                 superblock bytenr = 65536
>
>                 device name = /dev/mapper/roverlay
>                 superblock bytenr = 67108864
>
>                 device name = /dev/mapper/roverlay
>                 superblock bytenr = 274877906944
>
>         [All bad supers]:
>
> All supers are valid, no need to recover

3i) `btrfs rescue chunk-recover -v /dev/mapper/roverlay`
> All Devices:
>         Device: id = 1, name = /dev/mapper/roverlay
>
> Scanning: 2127447805952 in dev0chunk-recover.c:129:
process_extent_buffer: BUG_ON `exist->nmirrors >= BTRFS_MAX_MIRRORS`
triggered, value 1
> btrfs[0x463150]
> btrfs[0x463fd1]
> /usr/lib/libpthread.so.0(+0x7297)[0x7f0efc75a297]
> /usr/lib/libc.so.6(clone+0x3f)[0x7f0efc49b1ef]
> Aborted (core dumped)

Any more suggestions?

-
andre

On 02.07.2017 20:21, Wictor Lund wrote:
> Hi!
>  
> I cannot mount my filesystem anymore. The problem started with it going
> into read-only mode after the filesystem accidentally became full. At
> some point the system crashed and after that I got this error. Is it
> possible to recover the filesystem or at least recover some data from
> it?
>
> Here is some information from the system:
>  
> $ uname -a
> Linux localhost.localdomain 4.8.6-300.fc25.x86_64 #1 SMP Tue Nov 1 12:36:38 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
>  
> $ btrfs --version
> btrfs-progs v4.6.1
>  
> $ sudo mount /dev/sda4 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sda4,
>    missing codepage or helper program, or other error
>  
>    In some cases useful info is found in syslog - try
>    dmesg | tail or so.
>  
> $ sudo btrfs fi show
> Label: 'fedora'  uuid: 3ddc9cf1-ff3f-4081-900a-4f732838c31b
>    Total devices 1 FS bytes used 208.67GiB
>    devid 1 size 230.04GiB used 212.06GiB path /dev/sda4
>  
> $ dmesg | grep -i btrfs
> [ 5.747551] Btrfs loaded, crc32c=crc32c-intel
> [ 5.748632] BTRFS: device label fedora devid 1 transid 649633 /dev/sda4
> [   48.663727] BTRFS info (device sda4): disk space caching is enabled
> [   48.665184] BTRFS error (device sda4): bad tree block start 0 1234052513792
> [   48.665194] BTRFS warning (device sda4): failed to read tree root
> [   48.680625] BTRFS: open_ctree failed
>  
> $ sudo btrfs check /dev/sda4
> checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
> checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=1234052513792, have=0
> Couldn't read tree root
> Couldn't open file system
>
> $ sudo btrfs restore -l /dev/sda4
> checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
> checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=1234052513792, have=0
> Couldn't read tree root
> Could not open root, trying backup super
> checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
> checksum verify failed on 1234052513792 found E4E3BDB6 wanted 00000000
> bytenr mismatch, want=1234052513792, have=0
> Couldn't read tree root
> Could not open root, trying backup super
> Superblock bytenr is larger than device size
> Could not open root, trying backup super
>
> --
> Wictor Lund



