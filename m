Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48917 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbaDEPGk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Apr 2014 11:06:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WWSB4-0003RC-PK
	for linux-btrfs@vger.kernel.org; Sat, 05 Apr 2014 17:06:38 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 17:06:38 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 17:06:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 5 Apr 2014 15:06:26 +0000 (UTC)
Message-ID: <pan$1013e$ed20a34e$87a63f12$3c7b6f9f@cox.net>
References: <2692878.dRG1K49eOP@fnix> <3745993.asvTJRMXlK@vfr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Garry T. Williams posted on Sat, 05 Apr 2014 10:26:06 -0400 as excerpted:

> I no longer see the slow degradation over time because I made the
> following directories recursively nodatacow:
> 
>     .local/share/akonadi

...snip...

OK, we now have a second link to akonadi (and browsers) and slowness, 
this one confirmed as nocow helping.  Thanks.  It's on my list to watch 
for and point out when I see it in posts, now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

