Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50773 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2HaFik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:38:40 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5cbbU019070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:38 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5cb1J016617
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:37 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5caUv015285
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:38:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs: cleanup for unused ref cache stuff
Date: Fri, 31 Aug 2012 13:36:55 +0800
Message-Id: <1346391419-4278-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
References: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
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

