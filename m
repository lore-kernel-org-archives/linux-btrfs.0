Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51829 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaCXSvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 14:51:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WS9xy-0005bq-T2
	for linux-btrfs@vger.kernel.org; Mon, 24 Mar 2014 19:51:22 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 19:51:22 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 19:51:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Improve btrfs man page
Date: Mon, 24 Mar 2014 18:50:50 +0000 (UTC)
Message-ID: <pan$83baa$4fa193c7$def231f6$e0d4bf9e@cox.net>
References: <1395607101.4607.0.camel@spike.sunnydale.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Per Nystrom posted on Sun, 23 Mar 2014 13:38:21 -0700 as excerpted:

> I am going through the process of replacing a bad drive in a RAID 1
> mirror.  The filesystem wouldn't mount because of the missing device,
> and the btrfs man pages were not helpful in resolving it.  Specifically,
> it would have been very useful to me if this part of the wiki were
> included somewhere:
> 
> https://btrfs.wiki.kernel.org/index.php/
Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices
> 
> There is no mention in the man pages of the -o degraded mount option,
> which is needed to even manipulate the filesystem; nor is there any
> mention of the special option "missing" for device delete.
> 
> I'm sure I'm not the only one who would turn to man btrfs first when
> facing a failed drive.

Of course traditionally, mount options are covered in the mount manpage.  
But btrfs is new enough I guess it's not in that manpage yet, which has 
frustrated me too, since that's intuitively where I look.

The mount-manpage alternatives are either the wiki, or the
Documentation/filesystems/btrfs.txt file in the kernel sources.

But you're absolutely correct about btrfs device delete missing.  Btrfs 
device delete is of course in the btrfs manpage, but the one-sentence 
description lacks any hint that "missing" can be used if the device 
simply isn't there any longer.  Fleshing that out a bit beyond the single 
sentence would definitely be useful!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

