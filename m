Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45384 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbbGXBLp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 21:11:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZIRWX-0003FZ-Ih
	for linux-btrfs@vger.kernel.org; Fri, 24 Jul 2015 03:11:41 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 03:11:41 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 03:11:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: INFO: task btrfs-transacti:204 blocked for more than 120
 seconds. (more like 8+min)
Date: Fri, 24 Jul 2015 01:11:22 +0000 (UTC)
Message-ID: <pan$c1082$a7d4ba34$a423d8b6$984e3578@cox.net>
References: <CA+X5Wn57HuJEzp_iOMnsi7R5AHBvsCBDbAS0+gv4O2BP-+G4VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

james harvey posted on Thu, 23 Jul 2015 19:12:38 +0000 as excerpted:

> Up to date Arch.  linux kernel 4.1.2-2.  Fresh O/S install 12 days ago. 
> No where near full - 34G used on a 4.6T drive.   32GB memory.
> 
> Installed bonnie++ 1.97-1.
> 
> $ bonnie++ -d bonnie -m btrfs-disk -f -b
> 
> I started trying to run with a "-s 4G" option, to use 4GB files for
> performance measuring.  It refused to run, and said "file size should be
> double RAM for good results".  I sighed, removed the option, and let it
> run, defaulting to **64GB files**.  So, yeah, big files.  But,
> I do work with Photoshop .PSB files that get that large.

Not being a dev I won't attempt to address the btrfs problem itself, but 
the below may be useful...

FWIW, there's a kernel commandline option that can be used to tell the 
kernel that you have less memory than you actually do, for testing in 
memory-related cases such as this.  Of course it means rebooting with 
that option, so it's not something you'd normally use in production, but 
for testing it's an occasionally useful trick that sure beats physically 
unplugging memory DIMMs! =:^)

The option is mem=nn[KMG].  You may also need memmap=, presumably 
memmap=nn[KMG]$ss[KMG], to reserve the unused memory area, preventing its 
use for PCI address space, since that would collide with the physical 
memory that's there but unused due to mem=.

That should let you test with mem=2G, so double-memory becomes 4G. =:^)

See $KERNDIR/Documentation/kernel-parameters.txt for the details on that 
and the many other available kernel commandline options.


Meanwhile, does bonnie do pre-allocation for its tests?  If so, that's 
likely the problem, since pre-allocation on a cow-based filesystem 
doesn't work the way people are used to overwrite-in-place based 
filesystems.  If there's an option for that, try turning it off and see 
if your results are different.

Also, see the btrfs autodefrag mount option discussion below.  It works 
best with under quarter-gig files, tho some people don't see issues to a 
gig on spinning rust, more on fast ssd.  There's more detail in the 
discussion below.

> Yes, my kernel is tained... See "[5.310093] nvidia: module license
> 'NVIDIA' taints kernel."  Sigh, it's just that the nvidia module license
> isn't GPL...

But it's more than that.  Kernel modules can do whatever the kernel can 
do, and you're adding black-box code that for all the kernel devs know 
could be doing /anything/ -- there must be a reason the nvidia folks 
don't want to respect user rights and make the code transparent so people 
can actually see what it's doing, after all, or there'd be no reason to 
infringe those rights.

For some people (devs or not), this is a big issue, because they are, 
after all, expecting you to waive away your legal rights to damages, etc, 
if it harms your system, without giving you (or devs you trust) the right 
to actually examine the code to see what it's doing before asking you to 
waive those rights.  As the sig below says, if you use those programs, 
you're letting them be your master.

So it's far from "just" being that the license isn't GPL.  There's 
technical, legal and ethical reasons to insist on being able to examine 
code (or let those you trust examine it) before waiving your rights to 
damages should it harm you or your property, as well as to not worry so 
much about trying to debug problems when such undebuggable black-box code 
is deliberately inserted in the kernel and allowed to run.

Tho in this particular case the existence of the black-box code likely 
isn't interfering with the results.  But it would be useful if you could 
duplicate the results without that blackbox code in the picture, instead 
of expecting others to do it for you.  That's certainly doable at the 
user level, preserving the time of the devs for actually fixing the bugs 
found. =:^)

> What I did see from years ago seemed to be that you'd have to disable
> COW where you knew there would be large files.  I'm really hoping
> there's a way to avoid this type of locking, because I don't think I'd
> be comfortable knowing a non-root user could bomb the system with a
> large file in the wrong area.

