Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:45957 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbeHYJ0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Aug 2018 05:26:02 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix alignment in declaration and prototype of btrfs_get_extent
Date: Sat, 25 Aug 2018 13:47:59 +0800
Message-Id: <1535176079-78283-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes btrfs_get_extent to be consistent with our existing
declaration style.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.h | 4 ++--
 fs/btrfs/inode.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1aeed3c0e949..00e506de70ba 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3177,8 +3177,8 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-		struct page *page, size_t pg_offset,
-		u64 start, u64 end, int create);
+				    struct page *page, size_t pg_offset,
+				    u64 start, u64 end, int create);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1e0af0cc56fc..31d43355f052 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6787,9 +6787,9 @@ static noinline int uncompress_inline(struct btrfs_path *path,
  * This also copies inline extents directly into the page.
  */
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-		struct page *page,
-	    size_t pg_offset, u64 start, u64 len,
-		int create)
+				    struct page *page,
+				    size_t pg_offset, u64 start, u64 len,
+				    int create)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int ret;
-- 
1.8.3.1
