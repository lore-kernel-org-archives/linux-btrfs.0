Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46917 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbaC3WmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 18:42:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WUOQb-0005OL-Np
	for linux-btrfs@vger.kernel.org; Mon, 31 Mar 2014 00:42:09 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 00:42:09 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 00:42:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Backup: Compare sent snapshots
Date: Sun, 30 Mar 2014 22:41:59 +0000 (UTC)
Message-ID: <pan$92371$cf7e2c62$a94a9382$e3e154b@cox.net>
References: <8465933.4bvG1Xk5zJ@linuxpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GEO posted on Sun, 30 Mar 2014 10:58:13 +0200 as excerpted:

> Hi,
> 
> I am doing backups regularly following the scheme of
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup

Be aware that send/receive is getting a lot of attention and bugfixes 
ATM.  To the best of my knowledge, where it completes without error it's 
100% reliable, but there are various corner-cases where it will presently 
trigger errors.  So I'd have a fallback backup method ready, just in case 
it quits working, and wouldn't rely in it working at this point.  (Altho 
with all the bug fixing it's getting ATM, it should be far more reliable 
in the future.)

FWIW, the problems seem to be semi-exotic cases, like where subdirectory 
A originally had subdir B nested inside it, but then that was reversed, 
so A is now inside B instead of B inside A.  Send/receive can get a bit 
mixed up in that sort of case, still.

> It states we keep a local reference of the read only snapshot we sent to
> the backup drive, which I understand.
> But now I have a question:  When I do a read only snapshot of home, send
> the difference to the backup drive, keep it until the next incremental
> step, send the difference to the backup drive, remove the old read only
> snapshot and so on...
> I wonder what happens if the read only snapshot I keep as a local
> reference got corrupted somehow.
> Then maybe too much difference would be sent which would not be
> dramatic, or too less, which would be.

In general, it wouldn't be a case of too much or too little being sent.  
It would be a case of send or receive saying, "Hey, this no longer makes 
sense, ERROR!"

But as I said above, as long as both ends are completing without error, 
the result should be fully reliable.

> Is there a quick way I could compare the last sent snapshot to the local
> one, to make sure the local reference is still the same?

A checksum of all content (including metadata), using md5sum or the like, 
on both ends.  Or do a checksum and keep a record of the result, 
comparing a later result to the previous one for the same snapshot.

As for what to actually do that checksum on, I'll let someone with more 
knowledge and experience speak up there.

> Apart from that, imagine I somehow lost the local reference (e.g. delete
> it by mistake), would there still be a way to sync the difference to the
> last sent snapshot on the backup device?

Two possibilities:

1) Reverse the send/receive, sending it from the backup to the working 
instance, thereby recreating the missing snapshot.

2) Keep more than one snapshot on each end, with the snapshot thinning 
scripts kept in sync.

So if you're doing hourly send/receive, keep the latest three, plus the 
one done at (say) midnight for each of the previous two days, plus the 
midnight snapshot for say Saturday night for the last four weeks, being 
sure to keep the same snapshots on both ends.

That way, if there's a problem with the latest send/receive, you can try 
doing a send/receive against the two hour ago or two day ago base, 
instead of the one from an hour ago.  If that doesn't work, you can try 
reversing the send/receive, sending from the backup.

But as I said, do be prepared for send/receive bugs and the errors they 
trigger.  If you hit one, you may have to fall back to something more 
traditional such as rsync, presumably reporting the bug and keeping the 
last good received snapshots around as a reference so you can try again 
with test patches or after the next kernel upgrade.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

