Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:32907 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932155AbaFTQVx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 12:21:53 -0400
Received: from [79.135.116.105] (helo=[192.168.0.88])
	by lon-b.elastichosts.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.72)
	(envelope-from <alin.dobre@elastichosts.com>)
	id 1Wy1ZW-0004Hq-DS
	for linux-btrfs@vger.kernel.org; Fri, 20 Jun 2014 17:21:51 +0100
Message-ID: <53A45FBE.6040306@elastichosts.com>
Date: Fri, 20 Jun 2014 17:22:22 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Deadlock/high load
References: <5399C40F.3070509@elastichosts.com>
In-Reply-To: <5399C40F.3070509@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/06/14 16:15, Alin Dobre wrote:
> Hi all,
> 
> I have a problem that triggers quite often on our production machines. I
> don't really know what's triggering this or how to reproduce it, but the
> machine enters in some sort of deadlock state, where it consumes all the
> i/o and the load average goes very high in seconds (it even gets to over
> 200), sometimes in about a minute or even less, the machine is
> unresponsive and we have to reset it. Rarely, the load just stays high
> (~25) for hours, but it never gets down again, but this happens rarely,
> as I said. In general, the machine is either already unresponsive or is
> about to become unresponsive.
> 
> The last machine that encountered this has 40 cores and the btrfs
> filesystem is running over SSDs. We encountered this on a plain 3.14
> kernel, and also on the latest 3.14.6 kernel + all the patches whose
> summary is marked "btrfs:" that made it in 3.15, straight forward
> backported (cherry-picked) to 3.14.
> 
> Also, no suspicious (malicious) activity from the running processes either.
> 
> I noticed there was another report on 3.13 which was solved by a 3.15rc
> patch, it doesn't seem to be the same thing.
> 
> Since the only chance to obtain something was via a SysRq dump, here's
> what I could get from the last "w" trigger (tasks that are in
> uninterruptable (blocked) state), showing only tasks that are related to
> btrfs:

I tried to reproduce this on a slower/older machine with older SSDs and
couldn't get anywhere, the machine stood up. However, when I tried one
of our faster/newer machine also with newer and faster SSDs, I managed
to reproduce it twice.

I should mention that the disks are set up in a MD RAID6, and btrfs
single for both data and metadata is on top of that. I ran bonnie++ to
reproduce it (bonnie++ -d /home/bonnie -s 4g -m test -r 1024 -x 100 -u
bonnie) inside a container that was memory capped to 1GB (hence the -r
1024) with the help of cgroups.

Just before the machine stopped being fully responsive I had 3 processes
that were consuming 100% CPU: md128_raid6, btrfs-transact,
kworker/u82:6. The load was fairly low, but atop stopped working at ~5
load average.

I couldn't dump the sysrq blocked processes this time, but the above 3
processes are also in my initial report.

As per Liu Bo's request, the output of the df command is:
Data, single: total=73.01GiB, used=28.05GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=3.01GiB, used=1.04GiB
unknown, single: total=368.00MiB, used=0.00
at the moment when atop was already unresponsive.

Another thing to mention is that our production machines also have a
fairly high traffic of snapshotting (or plain creation, more rarely) and
deletion operations on subvolumes that are quota enabled.

Cheers,
Alin.
