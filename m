Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:52688 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbeHWDD2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 23:03:28 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: set leave_spinning in btrfs_get_extent
Date: Thu, 23 Aug 2018 07:36:18 +0800
Message-Id: <1534980978-91392-2-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unless it's going to read inline extents from btree leaf to page,
btrfs_get_extent won't sleep during the period of holding path lock.

This sets leave_spinning at first and sets path to blocking mode right
before reading inline extent if that's the case.  The benefit is that a
path in spinning mode typically has less impact (faster) on waiters
rather than that in blocking mode.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 10e86f7b5398..4219be9c21f9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6843,6 +6843,12 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	 */
 	path->reada = READA_FORWARD;
 
+	/*
+	 * Unless we're going to uncompress inline extent, no sleep would
+	 * happen.
+	 */
+	path->leave_spinning = 1;
+
 	ret = btrfs_lookup_file_extent(NULL, root, path, objectid, start, 0);
 	if (ret < 0) {
 		err = ret;
@@ -6945,6 +6951,8 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		em->orig_block_len = em->len;
 		em->orig_start = em->start;
 		ptr = btrfs_file_extent_inline_start(item) + extent_offset;
+
+		btrfs_set_path_blocking(path);
 		if (!PageUptodate(page)) {
 			if (btrfs_file_extent_compression(leaf, item) !=
 			    BTRFS_COMPRESS_NONE) {
@@ -6992,10 +7000,10 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	err = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
 	write_unlock(&em_tree->lock);
 out:
+	btrfs_free_path(path);
 
 	trace_btrfs_get_extent(root, inode, em);
 
-	btrfs_free_path(path);
 	if (err) {
 		free_extent_map(em);
 		return ERR_PTR(err);
-- 
1.8.3.1
