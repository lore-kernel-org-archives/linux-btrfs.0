Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38711 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751403AbcCYBjL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 21:39:11 -0400
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160322133812.GK8095@twin.jikos.cz> <56F1FEAF.2070806@cn.fujitsu.com>
 <20160324134217.GP29764@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F496AA.9000102@cn.fujitsu.com>
Date: Fri, 25 Mar 2016 09:38:50 +0800
MIME-Version: 1.0
In-Reply-To: <20160324134217.GP29764@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/03/24 14:42 +0100:
> On Wed, Mar 23, 2016 at 10:25:51AM +0800, Qu Wenruo wrote:
>> Thank you for your interest in dedupe patchset first.
>>
>> In fact I'm quite afraid if there is no one interest in the patchset, it
>> may be delayed again to 4.8.
>
> It's not about lack of interest, the high-profile features need time and
> input from several people that will supposedly cover all aspects.
>
>> David Sterba wrote on 2016/03/22 14:38 +0100:
>> There are 3 dedupe related on-disk items.
>>
>> 1) dedupe status
>>      Used by both dedupe backends. Mainly used to record the dedupe
>>      backend info, allowing btrfs to resume its dedupe setup after umount.
>>
>> Key contents:
>>      Objectid             , Type                   , Offset
>>     (0                    , DEDUPE_STATUS_ITEM_KEY , 0      )
>
> Please use the newly added BTRFS_PERSISTENT_ITEM_KEY instead of a new
> key type. As this is the second user of that item, there's no precendent
> how to select the subtype. Right now 0 is for the dev stats item, but
> I'd like to leave some space between them, so it should be 256 at best.
> The space is 64bit so there's enough room but this also means defining
> the on-disk format.

After checking BTRFS_PERSISENT_ITEM_KEY, it seems that its value is 
larger than current DEDUPE_BYTENR/HASH_ITEM_KEY, and since the objectid 
of DEDUPE_HASH_ITEM_KEY, it won't be the first item of the tree.

Although that's not a big problem, but for user using debug-tree, it 
would be quite annoying to find it located among tons of other hashes.

So personally, if using PERSISTENT_ITEM_KEY, at least I prefer to keep 
objectid to 0, and modify DEDUPE_BYTENR/HASH_ITEM_KEY to higher value, 
to ensure dedupe status to be the first item of dedupe tree.

>
>>>> 4) Ioctl interface with persist dedup status
>>>
>>> I'd like to see the ioctl specified in more detail. So far there's
>>> enable, disable and status. I'd expect some way to control the in-memory
>>> limits, let it "forget" current hash cache, specify the dedupe chunk
>>> size, maybe sync of the in-memory hash cache to disk.
>>
>> So current and planned ioctl should be the following, with some details
>> related to your in-memory limit control concerns.
>>
>> 1) Enable
>>      Enable dedupe if it's not enabled already. (disabled -> enabled)
>
> Ok, so it should also take a parameter which bckend is about to be
> enabled.

It already has.
It also has limit_nr and limit_mem parameter for in-memory backend.

>
>>      Or change current dedupe setting to another. (re-configure)
>
> Doing that in 'enable' sounds confusing, any changes belong to a
> separate command.

This depends the aspect of view.

For "Enable/config/disable" case, it will introduce a state machine for 
end-user.

Personally, I doesn't state machine for end user. Yes, I also hate 
merging play and pause button together on music player.

If using state machine, user must ensure the dedupe is enabled before 
doing any configuration.

For me, user only need to care the result of the operation. User can now 
configure dedupe to their need without need to know previous setting.
 From this aspect of view, "Enable/Disable" is much easier than 
"Enable/Config/Disable".

>
>>      For dedupe_bs/backend/hash algorithm(only SHA256 yet) change, it
>>      will disable dedupe(dropping all hash) and then enable with new
>>      setting.
>>
>>      For in-memory backend, if only limit is different from previous
>>      setting, limit can be changed on the fly without dropping any hash.
>
> This is obviously misplaced in 'enable'.

Then, changing the 'enable' to 'configure' or other proper naming would 
be better.

The point is, user only need to care what they want to do, not previous 
setup.

>
>> 2) Disable
>>      Disable will drop all hash and delete the dedupe tree if it exists.
>>      Imply a full sync_fs().
>
> That is again combining too many things into one. Say I want to disable
> deduplication and want to enable it later. And not lose the whole state
> between that. Not to say deleting the dedup tree.
>
> IOW, deleting the tree belongs to a separate command, though in the
> userspace tools it could be done in one command, but we're talking about
> the kernel ioctls now.
>
> I'm not sure if the sync is required, but it's acceptable for first
> implementation.

