Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33533 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934526AbdBQOoU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:20 -0500
Received: by mail-wm0-f66.google.com with SMTP id v77so2937906wmv.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:20 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 33/38] btrfs: Make btrfs_extent_item_to_extent_map take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:24 +0200
Message-Id: <1487342609-20652-34-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     | 2 +-
 fs/btrfs/file-item.c | 9 ++++-----
 fs/btrfs/inode.c     | 2 +-
 fs/btrfs/ioctl.c     | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cfa63b13d247..d44d414a2127 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3081,7 +3081,7 @@ int btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 		       u64 file_start, int contig);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
-void btrfs_extent_item_to_extent_map(struct inode *inode,
+void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     const struct btrfs_path *path,
 				     struct btrfs_file_extent_item *fi,
 				     const bool new_inline,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 71ed7f051685..640341ab692c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -930,14 +930,14 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	goto out;
 }
 
-void btrfs_extent_item_to_extent_map(struct inode *inode,
+void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     const struct btrfs_path *path,
 				     struct btrfs_file_extent_item *fi,
 				     const bool new_inline,
 				     struct extent_map *em)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf = path->nodes[0];
 	const int slot = path->slots[0];
 	struct btrfs_key key;
@@ -1003,7 +1003,6 @@ void btrfs_extent_item_to_extent_map(struct inode *inode,
 	} else {
 		btrfs_err(fs_info,
 			  "unknown file extent item type %d, inode %llu, offset %llu, root %llu",
-			  type, btrfs_ino(BTRFS_I(inode)), extent_start,
-			  root->root_key.objectid);
+			  type, btrfs_ino(inode), extent_start, root->root_key.objectid);
 	}
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bf7d10e15bd..5545a49a3396 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6853,7 +6853,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 		goto not_found_em;
 	}
 
-	btrfs_extent_item_to_extent_map(inode, path, item, new_inline, em);
+	btrfs_extent_item_to_extent_map(BTRFS_I(inode), path, item, new_inline, em);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9f712207a7db..f907853e1c47 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3323,7 +3323,7 @@ static void clone_update_extent_map(struct inode *inode,
 
 		fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_file_extent_item);
-		btrfs_extent_item_to_extent_map(inode, path, fi, false, em);
+		btrfs_extent_item_to_extent_map(BTRFS_I(inode), path, fi, false, em);
 		em->generation = -1;
 		if (btrfs_file_extent_type(path->nodes[0], fi) ==
 		    BTRFS_FILE_EXTENT_INLINE)
-- 
2.7.4

