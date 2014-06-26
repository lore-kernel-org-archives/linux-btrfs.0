Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55055 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107AbaFZNZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 09:25:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X09g1-0007pk-PS
	for linux-btrfs@vger.kernel.org; Thu, 26 Jun 2014 15:25:21 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 15:25:21 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 15:25:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: cancel btrfs delete job
Date: Thu, 26 Jun 2014 13:25:09 +0000 (UTC)
Message-ID: <pan$6d335$5c2b9a29$9bcb428d$7e0aa9cc@cox.net>
References: <1403783232.7657.25.camel@hsew-frn.HIPERSCAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Franziska Näpelt posted on Thu, 26 Jun 2014 13:47:12 +0200 as excerpted:

> What do you mean with "if it seems the space_cache rebuild is
> interfering with further activity for too long"
> 
> The boot-process runs for five hours now. How long should i wait? What
> would you recommend?

Well, you have TiBs of capacity to work thru, and your drives will be 
doing a lot of seeking so they won't be running at anything like full 
rated speed.  Multiple TiB at say 10 MiB/sec progress... ~100 seconds/
gig, couple thousand gig... 55 hours?  That's the couple TB drive you 
mentioned, if it was near full.  I suspect it's doing something else too, 
hopefully finishing the delete, but if the I/O for that is fighting with 
the I/O for space_cache rebuild, given the size and the two I/O heavy 
tasks at once, it could take awhile.  Tho hopefully the space_cache 
rebuild should be done in a few hours and the rebuild will go faster 
after that.

Anyway, when you're talking 2 TB, even at a relatively brisk 100 MB/sec 
you're looking at five hours, so if it /is/ actually completing the 
delete, that's about the /minimum/ I'd expect.

As long as you see drive activity I'd not bother it, even if it's a day 
or two... or even more... I'd be evaluating whether to give up at the 
week-point, tho.

Note that we've had cases reported on-list where a resumed balance or the 
like can take a week, but at some point the I/O quit and it was 
apparently CPU.  At that point you gotta guess whether it's looping or 
the logic is just taking time but making (some) progress, and evaluate 
whether it's time to simply give up and restore from backup and eat the 
loss on anything not backed up.

One of the reasons snapshot-aware-defrag was disabled was because it 
simply didn't scale to thousands of snapshots well at all, and as long as 
it didn't run out of memory, it wasn't exactly locked up, but forward 
progress was close to zero and it would literally take over a week in 
some cases.  There's similar issues with the old quota code, tho there's 
patches reworking that but I'm not sure they're actually in or ready for 
mainline yet.  So I've been recommending not using quotas on btrfs -- if 
you NEED them, use a more mature filesystem where they actually work 
properly.  And if you do automated snapshots, use a good thinning script 
to thin them down so you're well under 500. (I've posted figures where 
even starting with per-minute snapshots, thinning down to 10 minute, then 
to half hour within the day, then to say 4/day after two days, 1/day 
after a week, one a week after four weeks, one every 13 weeks aka 
quarterly after say six months, and clearing them all and relying on off-
machine backups after a year or 18 months, runs only 250-ish or so, under 
300.)

Etc.  But of course even if you were doing all the wrong things it's a 
bit late to worry about it now, until you're back up and running.

But as I said, drive activity is a good sign.  I'd leave it alone as long 
as that's happening -- with that much data it could literally take days.  
If the drive activity stops, tho, that's when you gotta reevaluate 
whether it's worth waiting or not.

Meanwhile, if the drive activity /does/ stop, consider doing an alt-sysrq-
w, to get a trace of what's blocking.  Then wait say a half an hour and 
do another, and compare.  People report that sometimes you can see if 
it's making forward progress from that (if the blocked tasks seem to be 
in the same spot), or at least post it for the devs to look at -- that's 
actually one of their most requested things, tho I'm not sure how easy 
it'll be to capture without being able to get at the logs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

