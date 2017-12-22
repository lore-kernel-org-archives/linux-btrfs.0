Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753008AbdLWA2s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 19:28:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0Slj0055700
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 00:28:47 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2f1cear0g6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 00:28:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0PSLi027885
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 00:25:29 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN0PSsg023815
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 00:25:28 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unused wait in btrfs_stripe_hash
Date: Fri, 22 Dec 2017 16:23:01 -0700
Message-Id: <20171222232301.17979-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In fact nobody is waiting on @wait's waitqueue, it can be safely
removed.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h  |  1 -
 fs/btrfs/raid56.c | 10 ----------
 2 files changed, 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 13c260b..b2e09fe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -679,7 +679,6 @@ enum btrfs_orphan_cleanup_state {
 /* used by the raid56 code to lock stripes for read/modify/write */
 struct btrfs_stripe_hash {
 	struct list_head hash_list;
-	wait_queue_head_t wait;
 	spinlock_t lock;
 };
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 3940906..9fa45e0 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -231,7 +231,6 @@ int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info)
 		cur = h + i;
 		INIT_LIST_HEAD(&cur->hash_list);
 		spin_lock_init(&cur->lock);
-		init_waitqueue_head(&cur->wait);
 	}
 
 	x = cmpxchg(&info->stripe_hash_table, NULL, table);
@@ -815,15 +814,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			}
 
 			goto done_nolock;
-			/*
-			 * The barrier for this waitqueue_active is not needed,
-			 * we're protected by h->lock and can't miss a wakeup.
-			 */
-		} else if (waitqueue_active(&h->wait)) {
-			spin_unlock(&rbio->bio_list_lock);
-			spin_unlock_irqrestore(&h->lock, flags);
-			wake_up(&h->wait);
-			goto done_nolock;
 		}
 	}
 done:
-- 
2.9.4

