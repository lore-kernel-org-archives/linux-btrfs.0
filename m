Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54012 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbcGXCg5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 22:36:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bR9Hg-0002gb-My
	for linux-btrfs@vger.kernel.org; Sun, 24 Jul 2016 04:36:54 +0200
Received: from 64.134.221.72 ([64.134.221.72])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jul 2016 04:36:52 +0200
Received: from 1i5t5.duncan by 64.134.221.72 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jul 2016 04:36:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Force recalculation of a data block checksum
Date: Sun, 24 Jul 2016 02:36:46 +0000 (UTC)
Message-ID: <pan$b8dd2$3f01d229$9a93b58$84a3b39a@cox.net>
References: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Melcer posted on Sun, 24 Jul 2016 04:03:08 +0200 as excerpted:

> How can I ask btrfs to recompute the checksum of a data block as it is
> stored on the drive? I don't see any command doing an operation like
> that, and I couldn't find anything on the topic on the internet.

There's no "easy" btrfs method to recompute the checksum of an individual 
block (you'd have to do some deep debugging and hex editing to manually 
rewrite the correct sum), but there /is/ one that reinitiates and 
recalculates checksums for the entire filesystem.

You don't mention what version of btrfs-progs you have, but you'll want a 
reasonably new one, as AFAIK the command is fairly new, and early 
versions of the command simply wiped the existing checksums without 
recalculating them.

btrfs check --init-csum-tree

... as found in the btrfs-check manpage.


Another alternative is using btrfs restore, again, see the btrfs-restore 
manpage.  Normally this command is used to get what you can off of a 
filesystem damaged badly enough it won't mount, but you can also use it 
to scrape specific files off an unmounted filesystem, if the checksum's 
bad, for instance.  In this case, you'd use the --path-regex option to 
restore only files matching that regex.  Of course, for a TB-sized file, 
you'll need a separate filesystem (need not be btrfs, but will need to be 
a filesystem that can handle a file that size) with at least a TB free to 
write it to.

I'd normally prefer the btrfs restore method, myself, particularly if the 
btrfs in question has other files that you don't want to risk in the 
process.  If that was the only file on the filesystem, I'd still try the 
restore method first, at least if I had some place to write it to, 
because btrfs restore is read-only against the btrfs you're restoring 
from, and thus has no chance of causing further damage, while of course 
btrfs check --init-csum-tree writes to the filesystem in question and 
thus is a higher risk.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