The design is just to to reduce complexity.
If want to keep hash but disable dedupe, it will make dedupe only handle 
extent remove, but ignore any new coming write.

It will introduce a new state for dedupe, other than current simple 
enabled/disabled.
So I just don't allow such mode.

>
>>
>> 3) Status
>>      Output basic status of current dedupe.
>>      Including running status(disabled/enabled), dedupe block size, hash
>>      algorithm, and limit setting for in-memory backend.
>
> Agreed. So this is basically the settings and static info.
>
>> 4) (PLANNED) In-memory hash size querying
>>      Allowing userspace to query in-memory hash structure header size.
>>      Used for "btrfs dedupe enable" '-l' option to output warning if user
>>      specify memory size larger than 1/4 of the total memory.
>
> And this reflects the run-time status. Ok.
>
>> 5) (PLANNED) Dedeup rate statistics
>>      Should be handy for user to know the dedupe rate so they can further
>>      fine tuning their dedup setup.
>
> Similar as above, but for a different type of data. Ok.
>
>> So for your "in-memory limit control", just enable it with different limit.
>> For "dedupe block size change", just enable it with different dedupe_bs.
>> For "forget hash", just disable it.
>
> I can comment once the semantics of 'enable' are split, but basically I
> want an interface to control the deduplication cache.

So better renaming 'enable'.

Current 'enable' provides the interface to control the limit or dedupe hash.

I'm not sure further control is needed.

>
>> And for "write in-memory hash onto disk", not planned and may never do
>> it due to the complexity, sorry.
>
> I'm not asking you to do it, definetelly not for the initial
> implementation, but sync from memory to disk is IMO something that we
> can expect users to ask for. The percieved complexity may shift
> implementation to the future, but we should take it into account.

OK, I'll keep it in mind.

>
>>>> 5) Ability to disable dedup for given dirs/files
>>>
>>> This would be good to extend to subvolumes.
>>
>> I'm sorry that I didn't quite understand the difference.
>> Doesn't dir includes subvolume?
>
> If I enable deduplication on the entire subvolume, it will affect all
> subdirectories. Not the other way around.

It can be done by setting 'dedupe disable' on all other subvolumes.
But it it's not practical yet.

So maybe introduce a new state for default dedupe behavior?
Current dedupe enabled default behavior is to dedup unless prohibited.
If dedupe default behavior can be don't dedupe unless allowed, then it 
will be much easier to do.

>
>> Or xattr for subvolume is only restored in its parent subvolume, and
>> won't be copied for its snapshot?
>
> The xattrs are copied to the snapshot.
>
>>>> TODO:
>>>> 1) Add extent-by-extent comparison for faster but more conflicting algorithm
>>>>      Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
>>>>      CPU may even be a bottleneck other than IO.
>>>>      But for faster hash, it will definitely cause conflicts, so we need
>>>>      extent comparison before we introduce new dedup algorithm.
>>>
>>> If sha256 is slow, we can use a less secure hash that's faster but will
>>> do a full byte-to-byte comparison in case of hash collision, and
>>> recompute sha256 when the blocks are going to disk. I haven't thought
>>> this through, so there are possibly details that could make unfeasible.
>>
>> Not exactly. If we are using unsafe hash, e.g MD5, we will use MD5 only
>> for both in-memory and on-disk backend. No SHA256 again.
>
> I'm proposing unsafe but fast, which MD5 is not. Look for xxhash or
> murmur. As they're both order-of-magnitutes faster than sha1/md5, we can
> actually hash both to reduce the collisions.

Don't quite like the idea to use 2 hash other than 1.
Yes, some program like rsync uses this method, but this also involves a 
lot of details, like the order to restore them on disk.

>
>> In that case, for MD5 hit case, we will do a full byte-to-byte
>> comparison. It may be slow or fast, depending on the cache.
>
> If the probability of hash collision is low, so the number of needed
> byte-to-byte comparisions is also low.

Considering the common use-case of dedupe, hash hit should be a common case.

In that case, each hash hit will lead to byte-to-byte comparison, which 
will significantly impact the dedupe performance.

On the other hand, if dedupe hit rate is low, then why use dedupe?

>
>> But at least for MD5 miss case, it should be faster than SHA256.
>>
>>> The idea is to move expensive hashing to the slow IO operations and do
>>> fast but not 100% safe hashing on the read/write side where performance
>>> matters.
>>
>> Yes, although on the read side, we don't perform hash, we only do hash
>> at write side.
>
> Oh, so how exactly gets the in-memory deduplication cache filled? My
> impression was that we can pre-fill it by reading bunch of files where we
> expect the shared data to exist.

