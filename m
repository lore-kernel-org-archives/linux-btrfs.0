From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Hot rb_next, setup_cluster_no_bitmap
Date: Thu, 04 Aug 2011 10:04:29 -0400
Message-ID: <1312466623-sup-3275@shiny>
References: <20110803220655.GE20966@hostway.ca> <20110803223949.GA20056@hostway.ca> <20110803231059.GB20056@hostway.ca> <20110804013210.GC20056@hostway.ca>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Simon Kirby <sim@hostway.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110804013210.GC20056@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Simon Kirby's message of 2011-08-03 21:32:10 -0400:
> Perhaps as a further clue as to what is going on, on this same backup box
> after all of the rsyncs are finished/killed and a good amount of time has
> passed (no cleaner processes running in the background or anything),
> "sync" is still consistently takes ~4 minutes to run, and pushes out a
> lot to disk every time it is run. Example:
> 
> echo 3 > /proc/sys/vm/drop_caches
> sync
> echo 3 > /proc/sys/vm/drop_caches
> sync
> vmstat 1 &
> time sync

Just to confirm, the profiling during this time shows your system time
is all in rb_next?

-chris
