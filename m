Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45956 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361AbaFZLa4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 07:30:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X07tD-0005CG-IJ
	for linux-btrfs@vger.kernel.org; Thu, 26 Jun 2014 13:30:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 13:30:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 13:30:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: cancel btrfs delete job
Date: Thu, 26 Jun 2014 11:30:26 +0000 (UTC)
Message-ID: <pan$29732$53f31aa9$65c1c12$13bb56c9@cox.net>
References: <1403596252.4221.9.camel@hsew-frn.HIPERSCAN>
	<1403780795.7657.7.camel@hsew-frn.HIPERSCAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Franziska Näpelt posted on Thu, 26 Jun 2014 13:06:35 +0200 as excerpted:

> There are a lot of following messages:
> btrfs free space inode generation (0) did not match free space cache
> generation

Well, set of messages at least is somewhat expected after a hard 
shutdown, and shouldn't be a problem as the filesystem should rebuild the 
cache.  In fact, that space_cache rebuild might be why you were seeing 
such high I/O after the reboot and fresh mount.

If the space-cache rebuild is all the problems you see, you may be lucky, 
and the hard-terminated delete and reboot might not have resulted in any 
permanent damage.  OTOH, if it seems the space_cache rebuild is 
interfering with further activity for too long and you end up doing 
another hard reset anyway, there's the nospace_cache mount option to turn 
it off.

(Just a user and list regular with that single comment... I'll let you 
get back to the expert help now.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

