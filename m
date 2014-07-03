Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44183 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGCL2y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 07:28:54 -0400
Received: by mail-lb0-f176.google.com with SMTP id w7so48258lbi.7
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 04:28:53 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <2201007.I7dgLZVjz9@localhost.localdomain>
References: <1403519147-19520-1-git-send-email-fdmanana@gmail.com>
	<2201007.I7dgLZVjz9@localhost.localdomain>
Date: Thu, 3 Jul 2014 12:28:52 +0100
Message-ID: <CAL3q7H42hY4xWYvQb2jaOEvA=1qJ6R6BcUWGNtT4CpikNC=qEA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: implement support for fallocate collapse range
From: Filipe David Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 3, 2014 at 5:46 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Monday 23 Jun 2014 11:25:47 Filipe David Borba Manana wrote:
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index aeab453..8f1a371 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2825,12 +2825,12 @@ cow_done:
>>                * It is safe to drop the lock on our parent before we
>>                * go through the expensive btree search on b.
>>                *
>> -              * If we're inserting or deleting (ins_len != 0), then we might
>> -              * be changing slot zero, which may require changing the parent.
>> -              * So, we can't drop the lock until after we know which slot
>> -              * we're operating on.
>> +              * If we're inserting, deleting or updating a key (cow != 0),
>> +              * then we might be changing slot zero, which may require
>> +              * changing the parent. So, we can't drop the lock until after
>> +              * we know which slot we're operating on.
>>                */
>> -             if (!ins_len && !p->keep_locks) {
>> +             if (!cow && !p->keep_locks) {
>>                       int u = level + 1;
>
> For the "key update" case (i.e. (ins_len == 0) and (cow == 1)), maybe
> we could optimize by having a variable to hold the return value of
> should_cow_block(), i.e. it keeps track of whether the current
> metadata block was COWed. If the variable indicates that the block was
> *not* COWed, then we could release the lock on the parent block since
> the update operation (even on slot 0) isn't going to change the
> corresponding entry in the parent block.

Hi Chandan,

Just because a node wasn't cowed it doesn't mean it isn't going to be
updated. Further updating the key works bottom-up - we don't know
during btrfs_search_slot() if our caller intends to update a key in
the leaf or just update the item, so we need to return a path here
with all nodes with slot == 0 having a write lock on them. I'm
actually for now basically just undoing this
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=eb653de15987612444b6cde3b0e67b1edd94625f

Anyway right now I have a functional issue to tackle first.

Thanks.

>
> Thanks,
> chandan
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
