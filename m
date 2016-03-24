Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64144 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753048AbcCXCeI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 22:34:08 -0400
Subject: Re: RAID-1 refuses to balance large drive
To: <bradtem@gmail.com>, Chris Murphy <lists@colorremedies.com>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com>
 <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com>
 <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com>
 <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
 <56F349F0.5070202@cn.fujitsu.com> <56F34D5F.4080407@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F35216.1060103@cn.fujitsu.com>
Date: Thu, 24 Mar 2016 10:33:58 +0800
MIME-Version: 1.0
In-Reply-To: <56F34D5F.4080407@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Brad Templeton wrote on 2016/03/23 19:13 -0700:
>
>
> On 03/23/2016 06:59 PM, Qu Wenruo wrote:
>
>>
>> About chunk allocation problem, I hope to get a clear view of the whole
>> disk layout now.
>>
>> What's the final disk layout?
>> Is that 4T + 3T + 6T + 20G layout?
>>
>> If so, I'll say, in that case, only fully re-convert to single may help.
>> As there is no enough space to allocate new raid1 chunks for balance
>> them all.
>>
>>
>> Chris Murphy may have already mentioned, btrfs chunk allocation has some
>> limitation, although it is already more flex than mdadm.
>>
>>
>> Btrfs chunk allocation will choose the device with most unallocated, and
>> for raid1, it will ensure always pick 2 different devices to allocation.
>>
>> This allocation does make btrfs raid1 allocation more space in a more
>> flex method than mdadm raid1.
>> But that only works if you start from scratch.
>>
>> I'll explain it that case first.
>>
>> 1) 6T and 4T devices only stage: Allocate 1T Raid1 chunk.
>>     As 6T and 4T devices have the most unallocated space, so the first
>>     1T raid chunk will be allocated from them.
>>     Remaining space: 3/3/5
>
> This stage never existed.  We had a 4 + 3 + 2 stage, which was low-ish
> on space but not full.  I mean it had hundreds of gb free.

The stage I talked about is only for you fill btrfs from scratch, with 3 
4 6 devices.

Just as an example to explain how btrfs allocated space on un-even devices.

>
> Then we had 4 + 3 + 6 + 2, but did not add more files or balance.
>
> Then we had a remove of the 2, which caused, as expected, all the chunks
> on the 2TB drive to be copied to the 6TB drive, as it was the most empty
> drive.
>
> Then we had a balance.  The balance (I would have expected) would have
> moved chunks found on both 3 and 4, taking one of them and moving it to
> the 6.  Generally alternating taking ones from the 3 and 4.   I can see
> no reason this should not work even if 3 and 4 are almost entirely full,
> but they were not.
> But this did not happen.
>
>>
>> 2) 6T and 3/4 switch stage: Allocate 4T Raid1 chunk.
>>     After stage 1), we have 3/3/5 remaining space, then btrfs will pick
>>     space from 5T remaining(6T devices), and switch between the other 3T
>>     remaining one.
>>
>>     Cause the remaining space to be 1/1/1.
>>
>> 3) Fake-even allocation stage: Allocate 1T raid chunk.
>>     Now all devices have the same unallocated space, and there are 3
>>     devices, we can't really balance all chunks across them.
>>     As we must and will only select 2 devices, in this stage, there will
>>     be 1T unallocated and never be used.
>>
>> After all, you will get 1 +4 +1 = 6T, still smaller than (3 + 4 +6 ) /2
>> = 6.5T
>>
>> Now let's talk about your 3 + 4 + 6 case.
>>
>> For your initial state, 3 and 4 T devices is already filled up.
>> Even your 6T device have about 4T available space, it's only 1 device,
>> not 2 which raid1 needs.
>>
>> So, no space for balance to allocate a new raid chunk. The extra 20G is
>> so small that almost makes no sence.
>
> Yes, it was added as an experiment on the suggestion of somebody on the
> IRC channel.  I will be rid of it soon.  Still, it seems to me that the
> lack of space even after I filled the disks should not interfere with
> the balance's ability to move chunks which are found on both 3 and 4 so
> that one remains and one goes to the 6.  This action needs no spare
> space.   Now I presume the current algorithm perhaps does not work this way?

