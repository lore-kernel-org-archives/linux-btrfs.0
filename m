Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29053 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751948AbcDUGKL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 02:10:11 -0400
Subject: Re: Question: raid1 behaviour on failure
To: <bo.li.liu@oracle.com>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
 <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
 <nf9o32$7r4$1@ger.gmane.org>
 <180d89ae-32cf-ad59-2b6e-56ed82e9f439@cn.fujitsu.com>
 <20160421060243.GB10789@localhost.localdomain>
CC: Matthias Bodenbinder <matthias@bodenbinder.de>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c425e917-44a6-626a-f109-11b9ec99bb8e@cn.fujitsu.com>
Date: Thu, 21 Apr 2016 14:09:59 +0800
MIME-Version: 1.0
In-Reply-To: <20160421060243.GB10789@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2016/04/20 23:02 -0700:
> On Thu, Apr 21, 2016 at 01:43:56PM +0800, Qu Wenruo wrote:
>>
>>
>> Matthias Bodenbinder wrote on 2016/04/21 07:22 +0200:
>>> Am 20.04.2016 um 09:25 schrieb Qu Wenruo:
>>>
>>>>
>>>> Unfortunately, this is the designed behavior.
>>>>
>>>> The fs is rw just because it doesn't hit any critical problem.
>>>>
>>>> If you try to touch a file and then sync the fs, btrfs will become RO immediately.
>>>>
>>> ....
>>>
>>>> Btrfs fails to read space cache, nor make a new dir.
>>>>
>>>> The failure on cow_block in mkdir is ciritical, and btrfs become RO.
>>>>
>>>> All expected behavior so far.
>>>>
>>>> You may try use degraded mount option, but AFAIK it may not handle case like yours.
>>>
>>> This really scares me. "Expected bevahour"?
>>> So you are saying: If one of the drives in the raid1 is going dead without noticing btrfs, the redundancy is lost.
>>>
>>> Lets say, the power unit of a disc is going dead. This disc will disappear from the raid1 pretty much as suddenly as in my test case here. No difference.
>>>
>>> You are saying that in this case, btrfs should exactly behave like this? If that is the case I eventually need to rethink my interpretation of redundancy.
>>>
>>> Matthias
>>>
>>
>> The "expected behavior" just means the abort transaction behavior for
>> critical error is expected.
>>
>> And you should know, btrfs is not doing full block level RAID1, it's doing
>> RAID at chunk level.
>> Which needs to consider more things than full block level RAID1, and it's
>> more flex than block level raid1.
>> (For example, you can use 3 devices with different sizes to do btrfs RAID1
>> and get more available size than mdadm raid1)
>>
>> You may think the behavior is totally insane for btrfs RAID1, but don't
>> forget, btrfs can have different metdata/data profile.
>> (And even more, there is already plan to support different profile for
>> different subvolumes)
>>
>> In case your metadata is RAID1, your data can still be RAID0, and in that
>> case a missing devices can still cause huge problem.
>
> From an user's point of view, what you're saying is more an excuse and
> kind of irrelavant.  Stop doing that please, try to fix the insane behavior instead.
>
> Thanks,
>
> -liubo

Didn't you see I have already submitted the first version of per-chunk 
degradable patchset for a long time to address the problem?

And you should blame the person who is blocking the patchset from 
merging by refusing the split them along.

Thanks,
Qu

>
>>
>> There are already unmerged patches which will partly do the mdadm level
>> behavior, like automatically change to degraded mode without making the fs
>> RO.
>>
>> The original patchset:
>> http://comments.gmane.org/gmane.comp.file-systems.btrfs/48335
>>
>> Or the latest patchset inside Anand Jain's auto-replace patchset:
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/55446
>>
>> Thanks,
>> Qu
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


