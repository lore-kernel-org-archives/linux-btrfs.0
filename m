Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34909 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755031AbdIGSYO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2017 14:24:14 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v87IODaF012037
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v87IODKv031628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v87IOD7c004250
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Sep 2017 18:24:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: remove nr_async_bios
Date: Thu,  7 Sep 2017 11:22:20 -0600
Message-Id: <20170907172222.20444-2-bo.li.liu@oracle.com>
In-Reply-To: <20170907172222.20444-1-bo.li.liu@oracle.com>
References: <20170907172222.20444-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was intended to congest higher layers to not send bios, but as

1) the congested bit has been taken by writeback
2) and no one is waiting for %nr_async_bios down to zero,

we can safely remove this now.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h   |  1 -
 fs/btrfs/disk-io.c |  1 -
 fs/btrfs/volumes.c | 14 --------------
 3 files changed, 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f3eb7b..27cd882 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -881,7 +881,6 @@ struct btrfs_fs_info {
 
 	atomic_t nr_async_submits;
 	atomic_t async_submit_draining;
-	atomic_t nr_async_bios;
 	atomic_t async_delalloc_pages;
 	atomic_t open_ioctl_trans;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f45b61f..95583e2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2657,7 +2657,6 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->nr_async_submits, 0);
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->async_submit_draining, 0);
-	atomic_set(&fs_info->nr_async_bios, 0);
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bd679bc..6e9df4d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -450,13 +450,6 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 		pending = pending->bi_next;
 		cur->bi_next = NULL;
 
-		/*
-		 * atomic_dec_return implies a barrier for waitqueue_active
-		 */
-		if (atomic_dec_return(&fs_info->nr_async_bios) < limit &&
-		    waitqueue_active(&fs_info->async_submit_wait))
-			wake_up(&fs_info->async_submit_wait);
-
 		BUG_ON(atomic_read(&cur->__bi_cnt) == 0);
 
 		/*
@@ -6132,13 +6125,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
 		return;
 	}
 
-	/*
-	 * nr_async_bios allows us to reliably return congestion to the
-	 * higher layers.  Otherwise, the async bio makes it appear we have
-	 * made progress against dirty pages when we've really just put it
-	 * on a queue for later
-	 */
-	atomic_inc(&fs_info->nr_async_bios);
 	WARN_ON(bio->bi_next);
 	bio->bi_next = NULL;
 
-- 
2.9.4

