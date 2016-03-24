Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1588 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752350AbcCXB73 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 21:59:29 -0400
Subject: Re: RAID-1 refuses to balance large drive
To: Chris Murphy <lists@colorremedies.com>, Brad Templeton <bradtem@gmail.com>
References: <56F1E7BE.1000004@gmail.com> <56F21510.6050707@cn.fujitsu.com>
 <56F21FC5.50209@gmail.com>
 <CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
 <56F22F80.501@gmail.com>
 <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
 <56F2C991.9080500@gmail.com>
 <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
 <56F2EA25.4070004@gmail.com>
 <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F349F0.5070202@cn.fujitsu.com>
Date: Thu, 24 Mar 2016 09:59:12 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy wrote on 2016/03/23 13:33 -0600:
> On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com> wrote:
>> It is Ubuntu wily, which is 4.2 and btrfs-progs 0.4.  I will upgrade to
>> Xenial in April but probably not before, I don't have days to spend on
>> this.   Is there a fairly safe ppa to pull 4.4 or 4.5?
>
> I'm not sure.
>
>
>   In olden days, I
>> would patch and build my kernels from source but I just don't have time
>> for all the long-term sysadmin burden that creates any more.
>>
>> Also, I presume if this is a bug, it's in btrfsprogs, though the new one
>> presumably needs a newer kernel too.
>
> No you can mix and match progs and kernel versions. You just don't get
> new features if you don't have a new kernel.
>
> But the issue is the balance code is all in the kernel. It's activated
> by user space tools but it's all actually done by kernel code.
>
>
>
>> I am surprised to hear it said that having the mixed sizes is an odd
>> case.
>
> Not odd as in wrong, just uncommon compared to other arrangements being tested.
>
>>   That was actually one of the more compelling features of btrfs
>> that made me switch from mdadm, lvm and the rest.   I presumed most
>> people were the same. You need more space, you go out and buy a new
>> drive and of course the new drive is bigger than the old drives you
>> bought because they always get bigger.
>
> Of course and I'm not saying it shouldn't work. The central problem
> here is we don't even know what the problem really is; we only know
> the manifestation of the problem isn't the desired or expected
> outcome. And how to find out the cause is different than how to fix
> it.

About chunk allocation problem, I hope to get a clear view of the whole 
disk layout now.

What's the final disk layout?
Is that 4T + 3T + 6T + 20G layout?

If so, I'll say, in that case, only fully re-convert to single may help.
As there is no enough space to allocate new raid1 chunks for balance 
them all.


Chris Murphy may have already mentioned, btrfs chunk allocation has some 
limitation, although it is already more flex than mdadm.


Btrfs chunk allocation will choose the device with most unallocated, and 
for raid1, it will ensure always pick 2 different devices to allocation.

This allocation does make btrfs raid1 allocation more space in a more 
flex method than mdadm raid1.
But that only works if you start from scratch.

I'll explain it that case first.

1) 6T and 4T devices only stage: Allocate 1T Raid1 chunk.
    As 6T and 4T devices have the most unallocated space, so the first
    1T raid chunk will be allocated from them.
    Remaining space: 3/3/5

2) 6T and 3/4 switch stage: Allocate 4T Raid1 chunk.
    After stage 1), we have 3/3/5 remaining space, then btrfs will pick
    space from 5T remaining(6T devices), and switch between the other 3T
    remaining one.

    Cause the remaining space to be 1/1/1.

3) Fake-even allocation stage: Allocate 1T raid chunk.
    Now all devices have the same unallocated space, and there are 3
    devices, we can't really balance all chunks across them.
    As we must and will only select 2 devices, in this stage, there will
    be 1T unallocated and never be used.

After all, you will get 1 +4 +1 = 6T, still smaller than (3 + 4 +6 ) /2 
= 6.5T

Now let's talk about your 3 + 4 + 6 case.

For your initial state, 3 and 4 T devices is already filled up.
Even your 6T device have about 4T available space, it's only 1 device, 
not 2 which raid1 needs.

So, no space for balance to allocate a new raid chunk. The extra 20G is 
so small that almost makes no sence.


The convert to single then back to raid1, will do its job partly.
But according to other report from mail list.
The result won't be perfect even, even the reporter uses devices with 
all same size.


So to conclude:

1) Btrfs will use most of devices space for raid1.
2) 1) only happens if one fills btrfs from scratch
3) For already filled case, convert to single then convert back will
    work, but not perfectly.

Thanks,
Qu

>
>
>
>> Under mdadm the bigger drive
>> still helped, because it replaced at smaller drive, the one that was
>> holding the RAID back, but you didn't get to use all the big drive until
>> a year later when you had upgraded them all.  In the meantime you used
>> the extra space in other RAIDs.  (For example, a raid-5 plus a raid-1 on
>> the 2 bigger drives) Or you used the extra space as non-RAID space, ie.
>> space for static stuff that has offline backups.  In fact, most of my
>> storage is of that class (photo archives, reciprocal backups of other
>> systems) where RAID is not needed.
>>
>> So the long story is, I think most home users are likely to always have
>> different sizes and want their FS to treat it well.
>
> Yes of course. And at the expense of getting a frownie face....
>
> "Btrfs is under heavy development, and is not suitable for
> any uses other than benchmarking and review."
> https://www.kernel.org/doc/Documentation/filesystems/btrfs.txt
>
> Despite that disclosure, what you're describing is not what I'd expect
> and not what I've previously experienced. But I haven't had three
> different sized drives, and they weren't particularly full, and I
> don't know if you started with three from the outset at mkfs time or
> if this is the result of two drives with a third added on later, etc.
> So the nature of file systems is actually really complicated and it's
> normal for there to be regressions - and maybe this is a regression,
> hard to say with available information.
>
>
>
>> Since 6TB is a relatively new size, I wonder if that plays a role.  More
>> than 4TB of free space to balance into, could that confuse it?
>
> Seems unlikely.
>
>


