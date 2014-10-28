Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35760 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaJ1NeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 09:34:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xj6uI-0006hC-Td
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 14:33:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 14:33:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 14:33:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS balance segfault, where to go from here
Date: Tue, 28 Oct 2014 13:33:39 +0000 (UTC)
Message-ID: <pan$9971f$f447ea56$689bac10$a0d10b02@cox.net>
References: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
	<5DD6D691-A067-4937-A5B4-545A0DFB9B1E@colorremedies.com>
	<pan$98595$5149a38a$2d53014$f3ac0c62@cox.net>
	<trinity-1f0ee155-d845-40b5-844d-77270be4d58e-1414495992747@3capp-mailcom-bs04>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stephan Alz posted on Tue, 28 Oct 2014 12:33:12 +0100 as excerpted:

> And about the "data not being important to backed up", hell yes it is so
> yesterday I did a "backup of the backups" to a good old XFS filesystem
> (something which is reliable).

Makes sense.  FWIW, my second backup is to reiserfs, which (counter to 
reputation) I've found extremely reliable, even thru various bits of 
faulty hardware over the years, at least since the switch to data=ordered 
by default.

> The problem is that our whole backup
> system was designed to use BTRFS. It rsync from a lot of servers to the
> backup server every night then creates snapshots. Changing this and
> going back to other filesystem would require a lot of time and effort,
> possibly rewriting all of our backup scripts.

Ouch.  The filesystem access and write pattern rsync does appears to be 
quite stressful for btrfs, and has triggered a number of race-condition 
and similar bugs over time as the filesystem has continued to develop and 
mature.  They get fixed, but the number of times rsync has been a trigger 
does demonstrate that it's rather higher stress on a btrfs than most 
access and write patterns.

Between that and the fact that btrfs /isn't/ yet fully stable and mature, 
it's not a filesystem I'd normally recommend... yet... for production or 
production backup use, where down-time waiting for the non-btrfs second 
level backup to restore is really going to hurt.  Here I'm running it, 
but it's just my own system and primary backup, and if it goes down, 
nothing but a bit of personal inconvenience and stress is at stake.

In hindsight, I guess you'd do a bit more research into your backup 
filesystem before designing a backup system dependent on it, but kinda 
late for that now.  Like I said, ouch.

FWIW, you might look into zfs, either on Linux, or under FreeBSD or the 
like.  While it does have license issues on Linux (and isn't an option 
for me), it's the closest parallel to the btrfs feature set, except it's 
actually mature.  I'm told it does require significantly more memory, 
preferably ECC, however, but under the circumstances, it may be less of a 
redesign to substitute it in place of btrfs and use its mature feature-
set, even if you have to throw some money into hardware to run it 
properly, than it'd be to try to redesign your entire backup setup so 
it's not dependent on otherwise btrfs-specific feature such as snapshots, 
etc.  Since it's not an option here I've not looked into it too closely 
personally, and don't know if it'll fit your needs, but if it does, it 
may well be simpler to substitute it into the existing backup setup 
without rewriting the WHOLE thing, than to do that full rewrite from 
scratch, without the btrfs/zfs features.  I'd at least look into it, 
assuming you haven't already.

> What else can I do?
> Should I try an even later 3.18 kernel version?
> Can this happen because it doesn't have enough space for real?
> 
> 
> The counter now says that:
>  btrfs    19534313824 12468488824 3753187048  77%
> 
> The whole point I added the new drive is because it was running out of
> space.
> Somebody could really explain how this balancing works with RAID10 mode.
> What I want to know that if ANY of the drives are fail do we lose data
> or not? And the fact that the balancing is paused now changes this or
> not? If any of the drives out of the 5 would completely fail right now,
> would I lose all the data? I definitely don't want to leave the system
> in an inconsistent state like this. At least the backups are only done
> at nights so if I can get the backup drive mounted to RW by the end of
> the day that's enough.

In theory, your data isn't in danger unless two devices fail at once, 
because the not yet rebalanced data is raid10 over four devices, while 
the rebalanced data is raid10 over five, so either way, dropout of a 
single device should at worst force the filesystem read-only.  And one of 
the reasons rebalance does require additional space is because it does 
/not/ rewrite in-place, but creates new chunks to write the data and 
metadata in, and only deactivates the old ones once the new ones are 
fully written and online.  So the balance activity itself shouldn't put 
the data in further danger; you should have two full copies of every 
chunk at every possible point.

However, btrfs is /not/ yet fully stable, and you're obviously running 
into a bug of /some/ sort, so while the theory says you're fine as long 
as you lose only a single device, due to the unknown nature of the bugs 
you're already seeing and more specifically, the unknown effect the bug 
itself might have on the raid10 mode, reality can't guarantee that.

Or at least I can't.  But I'm only an admin and list regular, not a dev, 
so it's not as if I can look at the code and the bugs and personally say, 
one way or the other, that they do or don't affect the raid10 
distribution and thus the defined existence of the second copy.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

