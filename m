Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44140 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753438AbbFLMir (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 08:38:47 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5CCb0wM017325
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 20:37:00 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: add error handling for scrub_workers_get()
Date: Fri, 12 Jun 2015 20:36:58 +0800
Message-ID: <c088cf536b2932849e86ae4564feb81e28d14b20.1434112598.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Although it is a rare case, we'd better free previous allocated
memory on error.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ab58115..eb35176 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3559,7 +3559,6 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 						int is_dev_replace)
 {
-	int ret = 0;
 	unsigned int flags = WQ_FREEZABLE | WQ_UNBOUND;
 	int max_active = fs_info->thread_pool_size;
 
@@ -3572,27 +3571,29 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
 			fs_info->scrub_workers =
 				btrfs_alloc_workqueue("btrfs-scrub", flags,
 						      max_active, 4);
-		if (!fs_info->scrub_workers) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!fs_info->scrub_workers)
+			goto fail_scrub_workers;
+
 		fs_info->scrub_wr_completion_workers =
 			btrfs_alloc_workqueue("btrfs-scrubwrc", flags,
 					      max_active, 2);
-		if (!fs_info->scrub_wr_completion_workers) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!fs_info->scrub_wr_completion_workers)
+			goto fail_scrub_wr_completion_workers;
+
 		fs_info->scrub_nocow_workers =
 			btrfs_alloc_workqueue("btrfs-scrubnc", flags, 1, 0);
-		if (!fs_info->scrub_nocow_workers) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!fs_info->scrub_nocow_workers)
+			goto fail_scrub_nocow_workers;
 	}
 	++fs_info->scrub_workers_refcnt;
-out:
-	return ret;
+	return 0;
+
+fail_scrub_nocow_workers:
+	btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
+fail_scrub_wr_completion_workers:
+	btrfs_destroy_workqueue(fs_info->scrub_workers);
+fail_scrub_workers:
+	return -ENOMEM;
 }
 
 static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
-- 
1.8.5.1

