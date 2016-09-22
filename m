Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20569 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933513AbcIVCJB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 22:09:01 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Chris Murphy <lists@colorremedies.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com>
 <20160921073502.GB357701@mother.pipebreaker.pl>
 <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com>
 <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
CC: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ac57e4db-dc9f-938f-9711-0c6d44d66d67@cn.fujitsu.com>
Date: Thu, 22 Sep 2016 10:08:01 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/21/2016 11:13 PM, Chris Murphy wrote:
> On Wed, Sep 21, 2016 at 3:15 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 09/21/2016 03:35 PM, Tomasz Torcz wrote:
>>>
>>> On Wed, Sep 21, 2016 at 03:28:25PM +0800, Qu Wenruo wrote:
>>>>
>>>> Hi,
>>>>
>>>> For this well-known bug, is there any one fixing it?
>>>>
>>>> It can't be more frustrating finding some one has already worked on it
>>>> after
>>>> spending days digging.
>>>>
>>>> BTW, since kernel scrub is somewhat scrap for raid5/6, I'd like to
>>>> implement
>>>> btrfsck scrub support, at least we can use btrfsck to fix bad stripes
>>>> before
>>>> kernel fix.
>>>
>>>
>>>   Why wouldn't you fix in-kernel code?  Why implement duplicate
>>> functionality
>>> when you can fix the root cause?
>>>
>> We'll fix in-kernel code.
>>
>> Fsck one is not duplicate, we need a better standard thing to compare with
>> kernel behavior.
>>
>> Just like qgroup fix in btrfsck, if kernel can't handle something well, we
>> do need to fix kernel, but a good off-line fixer won't hurt.
>> (Btrfs-progs is much easier to implement, and get fast review/merge cycle,
>> and it can help us to find better solution before screwing kernel up again)
>
> I understand some things should go in fsck for comparison. But in this
> case I don't see how it can help. Parity is not checksummed. The only
> way to know if it's wrong is to read all of the data strips, compute
> parity, and compare in-memory parity from current read to on-disk
> parity.

That's what we plan to do.
And I don't see the necessary to csum the parity.
Why csum a csum again?

> It takes a long time, and at least scrub is online, where
> btrfsck scrub is not.

At least btrfsck scrub will work and easier to implement, while kernel 
scrub doesn't.

The more important thing is, we can forget all about the complicated 
concurrency of online scrub, focusing on the implementation itself at 
user-space.
Which is easier to implement and easier to maintain.

> There is already an offline scrub in btrfs
> check which doesn't repair, but also I don't know if it checks parity.
>
>        --check-data-csum
>            verify checksums of data blocks

Just as you expected, it doesn't check parity.
Even for RAID1/DUP, it won't check the backup if it succeeded reading 
the first stripe.

Current implement doesn't really care if it's the data or the copy 
corrupted, any data can be read out, then there is no problem.
The same thing applies to tree blocks.

So the ability to check every stripe/copy is still quite needed for that 
option.

And that's what I'm planning to enhance, make --check-data-csum to 
kernel scrub equivalent.

>
>            This expects that the filesystem is otherwise OK, so this
> is basically and
>            offline scrub but does not repair data from spare coipes.

Repair can be implemented, but maybe just rewrite the same data into the 
same place.
If that's a bad block, then it can't repair further more unless we can 
relocate extent to other place.

>
> Is it possible to put parities into their own tree? They'd be
> checksummed there.

Personally speaking, this is quite a bad idea to me.
I prefer to separate different logical layers into their own codes.
Not mixing them together.

Block level things to block level(RAID/Chunk), logical thing to logical 
level(tree blocks).

Current btrfs csum design is already much much better than pure RAID.
Just think of RAID1, while one copy is corrupted, then which copy is 
correct then?

Thanks,
Qu

> Somehow I think the long term approach is that
> partial stripe writes, which apparently are overwrites and not CoW,
> need to go away. In particular I wonder what the metadata raid56 write
> pattern is, if this usually means a lot of full stripe CoW writes, or
> if there are many small metadata RMW changes that makes them partial
> stripe writes and not CoW and thus not safe.
>
>
>


