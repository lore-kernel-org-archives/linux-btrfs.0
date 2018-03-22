Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-cys01nam02on0119.outbound.protection.outlook.com ([104.47.37.119]:54703
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753931AbeCVA4J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 20:56:09 -0400
From: Shane Walton <shane.walton@indepth.com>
To: Hugo Mills <hugo@carfax.org.uk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Out of space and incorrect size reported
Date: Thu, 22 Mar 2018 00:56:05 +0000
Message-ID: <471593AD-7540-44BE-9E16-E7804D5C44A3@indepth.com>
References: <4B67E3B8-BF96-43A5-9F0E-91B32496CE7E@indepth.com>
 <20180321215615.GE17966@carfax.org.uk>
In-Reply-To: <20180321215615.GE17966@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately this didnâ€™t seem to correct the problem.  Please see below:

> uname -a 
Linux rockstor 4.12.4-1.el7.elrepo.x86_64 #1 SMP Thu Jul 27 20:03:28 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux

> btrfs â€”version
btrfs-progs v4.12

> btrfs fi df -H /mnt2/pool_homes
Data, RAID1: total=257.70GB, used=257.46GB
System, RAID1: total=8.39MB, used=65.54kB
Metadata, RAID1: total=7.52GB, used=6.35GB
GlobalReserve, single: total=498.27MB, used=0.00B

> btrfs fi show /mnt2/pool_homes
Label: 'pool_homes'  uuid: 0987930f-8c9c-49cc-985e-de6383863070
	Total devices 2 FS bytes used 245.69GiB
	devid    1 size 465.76GiB used 247.01GiB path /dev/sda
	devid    2 size 465.76GiB used 247.01GiB path /dev/sdb

rockstor mounts everything over and over, even if I manually unmount, so I did the following:

> umount /mnt2/pool_homes; mount -o clear_cache /dev/sda /mnt2/pool_home

dmesg shows the following:

[ 3473.848389] BTRFS info (device sda): use no compression
[ 3473.848393] BTRFS info (device sda): disk space caching is enabled
[ 3473.848394] BTRFS info (device sda): has skinny extents
[ 3548.337574] BTRFS info (device sda): force clearing of disk cache
[ 3548.337578] BTRFS info (device sda): disk space caching is enabled
[ 3548.337580] BTRFS info (device sda): has skinny extents

Any help is appreciated!

> On Mar 21, 2018, at 5:56 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> On Wed, Mar 21, 2018 at 09:53:39PM +0000, Shane Walton wrote:
>>> uname -a
>> Linux rockstor 4.4.5-1.el7.elrepo.x86_64 #1 SMP Thu Mar 10 11:45:51 EST 2016 x86_64 x86_64 x86_64 GNU/Linux
>> 
>>> btrfs â€”version 
>> btrfs-progs v4.4.1
>> 
>>> btrfs fi df /mnt2/pool_homes
>> Data, RAID1: total=240.00GiB, used=239.78GiB
>> System, RAID1: total=8.00MiB, used=64.00KiB
>> Metadata, RAID1: total=8.00GiB, used=5.90GiB
>> GlobalReserve, single: total=512.00MiB, used=59.31MiB
>> 
>>> btrfs filesystem show /mnt2/pool_homes
>> Label: 'pool_homes'  uuid: 0987930f-8c9c-49cc-985e-de6383863070
>> 	Total devices 2 FS bytes used 245.75GiB
>> 	devid    1 size 465.76GiB used 248.01GiB path /dev/sda
>> 	devid    2 size 465.76GiB used 248.01GiB path /dev/sdb
>> 
>> Why is the line above "Data, RAID1: total=240.00GiB, used=239.78GiBâ€ almost full and limited to 240 GiB when there is I have 2x 500 GB HDD?  This is all create/implemented with the Rockstor platform and it says the â€œshareâ€ should be 400 GB.
>> 
>> What can I do to make this larger or closer to the full size of 465 GiB (minus the System and Metadata overhead)?
> 
>   Most likely, you need to ugrade your kernel to get past the known
> bug (fixed in about 4.6 or so, if I recall correctly), and then mount
> with -o clear_cache to force the free space cache to be rebuilt.
> 
>   Hugo.
> 
> -- 
> Hugo Mills             | Q: What goes, "Pieces of seven! Pieces of seven!"?
> hugo@... carfax.org.uk | A: A parroty error.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
