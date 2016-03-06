Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbcCFGny (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Mar 2016 01:43:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1acSPv-0005Na-LE
	for linux-btrfs@vger.kernel.org; Sun, 06 Mar 2016 07:43:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 07:43:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Mar 2016 07:43:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Sun, 6 Mar 2016 06:43:46 +0000 (UTC)
Message-ID: <pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Haber posted on Sat, 05 Mar 2016 21:09:09 +0100 as excerpted:

> On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:

>> Something is happening with the usage of this file system that's out of
>> the ordinary. This is the first time I've seen such a large amount of
>> unused metadata allocation. And then for it not only fail to balance,
>> but for the allocation amount to increase is a first.
> 
> It is just a root filesystem of a workstation running Debian Linux, in
> daily use, with daily snapshots of the system, and ten-minute-increment
> snapshots of /home, with no cleanup happening for a few months.
> 
>>  So understanding the usage is important to figuring out what's
>>  happening. I'd file a bug and include as much information on how the
>>  fs got into this state as possible. And also if possible make a
>>  btrfs-image using the proper flags to blot out the filenames for
>>  privacy.

Now you're homing in on what I picked up on.  There's something very 
funky about that metadata, 100+ GiB of metadata total, only just over 2 
GiB metadata used, and attempts to balance it don't help with the spread 
between the two at all, only increasing the total metadata, if anything, 
but still seem to complete without error.  There's gotta be some sort of 
bug going on there, and I'd /bet/ it's the same one that's keeping full 
balances from working, as well.


OK, this question's out of left field, but it's the only thing (well, 
/almost/ only, see below) I've seen do anything /remotely/ like that:

Was the filesystem originally created as a convert from ext*, using btrfs-
convert?  If so, was the ext2_saved or whatever subvolume removed, and a 
successful defrag and balance completed at that time?

Because as I said, problems due to faulty conversion from ext* have been 
the one thing repeatedly reported to trigger balance behavior and spreads 
between total and used that balance doesn't fix, like this.


Tho AFAIK there was in addition a very narrow timeframe in which a bug in 
mkfs.btrfs would create invalid btrfs'.  That was with btrfs-progs 4.1.1, 
released in July 2015, with an urgent bugfix release 4.1.2 in the same 
month to fix the problem, so the timeframe was days or weeks.  Btrfs 
created with that buggy mkfs.btrfs were known to have some pretty wild 
behavior as well, with the recommendation being to simply blow them up 
and recreate them with a mkfs.btrfs from a btrfs-progs without the bug, 
as the btrfs created by the bugged version were simply too bugged out to 
reliably fix, and might well appear to work fine for awhile, until BOOM!  
If there's a chance the filesystem in question was created by that bugged 
mkfs.btrfs, don't even try to fix it, just get what you can off it and 
recreate with a mkfs.btrfs without that bug, ASAP.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

