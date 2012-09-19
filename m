Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55815 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab2ISTnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 15:43:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TEQBb-00023P-W6
	for linux-btrfs@vger.kernel.org; Wed, 19 Sep 2012 21:43:52 +0200
Received: from 50C58B65.flatrate.dk ([80.197.139.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 21:43:51 +0200
Received: from casper.bang by 50C58B65.flatrate.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 21:43:51 +0200
To: linux-btrfs@vger.kernel.org
From: Casper Bang <casper.bang@gmail.com>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Date: Wed, 19 Sep 2012 19:43:35 +0000 (UTC)
Message-ID: <loom.20120919T211827-915@post.gmane.org>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120919152550.GA15242@shiny.207.47.4.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> fusionio.com> writes:
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

That's good to hear - personally I'd rather use btrfs than ZFS, but it seems we 
were a tad bit early to the party with this kind of workload. Interesting nobody 
commented on block-size, I kind of expected that when writing my initial post 
(database using 8KB blocks, tweakable in ZFS but apparently not in btrfs).

/Casper

