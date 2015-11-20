Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161932AbbKTD1W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:27:22 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdX022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 24/25] btrfs-progs: convert: Strictly avoid meta or system chunk allocation
Date: Fri, 20 Nov 2015 11:24:28 +0800
Message-Id: <1447989869-24739-25-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, btrfs-convert only rely on large enough initial
system/metadata chunk size to ensure no newer system/meta chunk will be
created.

But that's not safe enough. So add two new members in fs_info,
avoid_sys/meta_chunk_alloc flags to prevent any newer system or meta
chunks to be created before init_btrfs_v2().

BTW, old fs_info->system_allocs is not the same, as if set it to -1, it
will only force chunk tree blocks to be allocated from metadata.
Such wired design will be handled in later cleanup patchset, but not
now.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 9 +++++++++
 ctree.h         | 2 ++
 extent-tree.c   | 9 +++++++++
 3 files changed, 20 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 1d09141..a81345d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2114,6 +2114,13 @@ static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, ext2_filsys ext2_fs,
 	int found_root = 0;
 	int ret;
 
+	/*
+	 * Don't alloc any metadata chunk, as we don't want any
+	 * chunk allocated before all data chunks are inserted.
+	 * Or we can screw up the chunk type.
+	 */
+	fs_info->avoid_meta_chunk_alloc = 1;
+	fs_info->avoid_sys_chunk_alloc = 1;
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
 	ret = btrfs_fix_block_accounting(trans, root);
@@ -2185,6 +2192,8 @@ static int init_btrfs_v2(struct btrfs_mkfs_config *cfg, ext2_filsys ext2_fs,
 
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
+	fs_info->avoid_meta_chunk_alloc = 0;
+	fs_info->avoid_sys_chunk_alloc = 0;
 err:
 	return ret;
 }
diff --git a/ctree.h b/ctree.h
index 6e3e919..41b5e8f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1015,6 +1015,8 @@ struct btrfs_fs_info {
 	unsigned int quota_enabled:1;
 	unsigned int suppress_check_block_errors:1;
 	unsigned int ignore_fsid_mismatch:1;
+	unsigned int avoid_meta_chunk_alloc:1;
+	unsigned int avoid_sys_chunk_alloc:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index a2f8fee..c0b4442 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1904,6 +1904,15 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	    thresh)
 		return 0;
 
+	/*
+	 * Avoid allocate any chunk forbit by fs_info
+	 */
+	if (extent_root->fs_info->avoid_meta_chunk_alloc &&
+	    (flags & BTRFS_BLOCK_GROUP_METADATA))
+		return 0;
+	if (extent_root->fs_info->avoid_sys_chunk_alloc &&
+	    (flags & BTRFS_BLOCK_GROUP_SYSTEM))
+		return 0;
 	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes,
 	                        space_info->flags);
 	if (ret == -ENOSPC) {
-- 
2.6.2

