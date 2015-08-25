Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47294 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbHYW31 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 18:29:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUMiZ-0005O4-Ae
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 00:29:23 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 00:29:23 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 00:29:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS cannot remove empty directory pretending it is not empty
Date: Tue, 25 Aug 2015 22:29:15 +0000 (UTC)
Message-ID: <pan$d11ec$99fb59da$ae69a869$20c43d39@cox.net>
References: <2017000.AEG9PyVY17@zafu>
	<pan$d4557$9c42de4e$12e74017$2f692aea@cox.net> <1474026.LQOmDW8fG5@tethys>
	<2139681.geeI7cQtEN@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Tue, 25 Aug 2015 16:03:55 +0200 as excerpted:

> Le mardi 25 août 2015 15:25:12 Swâmi Petaramesh a écrit :
>> Uh, I've started [btrfs check --repair] hours ago, and it has been
>> eating 100% CPU on one of my cores since, without apparently yet
>> finding a single error.
> 
> btrfs check finally came to an end, and fixed dirs iszes.
> 
> The 1st good news is that my FS didn't die in the process, the 2nd good
> news is that I was then actually able to delete the "empty" directory
> that couldn't be deleted before.
> 
> So, it did the job ;-)

=:^)

FWIW, there was something in the corner of my mind about those root nnnnn 
numbers that was bothering me a bit, but I was focused on the errors 200 
dir isize wrong end and couldn't quite place it, so didn't mention it.

Now I know what it was.  Roots above 256 (255?) are subvolume/snapshot 
roots.  That's not bad in itself, indeed, it's normal (which was why I 
couldn't place what was bothering me about it), but with the output 
including a root over 24k, it does indicate that you're very likely a 
heavy snapshotter.

And that /can/ be a bit of a problem when doing btrfs maintenance, as 
btrfs is known to have scaling issues with large numbers of snapshots, 
dramatically increasing the time required for maintenance tasks such as 
check and balance.

That's almost certainly why the check --repair took so long -- all those 
snapshots.

My recommendation has been to try to keep the number of snapshots under 
10K, worst-case, and preferably under 2K.  Even if you're doing automated 
snapshots at say half-hour intervals, a reasonable thinning program, say 
hourly after 12 hours, two-hourly after a day, six-hourly after two days, 
daily after a week, weekly after a quarter, ... and switch to longer term 
backups after six months or a year so older snapshots can be deleted, can 
easily keep per-subvolume snapshots to 250 or so.  250 snapshots per 
subvolume lets you do four subvolumes at a 1000 snapshot per filesystem 
cap, eight subvolumes at the 2000 snapshot cap.  Beyond that, and 
certainly beyond 10K, scaling really gets to be an issue, with btrfs 
maintenance time quickly increasing beyond the practical range.

Hours for a btrfs check --repair?  You're actually lucky.  We've had 
reports of days, weeks... when people have tens of thousands of snapshots.

If I'd have properly placed that nagging feeling about those root numbers 
that was in the back of my mind with the go-ahead post, I could at least 
have warned you about the time it could take.  Well, I guess I know for 
next time, anyway.  Talking about which... thanks for confirming the 
fix.  Very helpful for next time. =:^)

Meanwhile, talking scaling, one more thing... btrfs quotas...

Btrfs quotas just don't work well at this point, being both not always 
reliable, and dramatically increasing the scaling issues.  My 
recommendation is that if you really need them, use a more mature 
filesystem where they're known to work reliably.  If you can get by 
without them on btrfs, definitely do so, unless you're specifically 
working with the devs to develop and test that feature, because keeping 
quotas off will simplify your btrfs life considerably!  The devs are 
actively working on the problem and should eventually get it right, but 
it's just an incredibly difficult issue that has taken multiple tries.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

