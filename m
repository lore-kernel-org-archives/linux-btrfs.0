Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2641 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751653AbcAFA6K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 19:58:10 -0500
Subject: Re: Crash, boot mount failure: "corrupt leaf, slot offset bad"
To: Chris Bainbridge <chris.bainbridge@gmail.com>
References: <20160104170553.GA4975@localhost>
 <568B2304.8090205@cn.fujitsu.com>
 <CAP-bSRYB4mH1TK9uQnHQaMazxOnMcmCYkhF9xXmrVHPbveZLQQ@mail.gmail.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <568C6678.8020803@cn.fujitsu.com>
Date: Wed, 6 Jan 2016 08:57:28 +0800
MIME-Version: 1.0
In-Reply-To: <CAP-bSRYB4mH1TK9uQnHQaMazxOnMcmCYkhF9xXmrVHPbveZLQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Bainbridge wrote on 2016/01/05 13:41 +0000:
> On 5 January 2016 at 01:57, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>> Data, single: total=106.79GiB, used=82.01GiB
>>> System, single: total=4.00MiB, used=16.00KiB
>>> Metadata, single: total=2.01GiB, used=1.51GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> That's the btrfs fi df misleading output confusing you.
>>
>> In fact, your metadata is already used up without available space.
>> GlobalReserve should also be counted as Metadata *used* space.
>
> Thanks for the explanation - the FAQ[1] misleads when it describes
> GlobalReserve as "The block reserve is only virtual and is not stored
> on the devices." - which sounds like the reserve is literally not
> stored on the drive.

In fact FAQ description is not wrong either.

GlobalReserve is not stored in any where, that's true.
Since it doesn't takes space(unless its used is not 0), it is stored no 
where and FAQ is right.

Metadata allocation algorithm will try its best to keep enough free 
space for GlobalReserve.
So for end user, space you can't directly use is no different from used 
space.

>
> The FAQ[2] also suggests that the free space in metadata can be less
> than the block reserve total:
>
> "If the free space in metadata is less than or equal to the block
> reserve value (typically 512 MiB, but might be something else on a
> particularly small or large filesystem), then it's close to full."
>
> But what you are saying is that this is wrong and the free space in
> metadata can never be less than the block reserve, because the block
> reserve includes the metadata free space?

Sorry for the confusion.
Yes, it's possible for available metadata space less than global reserve 
space.

But when it happens, your used space in GlobalReserved is not 0, and 
unfortunately you are already super short of space.
Meaning you are even unable to touch an empty file.

And in that case, if your kernel is not new enough, you can't even 
delete a file thanks to the metadata COW.

So for common case, one can just treat global reserve as used metadata, 
unless used global reserve is not 0.

>
> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_GlobalReserve_and_why_does_.27btrfs_fi_df.27_show_it_as_single_even_on_RAID_filesystems.3F
> [2] https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29
>
>> Good, 5GiB freed space, it can be allocated for metadata to slightly reduce
>> the metadata pressure.
>>
>> But not for long.
>> The root resolve will be, add more space into this btrfs.
>
> Yes but this is a 128GB SSD and metadata could have been reallocated
> from some of the 25GB of free space allocated to data.

This can only happens when:
1) All data chunk is balanced into super compact case, to free all the 25G
    Since btrfs store data and metadata into different chunks, one needs
    to use balance to free space from allocated data/metadata chunks.

    And in your case, you just tried dlimit=1 2 and 5, which will only
    free at most 8 chunks (and at most 8G space).

    If you want to free all the 25G free space from data chunks, then no
    dlimit at all.

2) Mixed block groups.
    This is the most straightforward case.
    All data and metadata can be stored into the same chunk. Then no
    such problem at all.

    But developers tends to avoid such behavior though.
> Even with a
> bigger drive, it is possible that chunks could be allocated to data,
> and then later operations requiring more metadata will still run out
> (running out of metadata space seems to be a reasonably common
> occurrence judging by the number of "why is btrfs reporting no space
> when I have space free" questions).

This is true, and that's the long existing btrfs problem.

Except balance and add more devices, there is no super good ideas so far.
Maybe one day we can enhance it from the allocation algorithm.

> The file system shouldn't be corrupted when that happens.
>

I'm sorry that I'm off topic for the GlobalReserve and unbalanced 
data/metadata chunk.

But I don't consider the corruption is caused by unbalanced 
data/metadata chunks.

So let's go back to the corruption case.

Since you took the image of the corrupted fs, would you please try the 
following commands on the corrupted fs?

$ btrfs-debug-tree -b 67239936 <dumped image>

And, what the kernel mount option for the fs before crash?

The kernel messages shows that your tree root is corrupted.
This is common for a power loss.

But the problem is, btrfs uses barrier to ensure superblock is written 
to disk *after* all other metadata committed.
Or superblock is not updated and still points to old metadata, makes 
everything fine.

So, either barrier is broken or you specified nobarrier, or the power 
loss directly corrupted the new tree root and magically makes the csum 
still match.

Thanks,
Qu


