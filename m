Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46253 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaLMDCD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 22:02:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xzcy1-00060n-4f
	for linux-btrfs@vger.kernel.org; Sat, 13 Dec 2014 04:02:01 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 04:02:01 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Dec 2014 04:02:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Date: Sat, 13 Dec 2014 03:01:49 +0000 (UTC)
Message-ID: <pan$136bc$614a75aa$d8f5773e$dbbfa28b@cox.net>
References: <5488C6CF.1080608@pobox.com>
	<20141212035651.GD22023@hungrycats.org> <548A84A2.4000501@pobox.com>
	<20141212090647.GA5574@yadt.co.uk> <548ACE73.3000000@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Fri, 12 Dec 2014 03:16:03 -0800 as excerpted:

> Perhaps is just a tautological belief that someone here didn't buy into.
> Like how people keep partitioning drives into little slices for things
> because thats the preserved wisdom from early eighties.

While I absolutely agree with your raid5 sentiments (which is exactly 
what I suppose they might be; I'm getting a bit of an education in that 
regard myself, here)...

In the context of the 80s, or even the 90s, nothing about multi-gigabyte 
could be considered "little"! =:^)

In fact, while it most assuredly dates me, it /still/ feels a bit odd 
referring to the 1 GiB btrfs default threshold for mixed-bg-mode as 
"small", given that I distinctly remember wondering how long it might 
take me to fill my first 1 GB (not GiB, unfortunately) drive, tho by that 
time I did have enough experience to know I'd eventually be dealing with 
multi-gig as at the time I was dealing with multi-meg.

More to the point, however...

Those partitions have saved my a** quite a few times over the years.  
Among other things, partitioning allows me to keep my (8 GiB) rootfs an 
entirely separate filesystem that's mounted read-only by default, which 
has kept it undamaged and the tools on it still available to help recover 
my other filesystems, when /var/log and /home were damaged due to a hard 
shutdown recently.

And some years ago I had an AC failure here in Phoenix in the middle of 
the summer, resulting in a physical head-crash and loss of the operating 
partitions on my disk in use at the time, while the backup partitions on 
the same device remained intact, such that after cooldown I actually 
continued to use that disk for some time, mounting the damaged partitions 
only to recover the most recent copies of what I could, updating the 
backups which were now promoted to operational.

Sure, technology such as LVM can do similar and is more flexible in some 
ways, but unfortunately it requires userspace and thus an initr* in 
ordered to handle a root on the same technology.  Otherwise, root must be 
treated differently, and then you have partitioning again.

Additionally, LVM is yet another layer of software that can and does go 
wrong and itself need fixed.  Partitioning is too, to some extent, but in 
practice it has been pretty bullet-proof compared to technologies such as 
LVM and btrfs-subvolumes.  LVM has some way to go before it's as robust 
as partitioning, and of course btrfs with its subvolumes isn't really 
even completely stable yet.  Further, btrfs doesn't well limit damage of 
a subvolume to just that subvolume (that head-crash scenario would have 
almost certainly been a total loss on btrfs subvolumes), the way 
partitioning tends to do.  And LVM's very flexibility means it doesn't 
normally have that sort of damage limitation either.  It certainly can, 
but doing so severely reduces its flexibility, making going back to 
regular partitions to avoid the complexity and additional points of 
failure entirely a rather viable and often better choice.

Meanwhile, technology such as EFI and GPT is breathing new life into 
partitioning, making it more reliable (checksummed redundant partition 
tables), more useful/flexible (killing the primary/secondary/logical 
divisions and adding partition names/labels and a far larger typing 
space), and creating yet more uses for partitioning in the first place, 
due to separate reserved EFI and legacy-BIOS partition types.

Tho of course these days those partition "slices" are often tens or 
hundreds of gigs, and are now sometimes "teras"[1], bringing up my 
initial point once again; that's NOT actually so small!

But to each his own, of course, and I definitely do agree with you on 
raid5, the larger point.  FWIW, I still consider allowing a two-device 
"raid5" or a three-device "raid6" a bug, particularly given that a single-
device "raid1" is /not/ allowed, nor is a 3-device "raid10".

---
[1] Hmm, K, megs, gigs, "ters", "teras", simply "T" to match K ???

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

