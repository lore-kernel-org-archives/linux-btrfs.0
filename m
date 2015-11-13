Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17361 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751747AbbKMBHk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 20:07:40 -0500
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <5643F62D.6050703@cn.fujitsu.com> <56448E58.3070000@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <564537D8.5020407@cn.fujitsu.com>
Date: Fri, 13 Nov 2015 09:07:36 +0800
MIME-Version: 1.0
In-Reply-To: <56448E58.3070000@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S Hemmelgarn wrote on 2015/11/12 08:04 -0500:
> On 2015-11-11 21:15, Qu Wenruo wrote:
>> Hi Anand,
>>
>> Nice work.
>> But I have some small questions about it.
>>
>> Anand Jain wrote on 2015/11/09 18:56 +0800:
>>> These set of patches provides btrfs hot spare and auto replace support
>>> for you review and comments.
>>>
>>> First, here below are the simple example steps to configure the same:
>>>
>>> Add a spare device:
>>>      btrfs spare add /dev/sde -f
>>
>> I'm sorry but I didn't quite see the benefit of a spare device.
> Aside from what Duncan said (and I happen to agree with him), there is
> also the fact that hot-spares are (at least traditionally in most RAID
> systems) usually used with RAID5 or RAID6 (or some other parity scheme).
>
> So, to summarize:
> 1. Hot spares are more useful for most users in global context, and in
> that case only if they have more than one filesystem.
> 2. A pool of hot spares is even more useful.

Agreed, just as Ducan said.
Although only one spare device is supported yet.

> 3. Assuming whole disk usage (as opposed to partitioning), the hot spare
> will have no load on it until it gets used, at which point it will
> almost always be in better physical condition than the device it
> replaced (which is important for HA systems, in such cases you replace
> the disk that failed, and make the new disk a hot spare)

OK, that's also right, if no one is calling btrfs dev scan with a interval.

> 4. Hot spares are more often used (at least from what I've seen) on
> parity based raid systems than raid1.

I'm not familiar with parity based RAID5/6 in btrfs, so I can't say for 
sure.
But considering the chunk based RAID feature of btrfs, I think parity 
based RAID of BTRFS is not that different from current btrfs RAID1.
Just stripe size difference. hole chunk size(RAID1) vs real stripe size 
(btrfs RAID5/6)

And if Btrfs support to specify the number of disks used in raid5/6 
chunk allocation, for example only use any 3 devices to allocation raid5 
chunk even there are 4 devices, it will be much the same case.

I choose Btrfs Raid1 as an example in my mail just because Btrfs raid1 
will only use 2 devices no matter how many devices are in the filesystem.

So I'm very curious of why parity based RAID is often used with hot spare.

Thanks,
Qu

>
> In the rather limited case you outlined, I would probably just use raid1
> across all three devices myself (unless they were whole disks and not
> individual partitions, in which case I'd use a hot spare), but looking
> beyond that at my actual usage of BTRFS (multiple filesystems with
> multiple different raid profiles, spread across various disks), hot
> spares are definitely useful (although they would be more useful if I
> could specify that a given hot spare be used only for a given set of
> filesystems).
>
>
