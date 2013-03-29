Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab3C2RMI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 13:12:08 -0400
Date: Fri, 29 Mar 2013 18:12:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Ask =?iso-8859-1?Q?Bj=F8rn?= Hansen <ask@develooper.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs "stuck" on
Message-ID: <20130329171204.GH29125@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 21, 2013 at 11:56:37AM -0700, Ask Bjørn Hansen wrote:
> A few weeks ago I replaced a ZFS backup system with one backed by
> btrfs. A script loops over a bunch of hosts rsyncing them to each
> their own subvolume.  After each rsync I snapshot the "host-specific"
> subvolume.
> 
> The "disk" is an iscsi disk that in my benchmarks performs roughly
> like a local raid with 2-3 SATA disks.
> 
> It worked fine for about a week (~150 snapshots from ~20 sub volumes)
> before it "suddenly" exploded in disk io wait. Doing anything (in
> particular changes) on the file system is just insanely slow, rsync
> basically can't complete (an rsync that should take 10-20 minutes
> takes 24 hours; I have a directory of 60k files I tried deleting and
> it's deleting one file every few minutes, that sort of thing).

I'm seeing similar problem after a test that produces tons of snapshots
and snap deletions at the same time. Accessing the directory (eg. via
ls) containing the snapshots blocks for a long time.

The contention point is a mutex of the directory entry, used for lookups
on the 'ls' side, and the snapshot deletion process holds the mutex as
well with obvious consequences. The contention is multiplied by the
number of snapshots waiting to be deleted and eagerly grabbing the
mutex, making other waiters starve.

You've observed this as deletion progressing very slowly and rsync
blocked. That's really annoying and I'm working towards fixing it.

> I am using 3.8.2-206.fc18.x86_64 (Fedora 18). I tried rebooting, it
> doesn't make a difference. As soon as I boot "[btrfs-cleaner]" and
> "[btrfs-transacti]" gets really busy.
> 
> I wonder if it's because I deleted a few snapshots at some point? 

Yes. The progress or performance impact depends on amount of data shared
among the snapshots and used / free space fragmentation.

david
