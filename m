Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46822 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaEKDJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 23:09:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WjK8c-0002Gc-Cg
	for linux-btrfs@vger.kernel.org; Sun, 11 May 2014 05:09:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 05:09:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 05:09:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.15-rc5 btrfs send/receive corruption errors? Does scrub
Date: Sun, 11 May 2014 03:09:03 +0000 (UTC)
Message-ID: <pan$ca817$195609f1$cf655dea$2b05cd43@cox.net>
References: <20140510235717.GB15909@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 10 May 2014 16:57:18 -0700 as excerpted:

> So, does scrub actually make sure everything on my filesystem is sane,
> or can it miss some kinds of corruptions?

Catching it here as well as the other thread...

All scrub does is verify the checksum (and replace bad versions with good 
versions where there's a good copy available to do so).

Scrub does NOT detect or fix faulty logic bug writes that never-the-less 
were properly checksummed, as the checksums can be perfectly valid on 
entirely invalid (meta)data.

Using an example from recent US political history, it's as if someone 
recorded the head of the US NSA assuring congress that it did not 
knowingly collect data on US citizens in the generic case, when a few 
months later we found out it was doing just that.  Now if that recording 
was checksummed, that checksum will normally still verify just fine 
today, even tho we know the claims in the recorded stream are 100% 
faulty.  Verifying the checksum can validate the recording hasn't been 
corrupted since it was stored, but it does nothing at all to verify the 
claims made in that recording, and is simply the wrong tool for the job 
if that's what you're trying to do.

Back on btrfs, if we were checksumming metadata and that metadata was 
faulty due to some now fixed bug, verifying the checksum simply verifies 
that the still-faulty metadata hasn't changed from when we stored it, not 
that the metadata isn't faulty in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

