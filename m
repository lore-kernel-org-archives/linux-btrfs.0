Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab3KOHNO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 02:13:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhDab-0004w6-1B
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 08:13:13 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 08:13:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 08:13:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mixed and raid [was Re: BUG: btrfsRe: Does btrfs "raid1"
 actually provide any resilience?]
Date: Fri, 15 Nov 2013 07:12:50 +0000 (UTC)
Message-ID: <pan$afa55$861f820e$b8e2b567$4f5d324c@cox.net>
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it>
	<528536F7.6030503@libero.it> <52853ED2.8040606@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Thu, 14 Nov 2013 22:21:22 +0100 as
excerpted:

> after some tests and looking at the code I discovered that the current
> mkfs.btrfs doesn't allow any raid profile other than SINGLE for data and
> meta-data when the mixed metadata/data group is enabled.

That'd be a big problem for me, here, as I run a separate sub-GiB (640 
MiB) btrfs filesystem /var/log, in data+metadata raid1 mode.  (The 
mountpoint is actually /lg, with /var/log a symlink pointing at it.)

btrfs f sh /lg

Label: lg0238gcnx+35l0  uuid: c77a9eb8-9841-4c2b-925e-75d0a925dcc3
        Total devices 2 FS bytes used 51.93MiB
        devid    1 size 640.00MiB used 288.00MiB path /dev/sdc4
        devid    2 size 640.00MiB used 288.00MiB path /dev/sda4

btrfs f df /lg

System, RAID1: total=32.00MiB, used=4.00KiB
Data+Metadata, RAID1: total=256.00MiB, used=51.92MiB

I've had a couple bad shutdowns, but btrfs scrub has reliably cleaned up 
the resulting mess on /lg due to open logfiles, and I'd be rather unhappy 
if that weren't possible.

Meanwhile, I also have two separate sub-GiB (256 MiB) /boot filesystems, 
one on each (of two) SSDs, with the grub2 on each pointing at its own 
/boot so a broken grub2 update won't break my ability to boot.

Those are both data+metadata dup mode:

btrfs f df /bt

System, DUP: total=8.00MiB, used=4.00KiB
System, single: total=4.00MiB, used=0.00
Data+Metadata, DUP: total=114.00MiB, used=41.38MiB
Data+Metadata, single: total=8.00MiB, used=0.00

You're saying data+metadata DUP wouldn't be possible here either, which 
would make me pretty unhappy too.

Fortunately I did those mkfs.btrfs on an earlier btrfs-tools so wasn't 
affected by this bug, but bug I would indeed call it, for sure!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

