Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaAELRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 06:17:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vzlhh-0003Ar-6S
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 12:17:13 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 12:17:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 12:17:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sun, 5 Jan 2014 11:16:45 +0000 (UTC)
Message-ID: <pan$c5d0$eef130d$a5ee78f5$e77e7cd9@cox.net>
References: <52C73987.7000106@jrs-s.net> <1422900.iO9oO96QZb@quad>
	<1388847436.23513.26.camel@ret.masoncoding.com> <2354723.OENPHvUuC6@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Samuel posted on Sun, 05 Jan 2014 20:20:26 +1100 as excerpted:

> On Sat, 4 Jan 2014 02:56:39 PM Chris Mason wrote:
> 
>> Seconded +ADs-)  We're really focused on nailing down these problems
>> instead of hiding behind the experimental flag.  I know we won't be
>> perfect overnight, but it's time to focus on production workloads.
> 
> Perhaps an option here is to remove the need to specify the degraded
> flag but if the filesystem notice that it is mounting a RAID array and
> would otherwise fail it then sets the degraded flag itself and carries
> on?
> 
> That way the fact it was degraded would be visible in /proc/mounts and
> could be detected with health check scripts like NRPE for icinga/nagios.
> 
> Looking at the code this would be in read_one_dev() in
> fs/btrfs/volumes.c ?

The idea I came up elsewhere was to mount read-only, with a dmesg to the 
effect that the filesystem was configured for a raid-level that the 
current number of devices couldn't support, so mount rw,degraded to 
accept that temporarily and to make changes, either by adding a new 
device to fill out the required number for the configured raid level, or 
by reducing the configured raid level to match reality.

The read-only mount would be better than not mounting at all, while 
preserving the "first, do no further harm" ideal, since mounted read-
only, the existing situation should at least remain stable.  It would 
also alert the admin to problems, with a reasonable log message saying 
how to fix them, while letting the admin at least access the filesystem 
in read-only mode, thereby giving him tools access to manage whatever 
maintenance tasks are necessary, should it be the rootfs.  The admin 
could then take the action they deemed appropriate, whether that was 
getting the data backed up, or mounting degraded,rw in ordered to either 
add a device and bring it back to functional or to rebalance to a lower 
data/metadata redundancy level due to lack of devices.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

