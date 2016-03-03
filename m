Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51392 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751891AbcCCDnN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 22:43:13 -0500
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>,
        Marc Haber <mh+linux-btrfs@zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D7B290.3080004@cn.fujitsu.com>
Date: Thu, 3 Mar 2016 11:42:08 +0800
MIME-Version: 1.0
In-Reply-To: <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dāvis Mosāns wrote on 2016/03/03 02:28 +0200:
> 2016-02-27 23:14 GMT+02:00 Marc Haber <mh+linux-btrfs@zugschlus.de>:
>> Hi,
>>
>> I have again the issue of no space left on device while rebalancing
>> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
>>
>
> I've same issue, 4.4.3 kernel on Arch Linux
>
> $ sudo btrfs fi show /mnt/fs/
> Label: 'fs'  uuid: a3c66d25-2c25-40e5-a827-5f7e5208e235
>          Total devices 1 FS bytes used 396.94GiB
>          devid    1 size 435.76GiB used 435.76GiB path /dev/sdi2
>
> $ sudo btrfs fi df /mnt/fs/
> Data, single: total=416.70GiB, used=390.62GiB
> System, DUP: total=32.00MiB, used=96.00KiB
> Metadata, DUP: total=9.50GiB, used=6.32GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> $ sudo btrfs fi usage /mnt/fs/
> Overall:
>      Device size:                 435.76GiB
>      Device allocated:            435.76GiB
>      Device unallocated:            1.00MiB

Not quite the same with the problem with OP.
In your case, only 1M is not allocated, which is below minimal chunk 
size 16M.

So, you're really out of unallocated space.
>      Device missing:                  0.00B
>      Used:                        403.26GiB
>      Free (estimated):             26.07GiB      (min: 26.07GiB)
>      Data ratio:                       1.00
>      Metadata ratio:                   2.00
>      Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:416.70GiB, Used:390.62GiB
>     /dev/sdi2     416.70GiB
>
> Metadata,DUP: Size:9.50GiB, Used:6.32GiB
>     /dev/sdi2      19.00GiB

But considering your space usage, I didn't see any need to balance though.

You have over 3G metadata space, and about 20G data.
No obvious meta/data unbalance.

>
> System,DUP: Size:32.00MiB, Used:96.00KiB
>     /dev/sdi2      64.00MiB
>
> Unallocated:
>     /dev/sdi2       1.00MiB
>
>
> $ sudo btrfs balance start -v /mnt/fs/
> Dumping filters: flags 0x7, state 0x0, force is off
>    DATA (flags 0x0): balancing
>    METADATA (flags 0x0): balancing
>    SYSTEM (flags 0x0): balancing
> ERROR: error during balancing '/mnt/fs/': No space left on device
> There may be more info in syslog - try dmesg | tail
>
> $ sudo btrfs balance start -dusage=34 /mnt/fs/
> Done, had to relocate 0 out of 438 chunks
> $ sudo btrfs balance start -dusage=35 /mnt/fs/
> ERROR: error during balancing '/mnt/fs/': No space left on device
>
>
> $ sudo btrfs balance start -musage=0 /mnt/fs/
> Done, had to relocate 0 out of 438 chunks
> $ sudo btrfs balance start -musage=1 /mnt/fs/
> ERROR: error during balancing '/mnt/fs/': No space left on device
>
>
> $ sudo btrfs balance start -dprofiles=single /mnt/fs
> ERROR: error during balancing '/mnt/fs': No space left on device
>
> $ sudo btrfs balance start -mprofiles=dup /mnt/fs
> Done, had to relocate 20 out of 438 chunks
>
> $ sudo btrfs balance start -sprofiles=dup --force /mnt/fs
> Done, had to relocate 1 out of 433 chunks
>
>
> $ sudo btrfs fi df /mnt/fs/
> Data, single: total=416.70GiB, used=390.62GiB
> System, DUP: total=32.00MiB, used=96.00KiB
> Metadata, DUP: total=7.00GiB, used=6.31GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> $  sudo btrfs fi usage /mnt/fs/
> Overall:
>      Device size:                 435.76GiB
>      Device allocated:            430.76GiB
>      Device unallocated:            5.00GiB

After balancing data and metadata, you have space for at least 5 chunks.
So you should be OK to continue balance.

>      Device missing:                  0.00B
>      Used:                        403.25GiB
>      Free (estimated):             31.07GiB      (min: 28.57GiB)
>      Data ratio:                       1.00
>      Metadata ratio:                   2.00
>      Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:416.70GiB, Used:390.62GiB
>     /dev/sdi2     416.70GiB
>
> Metadata,DUP: Size:7.00GiB, Used:6.31GiB
>     /dev/sdi2      14.00GiB
>
> System,DUP: Size:32.00MiB, Used:96.00KiB
>     /dev/sdi2      64.00MiB
>
> Unallocated:
>     /dev/sdi2       5.00GiB
>
> now balance works
>
> $ sudo btrfs balance start -m /mnt/fs/
> Done, had to relocate 15 out of 433 chunks
>
> $ sudo btrfs balance start /mnt/fs/
>
> it's still going but most likley it will finish
>
> $ sudo btrfs balance status /mnt/fs/
> Balance on '/mnt/fs/' is running
> 26 out of about 431 chunks balanced (27 considered),  94% left
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


