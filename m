Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44813 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3H3TLZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 15:11:25 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CC8289A068A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 13:11:24 -0600 (MDT)
Received: from CAS2.int.fusionio.com ([10.101.1.41]) by mx1.fusionio.com with ESMTP id hiAWzqR1bMuo0sCk (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 13:11:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fixup error handling in btrfs_reloc_cow
Date: Fri, 30 Aug 2013 15:11:21 -0400
Message-ID: <1377889881-1686-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we failed to actually allocate the correct size of the extent to relocate we
will end up in an infinite loop because we won't return an error, we'll just
move on to the next extent.  So fix this up by returning an error, and then fix
all the callers to return an error up the stack rather than BUG_ON()'ing.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.c      |    7 +++++--
 fs/btrfs/ctree.h      |    6 +++---
 fs/btrfs/relocation.c |   41 ++++++++++++++++++++++++-----------------
 3 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6434672..61b5bcd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1005,8 +1005,11 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	if (root->ref_cows)
-		btrfs_reloc_cow_block(trans, root, buf, cow);
+	if (root->ref_cows) {
+		ret = btrfs_reloc_cow_block(trans, root, buf, cow);
+		if (ret)
+			return ret;
+	}
 
 	if (buf == root->node) {
 		WARN_ON(parent && parent != buf);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3c1da6f..2491ba0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3939,9 +3939,9 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
 int btrfs_recover_relocation(struct btrfs_root *root);
 int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len);
-void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct extent_buffer *buf,
-			   struct extent_buffer *cow);
+int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, struct extent_buffer *buf,
+			  struct extent_buffer *cow);
 void btrfs_reloc_pre_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending,
 			      u64 *bytes_to_reserve);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index aacc212..09b2b9a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1548,7 +1548,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	       btrfs_file_extent_other_encoding(leaf, fi));
 
 	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi)) {
-		ret = 1;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -1579,7 +1579,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 	u64 end;
 	u32 nritems;
 	u32 i;
-	int ret;
+	int ret = 0;
 	int first = 1;
 	int dirty = 0;
 
@@ -1642,11 +1642,13 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 
 		ret = get_new_location(rc->data_inode, &new_bytenr,
 				       bytenr, num_bytes);
-		if (ret > 0) {
-			WARN_ON(1);
-			continue;
+		if (ret) {
+			/*
+			 * Don't have to abort since we've not changed anything
+			 * in the file extent yet.
+			 */
+			break;
 		}
-		BUG_ON(ret < 0);
 
 		btrfs_set_file_extent_disk_bytenr(leaf, fi, new_bytenr);
 		dirty = 1;
@@ -1656,18 +1658,24 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 					   num_bytes, parent,
 					   btrfs_header_owner(leaf),
 					   key.objectid, key.offset, 1);
-		BUG_ON(ret);
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
+			break;
+		}
 
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					parent, btrfs_header_owner(leaf),
 					key.objectid, key.offset, 1);
-		BUG_ON(ret);
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
+			break;
+		}
 	}
 	if (dirty)
 		btrfs_mark_buffer_dirty(leaf);
 	if (inode)
 		btrfs_add_delayed_iput(inode);
-	return 0;
+	return ret;
 }
 
 static noinline_for_stack
@@ -4499,19 +4507,19 @@ out:
 	return ret;
 }
 
-void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct extent_buffer *buf,
-			   struct extent_buffer *cow)
+int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, struct extent_buffer *buf,
+			  struct extent_buffer *cow)
 {
 	struct reloc_control *rc;
 	struct backref_node *node;
 	int first_cow = 0;
 	int level;
-	int ret;
+	int ret = 0;
 
 	rc = root->fs_info->reloc_ctl;
 	if (!rc)
-		return;
+		return 0;
 
 	BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
 	       root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
@@ -4547,10 +4555,9 @@ void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 			rc->nodes_relocated += buf->len;
 	}
 
-	if (level == 0 && first_cow && rc->stage == UPDATE_DATA_PTRS) {
+	if (level == 0 && first_cow && rc->stage == UPDATE_DATA_PTRS)
 		ret = replace_file_extents(trans, rc, root, cow);
-		BUG_ON(ret);
-	}
+	return ret;
 }
 
 /*
-- 
1.7.7.6

