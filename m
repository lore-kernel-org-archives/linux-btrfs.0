Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35471 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbbHYPLo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:11:44 -0400
Received: by igbjg10 with SMTP id jg10so14979877igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 08:11:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Aug 2015 11:11:44 -0400
Message-ID: <CAAL+OBri=u1ZWb9SN0wvUirud6hZd4w3FxocmKxF95Z=Vi86ug@mail.gmail.com>
Subject: Unmountable file system
From: Dan Hentschel <dan@hentschels.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a box with 9 VMs residing on it on multiple SSDs, partitioned
with LVM. The particular VM in question is a very simple image, so
it's not all that big of a deal, but there are a few scripts I'd like
to recover from it if possible. The FS that died contains the root and
/home as subvolumes @ and @home, respectively. The boot FS is on an
ext4 FS on another partition. Any help appreciated.

Relevant fstab entries:

UUID=cb2b5614-b8c8-4c57-b2e9-569012b64347 /               btrfs
defaults,compress,subvol=@ 0       1
UUID=cb2b5614-b8c8-4c57-b2e9-569012b64347 /home           btrfs
defaults,compress,subvol=@home 0       2

# uname -a
Linux ******** 3.13.0-57-generic #95-Ubuntu SMP Fri Jun 19 09:28:15
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
Btrfs v3.12
# btrfs fi show /dev/mapper/kingston-streamer2
Label: none  uuid: cb2b5614-b8c8-4c57-b2e9-569012b64347
Total devices 1 FS bytes used 1.80GiB
devid    1 size 9.53GiB used 6.33GiB path /dev/mapper/kingston-streamer2

Btrfs v3.12

Attempting to mount:

# mount /dev/mapper/kingston-streamer2 /mnt
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/kingston-streamer2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

Relevant dmesg:

[1448196.961220] btrfs: device fsid
cb2b5614-b8c8-4c57-b2e9-569012b64347 devid 1 transid 529331
/dev/mapper/kingston-streamer2
[1448196.963836] btrfs: disk space caching is enabled
[1448196.965159] btrfs: bdev /dev/mapper/kingston-streamer2 errs: wr
0, rd 156, flush 0, corrupt 0, gen 0
[1448196.966430] btrfs: dm-28 checksum verify failed on 85360640
wanted C1A46C13 found 6934D1E8 level 0
[1448196.966574] btrfs: dm-28 checksum verify failed on 85360640
wanted C1A46C13 found 6934D1E8 level 0
[1448196.966577] Failed to read block groups: -5
[1448196.973931] btrfs: open_ctree failed

# btrfs-find-root /dev/mapper/kingston-streamer2
Super think's the tree root is at 4308992, chunk root 131072
Well block 4210688 seems great, but generation doesn't match,
have=529330, want=529331 level 0
Found tree root at 4308992 gen 529331 level 0

I can restore some (all?) of the root fs with btrfs restore:

# btrfs restore /dev/mapper/kingston-streamer2 /mnt
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
offset is 20480
failed to inflate: -3

Unfortunately, this doesn't seem to restore any of the contents of
/home, which is what I am really hoping to get at.

It apparently can't be repaired:

