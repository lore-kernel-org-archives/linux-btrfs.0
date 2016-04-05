Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40883 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750928AbcDEDJC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 23:09:02 -0400
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160322133812.GK8095@twin.jikos.cz> <56F1FEAF.2070806@cn.fujitsu.com>
 <20160324134217.GP29764@twin.jikos.cz> <56F496AA.9000102@cn.fujitsu.com>
 <20160404165517.GD3412@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57032C3B.1020802@cn.fujitsu.com>
Date: Tue, 5 Apr 2016 11:08:43 +0800
MIME-Version: 1.0
In-Reply-To: <20160404165517.GD3412@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/04/04 18:55 +0200:
> On Fri, Mar 25, 2016 at 09:38:50AM +0800, Qu Wenruo wrote:
>>> Please use the newly added BTRFS_PERSISTENT_ITEM_KEY instead of a new
>>> key type. As this is the second user of that item, there's no precendent
>>> how to select the subtype. Right now 0 is for the dev stats item, but
>>> I'd like to leave some space between them, so it should be 256 at best.
>>> The space is 64bit so there's enough room but this also means defining
>>> the on-disk format.
>>
>> After checking BTRFS_PERSISENT_ITEM_KEY, it seems that its value is
>> larger than current DEDUPE_BYTENR/HASH_ITEM_KEY, and since the objectid
>> of DEDUPE_HASH_ITEM_KEY, it won't be the first item of the tree.
>>
>> Although that's not a big problem, but for user using debug-tree, it
>> would be quite annoying to find it located among tons of other hashes.
>
> You can alternatively store it in the tree_root, but I don't know how
> frquently it's supposed to be changed.

Storing in tree root sounds pretty good.
As such status doesn't change until we enable/disable (including 
configure), so tree root seems good.

But we still need to consider the later dedupe rate statistics key order.
In that case, I hope to restore them both into dedupe tree.

>
>> So personally, if using PERSISTENT_ITEM_KEY, at least I prefer to keep
>> objectid to 0, and modify DEDUPE_BYTENR/HASH_ITEM_KEY to higher value,
>> to ensure dedupe status to be the first item of dedupe tree.
>
> 0 is unfortnuatelly taken by BTRFS_DEV_STATS_OBJECTID, but I don't see
> problem with the ordering. DEDUPE_BYTENR/HASH_ITEM_KEY store a large
> number in the objectid, either part of a hash, that's unlikely to be
> almost-all zeros and bytenr which will be larger than 1MB.

OK, as long as we can search the status item with exactly match key, it 
shouldn't cause big problem.

>
>>>>>> 4) Ioctl interface with persist dedup status
>>>>>
>>>>> I'd like to see the ioctl specified in more detail. So far there's
>>>>> enable, disable and status. I'd expect some way to control the in-memory
>>>>> limits, let it "forget" current hash cache, specify the dedupe chunk
>>>>> size, maybe sync of the in-memory hash cache to disk.
>>>>
>>>> So current and planned ioctl should be the following, with some details
>>>> related to your in-memory limit control concerns.
>>>>
>>>> 1) Enable
>>>>       Enable dedupe if it's not enabled already. (disabled -> enabled)
>>>
>>> Ok, so it should also take a parameter which bckend is about to be
>>> enabled.
>>
>> It already has.
>> It also has limit_nr and limit_mem parameter for in-memory backend.
>>
>>>
>>>>       Or change current dedupe setting to another. (re-configure)
>>>
>>> Doing that in 'enable' sounds confusing, any changes belong to a
>>> separate command.
>>
>> This depends the aspect of view.
>>
>> For "Enable/config/disable" case, it will introduce a state machine for
>> end-user.
>
> Yes, that's exacly my point.
>
>> Personally, I doesn't state machine for end user. Yes, I also hate
>> merging play and pause button together on music player.
>
> I don't see this reference relevant, we're not designing a music player.
>
>> If using state machine, user must ensure the dedupe is enabled before
>> doing any configuration.
>
> For user convenience we can copy the configuration options to the dedup
> enable subcommand, but it will still do separate enable and configure
> ioctl calls.

