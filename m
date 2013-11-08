Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37490 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab3KHJjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 04:39:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VeiXT-0002n5-PZ
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 10:39:39 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 10:39:39 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 10:39:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question about btrfs as root filesystem
Date: Fri, 8 Nov 2013 09:39:18 +0000 (UTC)
Message-ID: <pan$660$fa62c2d3$5e9643e4$83687499@cox.net>
References: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Göhler posted on Fri, 08 Nov 2013 00:45:32 +0100 as excerpted:

> The use case for that is to set quotas for the child subvolumes.

Quite apart from the main thread subject, you're aware that there are 
major bugs with btrfs quotas/qgroups ATM, right?  I'd certainly be wary 
of depending on them for anything at the distribution level you're 
discussing.

The known quota bugs appear to be in two areas and may or may not be 
related.  First, people have been complaining about huge and unaccounted 
memory usage on the order of multiple gigabytes while using quotas.  I 
believe one related memory leak has recently been fixed (tho I'm not sure 
the fix is actually in mainline yet, it's that new), but there could well 
be more.

Second, people are reporting negative quota numbers.  Apparently this is 
the result of deleting snapshots or turning off qgroups on some 
subvolumes/snapshots but not others and goes away when the quotas are 
fully rescanned, but that's a time-intensive process on multi-terabyte 
spinning rust partitions.  Again, there's work being done to address the 
issue, but it's nothing I'd want to rely on at this point.

Given the above situation, I'd strongly suggest leaving the quota feature 
off on btrfs at this point, certainly at the distro level.  If 
individuals want to test it that's fine, as long as they know the risk 
(which given that btrfs itself remains officially experimental, is simply 
a known stronger area of the risk that continues to apply to testing 
btrfs as a whole), but I'd argue it's inappropriate for distro level at 
this point.  If quotas are dictated by the use-case, there are other more 
stable filesystem options available with stable quota support.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

