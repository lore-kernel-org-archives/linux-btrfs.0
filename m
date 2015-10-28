Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41268 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965455AbbJ1Mql (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 08:46:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZrQ7h-0003IQ-1Z
	for linux-btrfs@vger.kernel.org; Wed, 28 Oct 2015 13:46:37 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:46:37 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 13:46:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: random i/o error without error in dmesg
Date: Wed, 28 Oct 2015 12:46:22 +0000 (UTC)
Message-ID: <pan$e5b89$1910fd58$67d33955$834f4f12@cox.net>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
	<pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
	<56308ADC.5060207@dblaci.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Szalma László posted on Wed, 28 Oct 2015 09:44:12 +0100 as excerpted:

> The umount/mount ALWAYS solved the problem for me, mount -o remount,ro
> was tried for the first time, but it was not enought. Reboot was not
> needed.
> (kernel 4.2.4)

So that means it's filesystem state that's tracked thru a remount, not 
something like deleted/orphan files that a remount should square away.  
But a full unmount clears the state, without having to unload the btrfs 
kernel module or reboot.

Which at least limits the active zone of the problem.  Unfortunately, I'm 
not a dev and don't have a clue where to go from there... unless it's 
related to the recent delayed-refs bug, in which case I believe a late 
4.3 rc, or 4.3.0 when released, should fix it.  That fix should be CCed 
to stable and thus appear there eventually, but I normally track pre-
releases, not stable, so don't know how long it might be...  And again, I 
don't know it's even related, but it does appear to be the active bug of 
the moment, so in the absence of knowing, one can hope.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

