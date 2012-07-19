Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab2GQKw4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 06:52:56 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6HAqrO4006948
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2012 18:52:53 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup for unused ref cache stuff
Date: Thu, 19 Jul 2012 18:52:43 +0800
Message-Id: <1342695163-28312-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As ref cache has been removed from btrfs, there is no user on
its lock and its check.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |    3 ---
 fs/btrfs/disk-io.c |    5 -----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84ac723..df031fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1256,9 +1256,6 @@ struct btrfs_fs_info {
 	struct rb_root defrag_inodes;
 	atomic_t defrag_running;
 
-	spinlock_t ref_cache_lock;
-	u64 total_ref_cache_size;
-
 	/*
 	 * these three are in extended format (availability of single
 	 * chunks is denoted by BTRFS_AVAIL_ALLOC_BIT_SINGLE bit, other
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 047f637..6975ece 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1910,7 +1910,6 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->caching_block_groups);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->trans_lock);
-	spin_lock_init(&fs_info->ref_cache_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
@@ -3116,10 +3115,6 @@ int close_ctree(struct btrfs_root *root)
 		printk(KERN_INFO "btrfs: at unmount delalloc count %llu\n",
 		       (unsigned long long)fs_info->delalloc_bytes);
 	}
-	if (fs_info->total_ref_cache_size) {
-		printk(KERN_INFO "btrfs: at umount reference cache size %llu\n",
-		       (unsigned long long)fs_info->total_ref_cache_size);
-	}
 
 	free_extent_buffer(fs_info->extent_root->node);
 	free_extent_buffer(fs_info->extent_root->commit_root);
-- 
1.6.5.2

