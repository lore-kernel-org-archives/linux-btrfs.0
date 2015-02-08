Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbbBHDbi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Feb 2015 22:31:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKIao-0004Sq-KH
	for linux-btrfs@vger.kernel.org; Sun, 08 Feb 2015 04:31:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 04:31:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 04:31:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1, SSD+non-SSD
Date: Sun, 8 Feb 2015 03:31:22 +0000 (UTC)
Message-ID: <pan$9d070$ec02cf80$defe792b$ff8d4b74@cox.net>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
	<CAJCQCtQn=HQU15D5qfS4ASR7HZM974f1p8xKQQCQRmR-NPXQ+w@mail.gmail.com>
	<mp0iqb-1f5.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sat, 07 Feb 2015 19:06:14 +0100 as excerpted:

> BTW: Is there work in progress to let btrfs choose which device to read
> from or write to other than using round-robin or pid mapping? Maybe it
> would be interesting to watch the current read and write latencies of
> all drives and choose the one with the lowest latency. Tho, I think it
> won't make much sense when passing accesses through btrfs.

There's several projects in that general area suggested on the wiki.  
You'd need to look there for status (unclaimed, claimed, in progress, 
etc) and to see if any of them match well enough to what you had in mind 
or if you might wish to add another.

There's definitely optimization planned, with the project ideas mentioned 
above going beyond that.  However, I'm not sure of the status of the 
actually planned optimization either.  There's certainly the standard 
premature optimization thing to worry about, but arguably, we're past the 
point at which it'd be premature now, and actually need it, if for no 
other reason, because making a case for true btrfs stability is rather 
difficult if such optimization is still being held off as premature, or 
isn't being held off any longer, but that state is so new the 
optimization simply hasn't been done yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