So, that's to say, user can assume there is a state machine, and to do 
enable-configure method.
And other user can use the state-less enable-enable method.

If so, I'm OK to add a configure ioctl interface.
(As it's still enable-enable stateless one beneath the stateful ioctl)

But in that case, if user forget to enable dedupe and call configure 
directly, btrfs won't give any warning and just enable dedupe.

Will that design be OK for you? Or we need to share most part of enable 
and configure ioctl, but configure ioctl will do extra check?


>
>> For me, user only need to care the result of the operation. User can now
>> configure dedupe to their need without need to know previous setting.
>>   From this aspect of view, "Enable/Disable" is much easier than
>> "Enable/Config/Disable".
>
> Getting the usability is hard and that's why we're having this
> dicussion. What suites you does not suite others, we have different
> habits, expectations and there are existing usage patterns. We better
> stick to something that's not too surprising yet still flexible enough
> to cover broad needs. I'm leaving this open, but I strongly disagree
> with the current interface proposal.

I'm still open to new ioctl interface design, as long as we can re-use 
most of current code.

Anyway, just as you pointed, the stateless one is just my personal taste.

>
>>>>       For dedupe_bs/backend/hash algorithm(only SHA256 yet) change, it
>>>>       will disable dedupe(dropping all hash) and then enable with new
>>>>       setting.
>>>>
>>>>       For in-memory backend, if only limit is different from previous
>>>>       setting, limit can be changed on the fly without dropping any hash.
>>>
>>> This is obviously misplaced in 'enable'.
>>
>> Then, changing the 'enable' to 'configure' or other proper naming would
>> be better.
>>
>> The point is, user only need to care what they want to do, not previous
>> setup.
>>
>>>
>>>> 2) Disable
>>>>       Disable will drop all hash and delete the dedupe tree if it exists.
>>>>       Imply a full sync_fs().
>>>
>>> That is again combining too many things into one. Say I want to disable
>>> deduplication and want to enable it later. And not lose the whole state
>>> between that. Not to say deleting the dedup tree.
>>>
>>> IOW, deleting the tree belongs to a separate command, though in the
>>> userspace tools it could be done in one command, but we're talking about
>>> the kernel ioctls now.
>>>
>>> I'm not sure if the sync is required, but it's acceptable for first
>>> implementation.
>>
>> The design is just to to reduce complexity.
>> If want to keep hash but disable dedupe, it will make dedupe only handle
>> extent remove, but ignore any new coming write.
>>
>> It will introduce a new state for dedupe, other than current simple
>> enabled/disabled.
>> So I just don't allow such mode.
>>
>>>
>>>>
>>>> 3) Status
>>>>       Output basic status of current dedupe.
>>>>       Including running status(disabled/enabled), dedupe block size, hash
>>>>       algorithm, and limit setting for in-memory backend.
>>>
>>> Agreed. So this is basically the settings and static info.
>>>
>>>> 4) (PLANNED) In-memory hash size querying
>>>>       Allowing userspace to query in-memory hash structure header size.
>>>>       Used for "btrfs dedupe enable" '-l' option to output warning if user
>>>>       specify memory size larger than 1/4 of the total memory.
>>>
>>> And this reflects the run-time status. Ok.
>>>
>>>> 5) (PLANNED) Dedeup rate statistics
>>>>       Should be handy for user to know the dedupe rate so they can further
>>>>       fine tuning their dedup setup.
>>>
>>> Similar as above, but for a different type of data. Ok.
>>>
>>>> So for your "in-memory limit control", just enable it with different limit.
>>>> For "dedupe block size change", just enable it with different dedupe_bs.
>>>> For "forget hash", just disable it.
>>>
>>> I can comment once the semantics of 'enable' are split, but basically I
>>> want an interface to control the deduplication cache.
>>
>> So better renaming 'enable'.
>>
>> Current 'enable' provides the interface to control the limit or dedupe hash.
>>
>> I'm not sure further control is needed.
>>
>>>
>>>> And for "write in-memory hash onto disk", not planned and may never do
>>>> it due to the complexity, sorry.
>>>
>>> I'm not asking you to do it, definetelly not for the initial
>>> implementation, but sync from memory to disk is IMO something that we
>>> can expect users to ask for. The percieved complexity may shift
>>> implementation to the future, but we should take it into account.
>>
>> OK, I'll keep it in mind.
>>
>>>
>>>>>> 5) Ability to disable dedup for given dirs/files
>>>>>
>>>>> This would be good to extend to subvolumes.
>>>>
>>>> I'm sorry that I didn't quite understand the difference.
>>>> Doesn't dir includes subvolume?
>>>
>>> If I enable deduplication on the entire subvolume, it will affect all
>>> subdirectories. Not the other way around.
>>
>> It can be done by setting 'dedupe disable' on all other subvolumes.
>> But it it's not practical yet.
>
> Thtat's opt-in vs opt-out, we'd need a better description of the
> usecase.

