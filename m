From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH] Btrfs: do not flush csum items of unchanged file data during treelog
Date: Fri, 06 May 2011 10:59:00 -0400
Message-ID: <1304693197-sup-4215@think>
References: <4DAD7957.6070505@cn.fujitsu.com> <4DAE3787.8050602@cn.fujitsu.com> <4DAE9C00.2020705@cn.fujitsu.com> <4DC35E99.5090600@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC35E99.5090600@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-05-05 22:36:09 -0400:
> 
> The current code relogs the entire inode every time during fsync log,
> and it is much better suited to small files rather than large ones.
> 
> During my performance test, the fsync performace of large files sucks,
> and we can ascribe this to the tremendous amount of csum infos of the
> large ones, cause we have to flush all of these csum infos into log trees
> even when there are only _one_ change in the whole file data.  Apparently,
> to optimize fsync, we need to create a filter to skip the unnecessary csum
> ones, that is, the corresponding file data remains unchanged before this fsync.
> 
> Here I have some test results to show, I use sysbench to do "random write + fsync".
> 
> ===
> sysbench --test=fileio --num-threads=1 --file-num=2 --file-block-size=4K --file-total-size=8G --file-test-mode=rndwr --file-io-mode=sync --file-extra-flags=  [prepare, run]
> ===
> 
> Sysbench args:
>   - Number of threads: 1
>   - Extra file open flags: 0
>   - 2 files, 4Gb each
>   - Block size 4Kb
>   - Number of random requests for random IO: 10000
>   - Read/Write ratio for combined random IO test: 1.50
>   - Periodic FSYNC enabled, calling fsync() each 100 requests.
>   - Calling fsync() at the end of test, Enabled.
>   - Using synchronous I/O mode
>   - Doing random write test
> 
> Sysbench results:
> ===
>    Operations performed:  0 Read, 10000 Write, 200 Other = 10200 Total
>    Read 0b  Written 39.062Mb  Total transferred 39.062Mb
> ===
> a) without patch:  (*SPEED* : 451.01Kb/sec)
>    112.75 Requests/sec executed
> 
> b) with patch:     (*SPEED* : 4.7533Mb/sec)
>    1216.84 Requests/sec executed
> 
> 
> PS: I've made a _sub transid_ stuff patch, but it does not perform as effectively as this patch,
> and I'm wanderring where the problem is and trying to improve it more.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/tree-log.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index c50271a..b934a36 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2662,6 +2662,9 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>              extent = btrfs_item_ptr(src, start_slot + i,
>                          struct btrfs_file_extent_item);
>  
> +            if (btrfs_file_extent_generation(src, extent) < trans->transid)
> +                continue;
> +

Some rough math shows you get 368 requests/sec per line added by this
patch.  Just think about how much better the metric would be without the
whitespace!  Really though, nicely done.

You're still copying the extent items into the log tree even though they
are from older transactions.  If you push the check into
btrfs_log_inode, you can avoid even more work.

-chris
