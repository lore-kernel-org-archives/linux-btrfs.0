Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41649 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbcCXDrZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 23:47:25 -0400
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
 <56F35216.1060103@cn.fujitsu.com> <56F3559C.3030201@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F36328.6000406@cn.fujitsu.com>
Date: Thu, 24 Mar 2016 11:46:48 +0800
MIME-Version: 1.0
In-Reply-To: <56F3559C.3030201@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Brad Templeton wrote on 2016/03/23 19:49 -0700:
>
>
> On 03/23/2016 07:33 PM, Qu Wenruo wrote:
>
>>
>> The stage I talked about is only for you fill btrfs from scratch, with 3
>> 4 6 devices.
>>
>> Just as an example to explain how btrfs allocated space on un-even devices.
>>
>>>
>>> Then we had 4 + 3 + 6 + 2, but did not add more files or balance.
>>>
>>> Then we had a remove of the 2, which caused, as expected, all the chunks
>>> on the 2TB drive to be copied to the 6TB drive, as it was the most empty
>>> drive.
>>>
>>> Then we had a balance.  The balance (I would have expected) would have
>>> moved chunks found on both 3 and 4, taking one of them and moving it to
>>> the 6.  Generally alternating taking ones from the 3 and 4.   I can see
>>> no reason this should not work even if 3 and 4 are almost entirely full,
>>> but they were not.
>>> But this did not happen.
>>>
>>>>
>>>> 2) 6T and 3/4 switch stage: Allocate 4T Raid1 chunk.
>>>>      After stage 1), we have 3/3/5 remaining space, then btrfs will pick
>>>>      space from 5T remaining(6T devices), and switch between the other 3T
>>>>      remaining one.
>>>>
>>>>      Cause the remaining space to be 1/1/1.
>>>>
>>>> 3) Fake-even allocation stage: Allocate 1T raid chunk.
>>>>      Now all devices have the same unallocated space, and there are 3
>>>>      devices, we can't really balance all chunks across them.
>>>>      As we must and will only select 2 devices, in this stage, there will
>>>>      be 1T unallocated and never be used.
>>>>
>>>> After all, you will get 1 +4 +1 = 6T, still smaller than (3 + 4 +6 ) /2
>>>> = 6.5T
>>>>
>>>> Now let's talk about your 3 + 4 + 6 case.
>>>>
>>>> For your initial state, 3 and 4 T devices is already filled up.
>>>> Even your 6T device have about 4T available space, it's only 1 device,
>>>> not 2 which raid1 needs.
>>>>
>>>> So, no space for balance to allocate a new raid chunk. The extra 20G is
>>>> so small that almost makes no sence.
>>>
>>> Yes, it was added as an experiment on the suggestion of somebody on the
>>> IRC channel.  I will be rid of it soon.  Still, it seems to me that the
>>> lack of space even after I filled the disks should not interfere with
>>> the balance's ability to move chunks which are found on both 3 and 4 so
>>> that one remains and one goes to the 6.  This action needs no spare
>>> space.   Now I presume the current algorithm perhaps does not work
>>> this way?
>>
>> No, balance is not working like that.
>> Although most user consider balance is moving data, which is partly right.
>> The fact is, balance is, copy-and-delete. And it needs spare space.
>>
>> Means you must have enough space for the extents you are balancing, then
>> btrfs will copy them, update reference, and then delete old data (with
>> its block group).
>>
>> So for balancing data in already filled device, btrfs needs to find
>> space for them first.
>> Which will need 2 devices with unallocated space for RAID1.
>>
>> And in you case, you only have 1 devices with unallocated space, so no
>> space to balance.
>
> Ah.  I would class this as a bug, or at least a non-optimal design.  If
> I understand, you say it tries to move both of the matching chunks to
> new homes.  This makes no sense if there are 3 drives because it is
> assured that one chunk is staying on the same drive.   Even with 4 or
> more drives, where this could make sense, in fact it would still be wise
> to attempt to move only one of the pair of chunks, and then move the
> other if that is also a good idea.

For only one of the pair of chunk, you mean a stripe of a chunk.
And in that case, IIRC only replace is doing like that.

