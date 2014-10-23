Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38013 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaJWEKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 00:10:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xh9ip-0007ta-MQ
	for linux-btrfs@vger.kernel.org; Thu, 23 Oct 2014 06:09:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 06:09:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 06:09:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Uh, 1COW?... what happens when someone does this...
Date: Thu, 23 Oct 2014 04:09:48 +0000 (UTC)
Message-ID: <pan$eef53$abe4b28$b617a1ea$654f6419@cox.net>
References: <54480856.9020604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 22 Oct 2014 12:41:10 -0700 as excerpted:

> So I've been considering some NOCOW files (for VM disk images), but some
> questions arose. IS there a "1COW" (copy on write only once) flag or are
> the following operations dangerous or undefined?
> 
> (1) The page https://btrfs.wiki.kernel.org/index.php/FAQ (section "Can
> copy-on-write be turned off for data blocks?") says "COW may still
> happen if a snapshot is taken." Is that a "may" or a "will", e.g. if I
> take a snapshot and then start the VM will the file in the snapshot
> still be frozen or will it update as I alter the VM? Does the
> read-only-or-not status of the snapshot matter in this outcome?
> 
> e.g. what does "may" mean in that section?

Hugo's correct, but I explain it (both to myself and to others) a bit 
differently, here.

Consider, btrfs is by default COW (which as we know means copy-on-write) 
based, and many of its more unique features, including snapshotting, 
depend on that.

Conceptually, what a snapshot does is pretty simple.  It simply locks the 
current data version, along with its metadata, in-place.

Because btrfs is native copy-on-write, normal writes will leave the 
existing version in place and will write the new version elsewhere.  When 
the write is completed and the updated version is safely in place, btrfs 
will normally remove the old version, thereby freeing the space it took 
to be used for something else.

What a snapshot does, then, is simply lock the existing copy in place -- 
when the COW-based update is written, instead of being deleted the old 
copy still has a reference to it from the snapshot, so the old version is 
left in place.

What's critical here is that it's always the NEW version that gets 
written elsewhere -- the OLD version remains where it is, to be deleted 
after the update if there's not a snapshot still referencing it and thus 
locking it in place, to be kept if there's a snapshot (or reflink or some 
other reference to the old version) still referencing it, so an attempt 
to access that old version (via the snapshot/reflink/whatever) can still 
return it.

Of course nocow turns some of these basic assumptions on their head, thus 
forcing btrfs to break its normal operating rules in one way or another.

As above, first the no-snapshot case.  The file is nocow, so each 
successive version in-place replaces what was there before.

But what happens when a snapshot locks the current version in-place, and 
the file is subsequently updated?  Btrfs can't overwrite in-place because 
that would break the viability of the snapshot, yet nocow says the file 
MUST be rewritten in-place.  The two rules now conflict and one or the 
other of the two, snapshot locking old data in place, or nocow forcing 
new data to be written to the same place, must be broken in ordered to 
allow the other one to be honored.

Btrfs resolves this situation with your (OP/RW's) cow1 solution.  In 
ordered to avoid breaking snapshot integrity, the new data is written -- 
once -- to a new location.  However, the file retains its nocow property 
and since the new location is no longer constrained to remain as-is by 
the snapshot, further updates to it will update the new location in-
place, just as they would have continued to update the old location in-
place, had the snapshot not forced moving to a new location in ordered to 
keep the integrity of the snapshot.

Which altho a definite compromise, still rewrites in-place for the most 
part, *AS LONG AS SNAPSHOTS AREN'T HAPPENING NEARLY AS FREQUENTLY AS DATA 
UPDATES*.

Which is where things get tricky, when people are doing automated 
snapshots as often as once a minute.  Under that sort of snapshotting 
condition,  nocow is essentially useless, because in a continuously 
updated file scenario, file updates are going to be forced to a new 
location so often that the nocow might as well not be there at all.

Which plays havoc with VM image and database fragmentation, the very 
reason one may have been attempting to nocow these files in the first 
place.

So what to do?  Three possible solutions:

1) For small files and larger ones where the update rate is quite slow 
(say an update every 10 minutes or so, on average), btrfs' autodefrag 
mount option can be very helpful, because it simply watches for 
fragmenting writes and queues up the affected file for rewrite as a whole 
unit, thereby defragging it.

But as soon as updates start coming in nearly as fast as the file can be 
rewritten, either because the file is big and thus takes a decent amount 
of time to rewrite, or because the updates are simply coming in too fast, 
that relatively simple (from the user-side) solution breaks down.  Rule 
of thumb guidelines suggest files under 100 MiB should generally be 
rewritten fast enough that autodefrag can keep up, while internal-rewrite-
pattern files over a gig will need some other solution.  In practice, for 
most uses a quarter gig is generally fine for autodefrag, while a half-
gig can be problematic if updates are coming too fast.  In the quarter-to-
half-gig-range, it's use-case and hardware specific.

2) Put the larger (half-gig-plus) internal-rewrite-pattern files 
(database and vm images being the most common examples) on a dedicated 
subvolume, nocow them, and either don't snapshot it at all, using 
conventional backups instead, or very strictly limit snapshots, say 
manually, perhaps every month, so cow1 based fragmentation is extremely 
tightly controlled.

Because snapshots stop at subvolume boundaries, the dedicated subvolume 
for the nocow files lets you continue snapshotting the parent subvolume 
as normal, since the complicating files are off in their own dedicated 
subvolume.

This can work well for VMs and databases that aren't "live" 24/7, as 
their downtime can be taken advantage of to do the conventional backups.

It does NOT work well if btrfs send is the backup mechanism, since that 
requires read-only snapshots.  Similarly, in production environments that 
must be up 24/7, there's no down-time for the backups to take place, 
leaving the possibility that the backup isn't a consistent-state capture. 
=:^(  For these cases, see #3.

3) For cases where routine snapshotting is unavoidable, either because 
btrfs send is the preferred backup method, or because the files in 
question are in-use and updated 24/7, leaving no chance to take a 
consistent backup on a quiesced file...

Do the same dedicated subvolume thing with nocow files to limit 
fragmentation to the extent possible, try to limit snapshotting to the 
extent possible (say half-hour instead of per-minute, or per-day instead 
of per-hour), and schedule a periodic btrfs defrag to deal with the 
unavoidable fragmentation.   Reports from people that have done this 
suggest weekly or monthly defrags are often enough, and don't run 
"forever", as long as fragmentation is already limited to the extent 
possible using the above techniques.

Meanwhile, while for technical reasons as described above, btrfs 
snapshotting and nocow don't work together perfectly, it's worth keeping 
in mind that they're still better than the comparable options (basically 
nothing comparable) you'd have on more conventional filesystems.  What 
alternatives would you have trying to do this same sort of thing on ext4 
or xfs, for instance?  On btrfs, you still have all them, PLUS you have 
access to btrfs-specific features that while limited in some aspects, at 
least give you /some/ options.

(The filesystem option most directly feature-comparable to btrfs, tho not 
available as an option to me for non-technical reasons, is zfs.  Of 
course it's also far more mature than btrfs is at this point.  But I'm 
told it has its own negatives, including far higher/stricter memory 
requirements for reliable operation than that required for btrfs.  YMMV 
however, as it's not an option for me so I've not checked into those 
claims.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

