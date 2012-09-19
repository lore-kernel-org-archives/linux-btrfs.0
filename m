Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:42052 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab2ISPZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 11:25:52 -0400
Date: Wed, 19 Sep 2012 11:25:50 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Casper Bang <casper.bang@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
Message-ID: <20120919152550.GA15242@shiny.207.47.4.2>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 02:45:08AM -0600, Casper Bang wrote:
> Abstract
> For database testing purposes, a COW filesystem was needed in order to
> facilitate snapshotting and rollback, such as to provide mirrors of
> our production database at fixed intervals (every night and by
> demand).

Thanks for taking the time to write this up follow through the thread.
It's always interesting to hear situations where btrfs doesn't work
well.

There are three basic problems with the database workloads on btrfs.
First is that we have higher latencies on writes because we are feeding
everything through helper threads for crcs.  Usually the extra latencies
don't show up because we have enough work in the pipeline to keep the
drive busy.

I don't believe the UEK kernels have the recent changes to do some of
the crc work inline (without handing off) for smaller synchronous IOs.

Second, on O_SYNC writes btrfs will write both the file metadata and
data into a special tree so we can be crash safe.  For big files this
tends to spend a lot of time looking for the extents in the file that
have changed.

Josef fixed that up and it is queued for the next merge window.

The third problem is that lots of random writes tend to make lots of
metadata.  If this doesn't fit in ram, we can end up doing many reads
that slow things down.  We're working on this now as well, but recent
kernels change how we cache things and should improve the results.

-chris
