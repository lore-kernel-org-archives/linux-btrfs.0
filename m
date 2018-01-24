Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:55321 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964999AbeAXSyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 13:54:04 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: Superblock update: Is there really any benefits of updating
 synchronously?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <2f19aa79-b8f4-294e-5298-3a7ed7fbd67d@dirtcellar.net>
 <f8674469-cb64-ace6-ae08-3c3b360fb8e3@suse.com>
 <e9b4a3f8-7b40-574f-20d0-579f5119a3f6@mendix.com>
 <a2a658d6-87ea-e2fc-1d57-825932ad82d9@suse.com>
 <0358d7af-bbce-7e2f-0b00-51b2823f83cb@dirtcellar.net>
 <7bf3c40d-30ef-1911-a1b8-49bf49fbdcd5@mendix.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <79b2a2dc-ce6f-f69e-bf28-a45225025c5f@dirtcellar.net>
Date: Wed, 24 Jan 2018 19:54:00 +0100
MIME-Version: 1.0
In-Reply-To: <7bf3c40d-30ef-1911-a1b8-49bf49fbdcd5@mendix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg wrote:
> On 01/23/2018 08:51 PM, waxhead wrote:
>> Nikolay Borisov wrote:
>>> On 23.01.2018 16:20, Hans van Kranenburg wrote:
> 
> [...]
> 
>>>>
>>>> We also had a discussion about the "backup roots" that are stored
>>>> besides the superblock, and that they are "better than nothing" to help
>>>> maybe recover something from a borken fs, but never ever guarantee you
>>>> will get a working filesystem back.
>>>>
>>>> The same holds for superblocks from a previous generation. As soon as
>>>> the transaction for generation X succesfully hits the disk, all space
>>>> that was occupied in generation X-1 but no longer in X is available to
>>>> be overwritten immediately.
>>>>
>> Ok so this means that superblocks with a older generation is utterly
>> useless and will lead to corruption (effectively making my argument
>> above useless as that would in fact assist corruption then).
> 
> Mostly, yes.
> 
>> Does this means that if disk space was allocated in X-1 and is freed in
>> X it will unallocated if you roll back to X-1 e.g. writing to
>> unallocated storage.
> 
> Can you reword that? I can't follow that sentence.
Sure why not. I'll give it a go:

Does this mean that if...
* Superblock generation N-1 have range 1234-2345 allocated and used.

and....

* Superblock generation N-0 (the current) have range 1234-2345 free 
because someone deleted a file or something

Then....

It is no point in rolling back to generation N-1 because that refers to 
what is no essentially free "memory" which may or may have not been 
written over by generation N-0. And therefore N-1 which still thinks 
range 1234-2345 is allocated may point to the wrong data.

I hope that was easier to follow - if not don't hold back on the 
explicitives! :)

> 
>> I was under the impression that a superblock was like a "snapshot" of
>> the entire filesystem and that rollbacks via pre-gen superblocks was
>> possible. Am I mistaking?
> 
> Yes. The first fundamental thing in Btrfs is COW which makes sure that
> everything referenced from transaction X, from the superblock all the
> way down to metadata trees and actual data space is never overwritten by
> changes done in transaction X+1.
> 
Perhaps a tad off topic, but assuming the (hopefully) better explanation 
above clear things up a bit. What happens if a block is freed?! in X+1 
--- which must mean that it can be overwritten in transaction X+1 (which 
I assume means a new superblock generation). After all without freeing 
and overwriting data there is no way to re-use space.

> For metadata trees that are NOT filesystem trees a.k.a. subvolumes, the
> way this is done is actually quite simple. If a block is cowed, the old
> location is added to a 'pinned extents' list (in memory), which is used
> as a blacklist for choosing space to put new writes in. After a
> transaction is completed on disk, that list with pinned extents is
> emptied and all that space is available for immediate reuse. This way we
> make sure that if the transaction that is ongoing is aborted, the
> previous one (latest one that is completely on disk) is always still
> there. If the computer crashes and the in memory list is lost, no big
> deal, we just continue from the latest completed transaction again after
> a reboot. (ignoring extra log things for simplicity)
> 
> So, the only situation in which you can fully use an X-1 superblock is
> when none of that previously pinned space has actually been overwritten
> yet afterwards.
> 
> And if any of the space was overwritten already, you can go play around
> with using an older superblock and your filesystem mounts and everything
> might look fine, until you hit that distant corner and BOOM!
Got it , this takes care of my questions above, but I'll leave them in 
just for completeness sake.
Thanks for the good explanation.

> 
> ---- >8 ---- Extra!! Moar!! ---- >8 ----
> 
> But, doing so does not give you snapshot functionality yet! It's more
> like a poor mans snapshot that only can prevent from messing up the
> current version.
> 
> Snapshot functionality is implemented only for filesystem trees
> (subvolumes) by adding reference counting (which does end up on disk) to
> the metadata blocks, and then COW trees as a whole.
> 
> If you make a snapshot of a filesystem tree, the snapshot gets a whole
> new tree ID! It's not a previous version of the same subvolume you're
> looking at, it's a clone!
> 
> This is a big difference. The extent tree is always tree 2. The chunk
> tree is always tree 3. But your subvolume snapshot gets a new tree number.
> 
> Technically, it would maybe be possible to implement reference counting
> and snapshots to all of the metadata trees, but it would probably mean
> that the whole filesystem would get stuck in rewriting itself all day
> instead of doing any useful work. The current extent tree already has
> such amount of rumination problems that the added work of keeping track
> of reference counts would make it completely unusable.
> 
> In the wiki, it's here:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_design#Copy_on_Write_Logging
> 
> Actually, I just paraphrased the first two of those six alineas... The
> subvolume trees actually having a previous version of themselves again
> (whaaaa!) is another thing... ;]
> 
hehe , again thanks for giving a good explanation. Clear things up a bit 
indeed!
