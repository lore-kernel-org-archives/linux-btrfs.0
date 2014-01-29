Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40698 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbaA2BV3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 20:21:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W8JqK-0002bS-1e
	for linux-btrfs@vger.kernel.org; Wed, 29 Jan 2014 02:21:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 02:21:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 02:21:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshots =?CP1251?B?lg==?= noob questions
Date: Wed, 29 Jan 2014 01:21:05 +0000 (UTC)
Message-ID: <pan$9f7b4$f33706f0$e7ef68e8$58886cd2@cox.net>
References: <52E664E0.5070909@gmail.com>
	<3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
	<lc8th4$8um$1@ger.gmane.org> <20140128191616.GP3314@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 28 Jan 2014 19:16:16 +0000 as excerpted:

>> Can we now consider making and deleting snapshots a "debugged stable
>> feature"?
> 
> I think so, yes, although there are still cases where having lots
> of snapshots (thousands and upwards) can cause problems. I'm thinking
> specifically of deletion of snapshots, where the system can bog down
> quite heavily doing all the deletions.

What about the recent pathologic large (half-gig-plus) frequently-
internally-rewritten and thus without NOCOW highly fragmented file case, 
made pathologic (even on SSD, it's a CPU not an IO bottleneck) by 
thousands of snapshots?

To my knowledge that's speculatively pinned down to the not all that long 
ago snapshot-aware-defrag code (which itself was in response to the 
problem of defrag not being snapshot aware before that), but while I'm 
not a dev and thus don't/can't-easily follow developing patches in code-
level detail (tho I routinely read both intros and followups), I'm not 
aware of pending patches that address that yet.

Altho recommended procedure is to NOCOW such files at creation (generally 
by setting NOCOW on the directory they're to be placed in, before the 
file is written at all), based on reports here, quite a few people get 
caught in the trap of not knowing about that until it's too late, and 
then are stuck with a file that it can literally take *DAYS* to do 
anything with due to the pathelogic lack of btrfs ability to scale or 
make pretty much any progress at all in attempting to move/defrag/delete 
such files (altho I believe they can be renamed in-place on the same 
snapshot).


That said, in general I'd agree, snapshots can practically be considered 
/reasonably/ debugged-stable, as long as you're doing reasonable snapshot 
management and don't get thousands (and preferably not too many hundreds) 
of them to deal with on the same filesystem.

An automated script that say takes a snapshot a minute, but keeps only 
say 30 one-minute snapshots, keeping a snapshot every half hour for a day 
(47, 30+47=77), keeping a snapshot every hour for another two days (48, 
total three days covered, 77+48=125), keeping a snapshot every 6 hours to 
fill out the week ((7-3)*4=16, 125+16=141), keeping a snapshot a day to 
fill out the month (31-7=24, 142+24=165), keeping a snapshot a week to 
fill out the year (52-4=48, 166+48=213), and finally keeping a snapshot a 
quarter (13 weeks) out to say a decade (40-4=36, 213+36=249), if the 
filesystem remains in use that long... should be reasonable, and assuming 
the math is correct, that's under 250 snapshots total, with coverage of a 
snapshot a minute out to a half hour, a snapshot a half-hour out to a 
day, a snapshot a day out to a month, a snapshot a week out to a year, 
and a snapshot a quarter out to a decade (!!).  If you need history back 
more than a decade and you don't have some sort of longer-term storage 
archiving involved... well let's just say I seriously doubt the quality 
of your decisions in that case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

