Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47424 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaHXM6R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 08:58:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XLXN6-0006OM-3c
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 14:58:12 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 14:58:12 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 14:58:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
Date: Sun, 24 Aug 2014 12:57:58 +0000 (UTC)
Message-ID: <pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net>
References: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oon-Ee Ng posted on Sun, 24 Aug 2014 17:55:32 +0800 as excerpted:

> I'm using 64-bit Arch Linux. Since update to kernel versions 3.16 and
> 3.16.1 I'm getting a constant 6+ MiB/s write on my root. Root does not
> seem to fill up though. Has run for 2 hours straight, and obviously
> slows everything else down to a crawl.
> 
> Downgrading to 3.15.8 (last working version for me) solves the symptoms.
> I'm unsure how to check for root causes, and my distro's mailing list
> suggested starting here.

I've seen that a couple of times here, but it always goes away when I 
reboot (and / is ro by default here, so it'd be on one of the other btrfs 
partitions, probably /home or /var/log).

Meanwhile, if you use the compress mount option, you might wish to return 
to 3.14.x temporarily.  There's a bug that can trigger lockups on 3.15+, 
altho a fix should make it to a later 3.16 stable and to 3.17.  The bug 
was a regression for 3.15 so doesn't affect 3.14, and is only a problem 
if you're using (AFAIK or have used) compression.  It's also not as big 
an issue here (on fast ssds with smaller than usual partitions) as it is 
on some people's systems, tho I'm not sure why and I think it has it me a 
time or two, but I've not bothered downgrading as it hasn't been that big 
an issue, here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