# btrfs check --repair /dev/mapper/kingston-streamer2
enabling repair mode
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
Checking filesystem on /dev/mapper/kingston-streamer2
UUID: cb2b5614-b8c8-4c57-b2e9-569012b64347
checking extents
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
checksum verify failed on 85360640 found 6934D1E8 wanted C1A46C13
Csum didn't match
deleting pointer to block 85360640
owner ref check failed [85360640 16384]
repair deleting extent record: key 85360640 168 16384
ref mismatch on [288342016 16384] extent item 0, found 1
Failed to find [72548352, 168, 16384]
btrfs unable to find ref byte nr 72548352 parent 0 root 2  owner 0 offset 0
adding new tree backref on start 288342016 len 16384 parent 257 root 257
Backref 288342016 parent 257 root 257 not found in extent tree
backpointer mismatch on [288342016 16384]
ref mismatch on [288374784 16384] extent item 0, found 1
adding new tree backref on start 288374784 len 16384 parent 257 root 257
Backref 288374784 parent 257 root 257 not found in extent tree
backpointer mismatch on [288374784 16384]
ref mismatch on [288604160 16384] extent item 0, found 1
adding new tree backref on start 288604160 len 16384 parent 257 root 257
Backref 288604160 parent 257 root 257 not found in extent tree
backpointer mismatch on [288604160 16384]
ref mismatch on [288636928 16384] extent item 0, found 1
adding new tree backref on start 288636928 len 16384 parent 257 root 257
Backref 288636928 parent 257 root 257 not found in extent tree
backpointer mismatch on [288636928 16384]
ref mismatch on [288653312 16384] extent item 0, found 1
adding new tree backref on start 288653312 len 16384 parent 257 root 257
Backref 288653312 parent 257 root 257 not found in extent tree
backpointer mismatch on [288653312 16384]
ref mismatch on [288669696 16384] extent item 0, found 1
adding new tree backref on start 288669696 len 16384 parent 257 root 257
Backref 288669696 parent 257 root 257 not found in extent tree
backpointer mismatch on [288669696 16384]
ref mismatch on [288702464 16384] extent item 0, found 1
adding new tree backref on start 288702464 len 16384 parent 257 root 257
Backref 288702464 parent 257 root 257 not found in extent tree
backpointer mismatch on [288702464 16384]
ref mismatch on [288718848 16384] extent item 0, found 1
adding new tree backref on start 288718848 len 16384 parent 257 root 257
Backref 288718848 parent 257 root 257 not found in extent tree
backpointer mismatch on [288718848 16384]
ref mismatch on [288751616 16384] extent item 0, found 1
adding new tree backref on start 288751616 len 16384 parent 257 root 257
Backref 288751616 parent 257 root 257 not found in extent tree
backpointer mismatch on [288751616 16384]
ref mismatch on [288784384 16384] extent item 0, found 1
adding new tree backref on start 288784384 len 16384 parent 257 root 257
Backref 288784384 parent 257 root 257 not found in extent tree
backpointer mismatch on [288784384 16384]
ref mismatch on [288800768 16384] extent item 0, found 1
adding new tree backref on start 288800768 len 16384 parent 257 root 257
Backref 288800768 parent 257 root 257 not found in extent tree
backpointer mismatch on [288800768 16384]
ref mismatch on [288817152 16384] extent item 0, found 1
adding new tree backref on start 288817152 len 16384 parent 257 root 257
Backref 288817152 parent 257 root 257 not found in extent tree
backpointer mismatch on [288817152 16384]
ref mismatch on [288833536 16384] extent item 0, found 1
adding new tree backref on start 288833536 len 16384 parent 257 root 257
Backref 288833536 parent 257 root 257 not found in extent tree
backpointer mismatch on [288833536 16384]
ref mismatch on [288849920 16384] extent item 0, found 1
adding new tree backref on start 288849920 len 16384 parent 257 root 257
Backref 288849920 parent 257 root 257 not found in extent tree
backpointer mismatch on [288849920 16384]
ref mismatch on [288866304 16384] extent item 0, found 1
adding new tree backref on start 288866304 len 16384 parent 257 root 257
Backref 288866304 parent 257 root 257 not found in extent tree
backpointer mismatch on [288866304 16384]
ref mismatch on [288882688 16384] extent item 0, found 1
adding new tree backref on start 288882688 len 16384 parent 257 root 257
Backref 288882688 parent 257 root 257 not found in extent tree
backpointer mismatch on [288882688 16384]
ref mismatch on [288915456 16384] extent item 0, found 1
adding new tree backref on start 288915456 len 16384 parent 257 root 257
Backref 288915456 parent 257 root 257 not found in extent tree
backpointer mismatch on [288915456 16384]
ref mismatch on [288931840 16384] extent item 0, found 1
adding new tree backref on start 288931840 len 16384 parent 257 root 257
Backref 288931840 parent 257 root 257 not found in extent tree
backpointer mismatch on [288931840 16384]
ref mismatch on [288948224 16384] extent item 0, found 1
adding new tree backref on start 288948224 len 16384 parent 257 root 257
Backref 288948224 parent 257 root 257 not found in extent tree
backpointer mismatch on [288948224 16384]
ref mismatch on [288964608 16384] extent item 0, found 1
adding new tree backref on start 288964608 len 16384 parent 257 root 257
Backref 288964608 parent 257 root 257 not found in extent tree
backpointer mismatch on [288964608 16384]
ref mismatch on [288997376 16384] extent item 0, found 1
adding new tree backref on start 288997376 len 16384 parent 257 root 257
Backref 288997376 parent 257 root 257 not found in extent tree
backpointer mismatch on [288997376 16384]
ref mismatch on [289013760 16384] extent item 0, found 1
adding new tree backref on start 289013760 len 16384 parent 257 root 257
Backref 289013760 parent 257 root 257 not found in extent tree
backpointer mismatch on [289013760 16384]
ref mismatch on [289030144 16384] extent item 0, found 1
adding new tree backref on start 289030144 len 16384 parent 257 root 257
Backref 289030144 parent 257 root 257 not found in extent tree
backpointer mismatch on [289030144 16384]
ref mismatch on [289046528 16384] extent item 0, found 1
adding new tree backref on start 289046528 len 16384 parent 257 root 257
Backref 289046528 parent 257 root 257 not found in extent tree
backpointer mismatch on [289046528 16384]
ref mismatch on [289062912 16384] extent item 0, found 1
adding new tree backref on start 289062912 len 16384 parent 257 root 257
Backref 289062912 parent 257 root 257 not found in extent tree
backpointer mismatch on [289062912 16384]
ref mismatch on [289079296 16384] extent item 0, found 1
adding new tree backref on start 289079296 len 16384 parent 257 root 257
Backref 289079296 parent 257 root 257 not found in extent tree
backpointer mismatch on [289079296 16384]
ref mismatch on [289095680 16384] extent item 0, found 1
adding new tree backref on start 289095680 len 16384 parent 257 root 257
Backref 289095680 parent 257 root 257 not found in extent tree
backpointer mismatch on [289095680 16384]
ref mismatch on [289112064 16384] extent item 0, found 1
adding new tree backref on start 289112064 len 16384 parent 257 root 257
Backref 289112064 parent 257 root 257 not found in extent tree
backpointer mismatch on [289112064 16384]
ref mismatch on [289128448 16384] extent item 0, found 1
adding new tree backref on start 289128448 len 16384 parent 257 root 257
Backref 289128448 parent 257 root 257 not found in extent tree
backpointer mismatch on [289128448 16384]
ref mismatch on [289144832 16384] extent item 0, found 1
adding new tree backref on start 289144832 len 16384 parent 257 root 257
Backref 289144832 parent 257 root 257 not found in extent tree
backpointer mismatch on [289144832 16384]
ref mismatch on [289161216 16384] extent item 0, found 1
adding new tree backref on start 289161216 len 16384 parent 257 root 257
Backref 289161216 parent 257 root 257 not found in extent tree
backpointer mismatch on [289161216 16384]
ref mismatch on [289406976 4096] extent item 0, found 1
failed to repair damaged filesystem, aborting

-- 
dan B hentschel
dan@hentschels.com
