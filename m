From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Updated performance results
Date: Mon, 14 Sep 2009 19:20:46 +0200
Message-ID: <20090914172045.GI14984@kernel.dk>
References: <4A6F5BB6.4020204@austin.ibm.com> <20090728202355.GC13940@think> <4A6F6951.9020304@austin.ibm.com> <20090805203526.GE12524@think> <4A7C32A4.9070106@austin.ibm.com> <20090807231240.GD3710@think> <4A9C0D19.5010108@austin.ibm.com> <20090911192955.GB2894@think> <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090914135130.GE8839@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14 2009, Chris Mason wrote:
> On Fri, Sep 11, 2009 at 04:35:50PM -0500, Steven Pratt wrote:
> > Chris Mason wrote:
> > >On Mon, Aug 31, 2009 at 12:49:13PM -0500, Steven Pratt wrote:
> > >>Better late than never. Finally got this finished up.  Mixed bag on
> > >>this one.  BTRFS lags significantly on single threaded.  Seems
> > >>unable to keep IO outstanding to the device.  Less that 60% busy on
> > >>the DM device, compared to 97%+ for all other filesystems.
> > >>nodatacow helps out, increasing utilization to about 70%, but still
> > >>trails by a large margin.
> > >
> > >Hi Steve,
> > >
> > >Jens Axboe did some profiling on his big test rig and I think we found
> > >the biggest CPU problems.  The end result is now setting in the master
> > >branch of the btrfs-unstable repo.
> > >
> > >On his boxes, btrfs went from around 400MB/s streaming writes to 1GB/s
> > >limit, and we're now tied with XFS while using less CPU time.
> > >
> > >Hopefully you will see similar results ;)
> > Hmmm, well no I didn't.  Throughputs at 1 and 128 threads are pretty
> > much unchanged, although I do see a good CPU savings on the 128
> > thread case (with cow).  For 16 threads we actually regressed with
> > cow enabled.
> > 
> > Results  are here:
> > 
> > http://btrfs.boxacle.net/repository/raid/large_create_test/write-test/1M_odirect_create.html
> > 
> > I'll try to look more into this next week.
> > 
> 
> Hmmm, Jens was benchmarking buffered writes, but he was also testing on
> his new per-bdi write back code.  If your next run could be buffered
> instead of O_DIRECT, I'd be curious to see the results.

I found out today that a larger MAX_WRITEBACK_PAGES is still an
essential for me. It basically doubles throughput on btrfs. So I think
we need to do something about that, and sooner and rather than later.

-- 
Jens Axboe

