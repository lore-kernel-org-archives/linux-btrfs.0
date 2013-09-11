Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3IKIwD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:52:03 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8prI6019959
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 9/9] btrfs: Replace thread_pool_size with workqueue default value
Date: Wed, 11 Sep 2013 16:52:38 +0800
Message-Id: <1378889558-21514-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original btrfs_workers uses the fs_info->thread_pool_size as the
max_active, and the previous patches followed this way.

But the kernel workqueue has the default value(0) for workqueue,
and workqueue itself has some threshold mechanism to prevent creating
too many threads, so we should use the default value.

Since the thread_pool_size algorithm is not used, related codes should
also be changed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 12 +++++++-----
 fs/btrfs/super.c   |  3 +--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a61e1fe..0446d27 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -750,9 +750,11 @@ int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
 {
-	unsigned long limit = min_t(unsigned long,
-				    info->thread_pool_size,
-				    info->fs_devices->open_devices);
+	unsigned long limit;
+	limit = info->thread_pool_size ?
+		min_t(unsigned long, info->thread_pool_size,
+		      info->fs_devices->open_devices) :
+		info->fs_devices->open_devices;
 	return 256 * limit;
 }
 
@@ -2191,8 +2193,8 @@ int open_ctree(struct super_block *sb,
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
 	spin_lock_init(&fs_info->reada_lock);
 
-	fs_info->thread_pool_size = min_t(unsigned long,
-					  num_online_cpus() + 2, 8);
+	/* use the default value of kernel workqueue */
+	fs_info->thread_pool_size = 0;
 
 	INIT_LIST_HEAD(&fs_info->ordered_roots);
 	spin_lock_init(&fs_info->ordered_root_lock);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 63e653c..ccf412f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -898,8 +898,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (info->alloc_start != 0)
 		seq_printf(seq, ",alloc_start=%llu",
 			   (unsigned long long)info->alloc_start);
-	if (info->thread_pool_size !=  min_t(unsigned long,
-					     num_online_cpus() + 2, 8))
+	if (info->thread_pool_size)
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
 	if (btrfs_test_opt(root, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
-- 
1.8.4

