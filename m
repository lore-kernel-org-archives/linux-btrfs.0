From: 810d4rk <810d4rk@gmail.com>
Subject: Re: btrfs encryption problems
Date: Wed, 23 Nov 2011 19:38:37 +0000
Message-ID: <CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
 <20111123110956.GB31800@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111123110956.GB31800@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

> dd that backup disk to another disk, so you have a backup of your
> backup, and work with that.

OK.

> You can also post the dmesg output you get when you mount the broken
> filesystem, and ask the experts if it might be worth to try experimental
> btrfs.fsck on it.

dmesg does not output anything of value since the file system is not
detectable, here is the kernel output:

[ 4834.149123] usb 2-1.1: new high speed USB device number 12 using ehci_hcd
[ 4834.245114] scsi20 : usb-storage 2-1.1:1.0
[ 4835.246193] scsi 20:0:0:0: Direct-Access     WDC WD75
00BPVT-22HXZT1   1A01 PQ: 0 ANSI: 2 CCS
[ 4835.317195] sd 20:0:0:0: Attached scsi generic sg4 type 0
[ 4835.317889] sd 20:0:0:0: [sdc] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[ 4835.318944] sd 20:0:0:0: [sdc] Write Protect is off
[ 4835.318956] sd 20:0:0:0: [sdc] Mode Sense: 00 38 00 00
[ 4835.320603] sd 20:0:0:0: [sdc] Asking for cache data failed
[ 4835.320619] sd 20:0:0:0: [sdc] Assuming drive cache: write through
[ 4835.324143] sd 20:0:0:0: [sdc] Asking for cache data failed
[ 4835.324153] sd 20:0:0:0: [sdc] Assuming drive cache: write through
[ 4836.894263]  sdc: sdc1
[ 4836.897190] sd 20:0:0:0: [sdc] Asking for cache data failed
[ 4836.897200] sd 20:0:0:0: [sdc] Assuming drive cache: write through
[ 4836.897206] sd 20:0:0:0: [sdc] Attached SCSI disk
[ 4844.803652] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
[ 4844.856054] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
[ 4844.902679] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem
[ 4932.637108] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
[ 4932.686841] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
[ 4932.738999] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem
[ 4949.142867] EXT3-fs (dm-1): error: can't find ext3 filesystem on dev dm-1.
[ 4949.197596] EXT2-fs (dm-1): error: can't find an ext2 filesystem on dev dm-1.
[ 4949.241721] EXT4-fs (dm-1): VFS: Can't find ext4 filesystem

> fwiw, I backup to gpg encrypted files stored on ext4 to cope with
> regressions in both btrfs and disk encryption.


In my experience btrfs + encryption eats the data, this is not the
first time I had this problem with btrfs so I am considering switching
to ext4, but can I still get the other data back on the broken btrfs??

-- 
Thanks
