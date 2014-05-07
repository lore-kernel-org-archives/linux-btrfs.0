Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52803 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbaEGLKB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 07:10:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Whzjb-0003Tp-QQ
	for linux-btrfs@vger.kernel.org; Wed, 07 May 2014 13:09:59 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 13:09:59 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 13:09:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using noCow with snapshots ?
Date: Wed, 7 May 2014 11:09:47 +0000 (UTC)
Message-ID: <pan$a42a8$6dec058$c2834d89$1d550ded@cox.net>
References: <1541415.olHfkWYf4R@zafu>
	<pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net> <3839313.LSaoXm11Qk@zafu>
	<pan$9fcd4$1023a4e5$d241126e$285ca14@cox.net>
	<16fd4391-5c16-42a6-82a2-9bd1cb988906@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Wed, 07 May 2014 15:36:15 +1000 as excerpted:

> How could BTRFS and a database "fight" about data recovery?
> 
> BTRFS offers similar guarantees about data durability etc to other
> journalled filesystems and only differs by having checksums so that
> while a snapshot might have half the data that was written by an app you
> at least know that the half will be consistent.
> 
> If you had database files on a separate subvol to the database log then
> you would be at risk of having problems making a any sort of consistent
> snapshot (the Debian approach of /var/log/mysql and /var/lib/mysql is a
> bad idea). But there would be no difference with LVM snapshots in that
> regard.

Race conditions having to do with unsynced checkpoints, primarily.  And 
it's actually the btrfs checksumming that seems to create the problem.

The symptom being reported (tho I can say I've not seen further reports 
recently, maybe it's fixed now) was that the checksummed values btrfs 
restored as "correct" were considered corrupted by the database or vm.  
If the checksums checked out after btrfs did its replay (as they did or 
btrfs would error on access), but the databases and VMs were still 
reporting corruption, then the explanation that was left was that the 
btrfs replay and checksum validation was screwing up the application's 
own checksumming validation, which could be explained if the two were 
sufficiently out of sync that btrfs fixing its own view was actually 
breaking the view as seen by the data validating app.

Tho as I said I've not seen that sort of report in several kernel cycles 
now.  But I'm not sure whether that's because the issues have been fixed 
or for some other reason (maybe everybody experiencing the problem gave 
up and switched to some other filesystem now, and the message is out 
there well enough that new people see it before they experience and 
report the same thing, or similar but everybody's switched to NOCOW now 
and knows not to do snapshotting on the NOCOW files, or...).

Regardless, NOCOW and not doing snapshotting (because it triggers COW 
anyway) on gig-plus internal-write files remains a very good idea.  
(Also, quotas and quota sequence numbers play into the combinational 
explosion problem along with snapshot-aware-defrag, too.  See the writeup 
on that that Dave wrote while he was on paternity leave.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

