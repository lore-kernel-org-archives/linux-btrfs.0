Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3K1Fff (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 00:35:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAS5ZNXj008146
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 13:35:33 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] Btrfs-progs: chunk-recover: add new flag to prepare recovering for ordered data chunk
Date: Thu, 28 Nov 2013 13:32:49 +0800
Message-Id: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

When reading block groups we will searching it's corresponding chunk, however, at this
time, some chunks has not been built(data chunks raid0/raid10/raid56), don't bug_on here,
we will try to rebuild these chunks later.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 1 +
 ctree.h         | 1 +
 volumes.c       | 9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index e880bbc..ae0d318 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1197,6 +1197,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 		fprintf(stderr, "Failed to allocate memory for fs_info\n");
 		return ERR_PTR(-ENOMEM);
 	}
+	fs_info->is_chunk_recover = 1;
 
 	fs_info->fs_devices = rc->fs_devices;
 	ret = btrfs_open_devices(fs_info->fs_devices, O_RDWR);
diff --git a/ctree.h b/ctree.h
index 92a396a..9f68862 100644
--- a/ctree.h
+++ b/ctree.h
@@ -977,6 +977,7 @@ struct btrfs_fs_info {
 	int system_allocs;
 	int readonly;
 	int on_restoring;
+	int is_chunk_recover;
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/volumes.c b/volumes.c
index c38da6c..bd01270 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1496,8 +1496,15 @@ int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 	int readonly = 0;
 	int i;
 
+	/*
+	 * During chunk recovering, we may fail to find block group's
+	 * corresponding chunk, we will rebuild it later
+	 */
 	ce = search_cache_extent(&map_tree->cache_tree, chunk_offset);
-	BUG_ON(!ce);
+	if (!root->fs_info->is_chunk_recover)
+		BUG_ON(!ce);
+	else
+		return 0;
 
 	map = container_of(ce, struct map_lookup, ce);
 	for (i = 0; i < map->num_stripes; i++) {
-- 
1.8.0.1

