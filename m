From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] [PATCH] Btrfs: improve fsync/osync write performance
Date: Tue, 31 Mar 2009 07:27:31 -0400
Message-ID: <1238498851.6431.6.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20090331115027.05879e88@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090331115027.05879e88@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-03-31 at 14:18 +0900, Hisashi Hifumi wrote:
> Hi Chris.
> 
> I noticed performance of fsync() and write() with O_SYNC flag on Btrfs is
> very slow as compared to ext3/4. I used blktrace to try to investigate the 
> cause of this. One of cause is that unplug is done by kblockd even if the I/O is 
> issued through fsync() or write() with O_SYNC flag. kblockd's unplug timeout
> is 3msec, so unplug via blockd can decrease I/O response. To increase 
> fsync/osync write performance, speeding up unplug should be done here.
> 

> Btrfs's write I/O is issued via kernel thread, not via user application context
> that calls fsync(). While waiting for page writeback, wait_on_page_writeback() 
> can not unplug I/O sometimes on Btrfs because submit_bio is not called from 
> user application context so when submit_bio is called from kernel thread, 
> wait_on_page_writeback() sleeps on io_schedule(). 
> 

This is exactly right, and one of the uglier side effects of the async
helper kernel threads.  I've been thinking for a while about a clean way
to fix it.

> I introduced btrfs_wait_on_page_writeback() on following patch, this is replacement 
> of wait_on_page_writeback() for Btrfs. This does unplug every 1 tick while
> waiting for page writeback.
> 
> I did a performance test using the sysbench.
> 
> # sysbench --num-threads=4 --max-requests=10000  --test=fileio --file-num=1 
> --file-block-size=4K --file-total-size=128M --file-test-mode=rndwr 
> --file-fsync-freq=5  run
> 
> The result was:
> -2.6.29
> 
> Test execution summary:
>     total time:                          628.1047s
>     total number of events:              10000
>     total time taken by event execution: 413.0834
>     per-request statistics:
>          min:                            0.0000s
>          avg:                            0.0413s
>          max:                            1.9075s
>          approx.  95 percentile:         0.3712s
> 
> Threads fairness:
>     events (avg/stddev):           2500.0000/29.21
>     execution time (avg/stddev):   103.2708/4.04
> 
> 
> -2.6.29-patched
> 
> Test execution summary:
>     total time:                          579.8049s
>     total number of events:              10004
>     total time taken by event execution: 355.3098
>     per-request statistics:
>          min:                            0.0000s
>          avg:                            0.0355s
>          max:                            1.7670s
>          approx.  95 percentile:         0.3154s
> 
> Threads fairness:
>     events (avg/stddev):           2501.0000/8.03
>     execution time (avg/stddev):   88.8274/1.94
> 
> 
> This patch has some effect for performance improvement. 
> 
> I think there are other reasons that should be fixed why fsync() or 
> write() with O_SYNC flag is slow on Btrfs.
> 

Very nice.  Could I trouble you to try one more experiment?  The other
way to fix this is to your WRITE_SYNC instead of WRITE.  Could you
please hardcode WRITE_SYNC in the btrfs submit_bio paths and benchmark
that?

It doesn't cover as many cases as your patch, but it might have a lower
overall impact.

-chris


