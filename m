Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaCUHle (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 03:41:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WQu54-00056t-2o
	for linux-btrfs@vger.kernel.org; Fri, 21 Mar 2014 08:41:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 08:41:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 08:41:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding btrfs and backups => automatic snapshot script
Date: Fri, 21 Mar 2014 07:41:04 +0000 (UTC)
Message-ID: <pan$e0add$d78f54c4$93efba8b$c6411b82@cox.net>
References: <loom.20140306T191655-366@post.gmane.org>
	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
	<20140317054224.GD6143@merlins.org> <20140321055733.GC28005@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Thu, 20 Mar 2014 22:57:33 -0700 as excerpted:

> On Sun, Mar 16, 2014 at 10:42:24PM -0700, Marc MERLIN wrote:
>> On Thu, Mar 06, 2014 at 09:33:24PM +0000, Duncan wrote:
>> > However, best snapshot management practice does progressive snapshot
>> > thinning, so you never have more than a few hundred snapshots to
>> > manage at once.
>> 
>> I'm happy to share my script with others if that helps:
>> http://marc.merlins.org/linux/scripts/btrfs-snaps
> 
> Now added to
> http://marc.merlins.org/perso/btrfs/post_2014-03-21_Btrfs-Tips_-How-To-
Setup-Netapp-Style-Snapshots.html

Hmm... I hadn't actually looked that closely at scripted snapshotting.  
Now that I did, and see how easy it is to manage both snapshotting and 
thinning, I just might.

But I recently switched to systemd, including replacing my crons with 
timer-unit scripts (which I setup like cron.hourly.d, daily.d, etc, but 
didn't have but those two to worry about, so didn't setup weekly or 
beyond).  I've not actually unmerged cron yet, but I probably will one of 
these days.  Anyway, I might well find myself setting up weekly/quarterly/
whatever too, with your script or something like it modified for systemd-
timer usage.  It'd give me an excuse to practice my unit-file setup 
skills some more. =:^)


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

