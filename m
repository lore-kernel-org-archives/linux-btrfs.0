Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40332 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2FLPWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 11:22:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SeSvD-0001P1-NP
	for linux-btrfs@vger.kernel.org; Tue, 12 Jun 2012 17:22:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 17:22:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 17:22:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug in btrfs-debug-tree for two  or more devices.
Date: Tue, 12 Jun 2012 15:22:00 +0000 (UTC)
Message-ID: <pan.2012.06.12.15.22.00@cox.net>
References: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Santosh Hosamani posted on Tue, 12 Jun 2012 06:53:00 +0000 as excerpted:

> I am working on btrfs filesystem on how it manages the free space. [...]

> I hav run these tests on SLES11-sp2-x86 Kernel 3.0.13.0.27-default

Quick mostly boilerplate intro reply.  I'm just a list regular following 
development without getting too technical, so won't even a full answer.


1. As you didn't mention the wiki and based on a couple hints in your 
mail including the kernel version, I'm guessing you haven't read up on 
btrfs there yet.

https://btrfs.wiki.kernel.org/


2. Btrfs is of course still experimental and under heavy development, so 
while testing as you're doing is great, even more than with proven 
filesystems, if you value your data, HAVE BACKUPS.

3. It follows from the "under heavy development" part but making it 
explicit: for btrfs testers, a 3.0 kernel is OLD CODE with many bugs, 
some critical, fixed since then, and many newly implemented features in 
newer code.  The standard STRONG recommendation is to run at least 
current Linus stable, thus currently 3.4, if not the 3.5 rcs, and there's 
pre-Linus-integration-branches as well, if you're brave.  Additionally, 
for the first time last kernel cycle (btrfs wasn't considered stable 
enough to bother before that), a btrfs update was submitted to the stable 
tree, so if you're staying with stable, do keep current with the stable 
point releases, 3.3.x in that case but now of course 3.4.x.

4. Also recommended (and following from the "heavy development" bit), 
btrfs testers should keep current with this list in ordered to know what 
bugs are already being worked on and how testers might be affected.


Now a brief reply that may or may not explain the one-device/multi-device 
difference you're seeing, I'm not deep enough into the technical side to 
know for sure.  As you'll be aware if you've read the wiki, btrfs 
defaults to single data, duplicate metadata.  On a single device, the two 
separate metadata copies are of course stored on the same device, but 
where btrfs has at least two devices to work with, it tries to keep the 
two copies on separate devices.  It may be that what you're seeing is the 
lower-level implications of that difference.

Of course it's also possible that you've found a bug, but testing with a 
current kernel would help in terms of knowing whether it's still an issue 
or not.  As I said, 3.0 is OLD for btrfs testers.  (There is however 
someone reporting a huge metadata imbalance with multi-device btrfs 
filesystems and current code, IDR whether it's 3.4 or 3.5-rcs.  Only a 
few gigs, single digits, of data, but something like 85 gigs of metadata, 
after adding a second device!  Definitely looks like a bug there!  That's 
where keeping current with the list comes in, knowing about that sort of 
current issue report with current code.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

