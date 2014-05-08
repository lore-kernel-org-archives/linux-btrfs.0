Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52176 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbaEHPH4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 May 2014 11:07:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WiPvN-0006Ky-Ta
	for linux-btrfs@vger.kernel.org; Thu, 08 May 2014 17:07:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 May 2014 17:07:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 May 2014 17:07:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balance performance problem with 3.14.1
Date: Thu, 8 May 2014 15:07:40 +0000 (UTC)
Message-ID: <pan$bfb68$5387197d$eb4cee58$e8e950f0@cox.net>
References: <201405081950.23922.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Thu, 08 May 2014 19:50:23 +1000 as excerpted:

> I've got a server/workstation (KDE desktop and file server) running
> kernel 3.14.1 from the Debian package 3.14-trunk-amd64.
> 
> It was running well until I decided to do a full balance of the BTRFS
> RAID-1 array of 3TB SATA disks (which hadn't been balanced before due to
> previous kernels performing badly with scrub or balance).  I canceled
> the balance after about 5 days when it had been claiming to be about 65%
> done for a day while doing a lot of disk IO.
> 
> After canceling the balance the performance of the array has been poor.

Not much help, but two comments:

1) I've seen other reports of performance problems after balance.  Nobody 
seems to have a good reason as to why a balance might do that.

2) I've NOT seen anything like that, here.  However, my btrfs are all 
rather small, under 50 GiB.

(FWIW, it /still/ seems weird to me calling a GB "small".  It doesn't 
seem all /that/ long ago that I bought my first 1 GB drive, and it sure 
wasn't small nor inexpensive then!  I guess I've officially joined the 
computer old-timers!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