Then still the default dedupe behavior idea.
Default to disable or enable.
And per-inode dedupe enable/disable flag.


>
>> So maybe introduce a new state for default dedupe behavior?
>> Current dedupe enabled default behavior is to dedup unless prohibited.
>> If dedupe default behavior can be don't dedupe unless allowed, then it
>> will be much easier to do.
>>
>>>
>>>> Or xattr for subvolume is only restored in its parent subvolume, and
>>>> won't be copied for its snapshot?
>>>
>>> The xattrs are copied to the snapshot.
>>>
>>>>>> TODO:
>>>>>> 1) Add extent-by-extent comparison for faster but more conflicting algorithm
>>>>>>       Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
>>>>>>       CPU may even be a bottleneck other than IO.
>>>>>>       But for faster hash, it will definitely cause conflicts, so we need
>>>>>>       extent comparison before we introduce new dedup algorithm.
>>>>>
>>>>> If sha256 is slow, we can use a less secure hash that's faster but will
>>>>> do a full byte-to-byte comparison in case of hash collision, and
>>>>> recompute sha256 when the blocks are going to disk. I haven't thought
>>>>> this through, so there are possibly details that could make unfeasible.
>>>>
>>>> Not exactly. If we are using unsafe hash, e.g MD5, we will use MD5 only
>>>> for both in-memory and on-disk backend. No SHA256 again.
>>>
>>> I'm proposing unsafe but fast, which MD5 is not. Look for xxhash or
>>> murmur. As they're both order-of-magnitutes faster than sha1/md5, we can
>>> actually hash both to reduce the collisions.
>>
>> Don't quite like the idea to use 2 hash other than 1.
>> Yes, some program like rsync uses this method, but this also involves a
>> lot of details, like the order to restore them on disk.
>
> I'm considering fast-but-unsafe hashes for the in-memory backend, where
> the speed matters and we cannot hide the slow sha256 calculations behind
> the IO (ie. no point to save microseconds if the IO is going to take
> milliseconds).

If only for in-memory backend, I'm OK.

In-memory backend is much like an experimental field for new ideas, as 
it won't affect on-disk format at all.

But the problem is still here.
For fast hash hit case, we still need calculate slow SHA256 to ensure 
that's a complete hit.
That's OK and expected.

But for fast hash miss case, nothing is really changed.
As long as we need to add hash for the extent into hash pool, we still 
need to calculate the slow SHA256.

We can't insert the fast hash only, or in next fast hash hit with this 
extent, we have no slow hash to ensure consistence.

