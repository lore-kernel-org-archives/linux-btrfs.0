Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43968 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGBIEX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 04:04:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X2FWe-0003NA-Ds
	for linux-btrfs@vger.kernel.org; Wed, 02 Jul 2014 10:04:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 10:04:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 10:04:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question about fallocate
Date: Wed, 2 Jul 2014 08:04:08 +0000 (UTC)
Message-ID: <pan$60dc4$de126478$afa9e0e8$68269820@cox.net>
References: <53B28A82.2000907@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gionatan Danti posted on Tue, 01 Jul 2014 12:16:34 +0200 as excerpted:

> So, my question is: why writing to a fallocated file produce
> fragmentation, even with CoW disabled?

Good question.

But how did you disable COW?  The nodatacow mount option?  Setting the 
NOCOW attribute on the file or parent-dir (chattr +C)?  Something else?

Because there are caveats to both the mount option and the file attribute 
methods.

For the nodatacow mount option, the caveat is that to the best of my 
knowledge, that option is one of several btrfs-specific options that's 
still whole-filesystem-based.  So if you are mounting multiple subvolumes 
from the same filesystem, nodatacow will toggle together for all of them 
-- you can't use it for just one.

The possible explanation there is thus that if multiple subvolumes are 
mounted and not all of them have the same nodatacow option applied, you 
might not have nodatacow set on that subvolume after all.

For the nocow file attribute case, there's two possibilities.  First, 
it's critical how the file attribute was set.  If it was set on a file 
with existing data, nocow behavior isn't guaranteed.  The nocow attribute 
must be set on the file while it is zero-sized, before it has any data in 
it.  The easiest way to do that is to set the attribute on the directory, 
such that newly created files (and subdirs) in it inherit the attribute.  
Nocow doesn't affect the directory itself and thus only determines 
inheritance.

Second, there's the snapshotting exception.  Because a btrfs snapshot 
locks the existing file data in place with the snapshot, the first 
modification to a fileblock after a snapshot will force a COW for that 
block, even on an otherwise nocow file.  The nocow attribute remains in 
effect, however, and further writes to the same block will modify it in-
place... until the next snapshot of course.  This becomes a real issue 
for people running automated snapshotting scripts, particularly if 
they've set it to something extreme like once a minute, since in that 
case the existing file content is locked in place once a minute, meaning 
the nocow attribute is effectively worthless for them.  The 
recommendation in that case is to put the nocow files in a dedicated 
subvolume, since snapshots stop at subvolume boundaries, and to use 
conventional backup instead of snapshotting for that subvolume.

So the possible explanations for the file attribute case is either that 
the file attribute wasn't applied correctly (the file already had content 
when the attribute was set), or that a snapshot intervened between file 
creation and modification, locking the existing file data in-place and 
thus forcing a cow for the first post-snapshot modification per-block.

Other than that, I don't know, but it'd be interesting to see if the 
behavior replicates on a current kernel.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

