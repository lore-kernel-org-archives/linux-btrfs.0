Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:43309 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750827AbdFUUM4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 16:12:56 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Exactly what is wrong with RAID5/6
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
 <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <34ac2dd7-88ba-6de7-d8e2-061c283bb9c1@inwind.it>
Date: Wed, 21 Jun 2017 22:12:52 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-21 20:24, Chris Murphy wrote:
> On Wed, Jun 21, 2017 at 2:45 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> 
>> Unlike pure stripe method, one fully functional RAID5/6 should be written in
>> full stripe behavior, which is made up by N data stripes and correct P/Q.
>>
>> Given one example to show how write sequence affects the usability of
>> RAID5/6.
>>
>> Existing full stripe:
>> X = Used space (Extent allocated)
>> O = Unused space
>> Data 1   |XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
>> Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
>> Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|
>>
>> When some new extent is allocated to data 1 stripe, if we write
>> data directly into that region, and crashed.
>> The result will be:
>>
>> Data 1   |XXXXXX|XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
>> Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
>> Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|
>>
>> Parity stripe is not updated, although it's fine since data is still
>> correct, this reduces the usability, as in this case, if we lost device
>> containing data 2 stripe, we can't recover correct data of data 2.
>>
>> Although personally I don't think it's a big problem yet.
>>
>> Someone has idea to modify extent allocator to handle it, but anyway I don't
>> consider it's worthy.
> 
> 
> If there is parity corruption and there is a lost device (or bad
> sector causing lost data strip), that is in effect two failures and no
> raid5 recovers, you have to have raid6. 

Generally speaking, when you write "two failure" this means two failure at the same time. But the write hole happens even if these two failures are not at the same time:

Event #1: power failure between the data stripe write and the parity stripe write. The stripe is incoherent.
Event #2: a disk is failing: if you try to read the data from the remaining data and the parity you have wrong data.

The likelihood of these two event at the same time (power failure and  in the next boot a disk is failing) is quite low. But in the life of a filesystem, these two event likely happens.

However BTRFS has an advantage: a simple scrub may (crossing finger) recover from event #1.

> However, I don't know whether
> Btrfs raid6 can even recover from it? If there is a single device
> failure, with a missing data strip, you have both P&Q. Typically raid6
> implementations use P first, and only use Q if P is not available. Is
> Btrfs raid6 the same? And if reconstruction from P fails to match data
> csum, does Btrfs retry using Q? Probably not is my guess.

It could, and in any case it is only an "implementation detail" :-)
> 
> I think that is a valid problem calling for a solution on Btrfs, given
> its mandate. It is no worse than other raid6 implementations though
> which would reconstruct from bad P, and give no warning, leaving it up
> to application layers to deal with the problem.
> 
> I have no idea how ZFS RAIDZ2 and RAIDZ3 handle this same scenario.

If I understood correctly, ZFS has a variable stripe size. In BTRFS could be easily implemented: it would be sufficient to have different block group with different number of disk.

If a filesystem is composed by 5 disks, it will contain:

1 BG RAID1 for writing up-to 64k
1 BG RAID5 (3 disks) for writing up-to 128k
1 BG RAID5 (4 disks) for writing up-to 192k
1 BG RAID5 (5 disks) for all other disks

Time to time the filesystem would need a re-balance in order to empty the smaller block group. 


Another option could be to track the stripes involved by a RWM cycle (i.e. all the writings smaller than a stripe size, which in a COW filesystem, are suppose to be few) in an "intent log", and scrubbing all these stripes if a power failure happens .




> 
> 
> 
>>
>>>
>>> 2. Parity data is not checksummed
>>> Why is this a problem? Does it have to do with the design of BTRFS
>>> somehow?
>>> Parity is after all just data, BTRFS does checksum data so what is the
>>> reason this is a problem?
>>
>>
>> Because that's one solution to solve above problem.
>>
>> And no, parity is not data.
> 
> Parity strip is differentiated from data strip, and by itself parity
> is meaningless. But parity plus n-1 data strips is an encoded form of
> the missing data strip, and is therefore an encoded copy of the data.
> We kinda have to treat the parity as fractionally important compared
> to data; just like each mirror copy has some fractional value. You
> don't have to have both of them, but you do have to have at least one
> of them.
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
