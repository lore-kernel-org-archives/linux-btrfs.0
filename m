Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54856 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3JOErZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 00:47:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VVwXU-0001gz-2M
	for linux-btrfs@vger.kernel.org; Tue, 15 Oct 2013 06:47:24 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 06:47:24 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 06:47:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: OK to take hourly snapshots, then cull older ones?
Date: Tue, 15 Oct 2013 04:47:04 +0000 (UTC)
Message-ID: <pan$73762$c90bc02$92b3c08c$d729ddd6@cox.net>
References: <525CBF0D.1020609@mersenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Madden posted on Mon, 14 Oct 2013 21:05:33 -0700 as excerpted:

> I'd like to use BTRFS to do something like the old NetApp snapshot
> system:
> every hour or so, there'd be a snapshot, then the 23 of the snapshots
> during a day would be deleted, leaving just a day snapshot, then after a
> month, 6 of 7 snapshots would be deleted, leaving just a week snapshot,
> and so on.
> 
> Is this a reasonable thing to do in a cron job with a BTRFS filesystem?
> Apart from running out of space, are there any resources that might get
> used up?  Has anybody done this for a year or two in an active
> filesystem, and encountered success or weirdness?

There's discussion of this idea along with links to existing tools/
scripts for it, on the wiki:

https://btrfs.wiki.kernel.org

In particular, see documentation, guides and usage, use cases,
2. snapshots and subvolumes, 2.2. backups/time-machine.  However, that 
you didn't already know that was covered indicates that you either 
weren't aware of the wiki, or haven't read much on it recently, so 
there's likely a lot more information there that you'll find useful if 
you spend some time looking around and reading.

(I haven't done a whole lot with snapshotting myself as it doesn't fit my 
use case very well, but I knew about it from reading the wiki and had 
tagged it in my mind to look up again later should I need the 
information, so it was a matter of just a few seconds to find it again 
and type the path above so you could find it too.  Since I /haven't/ done 
much with snapshotting myself, I can't help much in saying which of the 
listed tools will be easiest, but that script link points at a list post 
with a pre-made script and crontab entries that look like they do just 
about exactly what you outline. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

