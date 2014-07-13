Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46972 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaGMO32 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 10:29:28 -0400
Date: Sun, 13 Jul 2014 07:29:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Andrew E. Mileski" <andrewm@isoar.ca>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140713142918.GH10641@merlins.org>
References: <20140704011938.GO11539@merlins.org>
 <53B801DD.5040704@isoar.ca>
 <20140705144318.GT26932@merlins.org>
 <20140706145815.GD15009@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140706145815.GD15009@merlins.org>
Subject: Re: btrfs is  related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 06, 2014 at 07:58:15AM -0700, Marc MERLIN wrote:
> > As an update, after 1.7 days of scrubbing, the system has started
> > getting sluggish, I'm getting synchronization problems/crashes in some of
> > my tools that talk to serial ports (likely due to mini deadlocks in the
> > kernel), and I'm now getting a few btrfs hangs.
> 
> Predictably, it died yesterday afternoon after going into memory death
> (it was answering pings, but userspace was dead, and even sysrq-o did
> not respond, I had to power cycle the power outlet).
> 
> This happened just before my 3rd scrub finished, so I'm now 2 out of 2:
> running scrub on my 3 filesystems kills the system half way through the
> 3rd scrub.

Ok, I now changed the subject line to confirm that btrfs is to blame.

I had my system booted 6 days and it held steady at 6.4GB free.
I mounted 2 of my 4 btrfs filesystems (one by one) and waited a few
days, and no problems with RAM going down.

Then I mounted my 3rd btrfs filesystem, the one that holds many files
that has rsync backups running, and I lost 1.4GB of RAM overnight.
I've just umounted one of its mountpoints, the one where all the backups
happen while leaving its main pool mounted and will see if RAM keeps
going down or not (i.e. whether the memory leak is due to rsync activity
or some other background btrfs process).

But generally, is there a tool to locate which kernel function allocated
all that RAM that seems to get allocated and forgotten?

Is /proc/slabinfo supposed to show anything useful?

This is the filesystem in question:
gargamel:~# btrfs fi df /mnt/btrfs_pool2/
Data, single: total=3.34TiB, used=3.32TiB
System, DUP: total=8.00MiB, used=400.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=77.50GiB, used=59.87GiB
Metadata, single: total=8.00MiB, used=0.00


Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
