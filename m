Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34307 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaATNVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 08:21:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W5EnY-0003iJ-Ry
	for linux-btrfs@vger.kernel.org; Mon, 20 Jan 2014 14:21:52 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 14:21:52 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 14:21:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrubbing with BTRFS Raid 5
Date: Mon, 20 Jan 2014 13:21:30 +0000 (UTC)
Message-ID: <pan$a0b44$f26ffac9$eee521fc$3b37eb85@cox.net>
References: <BF66C259-5EEA-46DF-A6C6-1A98DCD95F68@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Graham Fleming posted on Sun, 19 Jan 2014 16:53:13 -0800 as excerpted:

> From the wiki, I see that scrubbing is not supported on a RAID 5 volume.
> 
> Can I still run the scrub routing (maybe read-only?) to check for any
> issues. I understand at this point running 3.12 kernel there are no
> routines to fix parity issues with RAID 5 while scrubbing but just want
> to know if I'm either a) not causing any harm by running the scrub on a
> RAID 5 volume and b) it's actually goin to provide me with useful
> feedback (ie file X is damaged).

This isn't a direct answer to your question, but answers a somewhat more 
basic question...

Btrfs raid5/6 isn't ready for use in a live-environment yet, period, only 
for testing where the reliability of the data beyond the test doesn't 
matter.  It works as long as everything works normally, writing out the 
parity blocks as well as the data, but besides scrub not yet being 
implemented, neither is recovery from loss of device, or from out-of-sync-
state power-off.

Since the whole /point/ of raid5/6 is recovery from device-loss, without 
that it's simply a less efficient raid0, which accepts the risk of fully 
data loss if a device is lost in ordered to gain the higher thruput of N-
way data striping.  So in practice at this point, if you're willing to 
accept loss of all data and want the higher thruput, you'd use raid0 or 
perhaps single mode instead, or if not, you'd use raid1 or raid10 mode.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

