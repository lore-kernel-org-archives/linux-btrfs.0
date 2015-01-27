Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46554 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbbA0MCL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 07:02:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YG4qJ-0001Zs-Af
	for linux-btrfs@vger.kernel.org; Tue, 27 Jan 2015 13:02:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 13:02:03 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 13:02:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to repair a damaged filesystem with btrfs raid5
Date: Tue, 27 Jan 2015 12:01:49 +0000 (UTC)
Message-ID: <pan$cd9a7$db37158b$82d48a45$d74474fa@cox.net>
References: <54C75683.80903@mpi-dortmund.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Fieroch posted on Tue, 27 Jan 2015 10:12:35 +0100 as excerpted:

> I'm testing btrfs RAID5 on three encrypted hdds (dm-crypt) and I'm
> simulating a harddisk failure by unplugging one device while writing
> some files.
> Now the filesystem is damaged. By now is there any chance to repair the
> filesystem?
> 
> My operating system is ubuntu server (vivid) with kernel 3.18 and btrfs
> 3.18.1 (external PPA).

Your kernel is too old for proper btrfs raid56 support.  Yes, it's the 
newest kernel stable kernel cycle, but...

When raid56 mode (that's either/or, so 5 or 6, the same raid56 code 
supports both) was introduced several kernel cycles ago, it was 
incomplete -- normal runtime support was there, but the recovery code was 
incomplete, so in effect those running it were running a slower raid0 -- 
loss of a device could mean loss of the entire filesystem (tho recovery 
was possible in limited cases, but the point is, you couldn't count on 
it, so from an admin perspective it was a slow raid0, sudden-death at 
loss of a device).

The raid56 mode status is, however, *JUST* changing.  The still in 
development kernel 3.19 series should be very close to code-complete, 
altho there's still known bugs ATM that may well not be fixed until the 
3.20 series.

So a fresh 3.19-rc or git development kernel, preferably combined with 
the 3.19 series btrfs-progs userspace (which won't actually be released 
until after the 3.19 kernel, so you'll be grabbing a development branch 
from git to get that code now), should be very close to working with 
raid56 mode, while anything older won't, at least for reliable recovery.  
And even 3.19 is likely to still have bugs to work out in that code.  I'd 
thus recommend waiting at /least/ until 3.20 for raid56, if not 21 or 
later, depending on how bug tolerant you are.

For present usage, meanwhile, I'd strongly recommend sticking with raid1 
or raid10, which are in general as stable as btrfs itself is ATM, which 
is to say not /entirely/ stable yet, so if you don't have tested-working 
backups by definition you don't care if you lose the data on the 
filesystem, but it's working /reasonably/ well, without too much trouble, 
for most users at this time.

FWIW, raid56 mode's incomplete status was in the original commit message 
for it, and the status hasn't changed from that since.  It's also 
documented on the btrfs wiki[1], and is well known on this list.  Still, 
you're not the first to have missed it. <shrug>

---
[1] https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

