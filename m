Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36221 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbaFSPGS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 11:06:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wxdup-0003bR-U3
	for linux-btrfs@vger.kernel.org; Thu, 19 Jun 2014 17:06:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 17:06:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 17:06:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: frustrations with handling of crash reports
Date: Thu, 19 Jun 2014 15:06:00 +0000 (UTC)
Message-ID: <pan$ac73e$751c79cd$27db22ed$aa34b841@cox.net>
References: <20140519134915.GA27432@merlins.org>
	<539FE03F.5030306@jp.fujitsu.com> <20140617145957.GH19071@merlins.org>
	<20140617182745.GO19071@merlins.org> <53A192B8.2040601@gmail.com>
	<pan$d2b51$8d2a30e2$29b90599$a8fc24d9@cox.net> <53A2A5DB.40204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Konstantinos Skarlatos posted on Thu, 19 Jun 2014 11:56:59 +0300 as
excerpted:

> Thats good to hear. But we should have a way to recover from these kinds
> of problems, first of all having btrfs report the exact location, disk
> and file name that is affected, and then make scrub fix or at least
> report about it, and finaly make fsck work for this.
> 
> My filesystem that consistently kernel panics when a specific logical
> address is read, passes scrub without anything bad reported. What's the
> use of scrub if it cant deal with this?

Scrub detects (and potentially fixes) exactly one sort of problem (tho 
that one can definitely cause others), and that's not it.

On btrfs, what scrub does is exactly this:  (a) Scrub calculates the 
checksums for all data and metadata blocks and matches that against the 
recorded checksum, reporting any no-match cases. (b) Where the checksums 
don't match up, if there's another copy of the data that /does/ checksum-
validate, scrub will "scrub" the bad copy, replacing it with a duplicate 
of the good one.

As it happens, on a (non-ssd) single-device filesystem, btrfs defaults to 
single data, dup metadata.  In that case there's a second, hopefully 
valid, copy of the metadata blocks that can be used to correct a bad 
copy.  But there's only a single copy of data blocks so while scrub can 
detect data-block errors, it won't be able to fix them.

On a multi-device filesystem, btrfs defaults to raid1 metadata (with only 
two copies regardless of the number of devices present, N-way-mirroring 
is roadmapped but not yet implemented), single data, so again, hopefully 
the second copy of a bad metadata block is valid and can be used to scrub 
the bad one, but just as with the single-device case, it can detect but 
not fix data checksum errors.

Tho of course in the multi-device case it's possible to set data to raid1 
as well, and that's what I've done here so it too can be error-corrected 
from a hopefully good second copy.  (Raid10 is similarly protected.  
Raid5/6 should work a bit differently, with parity, but last I knew raid56 
scrub and recovery wasn't fully implemented yet, leaving raid1 and raid10, 
along with dup mode for single-device metadata only, as the error-
correcting choices.)

But if the problem is a btrfs logic error, such that the (meta)data that 
was actually checksummed and written out was bad before it was ever 
checksummed in the first place, then scrub won't do a thing for it, 
because the checksum validates just fine, it's just that it's a perfectly 
valid checksum on perfectly invalid (meta)data.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

