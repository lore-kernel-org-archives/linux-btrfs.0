Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15517 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755251AbbLAHOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:35 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 07CE640444C6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:15 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 24/25] btrfs-progs: convert: Strictly avoid meta or system chunk allocation
Date: Tue,  1 Dec 2015 15:11:44 +0800
Message-Id: <1448953905-28673-25-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs-convert only rely on large enough initial
system/metadata chunk size to ensure no newer system/meta chunk will be
created.

But that's not safe enough. So add two new members in fs_info,
avoid_sys/meta_chunk_alloc flags to prevent any newer system or meta
chunks to be created before init_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c |  9 +++++++++
 ctree.h         |  3 +++
 extent-tree.c   | 10 ++++++++++
 3 files changed, 22 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index efa3b02..333f413 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2322,6 +2322,13 @@ static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 
+	/*
+	 * Don't alloc any metadata/system chunk, as we don't want
+	 * any meta/sys chunk allcated before all data chunks are inserted.
+	 * Or we screw up the chunk layout just like the old implement.
+	 */
+	fs_info->avoid_sys_chunk_alloc = 1;
+	fs_info->avoid_meta_chunk_alloc = 1;
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
 	ret = btrfs_fix_block_accounting(trans, root);
@@ -2359,6 +2366,8 @@ static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, struct btrfs_root *root,
 		goto err;
 
 	ret = btrfs_commit_transaction(trans, root);
+	fs_info->avoid_sys_chunk_alloc = 0;
+	fs_info->avoid_meta_chunk_alloc = 0;
 err:
 	return ret;
 }
diff --git a/ctree.h b/ctree.h
index 6e3e919..10038be 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1015,6 +1015,9 @@ struct btrfs_fs_info {
 	unsigned int quota_enabled:1;
 	unsigned int suppress_check_block_errors:1;
 	unsigned int ignore_fsid_mismatch:1;
+	unsigned int avoid_meta_chunk_alloc:1;
+	unsigned int avoid_sys_chunk_alloc:1;
+
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index bfc9060..2883785 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1904,6 +1904,16 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	    thresh)
 		return 0;
 
+	/*
+	 * Avoid allocating given chunk type
+	 */
+	if (extent_root->fs_info->avoid_meta_chunk_alloc &&
+	    (flags & BTRFS_BLOCK_GROUP_METADATA))
+		return 0;
+	if (extent_root->fs_info->avoid_sys_chunk_alloc &&
+	    (flags & BTRFS_BLOCK_GROUP_SYSTEM))
+		return 0;
+
 	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes,
 	                        space_info->flags);
 	if (ret == -ENOSPC) {
-- 
2.6.2



