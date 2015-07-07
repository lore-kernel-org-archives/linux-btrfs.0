Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42323 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbGGCIS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jul 2015 22:08:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCIIy-0002QX-GJ
	for linux-btrfs@vger.kernel.org; Tue, 07 Jul 2015 04:08:16 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 04:08:16 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 04:08:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange corruptions found during btrfs check
Date: Tue, 7 Jul 2015 02:08:09 +0000 (UTC)
Message-ID: <pan$65923$282e3e3b$de6298ea$18c9eea@cox.net>
References: <1435853528.6153.3.camel@scientia.net>
	<1436208023.7124.6.camel@scientia.net>
	<pan$a2365$d81c3521$a3dbaee4$237d0b1c@cox.net>
	<1436231005.7124.44.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 07 Jul 2015 03:03:25 +0200 as
excerpted:

> Well I haven't looked into any code, so the following is just
> perception: It seemed that send/receive itself has always worked
> correctly for me so far.
> I.e. I ran some complete diff -qr over the source and target of an
> already incrementally (-p) sent/received snapshot.
> That brought no error.

In general, the send/receive corner-cases are of the type where both the 
send and the receive complete successfully, it should be reliable, but 
sometimes it won't complete successfully.

> The aforementioned btrfs check errors only occurred after I had removed
> older snapshots on the receiving side, i.e. snapshots that btrfs, via
> the -p <same-old-snapshot-on-the-send-side>, used for building together
> the more recent snapshot.
> 
> The error messages seem to imply that some of that got lost,... or at
> least that would be my first wild guess... as if refs in the newer
> snapshot on the receiving side point into the void, as the older
> snapshot's objects, they were pointing to, have been removed (or some of
> them lost).

That would imply either a general btrfs bug (see stability discussion 
below) or perhaps a below-filesystem error, that happened to be exposed 
by the snapshot deletion.

It does look like a snapshot subsystem error, agreed, and conceivably 
could even be one at some level.  However, the point I sort of made, but 
not well, in the previous reply, was that the snapshot and subvolume 
subsystem is so reliant on the core assumptions that btrfs itself makes 
about copy-on-write, etc, that the two cores really can't be easily 
separated, such that if deletion of a particular snapshot actually 
deletes extents pointed to by another snapshot, it's not a problem with 
the subvolume/snapshot system so much, as with btrfs itself.

What /might/ be happening is that an extent usage reference count was 
somehow too low, such that when the snapshot was removed, the reference 
count decremented to zero and btrfs thus thought it safe to remove the 
actual data extents as well.  However, shared-extents are actually a core 
feature of btrfs itself, relied upon not just by snapshot/subvolumes, but 
for instance used with cp --reflink=always when both instances of the 
file are on the same subvolume.  So while such a reference count bug 
could certainly trigger with snapshot deletion, it wouldn't be a snapshot 
subsystem bug, but rather, a bug in core btrfs itself.

The snapshot/subvolume subsystem, then, should be as stable as btrfs 
itself is, the point I made in my original reply, but again, more on that 
below.

> Apart from that, I think it's quite an issue that the core developers
> don't keep some well maintained list of working/experimental features...
> that's nearly as problematic as the complete lack of good and extensive
> end user (i.e. sysadmin) documentation.
> btrfs is quite long around now, and people start using it... but when
> they cannot really tell what's stable and what's not (respectively which
> parts of e.g. raid56 still need polishing) and they then stumble over
> problems, trust into btrfs is easily lost. :(

Actually, that's a bit of a sore spot...

Various warnings, in mkfs.btrfs, in the kernel config help text for 
btrfs, etc, about btrfs being experimental, are indeed being removed, tho 
some of us think it may be a bit premature.  And various distros are now 
shipping btrfs as the default for one or more of their default 
partitions.  OpenSuSE is for example shipping with btrfs for the system 
partition, to enable update rollbacks via btrfs snapshotting, among other 
things.

But, btrfs itself remains under very heavy development.

As I've expanded upon in previous posts, due to the dangers of premature 
optimization, perhaps one of the most direct measures of when 
_developers_ consider something stable, is whether they've done 
production-level optimizations in areas where pre-production code may 
well change, since if they optimize and then it does change, they lose 
those optimizations and must recode them.  As an example, one reasonably 
well known optimization point in btrfs is the raid1-mode read-mode device 
scheduler.  Btrfs' current scheduler implementation is very simple and 
very easy to test; it simply chooses the first or second copy of the data 
based on even/odd PID.  That works well enough as an initial scheduler, 
being very simple to implement, ensuring both copies of the data get read 
over time, and being easy to test, since selectably loading either side 
or both sides is as easy as even/odd PID for the read test.

But for a single-read-task on an otherwise idle system, it's horrible, 
50% of best-case throughput.  And if your use-case happens to spawn 
multiple work threads such that they're all even-PID or all odd-PID, one 
device is saturated, while the other sits entirely idle!  Simple and 
easily understood case of obviously not yet production optimized!  But 
kernel code already exists for a much better scheduler, one generally 
agreed to be very well optimized, that used by mdraid for its raid1 
mode.  So a well tested much better optimized solution is known and 
actually in use elsewhere in the kernel.

Which pretty well demonstrates that the developers /themselves/ don't 
consider btrfs stable enough yet to do that sort of optimization.  Were 
they to do so and the raid1 implementation to change, they'd have to redo 
that optimization, so they haven't done it yet, despite distributions 
already defaulting to btrfs and people already using it as if it were 
stable and production-ready.


Really, the best that can be said is that btrfs isn't yet completely 
stable, despite distros already shipping it by default.  However, that 
isn't such a bad problem, as it's stable /enough/ for good admin use, 
where a good admin by definition follows the admin's rule of backups, 
that being that if the data isn't backed up, by definition, it's of less 
value than the time and resources required to do that backup, despite any 
claims to the contrary.  And of course the corollary, for purposes of the 
above rule, a would-be backup that hasn't been tested restorable isn't 
yet a backup, because a backup isn't complete until it has been tested.

Because btrfs isn't yet entirely stable, that rule applies double.  If 
you don't have backups, you /might/ lose the data, so best be prepared 
for it.  But with that in mind, btrfs is stable /enough/.  Many people 
use and depend on it to function normally in their daily routine, and 
btrfs is stable enough to do just that, as long as backups are available 
for valuable data, to cover the /non-/routine case.


As for end-user/admin documentation, there is a reasonable amount, 
available on the btrfs wiki (https://btrfs.wiki.kernel.org), as well as 
all the articles in the Linux press that have covered btrfs over the 
years.  Arguably, it's at an appropriate level for the state of btrfs 
itself, again, that being "not yet fully stable, but stabilizing".  
Between that and the btrfs list for questions not covered well enough on 
the wiki...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

