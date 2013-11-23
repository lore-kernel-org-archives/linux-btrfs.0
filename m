Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54244 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab3KWKfb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 05:35:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VkAYj-0005Zz-Gm
	for linux-btrfs@vger.kernel.org; Sat, 23 Nov 2013 11:35:29 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 11:35:29 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 11:35:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Nagios probe for btrfs RAID status?
Date: Sat, 23 Nov 2013 10:35:08 +0000 (UTC)
Message-ID: <pan$13621$9e5c77ca$1502a49b$4b791baa@cox.net>
References: <528F6085.4020603@pocock.com.au> <52902808.8020706@oracle.com>
	<5290695E.80506@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Pocock posted on Sat, 23 Nov 2013 09:37:50 +0100 as excerpted:

> What about when btrfs detects a bad block checksum and recovers data
> from the equivalent block on another disk?  The wiki says there will be
> a syslog event.  Does btrfs keep any stats on the number of blocks that
> it considers unreliable and can this be queried from user space?

The way you phrased that question is strange to me (considers unreliable?
does that mean ones that it had to fix, or ones that it had to fix more 
than once, or...), so I'm not sure this answers it, but from the btrfs 
manpage...

>>>>

btrfs device stats [-z] {<path>|<device>}

Read and print the device IO stats for all devices of the filesystem 
identified by <path> or for a single <device>.

Options

-z   Reset stats to zero after reading them.

<<<<

Here's the output for my (dual device btrfs raid1) rootfs, here:

btrfs dev stat /
[/dev/sdc5].write_io_errs   0
[/dev/sdc5].read_io_errs    0
[/dev/sdc5].flush_io_errs   0
[/dev/sdc5].corruption_errs 0
[/dev/sdc5].generation_errs 0
[/dev/sda5].write_io_errs   0
[/dev/sda5].read_io_errs    0
[/dev/sda5].flush_io_errs   0
[/dev/sda5].corruption_errs 0
[/dev/sda5].generation_errs 0

As you can see, for multi-device filesystems it gives the stats per 
component device.  Any errors accumulate until a reset using -z, so you 
can easily see if the numbers are increasing over time and by how much.



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

