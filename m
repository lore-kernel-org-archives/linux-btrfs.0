Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38823 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaJXGqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 02:46:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhYdy-0004WG-Qt
	for linux-btrfs@vger.kernel.org; Fri, 24 Oct 2014 08:46:38 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 08:46:38 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 08:46:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mounting(multiply)? Options(stored)? Options(barriers)?
Date: Fri, 24 Oct 2014 06:46:27 +0000 (UTC)
Message-ID: <pan$36970$682b4a1f$353db41d$7cb90559@cox.net>
References: <544980BA.8080007@pobox.com>
	<pan$ce81d$b98a312d$87b2f050$bb8a9bd1@cox.net>
	<5449D085.9030801@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Thu, 23 Oct 2014 21:07:33 -0700 as excerpted:

> Ouch, I abandoned multiple hard partitions on any one spindle a long,
> long time ago. The failure modes likely to occur just don't justify the
> restrictions and hassle. Let alone the competitive file-system
> scheduling that can eat your system performance with a box of wine.
> 
> I've been in this mess since Unix System 3 release 4. The mythology of
> the partitioned disk is deep and horrible. Ever since they stopped the
> implementation of pipes as anonymous files on the root partition, most
> of the reasoning ends up backward.
> 
> Soft failures are likely to spray the damage all over all the
> filesystems by type, and a disk failure isn't going to obey the
> partition boundaries.
> 
> Better the efficiency of the whole disk file-systems and a decent backup
> plan.
> 
> Just my opinion.

Of course JMHO as well, but that opinion is formed from a couple decades 
of hard experience, now...

The "single egg basket" hardware device failure scenario is why I use 
multiple identically partitioned devices setup with multiple independent 
raid1s (originally mdraid1, now btrfs raid1) across those partitions for 
most stuff, these days.  Raid itself isn't backup, but software raid 
along with hardware JBOD and standard-driver solutions such as AHCI, 
means both hardware storage devices and the chipsets driving them can be 
replaced as necessary, and I've actually done so.

So I do put multiple partitions including the working copy and primary 
backup of the same data on the same hardware device (which may or may not 
be a spindle, these days, my primaries are SSD, with the second-backups 
and media drives being spinning rust), but the partitioning layout and 
data on that device is raid-mirrored to a second device, identically 
partitioned (using redundant and checksummed GPT, BTW), with separate 
mdraid or now btrfs raid on each partition, so if one device fails, the 
mirror provides the first level hardware backup.

And the partitions are typically small enough, my root partition 
(including pretty much everything installed by the package manager, 
including its tracking database) is only 8 GB and all partitions other 
than the media partitions are under 50 GB, that I can keep multiple 
copies on that same set of software-raided hardware.  So I have an 8-gig 
root, and another 8-gig rootbak, a 20-gig home and another 20-gig homebak, 
with the second copies located rather further into the hardware devices, 
after the first copy of all my other partitions.

Grub is installed to each hardware device in the set, and tested to load 
from just the single hardware device.  Similarly, the /boot partition 
that grub points to on each device is independent, since grub can easily 
point at only one per device.  Of course I can select the hardware device 
to boot, and thus the copy of grub, from the BIOS.  (And when I update 
grub or the /boot partition, I do it on one device at a time, testing 
that the update still works before updating the other.)

And of course once I'm in grub I can adjust the kernel commandline root= 
and similar parameters as necessary, and indeed, even have grub menu 
options setup to do that so I don't have to do it at the grub cli.

But of course as you said, a kernel soft failure could scribble across 
all partitions, mounted and unmounted alike, thus taking out that first 
level backup along with the working copy.  I've never had it happen but I 
do run live-git pre-release kernels so I recognize the possibility.

Which is why the second level backup is to a totally different set of 
devices.  While my primary set of devices (and thus the working copy and 
first backup) are SSD, using btrfs, my second set is spinning rust, using 
reiserfs.  That covers hardware device technology failure as well as 
filesystem type failure. =:^)

And of course I can either bios-select the grub on the spinning rust or 
boot to the normal grub and grub-select the spinning rust boot, my second-
level backup, as easily as I can the first-level backup.

Meanwhile, other than simple hardware failure taking out a full device, 
my most frequent issues have all taken out individual partitions.  That 
includes one which was a heat-related head-crash due to A/C failure here 
in Phoenix, in the middle of the summer.  The room was at least 50C and 
the drive was way hotter than that.  But while I'm sure the platters were 
physically grooved due to heat-related head-crash, after I shutdown and 
everything cooled back down, partitions that weren't mounted were nearly 
undamaged (an individual file damaged here or there, I suppose due to 
random seeks across the unmounted partitions between operational 
partitions before the CPU froze).

I actually booted and ran from the backup-root, backup-home, etc, 
partitions on that damaged drive for a couple months, before I got the 
money together to replace it with an upgrade.  Just because the at the 
time mounted partitions were probably physically grooved and pretty well 
damaged beyond possibility of recovery, didn't mean the at the time 
unmounted partitions were significantly damaged, and they weren't, as 
demonstrated by the fact that I actually ran from them on the damaged 
hardware for that long.

FWIW, there's normally unattached third-level backups of some data as 
well, tho I don't as regularly update it, because I figure if the 
disaster is big enough I'm resorting to that, it's likely a robbery or 
fire or natural disaster, and I'll likely have bigger problems to worry 
about, like simply surviving and finding another place to live, and won't 
be too worried about the relatively minor issue of what happened to my 
computer.  After all, the *REAL* important backup is in my head, and of 
course, if /that/ gets significantly damaged or destroyed, I think it's 
safe to say I'm not going to be worrying about it or anything else for 
awhile. =8^0  Gotta keep some real perspective on things, after all. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

