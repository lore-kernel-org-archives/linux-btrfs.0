Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36487 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934351AbdBQOoH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:07 -0500
Received: by mail-wm0-f66.google.com with SMTP id r18so2936480wmd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:07 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 19/38] btrfs: Make btrfs_mark_extent_written take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:10 +0200
Message-Id: <1487342609-20652-20-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/file.c  | 8 ++++----
 fs/btrfs/inode.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4db18e5dc8f9..2bfc2e289f51 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3233,7 +3233,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode, u64 start,
 		       u64 end, int drop_cache);
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
-			      struct inode *inode, u64 start, u64 end);
+			      struct btrfs_inode *inode, u64 start, u64 end);
 int btrfs_release_file(struct inode *inode, struct file *file);
 int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e37b643205e1..8e48094ae831 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1082,10 +1082,10 @@ static int extent_mergeable(struct extent_buffer *leaf, int slot,
  * two or three.
  */
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
-			      struct inode *inode, u64 start, u64 end)
+			      struct btrfs_inode *inode, u64 start, u64 end)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *fi;
@@ -1102,7 +1102,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	int del_slot = 0;
 	int recow;
 	int ret;
-	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	if (!path)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 92e42a063639..ac134d75cd08 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2879,7 +2879,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		compress_type = ordered_extent->compress_type;
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
-		ret = btrfs_mark_extent_written(trans, inode,
+		ret = btrfs_mark_extent_written(trans, BTRFS_I(inode),
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
 						logical_len);
-- 
2.7.4

