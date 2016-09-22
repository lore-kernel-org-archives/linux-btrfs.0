Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37634 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933890AbcIVDBF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 23:01:05 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Chris Murphy <lists@colorremedies.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
 <20160921073502.GB357701@mother.pipebreaker.pl>
 <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com>
 <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
 <ac57e4db-dc9f-938f-9711-0c6d44d66d67@cn.fujitsu.com>
 <CAJCQCtQMZFnHhD0v0Qtwyh=MgeiMZjuWODY5unVLSVEUQMNYDQ@mail.gmail.com>
CC: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5381630f-594b-63f9-0958-261cd9562240@cn.fujitsu.com>
Date: Thu, 22 Sep 2016 11:00:54 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQMZFnHhD0v0Qtwyh=MgeiMZjuWODY5unVLSVEUQMNYDQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/22/2016 10:44 AM, Chris Murphy wrote:
> On Wed, Sep 21, 2016 at 8:08 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 09/21/2016 11:13 PM, Chris Murphy wrote:
>
>>> I understand some things should go in fsck for comparison. But in this
>>> case I don't see how it can help. Parity is not checksummed. The only
>>> way to know if it's wrong is to read all of the data strips, compute
>>> parity, and compare in-memory parity from current read to on-disk
>>> parity.
>>
>>
>> That's what we plan to do.
>> And I don't see the necessary to csum the parity.
>> Why csum a csum again?
>
> parity!=csum
>
>
> http://www.spinics.net/lists/linux-btrfs/msg56602.html

I know, it's more than csum, as normal csum will only tell you if it's 
corrupted, but parity can be used to recover data.

But, parity needs enough data stripe to recover data.
It's just between full backup(RAID1) and pure csum(hash).

But csum for parity is still not worthy, and will screw the whole 
block(chunk) and logical layer.

>
>
>
>>> There is already an offline scrub in btrfs
>>> check which doesn't repair, but also I don't know if it checks parity.
>>>
>>>        --check-data-csum
>>>            verify checksums of data blocks
>>
>>
>> Just as you expected, it doesn't check parity.
>> Even for RAID1/DUP, it won't check the backup if it succeeded reading the
>> first stripe.
>
> Both copies are not scrubbed? Oh hell...

I was replying to the "--check-data-csum" of btrfsck.

I mean, for --check-data-csum, it doesn't read the backup if the first 
data can be read out without error.

And if the first data is wrong, btrfsck will read backup, and output 
error about wrong csum, but won't return error.


>
> [chris@f24s ~]$ sudo btrfs scrub status /brick2
> scrub status for 7fea4120-9581-43cb-ab07-6631757c0b55
>     scrub started at Tue Sep 20 12:16:18 2016 and finished after 01:46:58
>     total bytes scrubbed: 955.93GiB with 0 errors
>
> How can this possibly correctly say 956GiB scrubbed if it has not
> checked both copies? That message is saying *all* the data, both
> copies, were scrubbed. You're saying that message is wrong? It only
> scrubbed half that amount?
>
> [chris@f24s ~]$ sudo btrfs fi df /brick2
> Data, RAID1: total=478.00GiB, used=477.11GiB
> System, RAID1: total=32.00MiB, used=96.00KiB
> Metadata, RAID1: total=2.00GiB, used=877.59MiB
> GlobalReserve, single: total=304.00MiB, used=0.00B
>
>
> When that scrub was happening, both drives were being accessed at 100%
> throughput.
>
>
>
>
>
>
>
>>
>> Current implement doesn't really care if it's the data or the copy
>> corrupted, any data can be read out, then there is no problem.
>> The same thing applies to tree blocks.
>>
>> So the ability to check every stripe/copy is still quite needed for that
>> option.
>>
>> And that's what I'm planning to enhance, make --check-data-csum to kernel
>> scrub equivalent.
>
> OK thanks.
>
>
>>
>>>
>>>            This expects that the filesystem is otherwise OK, so this
>>> is basically and
>>>            offline scrub but does not repair data from spare coipes.
>>
>>
>> Repair can be implemented, but maybe just rewrite the same data into the
>> same place.
>> If that's a bad block, then it can't repair further more unless we can
>> relocate extent to other place.
>
> Any device that's out of reserve sectors and can no longer remap LBA's
> on its own, is a drive that needs to be decommissioned. It's a new
> feature in just the last year or so that mdadm has a badblocks map so
> it can do what the drive won't do, but I'm personally not a fan of
> keeping malfunctioning drives in RAID.
>
>
>>
>>>
>>> Is it possible to put parities into their own tree? They'd be
>>> checksummed there.
>>
>>
>> Personally speaking, this is quite a bad idea to me.
>> I prefer to separate different logical layers into their own codes.
>> Not mixing them together.
>>
>> Block level things to block level(RAID/Chunk), logical thing to logical
>> level(tree blocks).
>
> OK.
>
>>
>> Current btrfs csum design is already much much better than pure RAID.
>> Just think of RAID1, while one copy is corrupted, then which copy is correct
>> then?
>
> Yes.
>
>


