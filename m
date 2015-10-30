Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54084 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbbJ3JlT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 05:41:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zs6BQ-00043H-Eq
	for linux-btrfs@vger.kernel.org; Fri, 30 Oct 2015 10:41:16 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 10:41:16 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 10:41:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: corrupted RAID1: unsuccessful recovery / help needed
Date: Fri, 30 Oct 2015 09:40:59 +0000 (UTC)
Message-ID: <pan$63109$22d497c4$de11d2b0$989e7123@cox.net>
References: <562DC606.3070602@lukas-pirl.de>
	<pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
	<5632930D.4040000@lukas-pirl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Pirl posted on Fri, 30 Oct 2015 10:43:41 +1300 as excerpted:

> Is e.g. "balance" also influenced by the userspace tools or does
> the kernel the actual work?

btrfs balance is done "online", that is, on the (writable-)mounted 
filesystem, and the kernel does the real work.  It's the tools that work 
on the unmounted filesystem, btrfs check, btrfs restore, btrfs rescue, 
etc, where the userspace code does the real work, and thus where being 
current and having all the latests userspace fixes is vital.

If you can't mount writable, you can't balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

