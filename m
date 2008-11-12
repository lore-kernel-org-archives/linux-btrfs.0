From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix race in btrfs_mark_extent_written
Date: Wed, 12 Nov 2008 17:04:46 +0800
Message-ID: <491A9C2E.1070603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When extent needs to be split, btrfs_mark_extent_written
truncates the extent at first, then inserts a new extent
and increases the reference count. The race happens if
someone else deletes the old extent before the new extent
is inserted. The fix here is increase the reference count
in advance. This race is similar to the race in
btrfs_drop_extents that fixed a few days ago. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/file.c 4/fs/btrfs/file.c
--- 1/fs/btrfs/file.c	2008-11-12 08:06:09.000000000 +0800
+++ 4/fs/btrfs/file.c	2008-11-12 13:13:03.000000000 +0800
@@ -746,6 +746,7 @@ int btrfs_mark_extent_written(struct btr
 	u64 other_end;
 	u64 split = start;
 	u64 locked_end = end;
+	u64 orig_parent;
 	int extent_type;
 	int split_end = 1;
 	int ret;
@@ -890,6 +891,12 @@ again:
 	}
 
 	btrfs_mark_buffer_dirty(leaf);
+
+	orig_parent = leaf->start;
+	ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
+				   orig_parent, root->root_key.objectid,
+				   trans->transid, inode->i_ino);
+	BUG_ON(ret);
 	btrfs_release_path(root, path);
 
 	key.offset = start;
@@ -910,10 +917,13 @@ again:
 	btrfs_set_file_extent_encryption(leaf, fi, 0);
 	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
 
-	ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes,
-				   leaf->start, root->root_key.objectid,
-				   trans->transid, inode->i_ino);
-	BUG_ON(ret);
+	if (orig_parent != leaf->start) {
+		ret = btrfs_update_extent_ref(trans, root, bytenr,
+					      orig_parent, leaf->start,
+					      root->root_key.objectid,
+					      trans->transid, inode->i_ino);
+		BUG_ON(ret);
+	}
 done:
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(root, path);
