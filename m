Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33300 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbdDKLd7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Apr 2017 07:33:59 -0400
Received: by mail-io0-f175.google.com with SMTP id t68so99982122iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 04:33:58 -0700 (PDT)
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <17965132-ca31-461a-7838-6a3500ffaeb6@gmail.com>
 <2bdc4a03-3a8e-52b6-5ede-ee4d40baac6c@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d07ae84b-72f7-bf67-147e-c3aa0940e69b@gmail.com>
Date: Tue, 11 Apr 2017 07:33:41 -0400
MIME-Version: 1.0
In-Reply-To: <2bdc4a03-3a8e-52b6-5ede-ee4d40baac6c@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-10 18:59, Hans van Kranenburg wrote:
> On 04/10/2017 02:23 PM, Austin S. Hemmelgarn wrote:
>> On 2017-04-08 16:19, Hans van Kranenburg wrote:
>>> So... today a real life story / btrfs use case example from the trenches
>>> at work...
>>>
>>> tl;dr 1) btrfs is awesome, but you have to carefully choose which parts
>>> of it you want to use or avoid 2) improvements can be made, but at least
>>> the problems relevant for this use case are managable and behaviour is
>>> quite predictable.
>>>
>>> This post is way too long, but I hope it's a fun read for a lazy sunday
>>> afternoon. :) Otherwise, skip some sections, they have headers.
>>>
>>> ...
>>>
>>> The example filesystem for this post is one of the backup server
>>> filesystems we have, running btrfs for the data storage.
>> Two things before I go any further:
>> 1. Thank you for such a detailed and well written post, and especially
>> one that isn't just complaining but also going over what works.
>
> Thanks!
>
>>> [...]
>>>
>>>
>>> == What's not so great... Allocated but unused space... ==
>>>
>>> Since the beginning it showed that the filesystem had a tendency to
>>> accumulate allocated but unused space that didn't get reused again by
>>> writes.
>>>
>>> [...]
>>>
>>> So about a month ago, I continued searching kernel code for the cause of
>>> this behaviour. This is a fun, but time consuming and often mind
>>> boggling activity, because you run into 10 different interesting things
>>> at the same time and want to start to find out about all of them at the
>>> same time etc. :D
>>>
>>> The two first things I found out about were:
>>>   1) the 'free space cluster' code, which is responsible to find empty
>>> space that new writes can go into, sometimes by combining several free
>>> space fragments that are close to each other.
>>>   2) the bool fragmented, which causes a block group to get blacklisted
>>> for any more writes because finding free space for a write did not
>>> succeed too easily.
>>>
>>> I haven't been able to find a concise description of how all of it
>>> actually is supposed to work, so have to end up reverse engineering it
>>> from code, comments and git history.
>>>
>>> And, in practice the feeling was that btrfs doesn't really try that
>>> hard, and quickly gives up and just starts allocating new chunks for
>>> everything. So, maybe it was just listing all my block groups as
>>> fragmented and ignoring them?
>> On this part in particular, while I've seen this behavior on my own
>> systems to a certain extent, I've never seen it as bad as you're
>> describing.  Based on what I have seen though, it really depends on the
>> workload.
>
> Yes.
>
>> In my case, the only things that cause this degree of
>> free-space fragmentation are RRD files and data files for BOINC
>> applications, but both of those have write patterns that are probably
>> similar to what your backups produce.
>>
>> One thing I've found helps at least with these particular cases is
>> bumping the commit time up a bit in BTRFS itself.  For both filesystems,
>> I run with -o commit=150, which is 5 times the default commit time.  In
>> effect, this means I'll lose up to 2.5 minutes of data if the system
>> crashes, but in both cases, this is not hugely critical data (the BOINC
>> data costs exactly as much time to regenerate as the length of time's
>> worth of data that was lost, and the RRD files are just statistics from
>> collectd).
>
> I think this might help if you have more little writes piling up in
> memory, and then write them out less often in one go yes. It doesn't
> help when you're pumping data into the fs because you want to have your
> backups finished.
>
> I did some tests with commit times once, to see if it would influence
> the amount of rumination the cow does before defecating metadata onto
> disk, but it didn't show any difference, I guess because the commit
> timeout never gets reached. It just keeps writing metadata at full speed
> to disk all the time.
>
> ...
>
> In my case the next thing after getting this free space fragmentation
> fixed (which looks like it's going in the right direction), is to go see
> why this filesystem needs to write so much metadata all the time (like,
> how many % is which tree, how close or far apart are the writes in the
> trees, and how close or far apart are the locations on disk that it's
> written to).
What the commit timeout ends up being is the longest the FS will wait 
before forcing the in-memory state out to disk.  IOW, the FS is 
guaranteed consistent at least once every 'commit' seconds.  In 
retrospect, you're right that it almost certainly won't help much in 
this case.
>
>>> == Balance based on free space fragmentation level ==
>>>
>>> Now, free space being fragmented when you have a high churn rate
>>> snapshot create and expire workload is not a surprise... Also, when data
>>> is added there is no way to predict if, and when it ever will be
>>> unreferenced from the snapshots again, which means I really don't care
>>> where it ends up on disk.
>>>
>>> But how fragmented is the free space, and how can we measure it?
>>>
>>> Three weeks ago I made up a free space 'scoring' algorithm, revised it a
>>> few times and now I'm using it to feed block groups with bad free space
>>> fragmentation to balance to clean up the filesystem a bit. But, this is
>>> a fun story for a separate post. In short, take the log2() of the size
>>> of a free space extent, and then punish it the hardest if it ends up in
>>> the middle of log2(sectorsize) and log2(block_group.length) and less if
>>> it's smaller or bigger.
>>>
>>> It's still 'mopping with the tap open', like we say in the Netherlands.
>>> But it's already much better than usage-based balance. If a block group
>>> is used for 50% and it has 512 alternating 1MiB filled and free
>>> segments, I want to get rid of it, but if it's 512MiB data and then
>>> 512MiB empty space, it has to stay.
>> If you could write up a patch for the balance operation itself to add
>> this as a filter (probably with some threshold value to control how
>> picky to be), that would be a great addition.
>
> I found out it's quite hard to come up with a useful scoring mechanism.
> Creating one that results in a number between 0 and 100 is even much harder.
>
> But... now I know about the nossd/ssd things seen below, I think it's
> better to find out what patterns of free space are *actually* a problem,
> i.e. which ones result in free space being ignored and getting that
> little boolean flag that prevents further writes.
>
> For example, if it's as simple as "with -o ssd all free space fragments
> that are <2 MiB will be ignored", (note to self: what about alignment?)
> then it's quite simple to come up with a calculation of how much MiB in
> total this is, and then give that as % of the total blockgroup size.
> This is already totally different method than what I describe above.
>
> So finding out what the actual behaviour is needs to be done first
> (like, how do I get access to that flagged list of blockgroups). Making
> up some algorithm is pointless without that.
Excellent point.
>
>>> == But... -o remount,nossd ==
>>>
>>> About two weeks ago, I ran into this code, from extent-tree.c:
>>>
>>> bool ssd = btrfs_test_opt(fs_info, SSD);
>>> *empty_cluster = 0;
>>> [...]
>>> if (ssd)
>>>     *empty_cluster = SZ_2M;
>>> if (space_info->flags & BTRFS_BLOCK_GROUP_METADATA) {
>>>     ret = &fs_info->meta_alloc_cluster;
>>>     if (!ssd)
>>>         *empty_cluster = SZ_64K;
>>> } else if ((space_info->flags & BTRFS_BLOCK_GROUP_DATA) && ssd) {
>>>     ret = &fs_info->data_alloc_cluster;
>>> }
>>> [...]
>>>
>>> Wait, what? If I mount -o ssd, every small write will turn into at least
>>> finding 2MiB for a write? What is this magic number?
>> Explaining this requires explaining a bit of background on SSD's.  Most
>> modern SSD's use NAND flash, which while byte-addressable for reads and
>> writes, is only large-block addressable for resetting written bytes.
>> This erase-block is usually a power of 2, and on most drives is 2 or
>> 4MB.  That lower size of 2MB is what got chosen here, and in essence the
>> code is trying to write to each erase block exactly once, which in turn
>> helps with SSD lifetime, since rewriting part of an erase block may
>> require erasing the block, and that erase operation is the limiting
>> factor for the life of flash memory.
>
> What I understand (e.g. [1]) is that the biggest challenge is to line up
> your writes in a way so that future 1) discards (assuming the fs sends
> discards for deletes) and 2) overwrites (which invalidate the previous
> write at that LBA) line up in the most optimal (same) way. That's a very
> different thing than the (from btrfs virtual address space point of
> view) pattern in which data is written, and it involves being able to
> see in the future to do it well.
>
> Any incoming write will be placed into a new empty page of the NAND. So,
> if an erase block is 2MiB, and in one btrfs transaction I do 512x a 4kiB
> write in 512 random places of the phsyical block device as seen by
> Linux, they will end up after each other on the NAND, filling one erase
> block (like, the first column in the pictures in the pdf).
>
> So, that would mean that the location where (seen from the point of view
> of the btrfs virtual address space) data is written does not matter, as
> long as all data that is part of the same thing (like everything that
> belongs to 1 file) is written out together.
>
> That means that if I have a 2MiB free space extent, and I write 4kIB, it
> does not make any sense at all to ignore the remaining 2093056 bytes
> after that. I really hope that's not what it's doing now.
That all assumes you have a smart FTL in the SSD's firmware.  Most 
modern ones do decent, but there are still some out there that don't do 
much in the way of remapping data.
>
> In this case... (-o nossd)
>
>
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4
>
> ...a small amount of vaddr locations are used over and over again (the
> /var/spool/postfix behaviour). This means that if this was an actual
> ssd, I'd be filling up erase blocks with small writes, and sending
> discards for those writes a bit later, over and over again, having the
> effect of having a nice pile of erase blocks that can be erased without
> having to move live data out of it first.
>
> In this case... (-o ssd)
>
>
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4
>
> ...the ssd sees the same write pattern coming in! Hey! That's nice. And
> if I have -o discard, it also sees the same pattern of discards coming in.
>
> If I *don't* have discard enabled in my mount options, I'm killing my
> ssd in a much higher speed with -o ssd than with -o nossd because it
> doesn't get the invalidate hints from overwriting used space.
>
> 8-)
>
> And, the difference is that my btrfs filesystem is totally killing
> itself creating blockgroups with usage <10% which are blocked from
> further writes, creating a nightmare for the user, having to use balance
> to clean them up, only resulting in doing many many more writes to the
> ssd...
>
> Since my reasoning here seems to be almost the 100% opposite of what
> btrfs tries to do, I must be missing something very important here. What
> is it?
>
> Doing bigger writes instead of splitting it up in fragmented writes all
> over the place is better for
> 1. having less extent items in the extent tree and less places in the
> (vaddr sorted) trees that need to be updated
> 2. causing less cowing because tree updates are less or closer to each other
> 3. keeping data together on "rotational" disks to minimize seeks.
>
> 1 is always good and does not have to do anything with ssd or no ssd,
> but with the size of metadata and complexity of operations that handle
> metadata.
> 2 seems to be pretty important also, because of the effect of the 64KiB
> writes instead of 2MiB writes that happen with -o nossd, so it's
> important for both ssd and nossd, while the nossd users are now
> suffering from these effects
> 3 is also nice for the rotational users, but for the ssd users it
> wouldn't really matter.
>
> [1]
> https://www.micron.com/~/media/documents/products/technical-marketing-brief/brief_ssd_effect_data_placement_writes.pdf
>
>>> Since the rotational flag in /sys is set to 0 for this filesystem, which
>>> does not at all mean it's an ssd by the way, it mounts with the ssd
>>> option by default. Since the lower layer of storage is iSCSI on NetApp,
>>> it does not make any sense at all for btrfs to make assumptions about
>>> where goes what or how optimal it is, as everything will be reorganized
>>> anyway.
>> FWIW, it is possible to use a udev rule to change the rotational flag
>> from userspace.  The kernel's selection algorithm for determining is is
>> somewhat sub-optimal (essentially, if it's not a local disk that can be
>> proven to be rotational, it assumes it's non-rotational), so
>> re-selecting this ends up being somewhat important in certain cases
>> (virtual machines for example).
>
> Just putting nossd in fstab seems convenient enough.
While that does work, there are other pieces of software that change 
behavior based on the value of the rotational flag, and likewise make 
misguided assumptions about what it means.
>
>>> == Work to do ==
>>>
>>> The next big change on this system will be to move from the 4.7 kernel
>>> to the 4.9 LTS kernel and Debian Stretch.
>>>
>>> Note that our metadata is still DUP, and it doesn't have skinny extent
>>> tree metadata yet. It was originally created with btrfs-progs 3.17, and
>>> when we realized we should have single it was too late. I want to change
>>> that and see if I can convert on a NetApp clone. This should reduce
>>> extent tree metadata size by maybe more than 60% and whoknowswhat will
>>> happen to the abhorrent write traffic.
>> Depending on how much you trust the NetApp storage appliance you're
>> using, you may also consider nodatasum.
>
> That... is... actually... a very interesting idea...
>
>> It wont' help much with the
>> metadata issues, but it may cut down on the resource usage on the system
>> itself while doing backups.
>
> Who knows... The csum tree must also be huuuge with 35TiB of data, and,
> snapshot removal causes a lot of deletes in the tree.
Well, for 35TiB, with 16KiB blocks, not including the metadata overhead, 
you're looking at a little less than 37.6 billion blocks, and each block 
has it's own checksum.  IIRC, we have 64 bits of space for the checksum 
(even though we're using only 16 of them), which (assuming I'm doing the 
math right) equates to 280GiB of checksums.  At a minimum, turning off 
data checksums will save you some space, and assuming I understand how 
the trees work, should actually cut down on the commit time for snapshot 
deletion and will cut down on the metadata writes (because the csum tree 
is metadata).
>
> So if this is the case, then who knows what things like "Btrfs: bulk
> delete checksum items in the same leaf" will do to it.
>
> But, first it needs more research about what those metadata writes are.
>
>> [...]
>

