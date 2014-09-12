Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50150 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaILFlo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 01:41:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSJc6-0003yW-7G
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 07:41:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 07:41:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 07:41:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should "btrfs device delete missing ..."  take?
Date: Fri, 12 Sep 2014 05:41:29 +0000 (UTC)
Message-ID: <pan$a1fc7$e248134c$125bdde4$c4a4b75e@cox.net>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com>
	<pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
	<4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com>
	<pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net>
	<6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 11 Sep 2014 20:10:26 -0600 as excerpted:

> And then when I think about just creating a new fs, using btrfs
> send/receive, the snapshots need to be ro first.

FWIW, at this point I'd forget about send/receive and create the backup 
(assuming one doesn't exist already) using more normal methods.  At least 
if the original send/receive hasn't yet been done, so it'd be copying off 
all the data anyway.  Perhaps mount selected snapshots and back them up 
too (after the current case is backed up), but throw away most of the 
snapshots.

Of course if there's an existing relatively current sent/received base to 
build on, and no indication that send/receive is broken, definitely try 
that first as the amount of data to sync in that case should be MUCH 
lower, but if not...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

