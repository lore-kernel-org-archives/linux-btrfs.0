Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39624 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbbIZBno (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 21:43:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZfeWZ-0003hL-11
	for linux-btrfs@vger.kernel.org; Sat, 26 Sep 2015 03:43:39 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 03:43:39 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 03:43:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raw devices or partitions?
Date: Sat, 26 Sep 2015 01:43:32 +0000 (UTC)
Message-ID: <pan$b1277$da5af759$7c0940dd$1bc738e@cox.net>
References: <2432089.CrOTrZyfAm@hoefnix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sjoerd posted on Fri, 25 Sep 2015 15:40:39 +0200 as excerpted:

> Is it better to use raw devices for a RAID setup or make one partition
> on the drive and then create your RAID from there?
> Right now if have one setup that uses raw, but get messages "unknown
> partition table" all the time in my logs.
> I am planning to create a RAID 5 setup (seems to be stable these days?),
> but wondering  to deal with  raw drives or partitions (4 at the moment).
> In the wiki they're referring to raw devices in the examples, but that
> could be outdated?

Raw device vs. partition (vs mdraid vs dmraid vs lvm) doesn't matter to 
btrfs.  They're all block devices.

That unknown partition table log entry is from elsewhere in the kernel, 
where it would normally read partition tables if there were any to read.  
It's simply telling you it couldn't find any, to help with diagnostics in 
case there's supposed to be one.  But if you deliberately used a raw 
device, there isn't supposed to be a partition table, so no big deal.

So just ignore the warning as the diagnostic aid for a case that doesn't 
apply to you, if you like.  Or if you find it irritating enough that 
isn't possible, then do the big partition thing and disappear the 
warning.  No big deal either way. =:^)


Tho if the device is either going to be bootable, or you might want to 
repurpose it to bootable in the future, you may well want to partition 
it, preferably gpt, and create a couple small partitions to make that 
easier, before creating the big one.

Here, I create both a tiny BIOS-reserved partition, for legacy BIOS boot 
(which I use now, grub2 installs to it for BIOS systems), and a slightly 
larger but still tiny EFI-reserved partition, for forward compatibility.  
The two together still take only an eighth of a gig (128 MiB), which I 
figure is a fair trade for the additional flexibility it gives me.

Here's my layout, FWIW.  (This is on SSD where partition order doesn't 
matter.  Since the first sections of a spinning rust device are the 
fastest, and these will only ever be used for boot if used at all, you 
might wish to put these last, on that.)

Generally 2 MiB minimum alignment, for better efficiency on modern 
devices, and the first few KiB of a device are taken by the boot sector 
and partition table.  But the BIOS partition is so small and accessed 
using primitive and inefficient BIOS routines anyway...

#	Start (MiB)	End (MiB)	Size (MiB)	Name/Description
x	0		1		1		GPT/free
1	1		4		3		BIOS/reserved
2	4		128		124		EFI/reserved

As you will note, that ends at an even 128 MiB alignment, 1/8 GiB.  FWIW, 
I put another couple small partitions (boot and log) under a gig, ending 
with GiB alignment, with everything else GiB aligned.

And 1/8 GiB is small enough, I'll often start off with that even on USB 
flash drives.  To me it's worth it, just to have the flexibility of 
making it bootable, should I decide to, without having to move partitions 
around to fit in the boot stuff.  Then I partition up the rest, or leave 
it one big partition, as the use-case calls for.

As an additional benefit, because I use this layout consistently, should 
I need to (tho with gpt having checksumming and a partition table at each 
end of the device, the chance of entirely losing it without the whole 
device being junk is dramatically lowered), I can recreate it with good 
confidence, knowing the normal partitions always start at 128 MiB.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

