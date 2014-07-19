Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbaGSKSj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 06:18:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X8Riv-0006A4-6L
	for linux-btrfs@vger.kernel.org; Sat, 19 Jul 2014 12:18:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 12:18:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 12:18:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS kernel errors in 3.15.5
Date: Sat, 19 Jul 2014 10:18:24 +0000 (UTC)
Message-ID: <pan$f1686$a044955$9456213d$15d333ff@cox.net>
References: <1874170.zy97UOFIcr@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Sat, 19 Jul 2014 09:19:13 +0200 as excerpted:

> This happens systematically these days, while trying to backup using
> rsync two of my laptops on an external HD - BTRFS formatted.

While I've not seen it, based on reports here on the list, there's 
apparently a known issue with rsync on btrfs for 3.15 so far.  It seems 
to trigger most often on btrfs' with compression enabled, tho I'm not 
sure if compression is required to trigger it or if it simply happens 
more often with it.

I'm not sure of the status, but Chris Mason mentioned that he was 
investigating and trying to reproduce, so they're definitely actively 
working on it.

People seem to have better luck either reverting to the latest 3.14 
series kernel for the moment, or updating to the latest 3.16-rc or live-
git build, with 3.16 of course getting close to release now.  I'd move 
forward as I know they're always fixing stuff and I routinely test kernel 
rcs anyway, but Marc Merlin (one of the people reporting this bug), at 
least, has moved back to 3.14 instead, as he says that works well for him.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

