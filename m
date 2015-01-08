Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53485 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbbAHFqZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 00:46:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y95vC-0004Zu-B9
	for linux-btrfs@vger.kernel.org; Thu, 08 Jan 2015 06:46:14 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 06:46:14 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Jan 2015 06:46:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS free space handling still needs more work: Hangs again
 (no complete lockups, "just" tasks stuck for some time)
Date: Thu, 8 Jan 2015 05:45:56 +0000 (UTC)
Message-ID: <pan$75d3b$ee534480$97e113aa$a8796b2d@cox.net>
References: <3738341.y7uRQFcLJH@merkaba> <2191338.tRc7Jxvh05@merkaba>
	<20150106200322.GA12706@hungrycats.org> <1499386.KVI6lPzt8j@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Wed, 07 Jan 2015 20:08:50 +0100 as excerpted:

> No BTRFS developers commented yet on this, neither in this thread nor in
> the bug report at kernel.org I made.

Just a quick general note on this point...

There has in the past (and I believe referenced on the wiki) been dev 
comment to the effect that on the list they tend to find particular 
reports/threads and work on them until they find and either fix the issue 
or (when not urgent) decide it must wait for something else, first.  
During the time they're busy pursuing such a report, they don't read 
others on the list very closely, and such list-only bug reports may thus 
get dropped on the floor and never worked on.

The recommendation, then, is to report it to the list, and if not picked 
up right away and you plan on being around in a few weeks/months when 
they potentially get to it, file a bug on it, so it doesn't get dropped 
on the floor.

With the bugzilla.kernel.org report you've followed the recommendation, 
but the implication is that you won't necessarily get any comment right 
away, only later, when they're not immediately busy looking at some other 
bug.  So lack of b.k.o comment in the immediate term doesn't mean they're 
ignoring the bug or don't value it; it just means they're hot on the 
trail of something else ATM and it might take some time to get that 
"first comment" engagement.

But the recommendation is to file the bugzilla report precisely so it 
does /not/ get lost, and you've done that, so... you've done your part 
there and now comes the enforced patience bit of waiting for that 
engagement.

But if it takes a bit, I would keep the bug updated every kernel release 
or so, with a comment updating status.

(Meanwhile, I've seen no indication of such issues here.  Most of my 
btrfs are 8-24 GiB each, all SSD, mostly dual-device btrfs raid1 both 
data/metadata.  Maybe I don't run those full enough, however.  I do have 
three mixed-bg mode sub-GiB btrfs, however, with one of them, a 256 MiB 
single-device dup-mode btrfs, used as /boot, that tends to run reasonably 
full, but I've not seen a problem like that there, either.  But my use-
case probably simply doesn't hit the problem.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

