Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36459 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaKTOKb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 09:10:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XrSRK-0000cs-Ea
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 15:10:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 15:10:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 15:10:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send and an existing backup
Date: Thu, 20 Nov 2014 14:10:13 +0000 (UTC)
Message-ID: <pan$483ea$3a099fee$7e09d57b$ed49879a@cox.net>
References: <o9rujb-sud.ln1@venus.xundeenergie.ssh22.net>
	<m4kpm0$r52$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bardur Arantsson posted on Thu, 20 Nov 2014 14:17:52 +0100 as excerpted:

> If you have no other backups, I would really recommend that you *don't*
> use btrfs for your backup, or at least have a *third* backup which isn't
> on btrfs -- there are *still* problems with btrfs that can potentially
> wreck your backup filesystem. (Although it's obviously less likely if
> the external HDD will only be connected occasionally.)
> 
> Don't get me wrong, btrfs is becoming more and more stable, but I
> wouldn't trust it with my *only* backup, especially if also running
> btrfs on the backed-up filesystem.

This.

My working versions and first backups are btrfs.  My secondary backups 
are reiserfs (my old filesystem of choice, which has been very reliable 
for me), just in case both the btrfs versions bite the dust due to a bug 
in btrfs itself.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

