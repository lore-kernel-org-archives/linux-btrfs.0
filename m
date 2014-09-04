Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbaIDWGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 18:06:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPfAY-0006eA-HF
	for linux-btrfs@vger.kernel.org; Fri, 05 Sep 2014 00:06:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 00:06:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 00:06:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
Date: Thu, 4 Sep 2014 22:06:04 +0000 (UTC)
Message-ID: <pan$68621$5f405fb4$84800416$5de9f6db@cox.net>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

john terragon posted on Thu, 04 Sep 2014 07:30:37 +0200 as excerpted:

> dm-0 is the first dmcrypt device of a pair on which I have
> btrfs in RAID0 (btrfs native raid).
> 
> I assume that a scrub would not do any good since it seems to be
> related to btrfs data structures more than actual file data[.]

On btrfs raid0 scrub can't fix anything anyway, tho it might give you a 
bit more information about problems it finds.

The only thing scrub does is verify block checksums and if there's a 
second copy (as there is in single-device dup mode for metadata, and 
multi-device raid1 and raid10 modes, raid5/6 scrub is still broken), 
verify its checksum and assuming it verifies, rewrite the bad copy with 
the new copy.  The same thing happens in normal operation if btrfs 
happens to come across the problem, but scrub gives you a way to 
systematically check the entire filesystem.

If there's no valid second copy, either because the block was in a single-
copy chunk (btrfs raid0 or single mode) or because the second copy is bad 
or the device it was on is missing (raid1/10 with a missing device), 
there's obviously no good copy to overwrite the bad one with, so the 
problem cannot be fixed.  However, if it's in a data chunk, scrub should 
log the file it was part of.  For metadata you simply get a number, and 
have to use btrfs debugging tools to figure out what's affected.

Since you said you're using btrfs raid0 mode, there's no second copy, so 
scrub might find bad checksums and give you a bit of additional 
information about what's affected, but it can never fix them, because 
there's no second copy to fix them from.  Scrub for btrfs raid0 (or 
single, and scrub for raid56 modes remains broken) mode is thus purely 
diagnostics, no possibility of fix, at least from scrub.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

