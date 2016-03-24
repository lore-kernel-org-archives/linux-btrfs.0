Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbcCXNmt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 09:42:49 -0400
Date: Thu, 24 Mar 2016 14:42:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
Message-ID: <20160324134217.GP29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160322133812.GK8095@twin.jikos.cz>
 <56F1FEAF.2070806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56F1FEAF.2070806@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 10:25:51AM +0800, Qu Wenruo wrote:
> Thank you for your interest in dedupe patchset first.
> 
> In fact I'm quite afraid if there is no one interest in the patchset, it 
> may be delayed again to 4.8.

It's not about lack of interest, the high-profile features need time and
input from several people that will supposedly cover all aspects.

> David Sterba wrote on 2016/03/22 14:38 +0100:
> There are 3 dedupe related on-disk items.
> 
> 1) dedupe status
>     Used by both dedupe backends. Mainly used to record the dedupe
>     backend info, allowing btrfs to resume its dedupe setup after umount.
> 
> Key contents:
>     Objectid             , Type                   , Offset
>    (0                    , DEDUPE_STATUS_ITEM_KEY , 0      )

Please use the newly added BTRFS_PERSISTENT_ITEM_KEY instead of a new
key type. As this is the second user of that item, there's no precendent
how to select the subtype. Right now 0 is for the dev stats item, but
I'd like to leave some space between them, so it should be 256 at best.
The space is 64bit so there's enough room but this also means defining
the on-disk format.

> >> 4) Ioctl interface with persist dedup status
> >
> > I'd like to see the ioctl specified in more detail. So far there's
> > enable, disable and status. I'd expect some way to control the in-memory
> > limits, let it "forget" current hash cache, specify the dedupe chunk
> > size, maybe sync of the in-memory hash cache to disk.
> 
> So current and planned ioctl should be the following, with some details 
> related to your in-memory limit control concerns.
> 
> 1) Enable
>     Enable dedupe if it's not enabled already. (disabled -> enabled)

Ok, so it should also take a parameter which bckend is about to be
enabled.

>     Or change current dedupe setting to another. (re-configure)

Doing that in 'enable' sounds confusing, any changes belong to a
separate command.

>     For dedupe_bs/backend/hash algorithm(only SHA256 yet) change, it
>     will disable dedupe(dropping all hash) and then enable with new
>     setting.
> 
>     For in-memory backend, if only limit is different from previous
>     setting, limit can be changed on the fly without dropping any hash.

This is obviously misplaced in 'enable'.

> 2) Disable
>     Disable will drop all hash and delete the dedupe tree if it exists.
>     Imply a full sync_fs().

That is again combining too many things into one. Say I want to disable
deduplication and want to enable it later. And not lose the whole state
between that. Not to say deleting the dedup tree.

IOW, deleting the tree belongs to a separate command, though in the
userspace tools it could be done in one command, but we're talking about
the kernel ioctls now.

I'm not sure if the sync is required, but it's acceptable for first
implementation.

> 
> 3) Status
>     Output basic status of current dedupe.
>     Including running status(disabled/enabled), dedupe block size, hash
>     algorithm, and limit setting for in-memory backend.

Agreed. So this is basically the settings and static info.

> 4) (PLANNED) In-memory hash size querying
>     Allowing userspace to query in-memory hash structure header size.
>     Used for "btrfs dedupe enable" '-l' option to output warning if user
>     specify memory size larger than 1/4 of the total memory.

And this reflects the run-time status. Ok.

> 5) (PLANNED) Dedeup rate statistics
>     Should be handy for user to know the dedupe rate so they can further
>     fine tuning their dedup setup.

Similar as above, but for a different type of data. Ok.

> So for your "in-memory limit control", just enable it with different limit.
> For "dedupe block size change", just enable it with different dedupe_bs.
> For "forget hash", just disable it.

I can comment once the semantics of 'enable' are split, but basically I
want an interface to control the deduplication cache.

> And for "write in-memory hash onto disk", not planned and may never do 
> it due to the complexity, sorry.

I'm not asking you to do it, definetelly not for the initial
implementation, but sync from memory to disk is IMO something that we
can expect users to ask for. The percieved complexity may shift
implementation to the future, but we should take it into account.

> >> 5) Ability to disable dedup for given dirs/files
> >
> > This would be good to extend to subvolumes.
> 
> I'm sorry that I didn't quite understand the difference.
> Doesn't dir includes subvolume?

