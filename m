Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51955 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab2FGJrt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 05:47:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1ScZJd-0006ER-Fr
	for linux-btrfs@vger.kernel.org; Thu, 07 Jun 2012 11:47:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2012 11:47:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2012 11:47:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Uncorrectable errors on newly extended volume
Date: Thu, 7 Jun 2012 09:47:31 +0000 (UTC)
Message-ID: <pan.2012.06.07.09.47.30@cox.net>
References: <CADP2XCmhPX9HyLn6XWs4jgDHhHj8S1-G8PrZo50m4pRRXVft7A@mail.gmail.com>
	<CADP2XCmzvf2x10L=Cn8Wvod=2hST0ZrQ16Nu4EaYraJ1JKZyrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Randall Mason posted on Thu, 07 Jun 2012 12:13:53 +0300 as excerpted:

> Any more help would be appreciated.  Why is this happening, and how can
> I get my data back?

Well, any data that's important is by definition backed up (no matter the 
filesystem use), or by definition you didn't consider it /that/ 
important, being willing to play games with losing it, in the first place.

And btrfs is stil an experimental filesystem, with big warnings on both 
the kernel option enabling it and on the wiki (as well as on this list) 
that it's not fit for anything but testing, so you can't really consider 
anything on btrfs more than testing data that you're willing to lose, 
with a primary copy as well as its normal backups on other than btrfs, so 
that if you lose your btrfs copy (which was only for testing anyway) no 
big deal because you have both the primary and (tested, a backup that's 
not tested isn't yet a complete backup) backup copies.

So to get your data back, simply grab the primary or backup copy that you 
copied your btrfs testing data from.  No big deal.  If you didn't have 
such copies, then by definition you didn't consider your data valuable in 
the first place, so again, no big deal losing what could only have been 
testing data, used for testing the still experimental btrfs.

But to answer your question about the checksum errors, that's btrfs 
checksum failures, which under heavy load (as in an rsync) it can 
occasionally report (due to bugs in the still experimental btrfs) even 
when the data is actually fine.  Try accessing a smaller chunk of data at 
a time, less files, or if it's a single large file, use dd or the like to 
copy individual chunks of it to a non-experimental filesystem, say 
ext3/4, reiserfs (which I use and which Chris Mason worked on for years 
before btrfs), or xfs.  Let the btrfs filesystem rest between accesses.

FWIW, I was testing btrfs myself with the kernel 3.4 rcs, but decided it 
was still to experimental for me, so I'm back on reiserfs, which has a 
bad rep from its early days, but which has been impressively solid for me 
even when not fully reliable hardware was triggering hard lockups and 
thus hard reboots.  But the technique mentioned above did allow me to 
access the data on the btrfs filesystems as I was copying it back to 
reiserfs (I had backups but the data had changed a bit while I was 
testing, so getting the data off of the testing/btrfs copies saved me 
from having to redo those changes).

If you're still getting checksum errors when accessing only a few megs at 
a time, then the data likely really is damaged, and the checksum errors 
are letting you know that.  That's what btrfs is ultimately designed to 
do, only it's still experimental and doesn't always work the way it's 
designed to, at present.

Also note that btrfs' compression option puts a bit more CPU load on it.  
I was using compression and think that was part of my problem.  I think 
I'd have had less issues had I not been using compression.  But of 
course, that doesn't help when trying to read data that's already on 
btrfs in compressed form.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