In most case, btrfs do in chunk unit, which means that may move data 
inside a device.

Even in that case, it's still useful.

For example, there is a chunk(1G size) which only contains 1 extent(4K).
Such balance can move the 4K extent into an existing chunk, and free the 
whole 1G chunk to allow new chunk to be created.

Considering balance is not only for making chunk allocation even, but 
also for a lot of other use, IMHO the behavior can hardly called as a bug.

>
>
>>
>>
>>>
>>> My next plan is to add the 2tb back. If I am right, balance will move
>>> chunks from 3 and 4 to the 2TB,
>>
>> Not only to 2TB, but to 2TB and 6TB. Never forgot that RAID1 needs 2
>> devices.
>> And if 2TB is filled and 3/4 and free space, it's also possible to 3/4
>> devices.
>>
>> That will free 2TB in already filled up devices. But that's still not
>> enough to get space even.
>>
>> You may need to balance several times(maybe 10+) to make space a little
>> even, as balance won't balance any chunk which is created by balance.
>> (Or balance will loop infinitely).
>
> Now I understand -- I had not thought it would try to move 2 when that's
> so obviously wrong on a 3-drive, and so I was not thinking of the
> general case.  So I can now calculate that if I add the 2TB, in an ideal
> situation, it will perhaps get 1TB of chunks and the 6TB will get 1TB of
> chunks and then the 4 drives will have 3 with 1TB free, and the 6TB will
> have 3TB free.   Then when I remove the 2TB, the 6TB should get all its
> chunks and will have 2TB free and the other two 1TB free and that's
> actually the right situation as all new blocks will appear on the 6TB
> and one of the other two drives.
>
> I don't want to keep 4 drives because small drives consume power for
> little, better to move them to other purposes (offline backup etc.)
>
>   In the algorithm below, does "chunk" refer to both the redundant copies
> of the data, or just to one of them?

Both, or more specifically, the logical data itself.

The copy is normally called stripe of the chunk.
In raid1 case, all the 2 stripes are just the same of the chunk contents.

In btrfs' view(logical address space), Btrfs only cares which chunk 
covers which bytenr range. This makes a lot things easier.

Like (0~1M range is never covered by any chunk)
Logical bytenr:
0        1G          2G          3G          4G
          |<-Chunk 1->|<-Chunk 2->|<-Chunk 3->|

Then how each chunk mapped to devices only needs chunk tree to consider.
Most part of btrfs only need to care about the logical address space.

In chunk tree, it records how chunk is mapped into real devices.
Chunk1: type RAID1|DATA, length 1G
         stripe 0 dev1, dev bytenr XXXX
         stripe 1 dev2, dev bytenr YYYY

Chunk2: type RAID1|METADATA, length 1G
         stripe 0 dev2, dev bytenr ZZZZ
         stripe 1 dev3, dev bytenr WWWW

And what balance do, is to move all extents(if possible) inside a chunk 
to another place.
Maybe a new chunk, or an old chunk with enough space.
For example, after balancing chunk1, btrfs creates a new chunk, chunk4.

Copy some extents inside chunk1 to chunk 4, some to chunk 2 and 3.

However stripes of chunk4 can still be in dev1 and dev2, although bytenr 
must changed.

0       1G          2G          3G          4G          5G
         |           |<-Chunk 2->|<-Chunk 3->|<-Chunk 4->|
Chunk 4: Type RAID1|DATA length 1G
          stripe 0 dev1, dev bytenr Some new BYTENR
          stripe 0 dev2, dev bytenr Some new BYTENR

>  I am guessing my misunderstanding
> may come from it referring to both, and moving both?

It's common to consider balance as moving data, and some times the idea 
of "moving" leads to misunderstanding.

>
> The ability of it to move within the same device you describe is
> presumably there for combining things together to a chunk, but it
> appears it slows down the drive rebalancing plan.

Personally speaking, the fastest plan is to create a 6T + 6T btrfs raid, 
and copy all data from old raid to them.
And only add devices in pair of same size to that raid.
No need to ever bother balancing (mostly).

