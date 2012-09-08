Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44678 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2IHCDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2012 22:03:31 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, dave@jikos.cz
Subject: [PATCH v2 2/6] Btrfs: cleanup for unused ref cache stuff
Date: Sat,  8 Sep 2012 10:01:26 +0800
Message-Id: <1347069690-30223-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
References: <1347069690-30223-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: liubo <liubo2009@cn.fujitsu.com>

As ref cache has been removed from btrfs, there is no user on
its lock and its check.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h   |    3 ---
 fs/btrfs/disk-io.c |    5 -----
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d195b5..4ae593c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1366,9 +1366,6 @@ struct btrfs_fs_info {
 	struct rb_root defrag_inodes;
 	atomic_t defrag_running;
 
-	spinlock_t ref_cache_lock;
-	u64 total_ref_cache_size;
-
 	/*
 	 * these three are in extended format (availability of single
 	 * chunks is denoted by BTRFS_AVAIL_ALLOC_BIT_SINGLE bit, other
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22e98e0..bcd1703 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2000,7 +2000,6 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->caching_block_groups);
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->trans_lock);
-	spin_lock_init(&fs_info->ref_cache_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
@@ -3211,10 +3210,6 @@ int close_ctree(struct btrfs_root *root)
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
1.7.7.6

