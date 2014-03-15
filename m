Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54177 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaCOLwb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 07:52:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOn8d-0002vx-8g
	for linux-btrfs@vger.kernel.org; Sat, 15 Mar 2014 12:52:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 12:52:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 12:52:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
Date: Sat, 15 Mar 2014 11:51:59 +0000 (UTC)
Message-ID: <pan$3aea$2e15c040$920db11$3a1e73c1@cox.net>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
	<20140307002549.GC16439@lenny.home.zabbo.net>
	<CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
	<53207C4B.6020000@fb.com>
	<CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com>
	<CAGfcS_=AZLFtnQfKaoDtnJB9n_PrKsNkhcQFM+g--SCwV+43Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Fri, 14 Mar 2014 18:40:25 -0400 as excerpted:

> And some more background.  I had more reboots over the next two days at
> the same time each day, just after my crontab successfully completed. 
> One of the last thing it does is runs the snapper cleanups which delete
> a bunch of snapshots.  During a reboot I checked and there were a bunch
> of deleted snapshots, which disappeared over the next 30-60 seconds
> before the panic, and then they would re-appear on the next reboot.
> 
> I disabled the snapper cron job and this morning had no issues at all.
>  One day isn't much to establish a trend, but I suspect that this is
> the cause.  Obviously getting rid of snapshots would be desirable at
> some point, but I can wait for a patch.  Snapper would be deleting about
> 48 snapshots at the same time, since I create them hourly and the
> cleanup occurs daily on two different subvolumes on the same filesystem.

Hi, Rich.  Imagine seeing you here! =:^)  (Note to others, I run gentoo 
and he's a gentoo dev, so we normally see each other on the gentoo 
lists.  But btrfs comes up occasionally there too, so we knew we were 
both running it, I'd just not noticed any of his posts here, previously.)

Three things:

1) Does running the snapper cleanup command from that cron job manually 
trigger the problem as well?

Presumably if you run it manually, you'll do so at a different time of 
day, thus eliminating the possibility that it's a combination of that and 
something else occurring at that specific time, as well as confirming 
that it is indeed the snapper 

2) What about modifying the cron job to run hourly, or perhaps every six 
hours, so it's deleting only 2 or 12 instead of 48 at a time?  Does that 
help?

If so then it's a thundering herd problem.  While definitely still a bug, 
you'll at least have a workaround until its fixed. 

3) I'd be wary of letting too many snapshots build up.  A couple hundred 
shouldn't be a huge issue, but particularly when the snapshot-aware-
defrag was still enabled, people were reporting problems with thousands 
of snapshots, so I'd recommend trying to keep it under 500 or so, at 
least of the same subvol (so under 1000 total since you're snapshotting 
two different subvols).

So a hourly cron job deleting or at least thinning down snapshots over 
say 2 days old, possibly in the same cron job that creates the new snaps, 
might be a good idea.  That'd only do two at a time, the same rate 
they're created, but with a 48 hour set of snaps before deletion.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

