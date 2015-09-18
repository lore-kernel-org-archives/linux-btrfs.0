Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41909 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbbIRGqs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 02:46:48 -0400
Message-ID: <55FBB2F7.4040402@oracle.com>
Date: Fri, 18 Sep 2015 14:45:11 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Remove unneeded missing device number check
References: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com> <1442375031-18212-2-git-send-email-quwenruo@cn.fujitsu.com> <55FA8B31.9080604@oracle.com> <55FA8F8B.6060903@gmx.com> <55FB6D31.9030504@oracle.com> <55FB71A8.3000004@cn.fujitsu.com>
In-Reply-To: <55FB71A8.3000004@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Qu,

  Thanks for the comments on patch [1].

> For example, if one use single metadata for 2 disks,
 > and each disk has one metadata chunk on it.

  how that can be achieved ?

> One device got missing later.

  it would surely depend on which one of the device ? (initial only 
devid 1 mountable, with other missing)


Thanks, Anand

> Then your patch will allow the fs to be mounted as rw, even some tree
> block can be in the missing device.
> For RO case, it won't be too dangerous, but if we mounted it as RW, who
> knows what will happen.
> (Normal tree COW thing should fail before real write, but I'm not sure
> about other RW operation like scrub/replace/balance and others)
>
> And I think that's the original design concept behind the old missing
> device number check, and it's not a bad idea to follow it anyway.
>
> For the patch size, I find a good idea to handle it, and should make the
> patch(set) size below 200 lines.
>
> Further more, it's even possible to make btrfs change mount option to
> degraded for runtime device missing.
>
> Thanks,
> Qu
>>
>>   I tried to break both the approaches (this patch set and [1]) but I
>> wasn't successful. sorry if I am missing something.
>>
>> Thanks, Anand
>>
>> [1] [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile



