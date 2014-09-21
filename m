Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41725 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaIUIes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 04:34:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XVcbW-0004q5-CP
	for linux-btrfs@vger.kernel.org; Sun, 21 Sep 2014 10:34:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Sep 2014 10:34:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Sep 2014 10:34:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: device delete progress
Date: Sun, 21 Sep 2014 08:34:33 +0000 (UTC)
Message-ID: <pan$1d8a8$448bb26c$d55fc521$929be7e0@cox.net>
References: <201409211209.11875.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 21 Sep 2014 12:09:11 +1000 as excerpted:

> We need to have a way to determine the progress of a device delete
> operation.
> Also for a balance of a RAID-1 that has more than 2 devices it would be
> good to know how much space is used on each device.
> 
> Could btrfs fi df be extended to show information separately for each
> device?

btrfs fi show should give you at least some minimal per-device stats, 
today.  Enough to at least have some idea of the progress of a balance 
when adding/removing devices.

Longer term, there has been discussion of extending/changing the fi df 
format and making it far more verbose, including the information found in 
btrfs fi show as well, and making everything potentially per-device.  I 
hadn't paid a whole lot of attention to the details, however.

Alternatively, leave df more or less as it is (perhaps extending it a bit 
but attempting not to kill existing scripts using it) and put the detail 
in a new btrfs filesystem usage.  This sounds rather more reasonable to 
me.

Either way the idea is to give people a single command that combines the 
current output of fi show and fi df, ideally displaying per-device and 
filesystem totals both, in enough verbosity to avoid the unintuitive and 
arcane btrfs specific knowledge required today to interpret it.

I had originally presumed that such a change would happen before the 
experimental labels came off, but it didn't.  I don't know the timetable 
for it now, or even if it's still planned, as IIRC the discussion died 
away back in the btrfs-progs 3.12 era and I expected to see it in 3.14 
and it wasn't there, so I don't know...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

