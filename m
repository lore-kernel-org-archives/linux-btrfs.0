From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] Btrfs: fdatasync should skip metadata writeout
Date: Mon, 08 Jun 2009 16:50:47 +0900
Message-ID: <6.0.0.20.2.20090608133848.0740d758@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

In btrfs, fdatasync and fsync are identical.
I think fdatasync should skip committing transaction when 
inode->i_state is set just I_DIRTY_SYNC and this indicates
only atime or/and mtime updates.
Following patch improves fdatasync throughput.

#sysbench --num-threads=16 --max-requests=10000 --test=fileio 
--file-block-size=4K --file-total-size=16G --file-test-mode=rndwr 
--file-fsync-mode=fdatasync run 


Results:
-2.6.30-rc8
Test execution summary:
    total time:                          1980.6540s
    total number of events:              10001
    total time taken by event execution: 1192.9804
    per-request statistics:
         min:                            0.0000s
         avg:                            0.1193s
         max:                            15.3720s
         approx.  95 percentile:         0.7257s

Threads fairness:
    events (avg/stddev):           625.0625/151.32
    execution time (avg/stddev):   74.5613/9.46


-2.6.30-rc8-patched
Test execution summary:
    total time:                          1695.9118s
    total number of events:              10000
    total time taken by event execution: 871.3214
    per-request statistics:
         min:                            0.0000s
         avg:                            0.0871s
         max:                            10.4644s
         approx.  95 percentile:         0.4787s

Threads fairness:
    events (avg/stddev):           625.0000/131.86
    execution time (avg/stddev):   54.4576/8.98


Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.30-rc8.org/fs/btrfs/file.c linux-2.6.30-rc8.btrfs/fs/btrfs/file.c
--- linux-2.6.30-rc8.org/fs/btrfs/file.c	2009-06-04 16:26:25.000000000 +0900
+++ linux-2.6.30-rc8.btrfs/fs/btrfs/file.c	2009-06-08 10:48:13.000000000 +0900
@@ -1189,6 +1189,8 @@ int btrfs_sync_file(struct file *file, s
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	root->log_batch++;
 
+	if (datasync && !(inode->i_state & I_DIRTY_PAGES))
+		goto out;
 	/*
 	 * ok we haven't committed the transaction yet, lets do a commit
 	 */

