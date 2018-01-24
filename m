Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35836 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932114AbeAXVAq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 16:00:46 -0500
Subject: Re: Superblock update: Is there really any benefits of updating
 synchronously?
To: "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
        Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <2f19aa79-b8f4-294e-5298-3a7ed7fbd67d@dirtcellar.net>
 <f8674469-cb64-ace6-ae08-3c3b360fb8e3@suse.com>
 <e9b4a3f8-7b40-574f-20d0-579f5119a3f6@mendix.com>
 <a2a658d6-87ea-e2fc-1d57-825932ad82d9@suse.com>
 <0358d7af-bbce-7e2f-0b00-51b2823f83cb@dirtcellar.net>
 <7bf3c40d-30ef-1911-a1b8-49bf49fbdcd5@mendix.com>
 <79b2a2dc-ce6f-f69e-bf28-a45225025c5f@dirtcellar.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c7359f87-b285-3234-0801-c57034205266@mendix.com>
Date: Wed, 24 Jan 2018 22:00:43 +0100
MIME-Version: 1.0
In-Reply-To: <79b2a2dc-ce6f-f69e-bf28-a45225025c5f@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/24/2018 07:54 PM, waxhead wrote:
> Hans van Kranenburg wrote:
>> On 01/23/2018 08:51 PM, waxhead wrote:
>>> Nikolay Borisov wrote:
>>>> On 23.01.2018 16:20, Hans van Kranenburg wrote:
>>
>> [...]
>>
>>>>>
>>>>> We also had a discussion about the "backup roots" that are stored
>>>>> besides the superblock, and that they are "better than nothing" to help
>>>>> maybe recover something from a borken fs, but never ever guarantee you
>>>>> will get a working filesystem back.
>>>>>
>>>>> The same holds for superblocks from a previous generation. As soon as
>>>>> the transaction for generation X succesfully hits the disk, all space
>>>>> that was occupied in generation X-1 but no longer in X is available to
>>>>> be overwritten immediately.
>>>>>
>>> Ok so this means that superblocks with a older generation is utterly
>>> useless and will lead to corruption (effectively making my argument
>>> above useless as that would in fact assist corruption then).
>>
>> Mostly, yes.
>>
>>> Does this means that if disk space was allocated in X-1 and is freed in
>>> X it will unallocated if you roll back to X-1 e.g. writing to
>>> unallocated storage.
>>
>> Can you reword that? I can't follow that sentence.
> Sure why not. I'll give it a go:
> 
> Does this mean that if...
> * Superblock generation N-1 have range 1234-2345 allocated and used.
> 
> and....
> 
> * Superblock generation N-0 (the current) have range 1234-2345 free 
> because someone deleted a file or something

Ok, so I assume that with current you mean the one on disk now.

> Then....
> 
> It is no point in rolling back to generation N-1 because that refers to 
> what is no essentially free "memory" which may or may have not been 
> written over by generation N-0.

If space that was used in N-1 turned into free space during N-0, then
N-0 will never have reused that space already, since if writing out N-0
had crashed halfway, so the superblock as seen when mounting is still
N-1, then you need to be able to fully use N-1.

It can be used immediately by N+1 however after the N-0 superblock is
safe on disk.

> And therefore N-1 which still thinks 
> range 1234-2345 is allocated may point to the wrong data.

So, at least for disk space used by metadata blocks:

1234-2345 - N-1 - in use
1234-2345 - N-0 - not in use, but can't be overwritten yet
1234-2345 - N+1 - can start writing whatever it wants in that disk
location any time

> I hope that was easier to follow - if not don't hold back on the 
> explicitives! :)
> 
>>
>>> I was under the impression that a superblock was like a "snapshot" of
>>> the entire filesystem and that rollbacks via pre-gen superblocks was
>>> possible. Am I mistaking?
>>
>> Yes. The first fundamental thing in Btrfs is COW which makes sure that
>> everything referenced from transaction X, from the superblock all the
>> way down to metadata trees and actual data space is never overwritten by
>> changes done in transaction X+1.
>>
> Perhaps a tad off topic, but assuming the (hopefully) better explanation 
> above clear things up a bit. What happens if a block is freed?! in X+1 
> --- which must mean that it can be overwritten in transaction X+1 (which 
> I assume means a new superblock generation). After all without freeing 
> and overwriting data there is no way to re-use space.

Freed in X you mean? Or not? But you write "freed?! in X+1".

For actual data disk space, it's the same pattern as above (so space
freed up during a transaction can only be reused in the next one), but
implemented a bit differently.

For metadata trees which do not have reference counting, (e.g. the
extent tree), there's the pinned extent (metadata block disk locations)
list I mentioned already.

For data, we have the filesystem (subvolume) trees which reference all
files and the data extents that they use data from, and via the links to
the extent tree they keep all locations where actual data is on disk as
occupied.

