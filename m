Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:50038 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdIUQty (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 12:49:54 -0400
Received: by mail-wr0-f177.google.com with SMTP id u96so5053145wrb.6
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 09:49:53 -0700 (PDT)
Subject: Re: SSD caching an existing btrfs raid1
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
 <2a208f7c-a140-3ac6-12c6-2e953f3f96ec@gmail.com>
 <36669362-6401-72e3-f963-41de0debd0a4@gmail.com>
 <20170920224520.044d4c45@jupiter.sol.kaishome.de>
From: Psalle <psalleetsile@gmail.com>
Message-ID: <9d690e14-0b87-8d46-124b-5304c8808870@gmail.com>
Date: Thu, 21 Sep 2017 18:49:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170920224520.044d4c45@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/09/17 22:45, Kai Krakow wrote:
> Am Wed, 20 Sep 2017 17:51:15 +0200
> schrieb Psalle <psalleetsile@gmail.com>:
>
>> On 19/09/17 17:47, Austin S. Hemmelgarn wrote:
>> (...)
>>> A better option if you can afford to remove a single device from
>>> that array temporarily is to use bcache.  Bcache has one specific
>>> advantage in this case, multiple backend devices can share the same
>>> cache device. This means you don't have to carve out dedicated
>>> cache space for each disk on the SSD and leave some unused space so
>>> that you can add new devices if needed.  The downside is that you
>>> can't convert each device in-place, but because you're using BTRFS,
>>> you can still convert the volume as a whole in-place.  The
>>> procedure for doing so looks like this:
>>>
>>> 1. Format the SSD as a bcache cache.
>>> 2. Use `btrfs device delete` to remove a single hard drive from the
>>> array.
>>> 3. Set up the drive you just removed as a bcache backing device
>>> bound to the cache you created in step 1.
>>> 4. Add the new bcache device to the array.
>>> 5. Repeat from step 2 until the whole array is converted.
>>>
>>> A similar procedure can actually be used to do almost any
>>> underlying storage conversion (for example, switching to whole disk
>>> encryption, or adding LVM underneath BTRFS) provided all your data
>>> can fit on one less disk than you have.
>> Thanks Austin, that's just great. For some reason I had discarded
>> bcache thinking that it would force me to rebuild from scratch, but
>> this kind of incremental migration is exactly why I hoped was
>> possible. I have plenty of space to replace the devices one by one.
>>
>> I will report back my experience in a few days, I hope.
> I've done it exactly that way in the past and it worked flawlessly (but
> it took 24+ hours). But it was easy for me because I was also adding a
> third disk to the pool, so existing stuff could easily move.
>
> I suggest to initialize bcache to writearound mode while converting, so
> your maybe terabytes of disk don't go through the SSD.
>
> If you later decide to remove bcache or not sure about future bcache
> usage, you can wrap any partition into a bcache container - just don't
> connect it to a cache and it will work like a normal partition.

Those are good advices. I've finished now and it seems to have gone 
without a hitch. Thanks!

>
>

