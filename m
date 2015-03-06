Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58678 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbbCFALG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Mar 2015 19:11:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YTfr5-00014x-IO
	for linux-btrfs@vger.kernel.org; Fri, 06 Mar 2015 01:11:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 01:11:03 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 01:11:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Lock-ups, assertion failure  in btrfsck, scrub reporting
 super=4
Date: Fri, 6 Mar 2015 00:10:57 +0000 (UTC)
Message-ID: <pan$387dc$a5a9554$54f0b365$e45c3f38@cox.net>
References: <1425556080.32673.11.camel@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Getzner posted on Thu, 05 Mar 2015 12:48:00 +0100 as excerpted:

> I booted back into the graphical system, and when not running Firefox, I
> did not get any immediate lock-ups anymore.
> 
> I’d welcome any advice on how to proceed, i.e., in how to resolve the
> lock-ups, and, if possible, in fixing potential problems with the
> file-system.

I'll let a dev answer that side of things but a couple comments, for what 
they are worth...

1) The firefox issue is likely related to the sqlite database files it 
uses.  Database random-rewrite-pattern files are always a challenge for 
cow-based filesystems such as btrfs, tho with small ones like those 
firefox typically uses, the btrfs autodefrag mount option can help.  Be 
aware, however, that it can trigger performance issues with larger 
(typically half-gig plus) random-rewrite-pattern files such as VM images 
and large databases, tho.  But if you're not running anything like that 
and don't have autodefrag in your btrfs mount options, I'd suggest trying 
it.  If you /are/ running VMs and the like, it's worth doing a bit more 
research on the topic both on the btrfs wiki, and on the backlist, here.  
There are workaround, but they can get a bit complex...

Meanwhile, the problem file is likely in your firefox profile.  You could 
try starting with a clean firefox profile and see if the problem 
disappears, and if so, bisect the profile to see what file it is and 
delete it or restore it from backup.

2) Just noting, I'm running kernel 3.19 here without issues, but I run 
multiple smaller btrfs (largest is <50 GiB) than some people, and I'm on 
fast SSD, so I don't tend to see the issues that people with TB-sized 
btrfs on spinning rust see.  And I mount with autodefrag...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