Now comes the different part. Because the filesystem trees already
implement the extra reference counting functionality, this is being used
to prevent freed up data space from already being overwritten in the
same transaction.

How does this work? Well, that's the rest of the wiki section I linked
below. :-D So you're asking exactly the right next question here I guess.

When making changes to a subvolume tree (normal file create, write
content, rename delete etc), btrfs is secretly just cloning the tree
into a new subvolume with the same subvolume ID. Wait, what? Whoa! So if
you're changing subvolume 1234, there's an item (1234 ROOT_ITEM N-0) on
disk in tree 1, and in memory it starts working on (1234 ROOT_ITEM N+1).
As an end user, you never see this happening when you look at btrfs sub
list etc, it's hidden from you.

    "When the transaction commits, a new root pointer is inserted in the
root tree for each new subvolume root." [...] "At this time the root
tree has two pointers for each subvolume changed during the transaction.
One item points to the new tree and one points to the tree that existed
at the start of the last transaction."

After the new transaction commits OK, the cleaner removes the old
subvolume from the previous transaction, which is technically the same
code which is used for regular subvol delete initiated by a user. So
when the old version of the same tree is removed, only then extent tree
mappings for data disk space that was freed in the previous transaction
will be adjusted and it ends up as free data space to be overwritten.

(Well, if an extent in its entirety is not referenced by any file in any
subvol, that is. Partial unreferenced extents keep hanging around as
unreachable data, but that's again another story).

When doing things like subvolume list between a transaction commit and
the cleanup being finished, the btrfs sub list code will only show the
one with highest generation (transaction) number if it encounters
multiple ones and filter out the others not to confuse you. If you
script some tree searches, e.g. with a few lines of python-btrfs, then
you could spot them.

So next time you remove a really big file, and you don't see a
difference in df output... You know you will only see it after the
current transaction is finished and the cleanup at the beginning of the
new one is done.

And the whole "Copy on Write Logging" section in the wiki should make
sense now. \o/

>> For metadata trees that are NOT filesystem trees a.k.a. subvolumes, the
>> way this is done is actually quite simple. If a block is cowed, the old
>> location is added to a 'pinned extents' list (in memory), which is used
>> as a blacklist for choosing space to put new writes in. After a
>> transaction is completed on disk, that list with pinned extents is
>> emptied and all that space is available for immediate reuse. This way we
>> make sure that if the transaction that is ongoing is aborted, the
>> previous one (latest one that is completely on disk) is always still
>> there. If the computer crashes and the in memory list is lost, no big
>> deal, we just continue from the latest completed transaction again after
>> a reboot. (ignoring extra log things for simplicity)
>>
>> So, the only situation in which you can fully use an X-1 superblock is
>> when none of that previously pinned space has actually been overwritten
>> yet afterwards.
>>
>> And if any of the space was overwritten already, you can go play around
>> with using an older superblock and your filesystem mounts and everything
>> might look fine, until you hit that distant corner and BOOM!
> Got it , this takes care of my questions above, but I'll leave them in 
> just for completeness sake.
> Thanks for the good explanation.
> 
>>
>> ---- >8 ---- Extra!! Moar!! ---- >8 ----
>>
>> But, doing so does not give you snapshot functionality yet! It's more
>> like a poor mans snapshot that only can prevent from messing up the
>> current version.
>>
>> Snapshot functionality is implemented only for filesystem trees
>> (subvolumes) by adding reference counting (which does end up on disk) to
>> the metadata blocks, and then COW trees as a whole.

Correction here:
* unfortunate wording: "COW trees as a whole"
* because: we're not copying an entire tree, but only cowing individual
changed metadata blocks
* better: metadata blocks can be shared between trees with a different
tree ID (subvolume ID).

>> If you make a snapshot of a filesystem tree, the snapshot gets a whole
>> new tree ID! It's not a previous version of the same subvolume you're
>> looking at, it's a clone!
>>
>> This is a big difference. The extent tree is always tree 2. The chunk
>> tree is always tree 3. But your subvolume snapshot gets a new tree number.
>>
>> Technically, it would maybe be possible to implement reference counting
>> and snapshots to all of the metadata trees, but it would probably mean
>> that the whole filesystem would get stuck in rewriting itself all day
>> instead of doing any useful work. The current extent tree already has
>> such amount of rumination problems that the added work of keeping track
>> of reference counts would make it completely unusable.
>>
>> In the wiki, it's here:
>> https://btrfs.wiki.kernel.org/index.php/Btrfs_design#Copy_on_Write_Logging
>>
>> Actually, I just paraphrased the first two of those six alineas... The
>> subvolume trees actually having a previous version of themselves again
>> (whaaaa!) is another thing... ;]
>>
> hehe , again thanks for giving a good explanation. Clear things up a bit 
> indeed!
> 

Fun stuff.

-- 
Hans van Kranenburg
