Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54160 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaL2CIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 21:08:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y5Pl2-0007Pj-LG
	for linux-btrfs@vger.kernel.org; Mon, 29 Dec 2014 03:08:32 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 03:08:32 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 03:08:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fstrim not working on one of three BTRFS filesystems
Date: Mon, 29 Dec 2014 02:08:21 +0000 (UTC)
Message-ID: <pan$e8b97$69faf00b$ca66e14d$c2effd06@cox.net>
References: <3979684.puYLD8DjTq@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 28 Dec 2014 17:58:17 +0100 as excerpted:

> The fstrim on /home returns immediately. It does not even seem to trim
> anything. What could be the cause for that?

While I don't know your mapper layout, trim working on the others but not 
on /home sounds to me like either one of the physical devices on which 
/home is located doesn't support trim, or they all do, but somewhere 
along the line that information is being lost, so it doesn't believe trim 
can actually work on that filesystem.  Typical shortcut "the information 
available says that can't work, simply return before trying" behavior.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