If I enable deduplication on the entire subvolume, it will affect all
subdirectories. Not the other way around.

> Or xattr for subvolume is only restored in its parent subvolume, and 
> won't be copied for its snapshot?

The xattrs are copied to the snapshot.

> >> TODO:
> >> 1) Add extent-by-extent comparison for faster but more conflicting algorithm
> >>     Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
> >>     CPU may even be a bottleneck other than IO.
> >>     But for faster hash, it will definitely cause conflicts, so we need
> >>     extent comparison before we introduce new dedup algorithm.
> >
> > If sha256 is slow, we can use a less secure hash that's faster but will
> > do a full byte-to-byte comparison in case of hash collision, and
> > recompute sha256 when the blocks are going to disk. I haven't thought
> > this through, so there are possibly details that could make unfeasible.
> 
> Not exactly. If we are using unsafe hash, e.g MD5, we will use MD5 only 
> for both in-memory and on-disk backend. No SHA256 again.

I'm proposing unsafe but fast, which MD5 is not. Look for xxhash or
murmur. As they're both order-of-magnitutes faster than sha1/md5, we can
actually hash both to reduce the collisions.

> In that case, for MD5 hit case, we will do a full byte-to-byte 
> comparison. It may be slow or fast, depending on the cache.

If the probability of hash collision is low, so the number of needed
byte-to-byte comparisions is also low.

> But at least for MD5 miss case, it should be faster than SHA256.
> 
> > The idea is to move expensive hashing to the slow IO operations and do
> > fast but not 100% safe hashing on the read/write side where performance
> > matters.
> 
> Yes, although on the read side, we don't perform hash, we only do hash 
> at write side.

Oh, so how exactly gets the in-memory deduplication cache filled? My
impression was that we can pre-fill it by reading bunch of files where we
expect the shared data to exist.

The usecase:

Say there's a golden image for a virtual machine, we'll clone it and use
for other VM's, with minor changes. If we first read the golden image
with deduplication enabled, pre-fill the cache, any subsequent writes to
the cloned images will be compared to the cached data. The estimated hit
ratio is medium-to-high.

And this can be extended to anything, not just VMs. Without the option
to fill the in-memory cache, the deduplication would seem pretty useless
to me. The clear benefit is lack of maintaining the persistent storage
of deduplication data.

> And in that case, if weak hash hit, we will need to do memory 
> comparison, which may also be slow.
> So the performance impact may still exist.

Yes the performance hit is there, with statistically low probability.

> The biggest challenge is, we need to read (decompressed) extent 
> contents, even without an inode.
> (So, no address_space and all the working facilities)
> 
> Considering the complexity and uncertain performance improvement, the 
> priority of introducing weak hash is quite low so far, not to mention a 
> lot of detail design change for it.

I disagree.

> A much easier and practical enhancement is, to use SHA512.
> As it's faster than SHA256 on modern 64bit machine for larger size.
> For example, for hashing 8K data, SHA512 is almost 40% faster than SHA256.
> 
> >> 2) Misc end-user related helpers
> >>     Like handy and easy to implement dedup rate report.
> >>     And method to query in-memory hash size for those "non-exist" users who
> >>     want to use 'dedup enable -l' option but didn't ever know how much
> >>     RAM they have.
> >
> > That's what we should try know and define in advance, that's part of the
> > ioctl interface.
> >
> > I went through the patches, there are a lot of small things to fix, but
> > first I want to be sure about the interfaces, ie. on-disk and ioctl.
> 
> I hope such small things can be pointed out, allowing me to fix them 
> while rebasing.

Sure, that's next after we agree on what the deduplication should
actually, the ioctls interefaces are settled and the on-disk format
changes are agreed on. The code is a good starting point, but pointing
out minor things at this point does not justify the time spent.

> > Then we can start to merge the patchset in smaller batches, the
> > in-memory deduplication does not have implications on the on-disk
> > format, so it's "just" the ioctl part.
> 
> Yes, that's my original plan, first merge simple in-memory backend into 
> 4.5/4.6 and then adding ondisk backend into 4.7.
> 
> But things turned out that, since we designed the two-backends API from 
> the beginning, on-disk backend doesn't take much time to implement.
> 
> So this makes what you see now, a big patchset with both backend 
> implemented.

For the discussions and review phase it's ok to see them both, but it's
unrealistic to expect merging in a particular version without going
through the review heat, especially for something like deduplication.
