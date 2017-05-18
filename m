Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755251AbdERIkI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 04:40:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EC1DAB9D
        for <linux-btrfs@vger.kernel.org>; Thu, 18 May 2017 08:40:07 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: jeffm@suse.com
From: Nikolay Borisov <nborisov@suse.com>
Subject: btrfs metadata reclaim behavior/performance characteristics
Message-ID: <dc9f3787-767b-6710-9694-9eb02aa07728@suse.com>
Date: Thu, 18 May 2017 11:40:05 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------7C5C59A8D9E52419B0B13190"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------7C5C59A8D9E52419B0B13190
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello list, 

As a result of the perf regression discovered in [0] I also took the time to 
investigate the behavior of the metadata reclaim algorithm and how it chagned
with the introduction of the ticketed reservations. My tests were performed on
the following commits: 

Pre-ticketed => c83f8effefa4 ("Btrfs: add tracepoint for adding block groups")
Ticketed => kernel version 4.11
Patched => my patch (attached), applied on top of 4.11 


The workload used was a stripped down version of generic/027 [1]. The filesystem
is created with the same condition - 256mb total size, mixed mode, only 2mb
free space, rest taken up by a large file. The canonical workload is a single
iteration of 8 workers, creating 2kb files. However, the below measurements 
have been taken by doing 10 iteration of that just to reduce noise. 


First here is latency distribution of reserve_metadata_bytes, obtained by 
the following systemtap script [2] Results are in milliseconds (ms):

pre-ticketed(ms):
value |-------------------------------------------------- count
    0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  345330
    1 |@@                                                  17221
    2 |                                                     3506
    4 |                                                      212
    8 |@@                                                  17777
   16 |@                                                    7125
   32 |                                                     1974
   64 |                                                      136
  128 |                                                        3
  256 |                                                        0
  512 |    

Ticketed:
value |-------------------------------------------------- count
    0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  311844
    1 |@                                                   11123
    2 |@                                                   10103
    4 |@                                                    8669
    8 |@                                                   10802
   16 |@@@                                                 20079
   32 |@@                                                  18015
   64 |                                                     1485
  128 |                                                      175
  256 |                                                        0
  512 |                                                        0

patched:
value |-------------------------------------------------- count
    0 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  321168
    1 |@                                                   10620
    2 |@                                                    9099
    4 |@                                                    6488
    8 |@@                                                  17000
   16 |@                                                   12495
   32 |                                                     3525
   64 |                                                       54
  128 |                                                        0
  256 |                                                        0


So if anything the ticketed rework seems to have negative impact on the 
latencies, making the results a lot more variable. My patch does improve things
a little bit but it's not as before. 

Latency however is not the only important metric, here is the sum of files
created by each of 8 workers for 10 iteration with: 

                Pre-ticketed    Ticketed        Patched
                9647            9688        	 9492
                9811            9805        	 9627
                9838            9656        	 9569
                9818            9809        	 9419
                9684            9883        	 9495
                9755            9861        	 9696
                9791            9756        	 9362
                9852            9714        	 9489
                9880            9787        	 9657
                9809            9863        	 9453

average         9788          	9782          	 9525
				100%             %97.38

median          9810            9787          	 9495
                                100%             %97.02

stdev           73           	77           	 108
stdev/average   0.75%           0.79%            1.14%
stdev/median    0.75%           0.79%            1.14% 

generic/027 
runtime:        300s            800s        	225s

Further drilling down on why the increased run times I traced that to the
amount of transaction being generated. I've already described this in my 
previous email [0] so I'm not going to repeat the numbers here as well. 

Empirically I discovered that one way to reduce the latency is to actually 
limit the commit cycle to 1 and only allow all other states except transaction
commit to happen during reclaim. This is exactly the strategy which the attached
patch implements. Evidently from the numbers provided, the reduced number of 
commit cycles is only marginally worse than the the current version, yet is 
a lot faster in this particular test and reduces latency as well.  I also 
tested doing only a single pass through all flush_space states ala 
pre-ticketed version, however the results were a lot noisier and worse. 

Admittedly this latency problem likely manifests when we are close to ENOSPC
condition hence why no one has observed this so far. However, I think a 3x 
drop in performance even in an edge case with no considerable change in 
success writes during ENOSPC is a bit too much. 

I would like this email light up a discussion regarding this since we might 
not really have the most optimal solution at the moment. 


[0] https://www.spinics.net/lists/linux-btrfs/msg65355.html
[1] http://sprunge.us/HVMF
[2] http://paste.ubuntu.com/24591513/

--------------7C5C59A8D9E52419B0B13190
Content-Type: text/x-patch;
 name="0001-btrfs-Rework-the-metadata-reclaim-algorithm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-btrfs-Rework-the-metadata-reclaim-algorithm.patch"