Balance is never as fast as normal copy, unfortunately.

Thanks,
Qu
>
> Thanks for your explanations.
>>
>>> but it should not move any from the 6TB
>>> because it has so much space.
>>
>> That's also wrong.
>> Whether balance will move data from 6TB devices, is only determined by
>> if the src chunk has stripe on 6TB devices and there is enough space to
>> copy them to.
>>
>> Balance, unlike chunk allocation, is much simple and no complicated
>> space calculation.
>>
>> 1) Check current chunk
>>     If the chunk is out of chunk range (beyond last chunk, which means
>>     we are done and current chunk is newly created one)
>>     then we finish balance.
>>
>> 2) Check if we have enough space for current chunk.
>>     Including creating new chunks.
>>
>> 3) Copy all exntets in this chunk to new location
>>
>> 4) Update reference of all extents to point to new location
>>     And free old extents.
>>
>> 5) Goto next chunk.(bytenr order)
>>
>> So, it's possible that some data in 6TB devices is moved to 6TB again,
>> or to the empty 2TB devices.
>>
>> It's chunk allocator which ensure the new chunk (destination chunk) is
>> allocated from 6T and empty 2T devices.
>>
>>>   LIkewise, when I re-remove the 2tb, all
>>> its chunks should move to the 6tb, and I will be at least in a usable
>>> state.
>>>
>>> Or is the single approach faster?
>>
>> As mentioned, not that easy. The 2Tb devices is not the silver bullet at
>> all.
>>
>> Re-convert method is the preferred one, although it's not perfect.
>>
>> Thanks,
>> Qu
>>>
>>>>
>>>>
>>>> The convert to single then back to raid1, will do its job partly.
>>>> But according to other report from mail list.
>>>> The result won't be perfect even, even the reporter uses devices with
>>>> all same size.
>>>>
>>>>
>>>> So to conclude:
>>>>
>>>> 1) Btrfs will use most of devices space for raid1.
>>>> 2) 1) only happens if one fills btrfs from scratch
>>>> 3) For already filled case, convert to single then convert back will
>>>>      work, but not perfectly.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>>
>>>>>
>>>>>> Under mdadm the bigger drive
>>>>>> still helped, because it replaced at smaller drive, the one that was
>>>>>> holding the RAID back, but you didn't get to use all the big drive
>>>>>> until
>>>>>> a year later when you had upgraded them all.  In the meantime you used
>>>>>> the extra space in other RAIDs.  (For example, a raid-5 plus a
>>>>>> raid-1 on
>>>>>> the 2 bigger drives) Or you used the extra space as non-RAID space,
>>>>>> ie.
>>>>>> space for static stuff that has offline backups.  In fact, most of my
>>>>>> storage is of that class (photo archives, reciprocal backups of other
>>>>>> systems) where RAID is not needed.
>>>>>>
>>>>>> So the long story is, I think most home users are likely to always
>>>>>> have
>>>>>> different sizes and want their FS to treat it well.
>>>>>
>>>>> Yes of course. And at the expense of getting a frownie face....
>>>>>
>>>>> "Btrfs is under heavy development, and is not suitable for
>>>>> any uses other than benchmarking and review."
>>>>> https://www.kernel.org/doc/Documentation/filesystems/btrfs.txt
>>>>>
>>>>> Despite that disclosure, what you're describing is not what I'd expect
>>>>> and not what I've previously experienced. But I haven't had three
>>>>> different sized drives, and they weren't particularly full, and I
>>>>> don't know if you started with three from the outset at mkfs time or
>>>>> if this is the result of two drives with a third added on later, etc.
>>>>> So the nature of file systems is actually really complicated and it's
>>>>> normal for there to be regressions - and maybe this is a regression,
>>>>> hard to say with available information.
>>>>>
>>>>>
>>>>>
>>>>>> Since 6TB is a relatively new size, I wonder if that plays a role.
>>>>>> More
>>>>>> than 4TB of free space to balance into, could that confuse it?
>>>>>
>>>>> Seems unlikely.
>>>>>
>>>>>
>>>>
>>>
>>>
>>
>
>


