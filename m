Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58382 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755667AbbIUCJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:09:42 -0400
Subject: Re: [PATCH 2/2] btrfs: Remove unneeded missing device number check
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        <linux-btrfs@vger.kernel.org>
References: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1442375031-18212-2-git-send-email-quwenruo@cn.fujitsu.com>
 <55FA8B31.9080604@oracle.com> <55FA8F8B.6060903@gmx.com>
 <55FB6D31.9030504@oracle.com> <55FB71A8.3000004@cn.fujitsu.com>
 <55FBB2F7.4040402@oracle.com> <55FDFE46.40600@gmx.com>
 <55FE462D.2010503@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55FF66E1.2010508@cn.fujitsu.com>
Date: Mon, 21 Sep 2015 10:09:37 +0800
MIME-Version: 1.0
In-Reply-To: <55FE462D.2010503@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2015/09/20 13:37 +0800:
>
>
> On 09/20/2015 08:31 AM, Qu Wenruo wrote:
>>
>>
>> 在 2015年09月18日 14:45, Anand Jain 写道:
>>>
>>> Hi Qu,
>>>
>>>   Thanks for the comments on patch [1].
>>>
>>>> For example, if one use single metadata for 2 disks,
>>>  > and each disk has one metadata chunk on it.
>>>
>>>   how that can be achieved ?
>> By this, I mean, the metadata profile is SINGLE,
>> and there is 2 metadata chunks.
>>
>> One on disk1 and one on disk2.
>>
>> As btrfs chunk allocate will always use device by avaiable space order,
>> it should be quite easy to archieve that situation.
>>
>> In that case, any missing device will be a disaster,
>
>   in this case the read chunk would anyway fail, right ?
>   and that will lead to mount fail.
>
> Thanks, Anand

Yes, read will cause fail, but I'm not completely sure other operation 
can handle it well or not.
Like chunk/extent allocation or scrub/replace/balance.

So I'd still keep it allow RO mount only.

Thanks,
Qu

>
>> and it's better not
>> to allow RW mount.
>>
>> Thanks,
>> Qu
>>>
>>>> One device got missing later.
>>>
>>>   it would surely depend on which one of the device ? (initial only
>>> devid 1 mountable, with other missing)
>>>
>>>
>>> Thanks, Anand
>>>
>>>> Then your patch will allow the fs to be mounted as rw, even some tree
>>>> block can be in the missing device.
>>>> For RO case, it won't be too dangerous, but if we mounted it as RW, who
>>>> knows what will happen.
>>>> (Normal tree COW thing should fail before real write, but I'm not sure
>>>> about other RW operation like scrub/replace/balance and others)
>>>>
>>>> And I think that's the original design concept behind the old missing
>>>> device number check, and it's not a bad idea to follow it anyway.
>>>>
>>>> For the patch size, I find a good idea to handle it, and should make
>>>> the
>>>> patch(set) size below 200 lines.
>>>>
>>>> Further more, it's even possible to make btrfs change mount option to
>>>> degraded for runtime device missing.
>>>>
>>>> Thanks,
>>>> Qu
>>>>>
>>>>>   I tried to break both the approaches (this patch set and [1]) but I
>>>>> wasn't successful. sorry if I am missing something.
>>>>>
>>>>> Thanks, Anand
>>>>>
>>>>> [1] [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
