From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch]btrfs: finish read pages in the order they are submitted
Date: Mon, 8 Feb 2010 12:44:34 +0100
Message-ID: <20100208114433.GD1025@kernel.dk>
References: <20100203074511.GA26548@sli10-desk.sh.intel.com> <20100203181845.GE22119@think> <20100208105901.GA1025@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shaohua Li <shaohua.li@intel.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100208105901.GA1025@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 08 2010, Jens Axboe wrote:
> Cache stats (millions)
> 
> Kernel          References              Misses
> ----------------------------------------------
> baseline        3547                    2387
> patched         3822                    2351
> 
> These numbers are very stable, the above were also averaged over 3 runs,
> but variability was very low.

Update on this. I setup the storage system for more stable runs and
repeated the above test. It runs a bit faster as well, completes the
workload at 2.5GB/sec average.

Cache stats (millions)

Kernel          References              Misses
----------------------------------------------
baseline        3384                    2318
baseline        3417                    2313
baseline        3382                    2323
baseline avg    3394                    2318

patched         3518                    2258
patched         3428                    2201
patched         3536                    2274
patched avg     3494                    2244

So for those runs, ~3% more references and ~3 less misses. Even with the
variability here, that looks like a win in my book.

-- 
Jens Axboe

