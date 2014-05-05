Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37069 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaEFTiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:38:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhkHz-0000m9-Iy
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 20:40:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:40:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:40:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Copying related snapshots to another server with btrfs
 send/receive?
Date: Mon, 5 May 2014 03:24:45 +0000 (UTC)
Message-ID: <pan$10f8$1751c450$6f6d3a98$57d04ce1@cox.net>
References: <20140504031231.GG9061@merlins.org>
	<5365E932.20602@swiftspirit.co.za> <20140504072829.GK9061@merlins.org>
	<5365F23E.8070009@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Sun, 04 May 2014 09:54:38 +0200 as excerpted:

>  From the man page section on -c:
>      "You must not specify clone sources unless you guarantee that these
> snapshots are exactly in the same state on both sides, the sender and
> the receiver. It is allowed to omit the '-p <parent>' option when '-c
> <clone-src>' options are given, in which case 'btrfs send' will
> determine a suitable parent among the clone sources itself."
> 
> -p does require that the sources be read-only. I suspect -c does as
> well. This means that it won't be so simple as you want your sources to
> be read-write. Probably the only way then would be to make read-only
> snapshots whenever you want to sync these over while also ensuring that
> you keep at least one read-only snapshot intact - again, much like
> incremental backups.

I don't claim in any way to be a send/receive expert as I don't use it 
for my use-case at all.  However...

It's worth noting in the context of that manpage quote, that really the 
only practical way to guarantee that the snapshots are exactly the same 
on both sides is to have them read-only the entire time.  Because the 
moment you make them writable on either side all bets are off as to 
whether something has been written, thereby killing the exact-same-state 
guarantee. =:^(

*However*: snapshotting a read-only snapshot and making the new one 
writable is easy enough[1].  Just keep the originals read-only so they 
can be used as parents/clones, and make a second, writable snapshot of 
the first, to do your writable stuff in.

---
[1]  Snapshotting a snapshot: I'm getting a metaphorical flashing light 
saying I need to go check the wiki FAQ that deals with this again before 
I post, but unfortunately I can't check out why ATM as I just upgraded 
firefox and cairo and am currently getting a blank window where the 
firefox content should be, that will hopefully be gone and the content 
displayed after I reboot and get rid of the still loaded old libs, so 
unfortunately I can't check that flashing light ATM and am writing 
blind.  Hopefully that flashing light warning isn't for something /too/ 
major that I'm overlooking!  =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

