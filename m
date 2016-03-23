Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10361 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbcCWEBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 00:01:34 -0400
Subject: Re: RAID-1 refuses to balance large drive
To: <bradtem@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <56F1E7BE.1000004@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F21510.6050707@cn.fujitsu.com>
Date: Wed, 23 Mar 2016 12:01:20 +0800
MIME-Version: 1.0
In-Reply-To: <56F1E7BE.1000004@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Brad Templeton wrote on 2016/03/22 17:47 -0700:
> I have a RAID 1, and was running a bit low, so replaced a 2TB drive with
> a 6TB.  The other drives are a 3TB and a 4TB.    After switching the
> drive, I did a balance and ... essentially nothing changed.  It did not
> balance clusters over to the 6TB drive off of the other 2 drives.  I
> found it odd, and wondered if it would do it as needed, but as time went
> on, the filesys got full for real.

Did you resized the replaced deivces to max?
Without resize, btrfs still consider it can only use 2T of the 6T devices.

Thanks,
Qu

>
> Making inquiries on the IRC channel, it was suggested perhaps the drives
> were too full for a balance, but they had at least 50gb free I would
> estimate, when I swapped.    As a test, I added a 4th drive, a spare
> 20gb partition and did a balance.  The balance did indeed balance the 3
> small drives, so they now each have 6gb unallocated, but the big drive
> remained unchanged.   The balance reported it operated on almost all the
> clusters, though.
>
> Linux kernel 4.2.0 (Ubuntu Wiley)
>
> Label: 'butter'  uuid: a91755d4-87d8-4acd-ae08-c11e7f1f5438
>          Total devices 4 FS bytes used 3.88TiB
>          devid    1 size 3.62TiB used 3.62TiB path /dev/sdi2
>          devid    2 size 2.73TiB used 2.72TiB path /dev/sdh
>          devid    3 size 5.43TiB used 1.42TiB path /dev/sdg2
>          devid    4 size 20.00GiB used 14.00GiB path /dev/sda1
>
> btrfs fi usage /local
>
> Overall:
>      Device size:                  11.81TiB
>      Device allocated:              7.77TiB
>      Device unallocated:            4.04TiB
>      Device missing:                  0.00B
>      Used:                          7.76TiB
>      Free (estimated):              2.02TiB      (min: 2.02TiB)
>      Data ratio:                       2.00
>      Metadata ratio:                   2.00
>      Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,RAID1: Size:3.87TiB, Used:3.87TiB
>     /dev/sda1      14.00GiB
>     /dev/sdg2       1.41TiB
>     /dev/sdh        2.72TiB
>     /dev/sdi2       3.61TiB
>
> Metadata,RAID1: Size:11.00GiB, Used:9.79GiB
>     /dev/sdg2       5.00GiB
>     /dev/sdh        7.00GiB
>     /dev/sdi2      10.00GiB
>
> System,RAID1: Size:32.00MiB, Used:572.00KiB
>     /dev/sdg2      32.00MiB
>     /dev/sdi2      32.00MiB
>
> Unallocated:
>     /dev/sda1       6.00GiB
>     /dev/sdg2       4.02TiB
>     /dev/sdh        5.52GiB
>     /dev/sdi2       7.36GiB
>
> ----------------------
> btrfs fi df /local
> Data, RAID1: total=3.87TiB, used=3.87TiB
> System, RAID1: total=32.00MiB, used=572.00KiB
> Metadata, RAID1: total=11.00GiB, used=9.79GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> I would have presumed that a balance would take blocks found on both the
> 3TB and 4TB, and move one of them over to the 6TB until all had 1.3TB of
> unallocated space.  But this does not happen.  Any clues on how to make
> it happen?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


