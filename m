Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54154 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3LWKKv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 05:10:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vv2TJ-0004PP-Qp
	for linux-btrfs@vger.kernel.org; Mon, 23 Dec 2013 11:10:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Dec 2013 11:10:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Dec 2013 11:10:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unlinked orphans.
Date: Mon, 23 Dec 2013 10:10:25 +0000 (UTC)
Message-ID: <pan$484a5$e3c30cf5$18e2aa4e$b79770e@cox.net>
References: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
	<20131223093953.GH17179@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 23 Dec 2013 09:39:53 +0000 as excerpted:

> On Sun, Dec 22, 2013 at 10:27:17PM -0800, Nacho Man wrote:
>> I ran dmesg and saw a bunch of these:
>> [564421.874063] BTRFS debug (device sda2): unlinked 32 orphans
>> 
>> Do I have to worry?

> No, this is harmless. Orphans are files that were deleted while
> they were still held open by a process. POSIX semantics requires that
> the file data is still readable by the process, but that the file's
> hardlink(s) are no longer visible -- so there's no way of finding the
> file again by "normal" methods. Once the process closes the file, it is
> unlinked.

Cool.  I knew delete worked that way on POSIX filesystems[1], and I'd 
seen various posts on this list with unlinking X orphans logs, but I had 
no idea /that/ was what orphans referred too!

New logical connection made.  Thanks. =:^)

> With btrfs, making a snapshot of a subvolume with (still open)
> orphan files in it will close the orphans on the new copy, because
> they're new files. This leads to the messages above.

... And that's entirely logical, once one actually knows what "orphans" 
are! =:^)

---
[1] Someone posted a script to the gentoo-dev list at one point, that can 
be run after an update to go thru /proc and list the processes that have 
open but deleted files... because they've been replaced in the update.  
That way, an admin can see what still-running apps still have outdated 
and possibly vulnerable libraries loaded, and can choose to restart those 
apps, or leave them running, or look a bit closer at what libs that 
process depends on that were updated and why, before choosing to restart 
that process, as appropriate based on the risk factor for that process vs 
whether it's doing something important that can't be interrupted without 
losing data.  Using that tool and seeing just what tends to need 
restarted after an update as well as how frequently, is what really drove 
home the principle here, but I didn't know what those deleted-but-still-
open files were called, until your explanation just now. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