No, balance is not working like that.
Although most user consider balance is moving data, which is partly right.
The fact is, balance is, copy-and-delete. And it needs spare space.

Means you must have enough space for the extents you are balancing, then 
btrfs will copy them, update reference, and then delete old data (with 
its block group).

So for balancing data in already filled device, btrfs needs to find 
space for them first.
Which will need 2 devices with unallocated space for RAID1.

And in you case, you only have 1 devices with unallocated space, so no 
space to balance.


>
> My next plan is to add the 2tb back. If I am right, balance will move
> chunks from 3 and 4 to the 2TB,

Not only to 2TB, but to 2TB and 6TB. Never forgot that RAID1 needs 2 
devices.
And if 2TB is filled and 3/4 and free space, it's also possible to 3/4 
devices.

That will free 2TB in already filled up devices. But that's still not 
enough to get space even.

You may need to balance several times(maybe 10+) to make space a little 
even, as balance won't balance any chunk which is created by balance.
(Or balance will loop infinitely).

> but it should not move any from the 6TB
> because it has so much space.

That's also wrong.
Whether balance will move data from 6TB devices, is only determined by 
if the src chunk has stripe on 6TB devices and there is enough space to 
copy them to.

Balance, unlike chunk allocation, is much simple and no complicated 
space calculation.

1) Check current chunk
    If the chunk is out of chunk range (beyond last chunk, which means
    we are done and current chunk is newly created one)
    then we finish balance.

2) Check if we have enough space for current chunk.
    Including creating new chunks.

3) Copy all exntets in this chunk to new location

4) Update reference of all extents to point to new location
    And free old extents.

5) Goto next chunk.(bytenr order)

So, it's possible that some data in 6TB devices is moved to 6TB again, 
or to the empty 2TB devices.

It's chunk allocator which ensure the new chunk (destination chunk) is 
allocated from 6T and empty 2T devices.

>  LIkewise, when I re-remove the 2tb, all
> its chunks should move to the 6tb, and I will be at least in a usable state.
>
> Or is the single approach faster?

As mentioned, not that easy. The 2Tb devices is not the silver bullet at 
all.

Re-convert method is the preferred one, although it's not perfect.

Thanks,
Qu
>
>>
>>
>> The convert to single then back to raid1, will do its job partly.
>> But according to other report from mail list.
>> The result won't be perfect even, even the reporter uses devices with
>> all same size.
>>
>>
>> So to conclude:
>>
>> 1) Btrfs will use most of devices space for raid1.
>> 2) 1) only happens if one fills btrfs from scratch
>> 3) For already filled case, convert to single then convert back will
>>     work, but not perfectly.
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>
>>>> Under mdadm the bigger drive
>>>> still helped, because it replaced at smaller drive, the one that was
>>>> holding the RAID back, but you didn't get to use all the big drive until
>>>> a year later when you had upgraded them all.  In the meantime you used
>>>> the extra space in other RAIDs.  (For example, a raid-5 plus a raid-1 on
>>>> the 2 bigger drives) Or you used the extra space as non-RAID space, ie.
>>>> space for static stuff that has offline backups.  In fact, most of my
>>>> storage is of that class (photo archives, reciprocal backups of other
>>>> systems) where RAID is not needed.
>>>>
>>>> So the long story is, I think most home users are likely to always have
>>>> different sizes and want their FS to treat it well.
>>>
>>> Yes of course. And at the expense of getting a frownie face....
>>>
>>> "Btrfs is under heavy development, and is not suitable for
>>> any uses other than benchmarking and review."
>>> https://www.kernel.org/doc/Documentation/filesystems/btrfs.txt
>>>
>>> Despite that disclosure, what you're describing is not what I'd expect
>>> and not what I've previously experienced. But I haven't had three
>>> different sized drives, and they weren't particularly full, and I
>>> don't know if you started with three from the outset at mkfs time or
>>> if this is the result of two drives with a third added on later, etc.
>>> So the nature of file systems is actually really complicated and it's
>>> normal for there to be regressions - and maybe this is a regression,
>>> hard to say with available information.
>>>
>>>
>>>
>>>> Since 6TB is a relatively new size, I wonder if that plays a role.  More
>>>> than 4TB of free space to balance into, could that confuse it?
>>>
>>> Seems unlikely.
>>>
>>>
>>
>
>


