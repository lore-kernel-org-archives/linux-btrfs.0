Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55702 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaBKHr1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 02:47:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WD83x-0006Md-Ku
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 08:47:25 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:47:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:47:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Date: Tue, 11 Feb 2014 07:47:02 +0000 (UTC)
Message-ID: <pan$25a5a$8ccbbd7c$d3d18db5$68fbad14@cox.net>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
	<20140211041527.57ef96c4@system>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Saint Germain posted on Tue, 11 Feb 2014 04:15:27 +0100 as excerpted:

> I understand. Normally the swap will only be used for hibernating. I
> don't expect to use it except perhaps in some extreme case.

If hibernate is your main swap usage, you might consider the noauto fstab 
option as well, then specifically swapon the appropriate one in your 
hibernate script since you may well need logic in there to figure out 
which one to use in any case.  I was doing that for awhile.

(I've run my own suspend/hibernate scripts based on the documentation in 
$KERNDIR/Documentation/power/*, for years.  The kernel's docs dir really 
is a great resource for a lot of sysadmin level stuff as well as the 
expected kernel developer stuff.  I think few are aware of just how much 
real useful admin-level information it actually contains. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

