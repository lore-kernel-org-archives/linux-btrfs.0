Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34705 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaFABwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 21:52:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wquwe-0007UQ-Rk
	for linux-btrfs@vger.kernel.org; Sun, 01 Jun 2014 03:52:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 03:52:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 03:52:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What to do about snapshot-aware defrag
Date: Sun, 1 Jun 2014 01:52:08 +0000 (UTC)
Message-ID: <pan$86a1$bc0de339$ebe33469$156d19e6@cox.net>
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org>
	<538A6B15.3080609@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Sun, 01 Jun 2014 01:51:49 +0200 as excerpted:

>> Will option one mean that we always need to mount with noatime or
>> read-only to allow snapshot defragging to do anything?
> 
> That is a very good question. I very rarely have mounts without noatime
> - and usually only because I hadn't thought of it.

Heh, a couple months ago I got tired of having to add noatime to all my 
standard mounts, and decided to patch my kernel to noatime (instead of 
relatime) by default.  I can if I need to still use relatime or 
strictatime, but if they aren't listed, noatime gets added by default, 
now. =:^)

The only remaining problem is that it's not a full default, as noatime 
still shows up in /proc/self/mounts, but avoiding that would have 
complexified the patch, and not being an actual coder (and DEFINITELY not 
a kernel coder), I decided I best leave well enough alone, patching only 
what I had to to avoid having relatime if I omitted the parameter, and 
only what I was reasonably sure I could do without screwing things up, 
based on my limited sysadmin level reading of the sources.

It would sure be nice if there were a kernel config option for that 
default, which would naturally still default to relatime, which is I'm 
sure where most of the distros not already patching it to noatime would 
leave it, as well.

Meanwhile, agreed, a good question that does indeed remain! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

