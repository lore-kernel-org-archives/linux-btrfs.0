Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37477 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752562AbdFVDzk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 23:55:40 -0400
Subject: Re: Exactly what is wrong with RAID5/6
To: Chris Murphy <lists@colorremedies.com>
CC: waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
 <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
 <1d88f12a-bd2a-9fff-cb53-da847f4526c7@cn.fujitsu.com>
 <CAJCQCtSwSfWKB7ic_Dh=NOJV4WQdwCJfbQE6RfuUrSVFcx3ewA@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <dd47220d-184b-063a-45fd-28647ec1324d@cn.fujitsu.com>
Date: Thu, 22 Jun 2017 11:55:30 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSwSfWKB7ic_Dh=NOJV4WQdwCJfbQE6RfuUrSVFcx3ewA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/22/2017 10:43 AM, Chris Murphy wrote:
> On Wed, Jun 21, 2017 at 8:12 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> 
>>
>> Well, in fact, thanks to data csum and btrfs metadata CoW, there is quite a
>> high chance that we won't cause any data damage.
> 
> But we have examples where data does not COW, we see a partial stripe
> overwrite. And if that is interrupted it's clear that both old and new
> metadata pointing to that stripe is wrong. There are way more problems
> where we see csum errors on Btrfs raid56 after crashes, and there are
> no bad devices.

First, if it's interrupted, there is no new metadata, as metadata is 
always updated after data.

And metadata is always update CoW, so if data write is interrupted, we 
are still at previous trans.


And in that case, no COW means no csum.
Btrfs won't check the correctness due to the lack of csum.

So the case will be that, for nodatacow case, btrfs won't detect the 
corruption, users take the responsibility to keep their data correct.

> 
> 
> 
>>
>> For the example I gave above, no data damage at all.
>>
>> First the data is written and power loss, and data is always written before
>> metadata, so that's to say, after power loss, superblock is still using the
>> old tree roots.
>>
>> So no one is really using that newly written data.
> 
> OK but that assumes that the newly written data is always COW which on
> Btrfs raid56 is not certain, there's a bunch of RMW code which
> suggests overwrites are possible.

RMW is mainly to update P/Q, as even we only update data stripe1, we 
still need data stripe 2 to calculate P/Q.

> And for raid56 metadata it suggests RMW could happen for metadata also.

As long as we have P/Q, RMW must be used.

The root problem will be, we need cross-device FUA to ensure full stripe 
is written correctly.
Or we may take the extent allocator modification, to ensure we only 
write into vertical stripe without used data.


So anyway, RAID5/6 is only designed to handle missing devices, not power 
loss.
IIRC mdadm RAID5/6 array needs to be scrubbed each time power loss is 
detected.

Thanks,
Qu

> 
> There's fairly strong anecdotal evidence that people have less
> problems with Btrfs raid5 when raid5 applies to data block groups, and
> metadata block groups use some other non-parity based profile like
> raid1.
> 
> 
> 


