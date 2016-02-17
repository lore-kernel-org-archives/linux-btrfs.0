Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12278 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbcBQF6m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 00:58:42 -0500
Subject: Re: RAID 6 full, but there is still space left on some devices
To: Dan Blazejewski <dan.blazejewski@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CABmr4wVBb0CCEoU_N2jxYvC=gVn9vUKWfb0902yZDuP2N3ck3w@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56C40C06.8090900@cn.fujitsu.com>
Date: Wed, 17 Feb 2016 13:58:30 +0800
MIME-Version: 1.0
In-Reply-To: <CABmr4wVBb0CCEoU_N2jxYvC=gVn9vUKWfb0902yZDuP2N3ck3w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dan Blazejewski wrote on 2016/02/16 15:20 -0500:
> Hello,
>
> I've searched high and low about my issue, but have been unable to
> turn up anything like what I'm seeing right now.
>
> A little background: I started using BTRFS over a year ago, in RAID 1
> with mixed size drives. A few months ago, I started replacing the
> disks with 4 TB drives, and eventually switched over to RAID 6. I am
> currently running a 6x4TB RAID6 drive configuration, which should give
> me ~14.5 TB
> usable, but I'm only getting around 11.
>
> The weird thing is that It seems to completely fill 4/6 of the disks,
> while leaving lots of space free on 2 of the disks. I've tried full
> filesystem balances, yet the problem continues.
>
> # btrfs fi show
>
> Label: none  uuid: 78733087-d597-4301-8efa-8e1df800b108
>          Total devices 6 FS bytes used 11.59TiB
>          devid    1 size 3.64TiB used 3.64TiB path /dev/sdd
>          devid    2 size 3.64TiB used 3.64TiB path /dev/sdg
>          devid    3 size 3.64TiB used 3.64TiB path /dev/sdf
>          devid    5 size 3.64TiB used 2.92TiB path /dev/sda
>          devid    6 size 3.64TiB used 1.48TiB path /dev/sdb
>          devid    7 size 3.64TiB used 3.64TiB path /dev/sdc
>
> btrfs-progs v4.2.3

Your space really used up, as it can't found *at least 4* disk with 
enough space to allocate a new chunk.
As 4 devices in your array is already filled, the rest 2 is of no means 
for RAID6, and can only be allocated with Single/RAID1/RAID0.


But the real problem is, why your devices get such a unbalanced layout.

Normally, for RAID5/6, it will allocate chunks using all disk with 
available space, and since all your devices are in the same size, it 
should result very balanced allocation.

How did you convert to current RAID6? Did it involves balance from 
already some used disks?

Thanks,
Qu

>
>
>
> # btrfs fi df /mnt/data
>
> Data, RAID6: total=11.67TiB, used=11.58TiB
> System, RAID6: total=64.00MiB, used=1.70MiB
> Metadata, RAID6: total=15.58GiB, used=13.89GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> dan@Morpheus:/mnt/data/temp$ sudo btrfs fi usage /mnt/data
>
>
>
> # btrfs fi usage /mnt/data
>
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> WARNING: RAID56 detected, not implemented
> Overall:
>      Device size:                  21.83TiB
>      Device allocated:                0.00B
>      Device unallocated:           21.83TiB
>      Device missing:                  0.00B
>      Used:                            0.00B
>      Free (estimated):                0.00B      (min: 8.00EiB)
>      Data ratio:                       0.00
>      Metadata ratio:                   0.00
>      Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,RAID6: Size:11.67TiB, Used:11.58TiB
>     /dev/sda        2.92TiB
>     /dev/sdb        1.48TiB
>     /dev/sdc        3.63TiB
>     /dev/sdd        3.63TiB
>     /dev/sdf        3.63TiB
>     /dev/sdg        3.63TiB
>
> Metadata,RAID6: Size:15.58GiB, Used:13.89GiB
>     /dev/sda        4.05GiB
>     /dev/sdb        1.50GiB
>     /dev/sdc        5.01GiB
>     /dev/sdd        5.01GiB
>     /dev/sdf        5.01GiB
>     /dev/sdg        5.01GiB
>
> System,RAID6: Size:64.00MiB, Used:1.70MiB
>     /dev/sda       16.00MiB
>     /dev/sdb       16.00MiB
>     /dev/sdc       16.00MiB
>     /dev/sdd       16.00MiB
>     /dev/sdf       16.00MiB
>     /dev/sdg       16.00MiB
>
> Unallocated:
>     /dev/sda      733.65GiB
>     /dev/sdb        2.15TiB
>     /dev/sdc        1.02MiB
>     /dev/sdd        1.02MiB
>     /dev/sdf        1.02MiB
>     /dev/sdg        1.02MiB
>
>
>
>
> Can anyone shed some light on why a full balance (sudo btrfs balance
> start /mnt/data) doesnt seem to straighten this out? Any and all help
> is appreciated.
>
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


