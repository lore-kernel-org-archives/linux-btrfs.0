Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38629 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbcECGov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 02:44:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1axU4a-0001SM-Ik
	for linux-btrfs@vger.kernel.org; Tue, 03 May 2016 08:44:44 +0200
Received: from ip5f5ae06c.dynamic.kabel-deutschland.de ([95.90.224.108])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 08:44:44 +0200
Received: from hurikhan77 by ip5f5ae06c.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 08:44:44 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Tue, 3 May 2016 08:44:28 +0200
Message-ID: <20160503084428.2e51a2e1@jupiter.sol.kaishome.de>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
	<20160501185418.5a148cdd@jupiter.sol.kaishome.de>
	<pan$cd18$90efec60$149cab40$cd3d9864@cox.net>
	<e3286f17-fc34-9b48-0256-cbc7dafe576a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 2 May 2016 09:19:13 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2016-05-01 19:49, Duncan wrote:
> > Kai Krakow posted on Sun, 01 May 2016 18:54:18 +0200 as excerpted:
> >  
> >> It affects all file systems. The "btrfs fi sync" is used to finish
> >> my rsync backup and ensure everything is written before I'm trying
> >> to unmount it or the system goes back to sleep.
> >>
> >> "df" and friends also freeze on tmp (ramdisk) fs and vfat fs (my
> >> EFI boot partition).  
> >
> > That's just weird, there.  df on tmpfs triggers a stall as well?
> > Weird to the point I wonder if you're seeing a general block layer
> > bug... only involving btrfs if btrfs is somehow fowling up the
> > block layer for everyone else as well.  Whatever it is, it's
> > obviously far different than my first guess, which now looks
> > ridiculously wrong.  Oh, well...  
> The question is: is it actually on a ramdisk (with a separate
> filesystem on top of that), or is it on tmpfs?  The ramdisk method is
> used by some people because it lets you do some more interesting
> things, but tmpfs is much more efficient (in terms of both processing
> time, and RAM usage). If it's on a ramdisk, then it may be a block
> layer bug, but if it's on tmpfs, then it's a VFS layer bug instead.

Sorry for the confusion: It's actually tmpfs - NOT ramdisk.

> That said, if something i8n BTRFS is causing stalls in the block
> layer, that would definately explain what is going on, as that can
> cause all I/O to stall across the whole system.

It seems to be triggered by access to btrfs for me, tho I don't use
tmpfs that much, so this assumption is more or less bogus.


-- 
Regards,
Kai

Replies to list-only preferred.

