Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38833 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaGJVbW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 17:31:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X5Lw1-0002Bz-Hl
	for linux-btrfs@vger.kernel.org; Thu, 10 Jul 2014 23:31:21 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 23:31:21 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 23:31:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop
	snapshot
Date: Thu, 10 Jul 2014 21:31:07 +0000 (UTC)
Message-ID: <pan$ca5c$23031d50$378e40$86a123f0@cox.net>
References: <20140709224150.GA5484@wotan.suse.de>
	<20140710004330.GG4453@dastard> <20140710173614.GB5484@wotan.suse.de>
	<20140710183228.GD17201@lenny.home.zabbo.net>
	<20140710190055.GC5484@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mark Fasheh posted on Thu, 10 Jul 2014 12:00:55 -0700 as excerpted:

> Given something like that, you'd just replace the calls to sleep with
> 'btrfs fi synctheworldandwait' and know that on return, the actions you
> just queued up completed.

I'll admit to not really knowing what I'm talking about here, but on 
first intuition, What about either btrfs filesystem sync calls, or 
mounting with the synctime (don't have time to look up the specific 
option ATM) mount option?  Normal sync is 30 seconds, but the mount 
option can be used to make that 5 seconds or whatever.  And I don't know 
whether btrfs filesystem sync is synchronous or not.

But that might help reduce it below 30 and 45 seconds, anyway, even if 
some sleep is still required.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

