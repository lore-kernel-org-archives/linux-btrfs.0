Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46103 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752623AbdBCIVT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 03:21:19 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 01B9A47B152B
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Feb 2017 16:20:33 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs: raid56: Don't keep rbio for later steal
Date: Fri, 3 Feb 2017 16:20:22 +0800
Message-ID: <20170203082023.3577-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
References: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs raid56 will keep raid56 rbio even all its IO is
done.
This may save some time allocating rbio, but it can cause deadly
use-after-free bug, for the following case:

Original fs: 4 devices RAID5

       Process A                 |          Process B
--------------------------------------------------------------------------
                                 |  Start device replace
                                 |    Now the fs has 5 devices
                                 |    devid 0: replace device
                                 |    devid 1~4: old devices
btrfs_map_bio()                  |
|- __btrfs_map_block()           |
|    bbio has 5 stripes          |
|    including devid 0           |
|- raid56_parity_write()         |
                                 |
raid_write_end_io()              |
|- rbio_orig_end_io()            |
   |- unlock_stripe()            |
       Keeps the old rbio for    |
       later steal, which has    |
       stripe for devid 0        |
                                 |  Cancel device replace
                                 |    Now the fs has 4 devices
                                 |    devid 0 is freed
Some IO happens                  |
raid_write_end_io()              |
|- rbio_orig_end_io()            |
   |- unlock_stripe()            |
      |- steal_rbio()            |
           Use old rbio, whose   |
           bbio has freed devid 0|
           stripe                |
Any access to rbio->bbio will    |
cause general protection or NULL |
pointer dereference              |

Such bug can already be triggered by fstests btrfs/069 for RAID5/6
profiles.

Fix it by not keeping old rbio in unlock_stripe(), so we just free the
finished rbio and rbio->bbio, so above problem wont' happen.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 453eefdcb591..aba82b95ec73 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -776,7 +776,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 	int bucket;
 	struct btrfs_stripe_hash *h;
 	unsigned long flags;
-	int keep_cache = 0;
 
 	bucket = rbio_bucket(rbio);
 	h = rbio->fs_info->stripe_hash_table->table + bucket;
@@ -788,19 +787,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 	spin_lock(&rbio->bio_list_lock);
 
 	if (!list_empty(&rbio->hash_list)) {
-		/*
-		 * if we're still cached and there is no other IO
-		 * to perform, just leave this rbio here for others
-		 * to steal from later
-		 */
-		if (list_empty(&rbio->plug_list) &&
-		    test_bit(RBIO_CACHE_BIT, &rbio->flags)) {
-			keep_cache = 1;
-			clear_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
-			BUG_ON(!bio_list_empty(&rbio->bio_list));
-			goto done;
-		}
-
 		list_del_init(&rbio->hash_list);
 		atomic_dec(&rbio->refs);
 
@@ -848,13 +834,11 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			goto done_nolock;
 		}
 	}
-done:
 	spin_unlock(&rbio->bio_list_lock);
 	spin_unlock_irqrestore(&h->lock, flags);
 
 done_nolock:
-	if (!keep_cache)
-		remove_rbio_from_cache(rbio);
+	remove_rbio_from_cache(rbio);
 }
 
 static void __free_raid_bio(struct btrfs_raid_bio *rbio)
-- 
2.11.0



