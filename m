From: "vivo75@gmail.com" <vivo75@gmail.com>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Thu, 03 May 2012 01:54:01 +0200
Message-ID: <4FA1C919.1090601@gmail.com>
References: <jnpdud$ta9$1@dough.gmane.org> <jnq5os$tdn$1@dough.gmane.org> <CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com> <jnqf0j$hcd$1@dough.gmane.org> <CAG1y0scNSit6oCvySUiP6RChx3_LLDY1QBML0BpGM-39etnZLQ@mail.gmail.com> <jnrems$tkh$1@dough.gmane.org> <pan.2012.05.02.18.41.15@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.05.02.18.41.15@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

Il 02/05/2012 20:41, Duncan ha scritto:
> Martin posted on Wed, 02 May 2012 15:00:59 +0100 as excerpted:
>
>> Multiple pairs of "HDD paired with SSD on md RAID 1 mirror" is a thought
>> with ext4...
> FWIW, I was looking at disk upgrades for my (much different use case)
> home workstation a few days ago, and the thought of raid1 across SSD and
> "spinning rust" drives occurred here, too.  It's an interesting idea...
> that I too would love some informed commentary on whether it's
> practically viable or not.

I've a similar setup, it's a 2xSSD + 1xHD, but cannot provide real data 
right now. Maybe next month.
One thing I've forgot to mention is that software raid is very flexible 
and it's very possible to do a raid0 of ssd and then combine it in a 
raid1 with one (or more) traditional HD.

given the kind of access (many small files) I'm not sure a raid0 is the 
best solution, to be really effective a raid0 need files (and access to 
these) bigger than stripe size.
>> And I was hoping that btrfs would help with handling the large
>> directories and multi-user parallel accesses, especially so for being
>> 'mirrored' by btrfs itself (at the filesystem level) across 4 disks for
>> example.
> Do you mean 4-way-mirroring?  btrfs doesn't do that yet.
>
> One thing keeping me off of btrfs ATM (besides it still being rather more
> experimental than I had thought from the various news I had read, before
> I started looking closely) is that its so-called raid1 mode really isn't
> (ATM) raid1 (in the normal sense) at all, but rather, strict two-way
> (only) mirroring.  If you throw more than two devices at btrfs and tell
> it to raid1 them, it'll stagger the two-way-mirroring, it will NOT N-way
> mirror except N=2.  My current use-case is four aging seagate 300 gig sata
> conventional "spinning rust" drives, in multiple (mostly) 4-way
> md/raid1s.  I /could/ upgrade drives if I needed to (thus the interest in
> disk upgrades and the thought of SSD/rust mixed raid1, mentioned above),
> but am looking at continuing to use the existing hardware, as well, and
> aging as they are, I simply don't trust two-way-only mirroring, at this
> point, as having a second device fail before I fully recovered from
> replacing the first is a realistic possibility, at this point.  3-way
> would be acceptable, but btrfs doesn't do that yet.
>
> At least 3-way and possibly N-way mirroring is on the btrfs roadmap, to
> be introduced after raid5/6 as it'll build on that code.  The raid5/6
> code was in turn roadmapped for after a writing btrfsck, which is now
> available but still being worked on.  So hopefully, raid5/6 for kernel
> 3.5, and with luck, 3-way/N-way raid1/mirroring could land in 3.6.
>
>> Thoughts welcomed.
>>
>>
>> Is btrfs development at the 'optimising' stage now, or is it all still
>> very much a 'work in progress'?
> As the above might hint, btrfs is still a work-in-progress.  Only since
> March has there been a btrfsck that could do any more than report errors,
> and using it to actually correct errors still comes with a warning that
> it could actually make them worse, instead, so is discouraged except for
> testing purposes.
>
> The basic btrfs itself is in somewhat better shape, but its most mature
> and well tested code is single device, or multiple stable devices, used
> with LOTS of free space left for "normal" usage, not stuff like databases
> where there's lots of modify a few bytes in the middle of a huge file
> sort of activity going on.  For that use case, btrfs is "sort of" stable,
> stable enough that it's being deployed by some distributions.
>
> The common errors reported now seem to be ENOSPC under filesystem stress
> conditions, problems dealing with checksum errors during filesystem scrub
> and the like (as with btrfsck, errors are found easily enough, repairing
> them remains problematic at times, however), and notably of interest for
> mirrored usage (so for both you and I), problems recovering from loss of
> one of the two mirror copies.  (At least some of this last one is
> actually a subcase of the checksum recovery issues, since the problem
> often appears as checksum issues on the remaining copy.)
>
> So while btrfs /might/ be argued to be reasonably stable for single
> device or multi-device home use where the devices remain stable and where
> the level of filesystem stress isn't too great, it's /not/ well suited to
> use-cases for which (other than striped-raid0) RAID would normally be
> considered, that is, where the R/Redundant bit comes into play, since
> recovery from loss/replacement of a "redundant" device on btrfs still all
> too often demonstrates that the device wasn't actually "redundant" after
> all, and its loss often results in not only lost data, but a damaged
> btrfs that's impossible to fully recover in btrfs current state, as well.
>
> And as I said above, features are still actively being added -- it's not
> yet feature-complete even to the originally defined feature-set (the
> brand new and still very much testing-only fixing btrfsck being just one
> example, that normally being considered a pretty basic requirement for
> any decent filesystem).  By traditional definition, then, btrfs is "alpha
> software", not yet feature complete.
>
> Basically, that means btrfs is still what it says on the kernel config
> option label, experimental.  Under the basic stable device low-filesystem-
> stress scenario, it's getting close to stable, except for the still
> testing level of btrfsck.  For anything beyond that, I'd definitely say
> wait, for now, but in 2-3 more kernel releases, say toward end-of-year or
> early next, the then-current outlook should be much better, to the point
> that it should start looking realistic for at least the early adopters
> with backups who are willing to risk having to use them.
>
> Meanwhile, for current usage, it is said that a wise admin always has
> backups, no matter the filesystem stability/maturity.  But for btrfs in
> current experimental state, that's really not good enough.  Ideally,
> anyone using btrfs now, will what they consider their primary data copy,
> with its normal backups, on something other than btrfs.  The copy they're
> testing with on btrfs, then, will be exactly that, a throw-away, testing
> copy, not even the primary copy of the data, with backups, but a copy
> made specifically for testing btrfs, that is really is considered throw-
> away, possibly missing the next time you go to use it, but no big deal
> because it wasn't the main copy anyway, let alone the backup, just the
> throw-away copy one was testing with that they half expected to be eaten
> by that test anyway.
>

