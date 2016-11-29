Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51612 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753137AbcK2Asa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 19:48:30 -0500
Subject: Re: RFC: raid with a variable stripe size
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
CC: Zygo Blaxell <zblaxell@furryterror.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <657fcefe-4e6c-ced3-a3c9-2dc1f77e1404@cn.fujitsu.com>
Date: Tue, 29 Nov 2016 08:48:19 +0800
MIME-Version: 1.0
In-Reply-To: <e6042e5a-d283-f66e-9d08-6028c9ba1946@libero.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/19/2016 02:15 AM, Goffredo Baroncelli wrote:
> Hello,
>
> these are only my thoughts; no code here, but I would like to share it hoping that it could be useful.
>
> As reported several times by Zygo (and others), one of the problem of raid5/6 is the write hole. Today BTRFS is not capable to address it.

I'd say, no need to address yet, since current soft RAID5/6 can't handle 
it yet.

Personally speaking, Btrfs should implementing RAID56 support just like 
Btrfs on mdadm.
See how badly the current RAID56 works?

The marginally benefit of btrfs RAID56 to scrub data better than 
tradition RAID56 is just a joke in current code base.

>
> The problem is that the stripe size is bigger than the "sector size" (ok sector is not the correct word, but I am referring to the basic unit of writing on the disk, which is 4k or 16K in btrfs).
> So when btrfs writes less data than the stripe, the stripe is not filled; when it is filled by a subsequent write, a RMW of the parity is required.
>
> On the best of my understanding (which could be very wrong) ZFS try to solve this issue using a variable length stripe.

Did you mean ZFS record size?
IIRC that's file extent minimum size, and I didn't see how that can 
handle the write hole problem.

Or did ZFS handle the problem?

Anyway, it should be a low priority thing, and personally speaking,
any large behavior modification involving  both extent allocator and bg 
allocator will be bug prone.

>
> On BTRFS this could be achieved using several BGs (== block group or chunk), one for each stripe size.
>
> For example, if a filesystem - RAID5 is composed by 4 DISK, the filesystem should have three BGs:
> BG #1,composed by two disks (1 data+ 1 parity)
> BG #2 composed by three disks (2 data + 1 parity)
> BG #3 composed by four disks (3 data + 1 parity).

Too complicated bg layout and further extent allocator modification.

More code means more bugs, and I'm pretty sure it will be bug prone.


Although the idea of variable stripe size can somewhat reduce the 
problem under certain situation.

For example, if sectorsize is 64K, and we make stripe len to 32K, and 
use 3 disc RAID5, we can avoid such write hole problem.
Withouth modification to extent/chunk allocator.

And I'd prefer to make stripe len mkfs time parameter, not possible to 
modify after mkfs. To make things easy.

Thanks,
Qu

>
> If the data to be written has a size of 4k, it will be allocated to the BG #1.
> If the data to be written has a size of 8k, it will be allocated to the BG #2
> If the data to be written has a size of 12k, it will be allocated to the BG #3
> If the data to be written has a size greater than 12k, it will be allocated to the BG3, until the data fills a full stripes; then the remainder will be stored in BG #1 or BG #2.
>
>
> To avoid unbalancing of the disk usage, each BG could use all the disks, even if a stripe uses less disks: i.e
>
> DISK1 DISK2 DISK3 DISK4
> S1    S1    S1    S2
> S2    S2    S3    S3
> S3    S4    S4    S4
> [....]
>
> Above is show a BG which uses all the four disks, but has a stripe which spans only 3 disks.
>
>
> Pro:
> - btrfs already is capable to handle different BG in the filesystem, only the allocator has to change
> - no more RMW are required (== higher performance)
>
> Cons:
> - the data will be more fragmented
> - the filesystem, will have more BGs; this will require time-to time a re-balance. But is is an issue which we already know (even if may be not 100% addressed).
>
>
> Thoughts ?
>
> BR
> G.Baroncelli
>
>
>


