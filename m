Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41302 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbaA0NLU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:11:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W7lyB-0001gD-1q
	for linux-btrfs@vger.kernel.org; Mon, 27 Jan 2014 14:11:19 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 14:11:19 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 14:11:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Monitoring for disk failures
Date: Mon, 27 Jan 2014 13:10:53 +0000 (UTC)
Message-ID: <pan$2540$a024a2e$1649dd5d$60e61fd@cox.net>
References: <52E64665.5020109@elastichosts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alin Dobre posted on Mon, 27 Jan 2014 11:43:33 +0000 as excerpted:

> I am trying to create a very simple script that would alert in case of
> disk failures from a RAID Btrfs.
> 
> Digging into the code, I have noticed that the "btrfs fi sh" command
> should display a warning if there is a missing disk. However, testing in
> a Qemu, I used "drive_del" via QMP to remove a "live" SCSI drive,
> already mounted as part of a RAID10 array, the "fi sh" command still
> gave no indication that the drive is missing. Then, I tried removing a
> scsi disk from the host via "echo 1 >/sys/block/sdX/device/delete" to
> actually make the kernel SCSI host forget about it, and "fi sh" still
> doesn't show anything.
> 
> I have tested using btrfs-progs v3.12 and kernel 3.13.0.

Without actually trying it here... I believe by default that'd update 
only when there was an I/O error.

Did you try btrfs filesystem show --all-devices?  That scans differently.

If that doesn't work try btrfs device scan first as that updates the in-
kernel list, then filesystem show.  Alternatively, monitor the kernel log 
for output as the scanned devices show up there.

And if /that/ doesn't work, try show, followed by a probe of all the 
devices listed by show.  But I strongly suspect a device scan will force 
the update you're looking for.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

