Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34728 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaAJO0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 09:26:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1d2o-0007ps-Hz
	for linux-btrfs@vger.kernel.org; Fri, 10 Jan 2014 15:26:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 15:26:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 15:26:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: backpointer mismatch
Date: Fri, 10 Jan 2014 14:26:19 +0000 (UTC)
Message-ID: <pan$d701f$adb6e087$f10cdac$a6ccb243@cox.net>
References: <52CF7032.3090004@oma.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Peter van Hoof posted on Fri, 10 Jan 2014 04:59:46 +0100 as excerpted:

> I am using btrfs for my backup RAID.

Oh, boy!  You're doing several things wrong in this post, tho you've also 
managed to get a couple thing right that a lot of people get wrong, too, 
which just might have saved your data!.  Here's what I see:

1) Btrfs is still in heavy development, and there are warnings all over 
your kernel btrfs option (tho that one has been reduced in severity of 
late, for 3.13 actually, I believe, but your kernels are earlier than 
that), mkfs.btrfs, and the btrfs wiki at https://btrfs.wiki.kernel.org , 
about being sure you have tested backups you're ready and willing to use 
before testing btrfs.

IOW, your backups shouldn't be btrfs, because btrfs itself is testing, 
and any data stored on it is by definition testing-only data you don't 
particularly care about, either because you have good tested-restorable 
backups, or because the data really isn't that valuable to you in the 
first place.  There's no way to avoid it by saying you didn't know 
either, as a careful admin researches (and may well early-deployment 
test, too) the filesystems he's going to use before /actual/ deployment.  
Failing to do that simply means the admin isn't "care-ful", that he 
simply isn't full of care about the data he's trusting to a filesystem he 
knows little or nothing about -- literally, he does not care, at least 
/enough/.

> This had been running well for about a year. 
> Recently I decided the upgrade the backup server to
> openSUSE 13.1. I checked all filesystems before the upgrade and
> everything was clean. I had several attempts at upgrading the system,
> but all failed (the installation of some rpm would hang indefinitely).
> So I aborted the installation and reverted the system back to openSUSE
> 12.3 (with a custom-installed 3.9.7 kernel). Unfortunately, after this
> the backup RAID reported lots of errors.

There's a couple things wrong here.

2) Btrfs testers are encouraged to always run a recent kernel, preferably 
the latest release of the latest Linus kernel stable series (currently 
3.12.x), if not the latest Linus development kernel (we're late in the 
3.13 rc cycle), if not even the btrfs-next patches that are slated for 
the /next/ development kernel.  If you're more than a stable series 
behind (thus currently you should be on the 3.11 series at absolute 
minimum), you're both risking your data to bugs that are already known 
and fixed, and as a btrfs tester, if/when things DO go wrong, your bug 
reports aren't as useful because the code you're running is simply too 
stale!

3.9.x?  For an admin who has chosen to be a btrfs tester, that is, or 
should be, ancient history!

(As implied by the mention of 3.13 toning down the btrfs kernel config 
option warning a bit, btrfs is indeed now beginning to stabilize, and 
these tester/user requirements should be a bit less strict going 
forward.  But you're not yet using 3.13, so they still apply in pretty 
much full force.  And even if they /are/ getting less strict now, four 
whole kernel series outdated really /is/ outdated, for btrfs!)

3) At this point in btrfs development, the on-device format is still 
getting slight tweaks.  There's a policy that existing formats are new-
kernel-compatible, but once you mount a btrfs with a new kernel, updates 
to the format may be made, and there's no such policy about the 
compatibility of mounting btrfs filesystems with old kernels again, once 
they've been mounted with a new kernel.

That's actually what you're seeing, I suspect.  The filesystem may well 
not be damaged.  It's simply that it was mounted with a newer kernel, and 
now the older kernel you're trying to use again, doesn't understand some 
of the changes the new kernel made.  That's not damage, it's just 
attempting to use a stale kernel on a filesystem mounted with a more 
recent version that updated the on-device format enough so your stale 
kernel doesn't understand parts of it any more.

