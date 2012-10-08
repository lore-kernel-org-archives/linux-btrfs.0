Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50512 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab2JHOik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 10:38:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TLETh-0000aU-Ea
	for linux-btrfs@vger.kernel.org; Mon, 08 Oct 2012 16:38:41 +0200
Received: from 50C58B65.flatrate.dk ([80.197.139.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 16:38:41 +0200
Received: from casper.bang by 50C58B65.flatrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 16:38:41 +0200
To: linux-btrfs@vger.kernel.org
From: Casper Bang <casper.bang@gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Date: Mon, 8 Oct 2012 14:38:22 +0000 (UTC)
Message-ID: <loom.20121008T161833-517@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120919152550.GA15242@shiny.207.47.4.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Thanks for taking the time to write this up follow through the thread.
> It's always interesting to hear situations where btrfs doesn't work
> well.
> 
> There are three basic problems with the database workloads on btrfs.
> First is that we have higher latencies on writes because we are feeding
> everything through helper threads for crcs.  Usually the extra latencies
> don't show up because we have enough work in the pipeline to keep the
> drive busy.
> 
> I don't believe the UEK kernels have the recent changes to do some of
> the crc work inline (without handing off) for smaller synchronous IOs.
> 
> Second, on O_SYNC writes btrfs will write both the file metadata and
> data into a special tree so we can be crash safe.  For big files this
> tends to spend a lot of time looking for the extents in the file that
> have changed.
> 
> Josef fixed that up and it is queued for the next merge window.
> 
> The third problem is that lots of random writes tend to make lots of
> metadata.  If this doesn't fit in ram, we can end up doing many reads
> that slow things down.  We're working on this now as well, but recent
> kernels change how we cache things and should improve the results.

I feel I should update my previous thread about performance issues using btrfs 
in light of recent findings. We have discovered that, in all likelihood, what we 
experienced and what was described, was not a problem with btrfs per se, but a 
result of a more general issue which btrfs was just really good at exposing 
(using threads more aggressively than zfs?!).

Various benchmarks in Java (thread-pool setup/shutdown) and C (pthreads creation 
and joining), has shown that our Xeon/E5-2620 server with the latest Oracle 
Unbreakable Linux has a very slow time serving up new threads (benchmarks 
available upon request).

Java threading benchmark on Xeon/E5-2620 @ 2.0GHz:
Oracle Unbreakable Linux: 1m49s	realtime, 3m17s sys-time
Ubuntu:                   5s realtime, 3.9s sys-time.

We are not sure how to continue investigating why the Oracle Linux/Kernel 
performs so poorly (scheduler, kernel config etc?), but it seems pretty obvious 
that this issue should be raised with Oracle rather than the btrfs developers - 
though we'll probably look into using another OS entirely. As such, apologies 
for creating the noise, btrfs was not to blame!

If you do have a suspicion or insight on the matter (perhaps work for Oracle, or 
know OUK?), of course we'd love a followup offline this list.

Kind regards,
Casper

