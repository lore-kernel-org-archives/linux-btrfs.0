From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] [PATCH] Btrfs: improve fsync/osync write performance
Date: Thu, 02 Apr 2009 07:25:36 -0400
Message-ID: <1238671536.27540.7.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20090331115027.05879e88@172.19.0.2>
	 <1238599038.18549.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20090402112809.06d828e0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090402112809.06d828e0@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-04-02 at 15:25 +0900, Hisashi Hifumi wrote:
> I tested your unplug patch.
> 
> # sysbench --num-threads=4 --max-requests=10000  --test=fileio --file-num=1 
>  --file-block-size=4K --file-total-size=128M --file-test-mode=rndwr 
>  --file-fsync-freq=5  run
> 
> -2.6.29
> Test execution summary:
>     total time:                          626.9416s
>     total number of events:              10004
>     total time taken by event execution: 442.5869
>     per-request statistics:
>          min:                            0.0000s
>          avg:                            0.0442s
>          max:                            1.4229s
>          approx.  95 percentile:         0.3959s
> 
> Threads fairness:
>     events (avg/stddev):           2501.0000/73.43
>     execution time (avg/stddev):   110.6467/7.15

> -2.6.29-patched
> Operations performed:  0 Read, 10003 Write, 1996 Other = 11999 Total
> Read 0b  Written 39.074Mb  Total transferred 39.074Mb  (68.269Kb/sec)
>    17.07 Requests/sec executed
> 
> Test execution summary:
>     total time:                          586.0944s
>     total number of events:              10003
>     total time taken by event execution: 347.5348
>     per-request statistics:
>          min:                            0.0000s
>          avg:                            0.0347s
>          max:                            2.2546s
>          approx.  95 percentile:         0.3090s
> 
> Threads fairness:
>     events (avg/stddev):           2500.7500/54.98
>     execution time (avg/stddev):   86.8837/3.06
> 

Very nice.

> 
> We can get some performance improvement by this patch.
> What if the case write() without O_SYNC ?
> I am concerned about decreasing optimization effect on block layer (merge, sort)
> when the I/O is not fsync or write with O_SYNC.

The performance should still be good for normal workloads, mostly
because the async threads try to collect IO already.  Basically what
happens is the bio is first sent to the checksumming threads, which do a
bunch of checksums but still queue things in such a way that the IO is
sent down in order.  This takes some time.

Then the bios are put into the submit bio thread pool, which wakes up a
different process to send it down.  It might be slightly less merging
than before, but it should still give the elevator enough bios to work
with.

-chris