But the good news is that particularly since you're already running a 
custom 3.9 kernel and thus must already know at least a /bit/ about 
configuring and building your own kernel, you shouldn't have much trouble 
getting a new kernel, the latest 3.12.x stable or even the latest 3.13.x 
rc since it's already late in the cycle, on your system, even if it means 
building it yourself to do so.  Hopefully with that, you'll find the 
currently reported errors gone, and it'll work fine. =:^)

> When I run btrfsck on the filesystem, I get [snipped but for this:]
> Btrfs v3.12+20131125
> 
> (this version of btrfsck comes from openSUSE factory).

Well, at least you're running a reasonably current btrfs-tools.  Btrfs-
tools 3.12 was released at about the same time as kernel 3.12, and was in 
fact the first release to use the new, kernel-synced, version number 
scheme.

4) But there's the hint, too.  A 3.12 btrfs-tools works best with a 3.12 
kernel, and you're attempting to use a very stale 3.9 kernel ATM.  No 
/wonder/ that combination triggers problems!  It /may/ be that an older 
btrfs-tools would match that kernel a bit better.

Of course before 3.12, btrfs-tools wasn't actually released all that 
often, and the older 0.19/0.20-rc1 style versioning didn't lend itself 
particularly well to kernel matching, which was a problem.  But a quick 
look at the changelog on the btrfs wiki suggests that kernel 3.9 was in 
April, 2013, while btrfs-progs 0.20-rc1 was, from memory, late 2012.  So 
a dated btrfs-progs git-snapshot version of something like 0.20-rc1
+201304xx, if you can find such an animal, might actually work a bit 
better with that kernel version, if you can't do the better thing and 
properly upgrade the kernel to current.

> I also ran btrfs scrub on the file system. This uncovered 4 checksum
> errors which I could repair manually. I do not know if that is related
> to the problem above. At least it didn't solve it...
> 
> The btrfs file system is installed on top of an mdadm RAID5.

Out of curiosity, how often do you run an mdadm scrub?

Unfortunately btrfs' native raid5/6 support, introduced in kernel 3.9, 
remained unfinished both then and thru current 3.13 -- it writes the 
parity data, but proper use of it in btrfs scrub and recovery remains not 
fully implemented, so (even more than btrfs in general) it's DEFINITELY 
not recommended except for run-mode testing, since the recovery mode that 
people /run/ raid5/6 for remains broken, making it effectively a raid0 -- 
if you lose a device, consider the entire filesystem lost.

So btrfs-native raid5/6 is entirely out as a viable option.

Which leaves you with mdraid (or possibly lvm?) for raid5/6 if that's 
what you need.  Unfortunately, while mdraid writes the parity data and 
(unlike btrfs raid5/6 mode) /does/ reliably use it for recovery, unlike 
btrfs once it's actually implemented properly, mdraid does no parity/
checksum checking in normal operation.  Which means any corruption on it 
will remain entirely undetected unless you run mdadm scrub.

FWIW, while I ran mdraid6 in the past, once I realized it didn't do 
normal runtime parity checking anyway, I switched out to the better 
performing mdraid1 mode.  Since I had four drives for the raid6, and was 
lucky enough to have the space to re-allocate when I squeezed a bit, I 
ended up with 4-way mdraid1, giving me loss of three device protection.  
But of course I didn't have the operational data integrity that btrfs 
raid1 mode provides, altho that's only across two mirrors.  (At present, 
btrfs raid1 mode is only two-way-mirrored regardless of the number of 
devices in the raid.  If there's more devices, it still only keeps two 
copies, and simply expands the amount of available storage.  Btrfs N-way 
mirroring remains on the btrfs roadmap for implementation after raid5/6 
is completed, but it's not there yet.  FWIW, while other btrfs features 
are nice, I really /really/ want N-way mirroring, as checksummed three-
way-mirroring for loss-of-two-devices protection really does appear to be 
my cost/risk balance sweet spot.  But as it's not yet available...

So while waiting for the btrfs full-checksummed 3-way-mirroring I 
/really/ want, I content myself with the 2-way-mirroring that's actually 
implemented, and /reasonably/ stable, tho I still keep an off-btrfs 
backup on reiserfs (which has been proven /extremely/ reliable, here, at 
least since the introduction of ordered-journal mode by default now many 
years ago, but unfortunately reiserfs isn't suited to use on ssds, the 
reason I've upgraded to btrfs even if it is still testing, while still 
keeping reiserfs backups on spinning rust).

