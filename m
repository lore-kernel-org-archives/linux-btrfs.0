Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37896 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbbKMKVr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 05:21:47 -0500
Message-ID: <5645B986.9090903@oracle.com>
Date: Fri, 13 Nov 2015 18:20:54 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com> <5643F62D.6050703@cn.fujitsu.com> <56448E58.3070000@gmail.com> <564537D8.5020407@cn.fujitsu.com>
In-Reply-To: <564537D8.5020407@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for commenting.

>>> I'm sorry but I didn't quite see the benefit of a spare device.
>> Aside from what Duncan said (and I happen to agree with him), there is
>> also the fact that hot-spares are (at least traditionally in most RAID
>> systems) usually used with RAID5 or RAID6 (or some other parity scheme).
>>
>> So, to summarize:
>> 1. Hot spares are more useful for most users in global context, and in
>> that case only if they have more than one filesystem.
>> 2. A pool of hot spares is even more useful.
>
> Agreed, just as Ducan said.
> Although only one spare device is supported yet.

  You can add more than one spare device currently.

>> 3. Assuming whole disk usage (as opposed to partitioning), the hot spare
>> will have no load on it until it gets used, at which point it will
>> almost always be in better physical condition than the device it
>> replaced (which is important for HA systems, in such cases you replace
>> the disk that failed, and make the new disk a hot spare)
>
> OK, that's also right, if no one is calling btrfs dev scan with a interval.

   Not too sure what you mean about the scan part.

Thanks, Anand
