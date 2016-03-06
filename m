Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51160 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbcCFGxA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Mar 2016 01:53:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1acSYi-0000sv-4T
	for linux-btrfs@vger.kernel.org; Sun, 06 Mar 2016 07:52:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 07:52:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 07:52:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: List missing files on a degraded read-only btrfs mount
Date: Sun, 6 Mar 2016 06:52:49 +0000 (UTC)
Message-ID: <pan$a8a36$df557ab$65c7500c$8abb0a5b@cox.net>
References: <CAJ5gi5+xZgHd7Bgpo1RzF=e1okyseibadvAUDDjCqiX2QsWbsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Justin Madru posted on Sat, 05 Mar 2016 12:32:31 -0800 as excerpted:

> I have a btrfs filesystem spanning 3 drives. The metadata is using raid1
> (mirroring), but the data is using single, so no mirroring or parity
> just spanning. For example:
> 
>     mkfs.btrfs -m raid1 -d single /dev/sda /dev/sdb /dev/sdc
> 
> One of the drives, /dev/sdb, had a hardware failure before I could
> replace it. I'm able to mount the filesystem in read-only using:
> 
>     mount -o degraded,ro /dev/sda /mnt/data
> 
> But how do I list the files that were on the failed drive?

I don't believe there's a simple, admin-level command, to list only the 
files that happened to be on a particular drive.

What you /can/ do is just do a global copy to somewhere else, and 
unaffected files will copy, while affected ones will fail.

The other alternative is to use btrfs restore on the unmounted 
filesystem, restoring the files that are possible to some other 
location.  Note that by default, the restored files will be written as 
root, using umask, with symlinks skipped, but on reasonably recent btrfs-
progs, restore has options that allow you to restore metadata such as 
ownership/perms/times, and symlinks, if you wish.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

