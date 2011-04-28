From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: return error to caller if read_one_inode() fails
Date: Thu, 28 Apr 2011 18:10:23 +0900
Message-ID: <201104280910.AA00018@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When read_one_inode() fails, error code is returned to caller instead
of BUG_ON().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/tree-log.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f997ec0..1bce4fa 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -678,7 +678,10 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	btrfs_release_path(root, path);
 
 	inode = read_one_inode(root, location.objectid);
-	BUG_ON(!inode);
+	if (!inode) {
+		kfree(name);
+		return -EIO;
+	}
 
 	ret = link_to_fixup_dir(trans, root, path, location.objectid);
 	BUG_ON(ret);
@@ -817,7 +820,10 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 		return -ENOENT;
 
 	inode = read_one_inode(root, key->objectid);
-	BUG_ON(!inode);
+	if (!inode) {
+		iput(dir);
+		return -EIO;
+	}
 
 	ref_ptr = btrfs_item_ptr_offset(eb, slot);
 	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
@@ -1054,7 +1060,8 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 
 		btrfs_release_path(root, path);
 		inode = read_one_inode(root, key.offset);
-		BUG_ON(!inode);
+		if (!inode)
+			return -EIO;
 
 		ret = fixup_inode_link_count(trans, root, inode);
 		BUG_ON(ret);
@@ -1088,7 +1095,8 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 	struct inode *inode;
 
 	inode = read_one_inode(root, objectid);
-	BUG_ON(!inode);
+	if (!inode)
+		return -EIO;
 
 	key.objectid = BTRFS_TREE_LOG_FIXUP_OBJECTID;
 	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
@@ -1175,7 +1183,8 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	int ret;
 
 	dir = read_one_inode(root, key->objectid);
-	BUG_ON(!dir);
+	if (!dir)
+		return -EIO;
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
@@ -1431,7 +1440,10 @@ again:
 			btrfs_release_path(root, path);
 			btrfs_release_path(log, log_path);
 			inode = read_one_inode(root, location.objectid);
-			BUG_ON(!inode);
+			if (!inode) {
+				kfree(name);
+				return -EIO;
+			}
 
 			ret = link_to_fixup_dir(trans, root,
 						path, location.objectid);

