Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63979 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbbKNAzC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 19:55:02 -0500
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <5643F62D.6050703@cn.fujitsu.com> <56448E58.3070000@gmail.com>
 <564537D8.5020407@cn.fujitsu.com> <5645B986.9090903@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56468653.9050005@gmx.com>
Date: Sat, 14 Nov 2015 08:54:43 +0800
MIME-Version: 1.0
In-Reply-To: <5645B986.9090903@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年11月13日 18:20, Anand Jain 写道:
>
>
> Thanks for commenting.
>
>>>> I'm sorry but I didn't quite see the benefit of a spare device.
>>> Aside from what Duncan said (and I happen to agree with him), there is
>>> also the fact that hot-spares are (at least traditionally in most RAID
>>> systems) usually used with RAID5 or RAID6 (or some other parity scheme).
>>>
>>> So, to summarize:
>>> 1. Hot spares are more useful for most users in global context, and in
>>> that case only if they have more than one filesystem.
>>> 2. A pool of hot spares is even more useful.
>>
>> Agreed, just as Ducan said.
>> Although only one spare device is supported yet.
>
>   You can add more than one spare device currently.
>
>>> 3. Assuming whole disk usage (as opposed to partitioning), the hot spare
>>> will have no load on it until it gets used, at which point it will
>>> almost always be in better physical condition than the device it
>>> replaced (which is important for HA systems, in such cases you replace
>>> the disk that failed, and make the new disk a hot spare)
>>
>> OK, that's also right, if no one is calling btrfs dev scan with a
>> interval.
>
>    Not too sure what you mean about the scan part.

Btrfs device scan will need to read the sb of the device.
So the hot spare device won't really sleep for a long time as each time 
btrfs scan devices, it will wakeup the device.

Not sure about soft raid hot spare. Maybe they won't cause any IO on the 
device? Or just the same with btrfs hot spare.

Thanks,
Qu

>
> Thanks, Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
