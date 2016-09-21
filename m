Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34869 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757581AbcIUPNc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:13:32 -0400
Received: by mail-oi0-f67.google.com with SMTP id n202so4019151oig.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 08:13:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <09b358f4-4564-e885-411a-27020a496755@cn.fujitsu.com> <20160921073502.GB357701@mother.pipebreaker.pl>
 <4a021bc5-8695-1f8e-ec97-6414b91796a6@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Sep 2016 09:13:14 -0600
Message-ID: <CAJCQCtS+g_FQpMUh+c+ccK4XAu72O4FQXtnXjOHL32t-M2VcVA@mail.gmail.com>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 3:15 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 09/21/2016 03:35 PM, Tomasz Torcz wrote:
>>
>> On Wed, Sep 21, 2016 at 03:28:25PM +0800, Qu Wenruo wrote:
>>>
>>> Hi,
>>>
>>> For this well-known bug, is there any one fixing it?
>>>
>>> It can't be more frustrating finding some one has already worked on it
>>> after
>>> spending days digging.
>>>
>>> BTW, since kernel scrub is somewhat scrap for raid5/6, I'd like to
>>> implement
>>> btrfsck scrub support, at least we can use btrfsck to fix bad stripes
>>> before
>>> kernel fix.
>>
>>
>>   Why wouldn't you fix in-kernel code?  Why implement duplicate
>> functionality
>> when you can fix the root cause?
>>
> We'll fix in-kernel code.
>
> Fsck one is not duplicate, we need a better standard thing to compare with
> kernel behavior.
>
> Just like qgroup fix in btrfsck, if kernel can't handle something well, we
> do need to fix kernel, but a good off-line fixer won't hurt.
> (Btrfs-progs is much easier to implement, and get fast review/merge cycle,
> and it can help us to find better solution before screwing kernel up again)

I understand some things should go in fsck for comparison. But in this
case I don't see how it can help. Parity is not checksummed. The only
way to know if it's wrong is to read all of the data strips, compute
parity, and compare in-memory parity from current read to on-disk
parity. It takes a long time, and at least scrub is online, where
btrfsck scrub is not.  There is already an offline scrub in btrfs
check which doesn't repair, but also I don't know if it checks parity.

       --check-data-csum
           verify checksums of data blocks

           This expects that the filesystem is otherwise OK, so this
is basically and
           offline scrub but does not repair data from spare coipes.

Is it possible to put parities into their own tree? They'd be
checksummed there. Somehow I think the long term approach is that
partial stripe writes, which apparently are overwrites and not CoW,
need to go away. In particular I wonder what the metadata raid56 write
pattern is, if this usually means a lot of full stripe CoW writes, or
if there are many small metadata RMW changes that makes them partial
stripe writes and not CoW and thus not safe.



-- 
Chris Murphy
