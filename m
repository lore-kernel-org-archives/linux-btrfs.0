Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59558 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaEZPju (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 11:39:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wox07-00068E-JR
	for linux-btrfs@vger.kernel.org; Mon, 26 May 2014 17:39:47 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 17:39:47 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 17:39:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs filesystem freezing during snapshots
Date: Mon, 26 May 2014 15:39:34 +0000 (UTC)
Message-ID: <pan$50759$4fa2d3e6$b614d48b$43ab60ba@cox.net>
References: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Bloquel posted on Mon, 26 May 2014 14:28:51 +0200 as excerpted:

> I have a problem with my btrfs filesystem which is freezing when I am
> doing snapshots.
> 
> I have a cron that is snapshoting around 70 sub volume every ten
> minutes. The sub volumes that btrfs is snapshoting are containers
> folders that are running through my virtual environment.
> Sub directories that btrfs is snapshoting are not that big (from 500MB
> to 10GB max and usually around 3GB) but there is a lot of IO on the
> filesystem because of the intensive use of the CTs and VMs.
> 
> At some point the snapshot process becomes really slow, at first it
> snapshot around one folder per seconds but then after a while it can
> take 30seconds or even few minutes to snapshot one single sub volumes.
> Subvolumes are really similar to each other in size and number of
> files so there is no reason that it takes 1second for one sub volume
> and then 3minutes for another one.
> 
> Moreover when my snapshot cron is running all my vms and containers
> are slowing down until the whole filesystem freezes which leads to
> frozen CT and VMs (which is a real problem for me).
> 
> Moreover I can see that my CPU load is really high during the process.
> 
> when I'm am looking to dmesg there is a lot of messages of this kind:
> 
> [orphan unlinking and btrfs-transacti blocked messages, kernel 3.12.0]
> 
> A solution would be to wait few seconds between each snapshot to avoid
> high load however I think it's just a way to avoid the problem and I
> would rather fix it because I am affraid it could appear during
> another operation (copy of a lot of small files etc...).
> 
> I have checked a lot of old messages from this mailling list and I got
> some clues but no real/working solution in my case.

You're hitting one of the btrfs performance and scaling weak-spots
head-on from two different directions at once, so it's little wonder 
you're seeing problems.  

Copy-on-write based filesystems such as btrfs will always find
"internal-rewrite-pattern" a severe challenge to deal with, because under 
normal circumstances, all those writes to blocks inside existing files 
force rewriting those blocks elsewhere, thus very heavily fragmenting the 
file.  We've had reports of files with hundreds of thousands of file 
extents!  No WONDER btrfs bogs down trying to manage these things!

Btrfs has two mechanisms to deal with this.  For small files up to a few 
hundred MiB (think firefox sqlite database files), the autodefrag mount 
option is useful, as when it sees a write into a file it queues that file 
for full rewrite.  However, as the file size increases toward a GiB and 
higher this doesn't scale so well, as the writes can come faster than the 
file can be rewritten.  

Thus for large internal-rewrite files another mechanism is needed.  Until 
the devs come up with a more efficient automated solution, the current 
recommendation is to set the NOCOW file attribute (chattr +C) on these 
files, or more accurately, on the directory before the files are created, 
so they inherit the attribute at creation.[1]  NOCOW files are updated
in-place as they would be on traditional filesystems, thus avoiding the 
fragmentation.

But unfortunately there's a number of caveats and limitations to NOCOW, 
the biggest of which is that snapshots assume COW semantics and freeze 
the existing file data in place at the time of the snapshot, so the first 
write to a file block after a snapshot forces a COW write even on NOCOW 
files, as the alternative would be destroying the snapshot.

Since you're snapshotting those files every 10 minutes, that means even 
with NOCOW files every ten minutes worth of changes will be stored in 
extents written out of order!

Which is what you're coming up against.  Take a look at what filefrag 
says about some of those several gig active VM images that have been 
around for a few weeks.  I bet you find a lot of them have tens of 
thousands of extents, even if you've used the NOCOW attribute on them 
from creation as recommended.

The bottom line is that VM images and the like should be set NOCOW and 
excluded from snapshots using subvolumes, since snapshots stop at 
subvolume boundaries.  Use more conventional backup methods for them,
and/or since setting NOCOW and avoiding snapshots bypasses many of the 
features people actually choose btrfs to get, consider creating separate 
filesystems for your VM images, etc, using something other than btrfs, 
since btrfs simply doesn't work so well for this use-case at this time.

Another caveat/limitation of NOCOW is that it turns off btrfs data 
checksumming and (mount-option-optional) compression, since in-place 
updates don't work well with these features and leaving them on would 
simply be an invitation to impossible to resolve race conditions and 
performance issues, so better to just force them off along with COW and 
avoid the additional danger.  However, that turns out not to be the 
problem one might think, since most applications using such internal file 
rewrite techniques have had to evolve their own methods of dealing with 
file integrity and crash restoration as they're used on filesystems 
without the file integrity mechanisms of btrfs, and in fact, having both 
btrfs and the application's own mechanisms trying to manage things has at 
times resulted in its own set of bugs since neither one accounts for what 
the other is doing and the checkpoints aren't coordinated, etc.  So 
actually, turning off btrfs file integrity checking for these files 
simply lets the applications handle it the way they do on other 
filesystems, without btrfs getting in the way.

Meanwhile, the devs are working hard at improving this use-case, but it's 
worth keeping in mind that features such as snapshotting and checksummed 
file integrity are features that other filesystems don't normally have, 
so even if there's limitations to where and how they work on btrfs, the 
fact that btrfs has them at all puts btrfs beyond other filesystems, and 
if the features must be disabled for a particular use-case, that only 
returns btrfs to the same general set of features that other filesystems 
have.

Addressing the problem from another angle, how many snapshots are you 
keeping?  You're taking snapshots every 10 minutes, but do you have 
automated thinning setup as well?  If you thin to say a snapshot every 
half hour after an hour, deleting two of three, then a snapshot every 
hour after six hours (deleting half), a snapshot every eight hours after 
a day, (three a day, deleting seven of eight), a snapshot a day after a 
week (deleting three of four), and do off-media backup after four weeks 
so can delete all snapshots older than that, you'll have 6 (10-minute, to 
1 hour) + 10 (half-hour, to 6 hours) + 18 (hourly, to a day) + 18
(8-hourly, to a week), + 21 (daily, to four weeks) = 6+10+18+18+21 =
73 snapshots.

