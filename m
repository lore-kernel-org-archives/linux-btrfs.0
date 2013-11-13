Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53563 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab3KMPEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 10:04:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vgbz4-00027T-UZ
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 16:03:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 16:03:58 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 16:03:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: invalid opcode: 0000 [#1] SMP
Date: Wed, 13 Nov 2013 15:03:37 +0000 (UTC)
Message-ID: <pan$d06e7$206fd374$423b51c3$17212f9e@cox.net>
References: <1384242552.7516.9.camel@hsew-frn.HIPERSCAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Franziska Näpelt posted on Tue, 12 Nov 2013 08:49:12 +0100 as excerpted:

> we are using a btrfs RAID 1 with four 2TB hard drives (WD Caviar green)
> on a Debian 7.2 with Kernel 3.11.6
> 
> Now we had an 'invalid opcode: 0000 [#1] SMP' when a sector fails in
> messages log.
> After that, access over smb and nfs wasn't possible.
> A restart solved the problem of inaccesibility.


A couple notes from a fellow btrfs-using sysadmin...

1) invalid opcode 0000:

As I understand it, this is relatively generic and doesn't define the 
error by itself.  The 0000 opcode can be viewed as a zero-dereference of 
sorts, it's indication of a bug happening earlier, such that an expected 
valid opcode ends up being zero.  The error itself will be earlier -- 
this is just where it ends up being trapped.

As to what that error is in this case...

2) btrfs raid1:

Unlike, for example, md/raid1, btrfs raid1 is not at this point run-time 
tolerant of device failure.  At this point, a btrfs raid1 device failure 
seems to make the entire system basically unusable and require a reboot, 
after which device/data recovery (for example, mount degraded, add a 
replacement device, rebalance, and delete the failed one, or if it was a 
temporary dropout, simply btrfs scrub to find and fix the checksum 
mismatches from the valid copy) can be initiated, if necessary.

When the sector failed, it apparently triggered the kernel btrfs to drop 
the entire device from active, which as I said, isn't well runtime 
supported at present, thus causing various btrfs worker threads to go 
unresponsive requiring a reboot to get back a normally functioning system.

As the device failure was actually just that single sector failure, on 
reboot the device was once again available, and functionality was 
restored.

However, if you haven't already done so, I'd strongly recommend doing a 
btrfs scrub on the affected filesystem, thus allowing btrfs to find the 
bad data copy due to the checksum mismatch and to recover from the good 
one it should have, due to the raid1 redundancy, rewriting a new, valid 
second copy once again, thereby restoring data redundancy as protection 
against the now single valid copy getting corrupted as well.


Meanwhile, if you require runtime stability and failover, I'd suggest md/
raid1 or similar more mature and stable option designed to provide that.  
btrfs will hopefully do so at some point, but as the kernel btrfs option 
mentions, btrfs is still experimental and features are still being added 
and improved, and runtime failover is one such feature btrfs doesn't well 
support just yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