Yes, we used to do that method aging back to the first version of 
in-memory implementation.

But that will cause a lot of CPU usage and most of them are just wasted.

Don't forget that, in common dedupe use-case, dedupe rate should be 
high, I'll use 50% as an exmaple.

This means, 50% of your read will be pointed to a shared extents. But 
100% of read will need to calculate hash, and 50% of them are already in 
hash pool.
So the CPU time are just wasted.

>
> The usecase:
>
> Say there's a golden image for a virtual machine,

Not to nitpick, but I though VM images are not good use-case for btrfs.
And normally user would set nodatacow for it, which will bypass dedupe.

> we'll clone it and use
> for other VM's, with minor changes. If we first read the golden image
> with deduplication enabled, pre-fill the cache, any subsequent writes to
> the cloned images will be compared to the cached data. The estimated hit
> ratio is medium-to-high.

And performance is so low that most user would feel, and CPU usage will 
be so high (up to 8 cores 100% used)that almost no spare CPU time can be 
allocated for VM use.

>
> And this can be extended to anything, not just VMs. Without the option
> to fill the in-memory cache, the deduplication would seem pretty useless
> to me. The clear benefit is lack of maintaining the persistent storage
> of deduplication data.

I originally planned a ioctl for it to fill hash manually.
But now I think re-write would be good enough.
Maybe I could a pseudo 'dedupe fill' command in btrfs-progs, which will 
just read out the data and re-write it.

>
>> And in that case, if weak hash hit, we will need to do memory
>> comparison, which may also be slow.
>> So the performance impact may still exist.
>
> Yes the performance hit is there, with statistically low probability.
>
>> The biggest challenge is, we need to read (decompressed) extent
>> contents, even without an inode.
>> (So, no address_space and all the working facilities)
>>
>> Considering the complexity and uncertain performance improvement, the
>> priority of introducing weak hash is quite low so far, not to mention a
>> lot of detail design change for it.
>
> I disagree.

Explained above, hash hit in dedupe use-case is common case, while we 
must do byte-to-byte comparison in common case routine, it's hard to 
ignore the overhead.

>
>> A much easier and practical enhancement is, to use SHA512.
>> As it's faster than SHA256 on modern 64bit machine for larger size.
>> For example, for hashing 8K data, SHA512 is almost 40% faster than SHA256.
>>
>>>> 2) Misc end-user related helpers
>>>>      Like handy and easy to implement dedup rate report.
>>>>      And method to query in-memory hash size for those "non-exist" users who
>>>>      want to use 'dedup enable -l' option but didn't ever know how much
>>>>      RAM they have.
>>>
>>> That's what we should try know and define in advance, that's part of the
>>> ioctl interface.
>>>
>>> I went through the patches, there are a lot of small things to fix, but
>>> first I want to be sure about the interfaces, ie. on-disk and ioctl.
>>
>> I hope such small things can be pointed out, allowing me to fix them
>> while rebasing.
>
> Sure, that's next after we agree on what the deduplication should
> actually, the ioctls interefaces are settled and the on-disk format
> changes are agreed on. The code is a good starting point, but pointing
> out minor things at this point does not justify the time spent.
>

That's OK.

>>> Then we can start to merge the patchset in smaller batches, the
>>> in-memory deduplication does not have implications on the on-disk
>>> format, so it's "just" the ioctl part.
>>
>> Yes, that's my original plan, first merge simple in-memory backend into
>> 4.5/4.6 and then adding ondisk backend into 4.7.
>>
>> But things turned out that, since we designed the two-backends API from
>> the beginning, on-disk backend doesn't take much time to implement.
>>
>> So this makes what you see now, a big patchset with both backend
>> implemented.
>
> For the discussions and review phase it's ok to see them both, but it's
> unrealistic to expect merging in a particular version without going
> through the review heat, especially for something like deduplication.
>
>
In fact, I didn't expect dedupe to receive such heat.

I originally expect such dedupe to be an interesting but not so 
practical feature, just like ZFS dedupe.
(I can be totally wrong, please point it out if there is some well-known 
use-case of ZFS dedupe)

I was expecting dedupe to be a good entrance to expose existing bugs, 
and raise attention for better delayed_ref and delalloc implementation.


Since it's considered as a high-profile feature, I'm OK to slow down the 
rush of merge and polish the interface/code further more.

Thanks,
Qu


