Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaGTCjk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 22:39:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X8h2I-0007NW-G5
	for linux-btrfs@vger.kernel.org; Sun, 20 Jul 2014 04:39:38 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 04:39:38 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 04:39:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during balance
Date: Sun, 20 Jul 2014 02:39:27 +0000 (UTC)
Message-ID: <pan$c685d$4bb40507$f2be4604$15619074@cox.net>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 19 Jul 2014 11:38:08 -0600 as excerpted:

> I'm not sure of the reason for the "BTRFS info (device sdg2): 2 enospc
> errors during balance" but it seems informational rather than either a
> warning or problem. I'd treat ext4->btrfs converted file systems to be
> something of an odd duck, in that it's uncommon, therefore isn't getting
> as much testing and extra caution is a good idea. Make frequent backups.

Expanding on that a bit...

Balance simply rewrites chunks, combining where possible and possibly 
converting to a different layout (single/dup/raid0/1/10/5/6[1]) in the 
process.  The most common reason for enospc during balance is of course 
all space allocated to chunks, with various workarounds for that if it 
happens, but that doesn't seem to be what was happening to you
(Mark J./OP).

Based on very similar issues reported by another ext4 -> btrfs converter 
and the discussion on that thread, here's what I think happened:

First a critical question for you as it's a critical piece of this 
scenario that you didn't mention in your summary.  The wiki page on
ext4 -> btrfs conversion suggests deleting the ext2_saved subvolume and 
then doing a full defrag and rebalance.  You're attempting a full 
rebalance, but have you yet deleted ext2_saved and did you do the defrag 
before attempting the rebalance?

I'm guessing not, as was the case with the other user that reported this 
issue.  Here's what apparently happened in his case and how we fixed it:

The problem is that btrfs data chunks are 1 GiB each.  Thus, the maximum 
size of a btrfs extent is 1 GiB.  But ext4 doesn't have an arbitrary 
limitation on extent size, and for files over a GiB in size, ext4 extents 
can /also/ be over a GiB in size.

That results in two potential issues at balance time.  First, btrfs 
treats the ext2_saved subvolume as a read-only snapshot and won't touch 
it, thus keeping the ext* data intact in case the user wishes to rollback 
to ext*.  I don't think btrfs touches that data during a balance either, 
as it really couldn't do so /safely/ without incorporating all of the 
ext* code into btrfs.  I'm not sure how it expresses that situation, but 
it's quite possible that btrfs treats it as enospc.

Second, for files that had ext4 extents greater than a GiB, balance will 
naturally enospc, because even the biggest possible btrfs extent, a full 
1 GiB data chunk, is too small to hold the existing file extent.  Of 
course this only happens on filesystems converted from ext*, because 
natively btrfs has no way to make an extent larger than a GiB, so it 
won't run into the problem if it was created natively instead of 
converted from ext*.

Once the ext2_saved subvolume/snapshot is deleted, defragging should cure 
the problem as it rewrites those files to btrfs-native chunks, normally 
defragging but in this case fragging to the 1 GiB btrfs-native data-chunk-
size extent size.

Alternatively, and this is what the other guy did, one can find all the 
files from the original ext*fs over a GiB in size, and move them off-
filesystem and back AFAIK he had several gigs of spare RAM and no files 
larger than that, so he used tmpfs as the temporary storage location, 
which is memory so the only I/O is that on the btrfs in question.  By 
doing that he deleted the existing files on btrfs and recreated them, 
naturally splitting the extents on data-chunk-boundaries as btrfs 
normally does, in the recreation.

If you had deleted the ext2_saved subvolume/snapshot and done the defrag 
already, that explanation doesn't work as-is, but I'd still consider it 
an artifact from the conversion, and try the alternative move-off-
filesystem-temporarily method.

If you don't have any files over a GiB in size, then I don't know... 
perhaps it's some other bug.

---
[1] Raid5/6 support not yet complete.  Operational code is there but 
recovery code is still incomplete.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