>From 8b3e5b1a45c47043e4ae3a066ca494d9211cc8be Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Tue, 16 May 2017 14:46:03 +0300
Subject: [PATCH] btrfs: Rework the metadata reclaim algorithm

Currently the metadata reclaim algorithm works by allong up to 2 commit cycles
(where a commit cycle is defined as an iteration through all states in
flush_space) for every space reservation ticket on the space_info->ticket_list.
Empirical testing shows that this improves the number of reservations which
could be satisfied, however it also leads to a very large number of transaction
commits. Testing showed that for the same workload ticketed rework generates
~4.5k transaction whereas pre-ticketed work generated ~1.5k. This results in
generic/027 runtime increase almost 3x (from 300 to 800 seconds), mainly due to
the 'rm' phase causing a lot more transaction commits.

Current patch fixes this by modifying the algorithm in such a way so as to
allow only 1 transactino commit for every ticket by allow every other metadata
cleaning operation to be performed twice. That is the code would stop flushing
before the  2nd transaction commit commences.

In addition to runtime measurements I also measured the number of reservations
which are being satisfied. The test case is the following:

#!/bin/bash
create_file()
{
        local dir=$1
        local direct=$2
        local i=0

        mkdir -p $dir >/dev/null 2>&1
        local STARTTIME=$(date +%s)
        while xfs_io -f $direct -c "pwrite 0 1k" $dir/file_$i >/dev/null 2>&1; do
                let i=$i+1
        done

        local ENDTIME=$(date +%s)
        echo "Created $i files before returning error, time taken $(($ENDTIME - $STARTTIME))"
}

dir=/media/scratch/testdir/
loop=1
i=1
while [ $i -le $loop ]; do
        nr_worker=8
        while [ $nr_worker -gt 0 ]; do
                # half buffered I/O half direct I/O
                if [ `expr $nr_worker % 2` -eq 0 ]; then
                        create_file $dir/$nr_worker -d &
                else
                        create_file $dir/$nr_worker &
                fi
                let nr_worker=$nr_worker-1
        done
        wait
        STARTTIME=$(date +%s)
        rm -rf $dir
        ENDTIME=$(date +%s)
        echo "rming took $(($ENDTIME - $STARTTIME)) seconds"
        let i=$i+1
done

Runnig this 10 times yelds the following sums of successful writes for
all 8 workers per iteration:
                Pre-ticketed    Ticketed        Patched
                9647            9688        	 9492
                9811            9805        	 9627
                9838            9656        	 9569
                9818            9809        	 9419
                9684            9883        	 9495
                9755            9861        	 9696
                9791            9756        	 9362
                9852            9714        	 9489
                9880            9787        	 9657
                9809            9863        	 9453

average         9788          	9782          	 9525
								100%             %97.38

median          9810            9787          	 9495
                                100%             %97.02

stdev           73           	77           	 108
stdev/average   0.75%           0.79%            1.14%
stdev/median    0.75%           0.79%            1.14% 

generic/027 
runtime:        300s            800s        	225s

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3ab1f88af038..8124a750fd6b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4973,8 +4973,8 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_space_info *space_info;
 	u64 to_reclaim;
-	int flush_state;
-	int commit_cycles = 0;
+	int flush_state = FLUSH_DELAYED_ITEMS_NR;
+	bool committed = false;
 	u64 last_tickets_id;
 
 	fs_info = container_of(work, struct btrfs_fs_info, async_reclaim_work);
@@ -4991,8 +4991,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 	last_tickets_id = space_info->tickets_id;
 	spin_unlock(&space_info->lock);
 
-	flush_state = FLUSH_DELAYED_ITEMS_NR;
-	do {
+	while (!committed || flush_state < COMMIT_TRANS) {
 		struct reserve_ticket *ticket;
 		int ret;
 
@@ -5013,21 +5012,21 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		} else {
 			last_tickets_id = space_info->tickets_id;
 			flush_state = FLUSH_DELAYED_ITEMS_NR;
-			if (commit_cycles)
-				commit_cycles--;
+			if (committed)
+				committed = false;
 		}
+		spin_unlock(&space_info->lock);
 
 		if (flush_state > COMMIT_TRANS) {
-			commit_cycles++;
-			if (commit_cycles > 2) {
-				wake_all_tickets(&space_info->tickets);
-				space_info->flush = 0;
-			} else {
-				flush_state = FLUSH_DELAYED_ITEMS_NR;
-			}
+			committed = true;
+			flush_state = FLUSH_DELAYED_ITEMS_NR;
 		}
-		spin_unlock(&space_info->lock);
-	} while (flush_state <= COMMIT_TRANS);
+	}
+
+	spin_lock(&space_info->lock);
+	wake_all_tickets(&space_info->tickets);
+	space_info->flush = 0;
+	spin_unlock(&space_info->lock);
 }
 
 void btrfs_init_async_reclaim_work(struct work_struct *work)
-- 
2.7.4

--------------7C5C59A8D9E52419B0B13190--
