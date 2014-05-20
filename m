Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40498 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaETO0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 10:26:20 -0400
From: Russell Coker <russell@coker.com.au>
To: Astro Xe <astroxeu@yahoo.it>
Reply-To: russell@coker.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs fi df output is not updated in a timely manner after subvolumes have been deleted
Date: Wed, 21 May 2014 00:26:14 +1000
Message-ID: <1904314.55zAnN3BMv@xev>
In-Reply-To: <1400593810.31610.YahooMailNeo@web172206.mail.ir2.yahoo.com>
References: <1400593810.31610.YahooMailNeo@web172206.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 May 2014 14:50:10 Astro Xe wrote:
> On my box, the "used" value in the output of "btrfs filesystem df" is not
> updated in a timely manner, after that one or more subvolumes have been
> deleted. I need to execute "btrfs filesystem sync", in order to update the
> value.
> 
> How do I fix this? Or, could someone fix this in btrfs-progs, please?
> 
> I suspect the cause is that subvolumes are marked immediately as deleted,
> but cleaned up at a later time, is this right?

That appears to be the case.  I've deleted subvolumes and then had btrfs take 
10+ minutes to reclaim all the disk space.  I've even had the system crash 
during the process (due to btrfs bugs that seem fixed in 3.14) and the space 
keeps getting freed after the reboot.

Do we really want to make it the default to block on a btrfs sync?  In the 
case of manual sysadmin tasks it's probably going to be preferable to run the 
delete command and then move on to other things.

In the case of cron jobs we have to consider bulk performance, maybe it would 
be better for the authors of cron jobs to run a filesystem sync after deleting 
all snapshots to avoid driving the load average too high (I have had issues in 
the past when cron jobs to remove snapshots end up running at the same time as 
creating snapshots and scrubbing the filesystem).  If a cron job was to delete 
dozens of snapshots and sync after each one would that cause more disk access 
than syncing once after all deletes?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

