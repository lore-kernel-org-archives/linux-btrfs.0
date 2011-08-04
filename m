From: Simon Kirby <sim@hostway.ca>
Subject: Re: Hot rb_next, setup_cluster_no_bitmap
Date: Thu, 4 Aug 2011 10:28:35 -0700
Message-ID: <20110804172835.GA5301@hostway.ca>
References: <20110803220655.GE20966@hostway.ca> <20110803223949.GA20056@hostway.ca> <20110803231059.GB20056@hostway.ca> <20110804013210.GC20056@hostway.ca> <1312466623-sup-3275@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312466623-sup-3275@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 04, 2011 at 10:04:29AM -0400, Chris Mason wrote:

> Excerpts from Simon Kirby's message of 2011-08-03 21:32:10 -0400:
> > Perhaps as a further clue as to what is going on, on this same backup box
> > after all of the rsyncs are finished/killed and a good amount of time has
> > passed (no cleaner processes running in the background or anything),
> > "sync" is still consistently takes ~4 minutes to run, and pushes out a
> > lot to disk every time it is run. Example:
> > 
> > echo 3 > /proc/sys/vm/drop_caches
> > sync
> > echo 3 > /proc/sys/vm/drop_caches
> > sync
> > vmstat 1 &
> > time sync
> 
> Just to confirm, the profiling during this time shows your system time
> is all in rb_next?

Correct, rb_next() called from setup_cluster_no_bitmap(). Also, much of the
other CPU time is spent spinning (on refill_lock, I think).

It's in this state again now (just one overnight backup run does it). It
doesn't seem to happen for the first few hours, but shows up by the next
morning.

Simon-
