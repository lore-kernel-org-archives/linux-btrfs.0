Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46336 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3FADGf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 23:06:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Uic9J-0001xd-QP
	for linux-btrfs@vger.kernel.org; Sat, 01 Jun 2013 05:06:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jun 2013 05:06:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jun 2013 05:06:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: degraded two-device btrfs raid1 (data/metadata) questions
Date: Sat, 1 Jun 2013 03:06:18 +0000 (UTC)
Message-ID: <pan$6834d$51a8a8e4$efe59dda$f34fd40d@cox.net>
References: <pan$8e5ed$b63791f$8b3cc2f5$8c662141@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Fri, 31 May 2013 14:24:25 +0000 as excerpted:

> Now, I'm setting up a minimal initramfs just to user-space mount the
> btrfs root properly so I don't have to mount it degraded.
> 
> But I'm still left wondering how I'm supposed to tell whether it's
> actually running degraded or not, and how to sync everything back up if
> so.

FWIW, I'm up on the initramfs for the dual-device btrfs raid1 root, now.  
It seems to work reasonably, altho I still have some fine tuning to do on 
the initramfs (include gdisk/cgdisk, and I still want to see about 
rolling my own instead of using dracut) once I have my other partitions 
over on btrfs on the ssds.

Of course that means figuring out how to check for degraded raid1 btrfs 
and how to "undegrade" it if necessary, is no longer simply theoretical, 
altho I intend to be keep the reiserfs "spinning rust" backups current 
for quite some time, given btrfs' development status.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

