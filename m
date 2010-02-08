From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch]btrfs: finish read pages in the order they are submitted
Date: Mon, 8 Feb 2010 11:59:01 +0100
Message-ID: <20100208105901.GA1025@kernel.dk>
References: <20100203074511.GA26548@sli10-desk.sh.intel.com> <20100203181845.GE22119@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shaohua Li <shaohua.li@intel.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100203181845.GE22119@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 03 2010, Chris Mason wrote:
> On Wed, Feb 03, 2010 at 03:45:11PM +0800, Shaohua Li wrote:
> > the endio is done at reverse order of bio vectors. That means for a sequential
> > read, the page first submitted will finish last in a bio. Considering we will
> > do checksum (making cache hot) for every page, this does introduce delay (and
> > chance to squeeze cache used soon) for pages submitted at the begining. I
> > don't observe obvious performance difference with below patch at my simple test,
> > but seems more natural to finish read in the order they are submitted.
> 
> Interesting, I wonder if we'd be able to see this on a higher throughput
> system.  Jens, care to give it a shot (patch below)?

Sure, I gave it a spin. Baseline is current -git (-rc7'ish), and the
workload is just stream reading 8 16GB files. I used large streaming
reads as the bigger ios would hopefully help show the effect of doing
the reverse completions. The run takes ~1 minute, and the results are
averaged over 3 runs.

Throughput:

Kernel          Slowest         Fastest         Average
-------------------------------------------------------
baseline        2041MB/sec      2229MB/sec      2155MB/sec
patched         2052MB/sec      2071MB/sec      2062MB/sec


Completion latency average (msecs):

Kernel          Best            Worst           Average
-------------------------------------------------------
baseline        1.72            1.89            1.79
patche          1.83            1.89            1.85


Probably would need a LOT more runs to get a statistically significant
number here, it would be nice if O_DIRECT worked (hint, hint!) which
usually makes these things easier to test. If I look at the throughput
of the runs, the baseline usually starts a little slower (1.8GB/sec or
so) and gets faster, while the patched run starts much higher (close to
3.0GB/sec) and drops to 2.0GB/sec after that for the rest of the run.

So I did some perf stat checks too, to see if we see an improvement for
cache utilization. Results below.


Cache stats (millions)

Kernel          References              Misses
----------------------------------------------
baseline        3547                    2387
patched         3822                    2351o

These numbers are very stable, the above were also averaged over 3 runs,
but variability was very low.

My feeling is that the patch should be included. Cache misses are
provably down and the patch makes a lot of sense just logically. The
patched runs seemed more stable, and my gut tells me that the unpatched
runs may have been a bit flukey (one fast run, should probably be
excluded).

Let me know if you want more tests.

-- 
Jens Axboe

