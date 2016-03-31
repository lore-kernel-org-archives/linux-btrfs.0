Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34768 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbcCaX1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 19:27:23 -0400
Received: by mail-lb0-f174.google.com with SMTP id vo2so61678238lbb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 16:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
Date: Fri, 1 Apr 2016 01:27:21 +0200
Message-ID: <CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 10:44 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Hello!
>
> I already reported this in another thread but it was a bit confusing by
> intermixing multiple volumes. So let's start a new thread:
>
> Since one of the last kernel upgrades, I'm experiencing one VDI file
> (containing a NTFS image with Windows 7) getting damaged when running
> the machine in VirtualBox. I got knowledge about this after
> experiencing an error "duplicate object" and btrfs went RO. I fixed it
> by deleting the VDI and restoring from backup - but no I get csum
> errors as soon as some VM IO goes into the VDI file.
>
> The FS is still usable. One effect is, that after reading all files
> with rsync (to copy to my backup), each call of "du" or "df" hangs, also
> similar calls to "btrfs {sub|fi} ..." show the same effect. I guess one
> outcome of this is, that the FS does not properly unmount during
> shutdown.
>
> Kernel is 4.5.0 by now (the FS is much much older, dates back to 3.x
> series, and never had problems), including Gentoo patch-set r1.

One possibility could be that the vbox kernel modules somehow corrupt
btrfs kernel area since kernel 4.5.

In order to make this reproducible (or an attempt to reproduce) for
others, you could unload VirtualBox stuff and restore the VDI file
from backup (or whatever big file) and then make pseudo-random, but
reproducible writes to the file.

It is not clear to me what 'Gentoo patch-set r1' is and does. So just
boot a vanilla v4.5 kernel from kernel.org and see if you get csum
errors in dmesg.

Also, where does 'duplicate object' come from? dmesg ? then please
post its surroundings, straight from dmesg.

> The device layout is:
>
> $ lsblk -o NAME,MODEL,FSTYPE,LABEL,MOUNTPOINT
> NAME        MODEL            FSTYPE LABEL      MOUNTPOINT
> sda         Crucial_CT128MX1
> ├─sda1                       vfat   ESP        /boot
> ├─sda2
> └─sda3                       bcache
>   ├─bcache0                  btrfs  system
>   ├─bcache1                  btrfs  system
>   └─bcache2                  btrfs  system     /usr/src
> sdb         SAMSUNG HD103SJ
> ├─sdb1                       swap   swap0      [SWAP]
> └─sdb2                       bcache
>   └─bcache2                  btrfs  system     /usr/src
> sdc         SAMSUNG HD103SJ
> ├─sdc1                       swap   swap1      [SWAP]
> └─sdc2                       bcache
>   └─bcache1                  btrfs  system
> sdd         SAMSUNG HD103UJ
> ├─sdd1                       swap   swap2      [SWAP]
> └─sdd2                       bcache
>   └─bcache0                  btrfs  system
>
> Mount options are:
>
> $ mount|fgrep btrfs
> /dev/bcache2 on / type btrfs (rw,noatime,compress=lzo,nossd,discard,space_cache,autodefrag,subvolid=256,subvol=/gentoo/rootfs)
>
> The FS uses mraid=1 and draid=0.
>
> Output of btrfsck is:
> (also available here:
> https://gist.github.com/kakra/bfcce4af242f6548f4d6b45c8afb46ae)
>
> $ btrfsck /dev/disk/by-label/system
> checking extents
> ref mismatch on [10443660537856 524288] extent item 1, found 2
This   10443660537856  number is bigger than the  1832931324360 number
found for total bytes. AFAIK, this is already wrong.

[...]

> checking fs roots
> root 4336 inode 4284125 errors 1000, some csum missing
What is in this inode?

> Checking filesystem on /dev/disk/by-label/system
> UUID: d2bb232a-2e8f-4951-8bcc-97e237f1b536
> found 1832931324360 bytes used err is 1
> total csum bytes: 1730105656
> total tree bytes: 6494474240
> total fs tree bytes: 3789783040
> total extent tree bytes: 608219136
> btree space waste bytes: 1221460063
> file data blocks allocated: 2406059724800
>  referenced 2040857763840
