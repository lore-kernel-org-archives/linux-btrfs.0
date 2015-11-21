Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59986 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbbKUHQt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Nov 2015 02:16:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a02Pg-0005sv-7t
	for linux-btrfs@vger.kernel.org; Sat, 21 Nov 2015 08:16:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2015 08:16:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2015 08:16:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.2.6: livelock in recovery (free_reloc_roots)?
Date: Sat, 21 Nov 2015 07:16:40 +0000 (UTC)
Message-ID: <pan$3f62e$32bded6f$af93867e$b809a854@cox.net>
References: <564EE213.3060007@lukas-pirl.de>
	<564FBCD1.1020009@lukas-pirl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Pirl posted on Sat, 21 Nov 2015 13:37:37 +1300 as excerpted:

> Can "btrfs_recover_relocation" prevented from being run? I would not
> mind losing a few recent writes (what was a balance) but instead going
> rw again, so I can restart a balance.

I'm not familiar with that thread name (I run multiple small btrfs on 
ssds, so scrub, balance, etc, take only a few minutes at most), but if 
it's the balance thread, then yes, there's a mount option that cancels a 
running balance.  See the wiki page covering mount options.

> From what I have read, btrfs-zero-log would not help in this case (?) so
> I did not run it so far.

Correct.  Btrfs is atomic at commit time, so doesn't need a journal in 
the sense of older filesystems like reiserfs, jfs and ext3/4.

What's this log, then?  While btrfs won't fully write normal file writes 
until a commit (every 30 seconds by default, there's a mount option...), 
which is atomic (with copy-on-write helping here) so in the event of a 
crash either the before or after state is returned, not something half 
written, fsync is different.  That says don't return until the file is 
written to storage.  But if a commit is done to ensure that, there may be 
far more data to commit that otherwise doesn't need to be committed yet, 
seriously slowing things down.  So that's where this log comes in.  It's 
purely a log of fsynced data (and perhaps a few other similar things, I'm 
not a dev and am not sure) between atomic commits, so the fsync can 
return quickly while still having actually written the data to store, 
without having to wait upto 30 seconds (by default) for the normal commit 
to complete, or forcing a commit, along with everything else half 
written, early.

There was a bug at one point where this log could be corrupted and thus 
couldn't be written properly at mount, but the primary trigger bug for 
that problem is long since fixed, so while there's various hardware bugs 
and etc that could still by remote chance cause problems, thus the option 
to zero the log, it's a very rare occurrence, and the trace when it fails 
is telltale enough that if it's posted the devs can tell you to run the 
zero-log command then.  Otherwise, it generally does no good, and while 
it generally does no serious harm beyond the loss of a few seconds worth 
of fsyncs, etc, either, because the commits /are/ atomic and zeroing the 
log simply returns the system to the state of such a commit, it's not 
recommended as it /does/ needlessly kill the log of those last few 
seconds of fsyncs.

> By the way, I can confirm the defect of 'btrfs device remove missing …"
> mentioned here: http://www.spinics.net/lists/linux-btrfs/msg48383.html :
> 
> $ btrfs device delete missing
> /mnt/data ERROR: missing is not a block device
> $ btrfs device delete 5
> /mnt/data ERROR: 5 is not a block device

That's a known bug, with patches working their way thru the system both 
to provide a different alternative and to let btrfs device delete missing 
work again, but IDR the specific status of those patches.  Presumably 
they'll be in 4.4, but I don't know if they made it into 4.3 or not and 
don't feel like looking it up ATM when you could do so just as easily.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