Of course, if feasible reducing the base snapshot frequency to every half 
hour will cut it to under 70, and give you a bit more time between 
snapshots to avoid the possibility of a new cycle starting before the 
last one has finished, as well.

I don't know if you're thinning now, but if not, you may have hundreds or 
thousands of existing snapshots.  Simply thinning them out to something 
reasonable like the 70-ish proposed above may well be all you need.

Finally, I note that you're still on a 3.12 kernel, while 3.14 is out and 
3.15 is well on its way.  There's still enough bugs being fixed in each 
kernel that it's worth keeping current, and certainly, if you report 
problems here with a two-kernel-cycle-old kernel, you can expect that 
trying at least the latest stable kernel is going to be suggested, if not 
the latest rc kernel, altho I usually wait until rc2 or rc3 myself, 
figuring I should have read about any real bad system eating bugs by then 
and they will have probably been fixed by then as well, if I didn't.  
Somewhere right about 3.12 they disabled the snapshot aware defrag as it 
simply was NOT scaling well in these sorts of cases, tho it might have 
been 3.11.  If you don't have that snapshot-aware-defrag disabling in 
your kernel, defrags especially will take much *MUCH* longer, but IIRC it 
was disabled by 3.12 so with luck you don't have /that/ problem to worry 
about with your current kernel, at least.

Similarly with btrfs-progs.  Current release (last I checked, about a 
week ago myself) is 3.14.1.  If you're behind that, consider upgrading it 
too, altho it's not quite as critical as the kernel.  The version before 
that was 3.12, and I'd recommend at least having that.  If you're still 
on 0.19 or 0.20-rc, better upgrade!

---
[1] NOCOW attribute inheritance:  On btrfs the nocow attribute should be 
set at file creation in ordered to guarantee that it applies properly.  
The easiest way to do this is to set it on the directory that will 
contain the files, then copy (not move, unless from a different 
filesystem, and not using cp --reflink) existing files from elsewhere 
into the directory with the attribute already set, so they get it set 
when they are created as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

