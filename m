Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56077 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbbHZLu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 07:50:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUZEF-0000H7-Q5
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 13:50:55 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 13:50:55 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 13:50:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding BTRFS storage
Date: Wed, 26 Aug 2015 11:50:43 +0000 (UTC)
Message-ID: <pan$62cb6$a1b17765$7bc77f6$cf6d5a4a@cox.net>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Duffield posted on Wed, 26 Aug 2015 10:56:03 +0200 as excerpted:

> Two quick questions:
> - If I were simply to create a Btrfs volume using 5x3TB drives and not
> create a raid5/6/10 array I understand data would be striped across the
> 5 drives with no reduncancy ... i.e. if a drive fails all data is lost? 
> Is this correct?

I'm not actually sure if the data default on a multi-device is raid0 (all 
data effectively lost) or what btrfs calls single mode, which is what it 
uses for a single device and on a multi-device fs, is sort of like raid0 
but with very large strips.  Earlier on it was single mode, but somebody 
commented that it's raid0 mode now instead, so I'm no longer sure what 
the current default is.

In single mode, files written all at once and not changed, upto a gig in 
size (that being the nominal data chunk size), will likely appear on a 
single device.  With five devices, dropping out only one should in theory 
leave many of those files and even a reasonable number of 2 GiB files 
intact.  However, fragmentation or rewriting some data within a file 
would tend to spread it out among data chunks, and thus likely across 
more devices, making the chance of loosing it higher.

Meanwhile, metadata default remains paired-mirrored raid1, regardless of 
the number of devices.

But you can always specify the data and metadata raid levels as desired, 
assuming you have at least the minimum number of devices required for 
that raid level.  I always specify them here, preferring raid1 for both 
data and metadata, tho if it were available, I'd probably use 3-way-
mirroring.  That's roadmapped but probably won't be available for a year 
or so yet, and it'll take some time to stabilize after that.

> - Is Btrfs RAID10 (for data) ready to be used reliably?

Btrfs raid0/1/10 modes as well as single and (for single device metadata) 
dup modes are all relatively mature, and should be as stable as btrfs 
itself, meaning stabilizing, but not fully stable just yet, with bugs 
from time to time.

Basically, that means the sysadmin's backups rule, that if it's not 
backed up, by action and definition it wasn't valuable, regardless of 
claims to the contrary (and complete backups are tested, if it's not 
tested usable/restorable, the backup isn't complete yet), applies double 
-- really, have backups or you're playing Russian roulette with your 
data, but those modes are stable enough for daily use, as long as you do 
have those backups or the data is simply throw-away.

Btrfs raid56 (5 and 6, it's the same code dealing with both) modes were 
nominally code-complete as of 3.19, but are still new enough they've not 
reached the stability of the rest of btrfs, yet.  As such, I've been 
suggesting that unless people are prepared to deal with that additional 
potential instability and bugginess, they wait for a year after 
introduction, effectively five kernel cycles, which should put btrfs-
stability-match at about the 4.4 kernel timeframe.

Similarly, quota code has been a problem and remains less than stable, so 
don't use btrfs quotas in the near term (until at least 4.3, then see 
what behavior looks like), unless of course you're doing so in 
cooperation with the devs working on it specifically to help test and 
stabilize it.

Other features are generally as stable as btrfs as a whole, except that 
keeping to say 250-ish snapshots per subvolume, 1000-2000 snapshots per 
filesystem, is recommended, as snapshotting, while it works well in 
general as long as there's not too many, simply doesn't scale well in 
terms of maintenance time -- device replaces, balances, btrfs checks, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

