Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36886 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162302Ab3DEUuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 16:50:12 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 16AE87C0694
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2013 14:50:12 -0600 (MDT)
Received: from mail1.int.fusionio.com ([10.101.1.21]) by mx2.fusionio.com with ESMTP id T5fgKVuUn9naTTMV (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2013 14:50:11 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make sure nbytes are right after log replay V2
Date: Fri, 5 Apr 2013 16:50:09 -0400
Message-ID: <1365195009-2156-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While trying to track down a tree log replay bug I noticed that fsck was always
complaining about nbytes not being right for our fsynced file.  That is because
the new fsync stuff doesn't wait for ordered extents to complete, so the inodes
nbytes are not necessarily updated properly when we log it.  So to fix this we
need to set nbytes to whatever it is on the inode that is on disk, so when we
replay the extents we can just add the bytes that are being added as we replay
the extent.  This makes it work for the case that we have the wrong nbytes or
the case that we logged everything and nbytes is actually correct.  With this
I'm no longer getting nbytes errors out of btrfsck.  Thanks,

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: Only set nbytes if the extent isn't a hole.

 fs/btrfs/tree-log.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 83d4e1d..f728eeb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -317,6 +317,7 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 	unsigned long src_ptr;
 	unsigned long dst_ptr;
 	int overwrite_root = 0;
+	bool inode_item = key->type == BTRFS_INODE_ITEM_KEY;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 		overwrite_root = 1;
@@ -326,6 +327,9 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 
 	/* look for the key in the destination tree */
 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+
 	if (ret == 0) {
 		char *src_copy;
 		char *dst_copy;
@@ -367,6 +371,30 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 			return 0;
 		}
 
+		/*
+		 * We need to load the old nbytes into the inode so when we
+		 * replay the extents we've logged we get the right nbytes.
+		 */
+		if (inode_item) {
+			struct btrfs_inode_item *item;
+			u64 nbytes;
+
+			item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					      struct btrfs_inode_item);
+			nbytes = btrfs_inode_nbytes(path->nodes[0], item);
+			item = btrfs_item_ptr(eb, slot,
+					      struct btrfs_inode_item);
+			btrfs_set_inode_nbytes(eb, item, nbytes);
+		}
+	} else if (inode_item) {
+		struct btrfs_inode_item *item;
+
+		/*
+		 * New inode, set nbytes to 0 so that the nbytes comes out
+		 * properly when we replay the extents.
+		 */
+		item = btrfs_item_ptr(eb, slot, struct btrfs_inode_item);
+		btrfs_set_inode_nbytes(eb, item, 0);
 	}
 insert:
 	btrfs_release_path(path);
@@ -486,7 +514,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	int found_type;
 	u64 extent_end;
 	u64 start = key->offset;
-	u64 saved_nbytes;
+	u64 nbytes = 0;
 	struct btrfs_file_extent_item *item;
 	struct inode *inode = NULL;
 	unsigned long size;
@@ -496,10 +524,19 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	found_type = btrfs_file_extent_type(eb, item);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
-	    found_type == BTRFS_FILE_EXTENT_PREALLOC)
-		extent_end = start + btrfs_file_extent_num_bytes(eb, item);
-	else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		nbytes = btrfs_file_extent_num_bytes(eb, item);
+		extent_end = start + nbytes;
+
+		/*
+		 * We don't add to the inodes nbytes if we are prealloc or a
+		 * hole.
+		 */
+		if (btrfs_file_extent_disk_bytenr(eb, item) == 0)
+			nbytes = 0;
+	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size = btrfs_file_extent_inline_len(eb, item);
+		nbytes = btrfs_file_extent_ram_bytes(eb, item);
 		extent_end = ALIGN(start + size, root->sectorsize);
 	} else {
 		ret = 0;
@@ -548,7 +585,6 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, root, inode, start, extent_end, 1);
 	BUG_ON(ret);
@@ -635,7 +671,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 	}
 
-	inode_set_bytes(inode, saved_nbytes);
+	inode_add_bytes(inode, nbytes);
 	ret = btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
-- 
1.7.7.6