>
>>>> In that case, for MD5 hit case, we will do a full byte-to-byte
>>>> comparison. It may be slow or fast, depending on the cache.
>>>
>>> If the probability of hash collision is low, so the number of needed
>>> byte-to-byte comparisions is also low.
>>
>> Considering the common use-case of dedupe, hash hit should be a common case.
>>
>> In that case, each hash hit will lead to byte-to-byte comparison, which
>> will significantly impact the dedupe performance.
>>
>> On the other hand, if dedupe hit rate is low, then why use dedupe?
>
> Oh right, that would require at least 2 hashes then.
>
>>>> But at least for MD5 miss case, it should be faster than SHA256.
>>>>
>>>>> The idea is to move expensive hashing to the slow IO operations and do
>>>>> fast but not 100% safe hashing on the read/write side where performance
>>>>> matters.
>>>>
>>>> Yes, although on the read side, we don't perform hash, we only do hash
>>>> at write side.
>>>
>>> Oh, so how exactly gets the in-memory deduplication cache filled? My
>>> impression was that we can pre-fill it by reading bunch of files where we
>>> expect the shared data to exist.
>>
>> Yes, we used to do that method aging back to the first version of
>> in-memory implementation.
>>
>> But that will cause a lot of CPU usage and most of them are just wasted.
>
> I think this depends on the data.
>
>> Don't forget that, in common dedupe use-case, dedupe rate should be
>> high, I'll use 50% as an exmaple.
>> This means, 50% of your read will be pointed to a shared extents. But
>> 100% of read will need to calculate hash, and 50% of them are already in
>> hash pool.
>> So the CPU time are just wasted.
>
> I understand the concerns, but I don't understand the example, sorry.

My poor English again.

Take 4 file extents as example.
File Ext A: points to extent X
File Ext B: points to extent X
File Ext C: points to extent Y
File Ext D: points to extent Y

They are all read at the same time, then we calculate hash for all 4 of 
them at read time.

But at dedupe hash insert time, only hash for extent X and Y is inserted.

We hashed 4 times, but only inserted 2 hashes into dedupe hash pool.

>
>>> The usecase:
>>>
>>> Say there's a golden image for a virtual machine,
>>
>> Not to nitpick, but I though VM images are not good use-case for btrfs.
>> And normally user would set nodatacow for it, which will bypass dedupe.
>
> VM on nodatacow. By bypass you mean that it cannot work together or that
> it's just not going to be implemented?

It can't work together, so for nodatacow file, it won't go through 
dedupe routine.
Dedupe needs datacow to ensure its hashed data won't change.

If a extent is re-written while dedupe hash not changed, next hash hit 
will cause corruption.

And for already deduped(shared) extent, data cow will always happen no 
matter the mount option or file flag.

>
>>> we'll clone it and use
>>> for other VM's, with minor changes. If we first read the golden image
>>> with deduplication enabled, pre-fill the cache, any subsequent writes to
>>> the cloned images will be compared to the cached data. The estimated hit
>>> ratio is medium-to-high.
>>
>> And performance is so low that most user would feel, and CPU usage will
>> be so high (up to 8 cores 100% used)that almost no spare CPU time can be
>> allocated for VM use.
>>
>>>
>>> And this can be extended to anything, not just VMs. Without the option
>>> to fill the in-memory cache, the deduplication would seem pretty useless
>>> to me. The clear benefit is lack of maintaining the persistent storage
>>> of deduplication data.
>>
>> I originally planned a ioctl for it to fill hash manually.
>> But now I think re-write would be good enough.
>> Maybe I could a pseudo 'dedupe fill' command in btrfs-progs, which will
>> just read out the data and re-write it.
>
> Rewriting will take twice the IO and might even fail due to enospc
> reasons, I don't see that as a viable option.

Then we still need another ioctl for it to re-fill hash.

Added to ioctl TO-DO list.

>
>>>> And in that case, if weak hash hit, we will need to do memory
>>>> comparison, which may also be slow.
>>>> So the performance impact may still exist.
>>>
>>> Yes the performance hit is there, with statistically low probability.
>>>
>>>> The biggest challenge is, we need to read (decompressed) extent
>>>> contents, even without an inode.
>>>> (So, no address_space and all the working facilities)
>>>>
>>>> Considering the complexity and uncertain performance improvement, the
>>>> priority of introducing weak hash is quite low so far, not to mention a
>>>> lot of detail design change for it.
>>>
>>> I disagree.
>>
>> Explained above, hash hit in dedupe use-case is common case, while we
>> must do byte-to-byte comparison in common case routine, it's hard to
>> ignore the overhead.
>
> So this should be solved by the double hashing, pushing the probability
> of byte-to-byte comparision low.

