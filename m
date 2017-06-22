Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17769 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751126AbdFVCMU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 22:12:20 -0400
Subject: Re: Exactly what is wrong with RAID5/6
To: Chris Murphy <lists@colorremedies.com>
CC: waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
 <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1d88f12a-bd2a-9fff-cb53-da847f4526c7@cn.fujitsu.com>
Date: Thu, 22 Jun 2017 10:12:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/22/2017 02:24 AM, Chris Murphy wrote:
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
> raid5 recovers, you have to have raid6. However, I don't know whether
> Btrfs raid6 can even recover from it? If there is a single device
> failure, with a missing data strip, you have both P&Q. Typically raid6
> implementations use P first, and only use Q if P is not available. Is
> Btrfs raid6 the same? And if reconstruction from P fails to match data
> csum, does Btrfs retry using Q? Probably not is my guess.

Well, in fact, thanks to data csum and btrfs metadata CoW, there is 
quite a high chance that we won't cause any data damage.

For the example I gave above, no data damage at all.

First the data is written and power loss, and data is always written 
before metadata, so that's to say, after power loss, superblock is still 
using the old tree roots.

So no one is really using that newly written data.

And in that case even device of data stripe 2 is missing, btrfs don't 
really need to use parity to rebuild it, as btrfs knows there is no 
extent in that stripe, and data csum matches for data stripe 1.
No need to use parity at all.

So that's why I think the hole write is not an urgent case to handle 
right now.

Thanks,
Qu
> 
> I think that is a valid problem calling for a solution on Btrfs, given
> its mandate. It is no worse than other raid6 implementations though
> which would reconstruct from bad P, and give no warning, leaving it up
> to application layers to deal with the problem.
> 
> I have no idea how ZFS RAIDZ2 and RAIDZ3 handle this same scenario.
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