The problem with cow isn't large files in general, it's rewrites into the 
middle of them (as opposed to append-writes).  If the writes are 
sequential appends, or if it's write-one-read-many, cow on large files 
doesn't tend to be an issue.

But of course if you're allocating and fsyncing a file, then writing into 
it, you're in effect rewriting into the middle of it, and cow again 
becomes an issue.  As I mentioned above, this might be the case with 
bonnie, since its default assumptions would be rewrite-in-place, where 
pre-allocation tends to be an optimization, not the pessimization it can 
be on cow-based filesystems.

> IF I do HAVE to disable COW, I know I can do it selectively.  But, if I
> did it everywhere... Which in that situation I would, because I can't
> afford to run into many minute long lockups on a mistake...

If you have to disable cow everywhere... there's far less reason to run 
btrfs in the first place, since that kills many (but not all) of the 
reasons you'd run it.  So while possible, it's obviously not the ideal.

Tho personally, I'd rather use another filesystem for files I'd set nocow 
on btrfs, in no small measure because btrfs really isn't fully stable and 
mature yet, and the loss of features due to nocow is enough that I'd 
rather simply forget it and use the more stable and mature filesystem as 
opposed to additional risk of the not yet fully stable nocow-crippled 
btrfs, in the first place.  But I tend to be far less partitioning-averse 
than many already, so I already partition up my devices and another 
partition to dedicate to some other filesystem to avoid nocow files on 
btrfs isn't the big deal to me that it would be to people who want to 
treat a single big btrfs as a big storage pool, using subvolumes instead 
of partitions or lvm, and who thus run away screaming from the idea of 
having to partition up and do a dedicated non-btrfs filesystem for the 
files in question, when they can simply set them nocow and keep them on 
their big btrfs storage pool.

> I lose
> compression, right?  Do I lose snapshots?  (Assume so, but hope I'm
> wrong.)  What else do I lose?  Is there any advantage running btrfs
> without COW anywhere over other filesystems?

You lose compression, yes.

You don't lose snapshots, altho they require COW since they work by 
locking the existing extents in place just as they are, because in the 
case of writes to nocow files after snapshots, the first write to a block 
is cow anyway, since the existing block is locked in place.  Sometimes 
this is referred to as cow1, since the first write after the snapshot 
will cow, but after that, until the next snapshot at least, further 
writes to the already cowed block will again rewrite-in-place.  So the 
effect of snapshots on nocow is to reduce but not eliminate the effect of 
nocow (which is generally set to avoid fragmentation), tho if you're 
doing extreme snapshotting, say every minute, the fragmentation avoidance 
of nocow is obviously close to nullified.

You also lose checksumming and thus btrfs' data integrity features, altho 
you'll still have metadata checksumming.

You still have some other features, however.  As mentioned, snapshotting 
still works, altho at the cost of not avoiding cow entirely (cow1).  
Subvolumes still work.  And the multi-device features aren't affected 
except that as mentioned you lose the data integrity feature and thus the 
ability to repair a bad copy with a good copy, that normally comes with 
btrfs raid1/10 (and corresponding parity-repair with raid5/6, tho it was 
only fully implemented with 3.19, and thus isn't yet as stable and mature 
as raid1/10).

But basically, if you're doing global nocow, the remaining btrfs features 
aren't anything special and you can get them elsewhere, say by layering 
some other filesystem on top of mdraid or dmraid, and using either 
partitioning or lvm in place of subvolumes.

> How would one even know where the division is between a file small
> enough to allow on btrfs, vs one not to?

The experience with btrfs' autodefrag mount option suggests that people 
don't generally have any trouble with it at all to a quarter gig (256 
MiB) or so, while at least on spinning rust, problems are usually 
apparent at a GiB.  Half to three-quarter gig is the range at which most 
people start seeing issues.  On a reasonably fast ssd, at a guess I'd say 
the range is 2-10 GiB, or might not be hit at all, tho due to the per-gig 
expense of ssd storage, in general people don't tend to use it for files 
over a few GiB except in fast database use-cases where expense basically 
doesn't figure in at all.

But I'd guess autodefrag to hit the interactive issues before other usage 
would.  So at a guess, I'd say you'd be good to a gig or two on spinning 
rust, but would perhaps hit issues between 2-10 gig.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