As long as we are going to add the hash into hash pool, we need all of 
the two hashes.(explained above)

So nothing changed.

That's the difference with rsync, which doesn't need to add hash into 
its pool. It only needs to make sure they are identical.

Such fast hash only case will only happen in priority based dedupe use case.

In a simple priority based case, only specified(high priority) files can 
populate the hash pool.
Other(low priority) files can only be deduped using high priority files' 
extent, but never populate hash pool.

In that case, fast hash will work, as low priority files will go through 
fast hash calculation but only when fast hash hit, they will go through 
slow hash, and save some time.
(But still, in high dedupe-rate case, the saved some is still small)

>
>>>> A much easier and practical enhancement is, to use SHA512.
>>>> As it's faster than SHA256 on modern 64bit machine for larger size.
>>>> For example, for hashing 8K data, SHA512 is almost 40% faster than SHA256.
>>>>
>>>>>> 2) Misc end-user related helpers
>>>>>>       Like handy and easy to implement dedup rate report.
>>>>>>       And method to query in-memory hash size for those "non-exist" users who
>>>>>>       want to use 'dedup enable -l' option but didn't ever know how much
>>>>>>       RAM they have.
>>>>>
>>>>> That's what we should try know and define in advance, that's part of the
>>>>> ioctl interface.
>>>>>
>>>>> I went through the patches, there are a lot of small things to fix, but
>>>>> first I want to be sure about the interfaces, ie. on-disk and ioctl.
>>>>
>>>> I hope such small things can be pointed out, allowing me to fix them
>>>> while rebasing.
>>>
>>> Sure, that's next after we agree on what the deduplication should
>>> actually, the ioctls interefaces are settled and the on-disk format
>>> changes are agreed on. The code is a good starting point, but pointing
>>> out minor things at this point does not justify the time spent.
>>
>> That's OK.
>>
>>>>> Then we can start to merge the patchset in smaller batches, the
>>>>> in-memory deduplication does not have implications on the on-disk
>>>>> format, so it's "just" the ioctl part.
>>>>
>>>> Yes, that's my original plan, first merge simple in-memory backend into
>>>> 4.5/4.6 and then adding ondisk backend into 4.7.
>>>>
>>>> But things turned out that, since we designed the two-backends API from
>>>> the beginning, on-disk backend doesn't take much time to implement.
>>>>
>>>> So this makes what you see now, a big patchset with both backend
>>>> implemented.
>>>
>>> For the discussions and review phase it's ok to see them both, but it's
>>> unrealistic to expect merging in a particular version without going
>>> through the review heat, especially for something like deduplication.
>>>
>>>
>> In fact, I didn't expect dedupe to receive such heat.
>
> Really? That surprises me :) It modifies on-disk format, adds ioctls,
> can have impact on performacne (that we even haven't measured yet), and
> from the users POV, it's been requested for a long time.

Don't forget I was pushing for in-memory only backend at first.

The main reason for in-memory only backend is that we can do whatever we 
want to try and won't affect the on-disk format.
The very first vision of dedupe is to be a cool but not that useful feature.

But that's the past.
Since now we have on-disk format change, new and expanding ioctls, slow 
performance (but still a little better for all miss case compared to 
compression), it will receive much heat.

Thanks,
Qu
>
>> I originally expect such dedupe to be an interesting but not so
>> practical feature, just like ZFS dedupe.
>> (I can be totally wrong, please point it out if there is some well-known
>> use-case of ZFS dedupe)
>>
>> I was expecting dedupe to be a good entrance to expose existing bugs,
>> and raise attention for better delayed_ref and delalloc implementation.
>>
>> Since it's considered as a high-profile feature, I'm OK to slow down the
>> rush of merge and polish the interface/code further more.
>
> Yeah, as already mentioned, for exposing the bugs we can add code but
> hide the ioctls.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