And due to unclean shutdowns for reasons not entirely related to btrfs, I 
do occasionally see btrfs scrub fixing problems here, just as I had to do 
mdraid device re-adds on occasion.

But anyway, given the big hole in current functionality, btrfs having run-
time checksumming support but nothing above 2-way-mirrored raid1 (or 
raid10), and mdraid/lvm having raid5/6 and n-way-mirroring, but no 
routine runtime integrity checking, only on-demand scrub, btrfs on top of 
mdraid5 is a reasonable way to go.

5) But if you do start getting btrfs errors I would certainly recommend 
an mdraid level scrub, just to be sure they're not coming from that level.

Tho in this case I really do suspect it's simply a matter of trying to 
run a filesystem that has been mounted on a newer kernel, again on an 
older kernel that it's now no longer fully compatible with, and really do 
hope/expect that at least some of your problems will go away once you try 
a current kernel. ...

> How worried should I be about the reported errors? What confuses me is
> that in the end btrfsck reports an error count of 0.

... Which if I'm correct, may explain this as well, particularly since 
your kernel is old and likely reporting things it doesn't understand, 
while your btrfs-tools are new, and thus may well not see a problem, 
because there (hopefully) really isn't a problem, except that you're 
trying to use too old a kernel for the on-device btrfs format.

> Should I try to repair this? I have had bad experiences in the past with
> "btrfsck --repair", but that was with a much older version...

6) *THIS* is the thing you actually did correctly, that MAY WELL HAVE 
SAVED YOUR DATA! =:^)

Currently, btrfsck --repair (or btrfs check --repair in current btrfs-
tools, where it is now part of the main general purpose btrfs tool), is 
only recommended as a last resort.  It can and sometimes does actually 
make the problem worse.

Given that I suspect your problem may not actually be a filesystem issue 
at all, but rather, simply due to trying to use an old and stale kernel 
with a filesystem updated to use elements the old kernel doesn't 
understand, the chance if btrfs --repair actually doing more damage than 
fix is even higher.

> I can of course recreate the backups, but this would take a long time
> and I would loose my entire snapshot history which I would rather
> avoid...

Well, given the situation, with any luck the resolution to the immediate 
problem is as I said, simply run a current kernel as recommended, that 
matches your current btrfs-tools version, and that isn't a regression to 
a MUCH too stale kernel significantly older than the most current one 
you've ever mounted the filesystem with.

But while with any luck that does solve the /immediate/ problem, it 
doesn't do anything to solve the more general situation, that you're 
using a still under heavy development btrfs as a backup, an entirely 
unappropriate role for a filesystem that is recommended for testing only 
with data that you don't care of it's lost, either because you keep off-
btrfs backups, or because the data isn't that important to you if your 
btrfs testing should lose it all, in the first place.

So even if a current kernel does resolve the immediate situation, I'd 
still recommend using something else rather more mature for your backup 
solution.

Meanwhile, redoing your older btrfs filesystems with newly created 
mkfs.btrfs filesystems is probably a good idea as well, because there's a 
number of efficiency and robustness optimizations now enabled by default 
on newly created filesystems, that simply aren't available on filesystems 
created before their introduction.  Newer kernels and tools can still 
mount and run on the older filesystems as that compatibility is policy, 
but that doesn't mean it's as efficient or robust an implementation as 
if you'd created the filesystem with current tools and kernel, using all 
the latest format variants.

So even if using a current kernel solves your immediate issues, as I have 
a reasonable expectation/hope that it will, I'd still recommend redoing 
those backups, to something more appropriate for backups than btrfs at 
this point.

And for anything you do use btrfs for (with appropriate backups), I'd 
suggest a fresh mkfs.btrfs filesystem, to take advantage of the latest 
format optimizations and robustness features.

And then for anything running btrfs, keep current, both kernel and and 
btrfs-tools.  It really /can/ be the difference between safe data because 
a bug that you might have triggered is fixed, and trashed data because 
you triggered a long fixed bug while using ancient tools and kernel!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

