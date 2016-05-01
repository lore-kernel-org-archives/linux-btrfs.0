Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41925 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbcEAXty (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 19:49:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ax17X-0004vC-Th
	for linux-btrfs@vger.kernel.org; Mon, 02 May 2016 01:49:51 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 01:49:51 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 01:49:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Sun, 1 May 2016 23:49:44 +0000 (UTC)
Message-ID: <pan$cd18$90efec60$149cab40$cd3d9864@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
	<20160501185418.5a148cdd@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 01 May 2016 18:54:18 +0200 as excerpted:

> It affects all file systems. The "btrfs fi sync" is used to finish my
> rsync backup and ensure everything is written before I'm trying to
> unmount it or the system goes back to sleep.
> 
> "df" and friends also freeze on tmp (ramdisk) fs and vfat fs (my EFI
> boot partition).

That's just weird, there.  df on tmpfs triggers a stall as well?  Weird 
to the point I wonder if you're seeing a general block layer bug... only 
involving btrfs if btrfs is somehow fowling up the block layer for 
everyone else as well.  Whatever it is, it's obviously far different than 
my first guess, which now looks ridiculously wrong.  Oh, well...

But given that I've seen no other reports of it, I'd consider the things 
that are unique to your kernel config compared to others running btrfs.  
The first thing off the top of my head, bcache.  Do you happen to follow 
the bcache list (presuming it has one) as well?  Given this new 
information and the contrast with others running btrfs, I'd wonder if 
they've had similar reported.

If I understand correctly, with bcache, you can't entirely turn it off or 
bypass it as the filesystems are installed on top of it.  Have you tried 
tinkering with its writeback settings?  Alternatively, if you have the 
space/time to test, try creating a new btrfs with the same options, etc, 
but without the bcache layer, and see if it gives you similar behavior in 
terms of even df of a tmpfs hanging like that, of course without the 
positive effects of bcache as well, tho.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

