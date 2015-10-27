Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51007 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbbJ0GXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 02:23:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zqxf6-0004fA-BL
	for linux-btrfs@vger.kernel.org; Tue, 27 Oct 2015 07:23:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 07:23:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 07:23:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: random i/o error without error in dmesg
Date: Tue, 27 Oct 2015 06:23:06 +0000 (UTC)
Message-ID: <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Mon, 26 Oct 2015 15:23:39 +0100 as excerpted:

> Occasionally they go away by themselves, but usually I have to reboot to
> make them go away.  This happens when getmail attempts to fetch mail,
> which fails due to the above error.  After the reboot getmail succeeds
> again.

Just out of curiosity, does a remount,ro, followed by a remount,rw, solve 
the problem?

The ro/rw cycle should force anything in memory to device, so if that 
eliminates the problem, it could well be some sort of sync issue.  If it 
doesn't, then it's more likely an in-memory filesystem state issue, 
that's cleared by the reboot.

And if the ro/rw cycle doesn't clear the problem, what about a full 
unmount/mount cycle, at least of that subvolume?

If you're running multiple subvolumes with root being one of them, you 
can't of course unmount the entire filesystem, but you could go down to 
emergency mode (systemctl emergency), try unmounting everything but /, 
mounting / ro, and then switching back to normal mode (from emergency 
mode, simply exiting should return you to normal multi-user or gui 
target, remounting filesystems as necessary, etc).

IOW, does it take a full reboot to clear the problem, or is a simple ro/rw 
mount cycle enough, or an unmount/remount?

Finally, assuming root itself isn't btrfs, if you have btrfs configured 
as a module, you could try unmounting all btrfs and then unloading the 
module, then reloading and remounting.  That should entirely clear all in-
memory btrfs state, so if that doesn't solve the problem, while rebooting 
does, then the problem's very possibly outside of btrfs scope.  Of course 
if root is btrfs, you can't really check that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

