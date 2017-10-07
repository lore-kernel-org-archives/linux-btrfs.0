Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:47987 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdJGOsJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Oct 2017 10:48:09 -0400
Subject: [PATCH] btrfs: Fix bool initialization/comparison
From: Thomas Meyer <thomas@m3y3r.de>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1507383097083-1296921724-3-diffsplit-thomas@m3y3r.de>
References: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de>
Date: Sat, 07 Oct 2017 16:02:21 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bool initializations should use true and false. Bool tests don't need
comparisons.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6958,7 +6958,7 @@ static int __btrfs_free_extent(struct bt
 	BUG_ON(!is_data && refs_to_drop != 1);
 
 	if (is_data)
-		skinny_metadata = 0;
+		skinny_metadata = false;
 
 	ret = lookup_extent_backref(trans, info, path, &iref,
 				    bytenr, num_bytes, parent,
@@ -9311,7 +9311,7 @@ out:
 	 * don't have it in the radix (like when we recover after a power fail
 	 * or unmount) so we don't leak memory.
 	 */
-	if (!for_reloc && root_dropped == false)
+	if (!for_reloc && !root_dropped)
 		btrfs_add_dead_root(root);
 	if (err && err != -EAGAIN)
 		btrfs_handle_fs_error(fs_info, err, NULL);
diff -u -p a/fs/btrfs/file.c b/fs/btrfs/file.c
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2046,7 +2046,7 @@ int btrfs_sync_file(struct file *file, l
 	struct btrfs_trans_handle *trans;
 	struct btrfs_log_ctx ctx;
 	int ret = 0, err;
-	bool full_sync = 0;
+	bool full_sync = false;
 	u64 len;
 
 	/*
diff -u -p a/fs/btrfs/inode.c b/fs/btrfs/inode.c
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4439,9 +4439,9 @@ int btrfs_truncate_inode_items(struct bt
 	int err = 0;
 	u64 ino = btrfs_ino(BTRFS_I(inode));
 	u64 bytes_deleted = 0;
-	bool be_nice = 0;
-	bool should_throttle = 0;
-	bool should_end = 0;
+	bool be_nice = false;
+	bool should_throttle = false;
+	bool should_end = false;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4451,7 +4451,7 @@ int btrfs_truncate_inode_items(struct bt
 	 */
 	if (!btrfs_is_free_space_inode(BTRFS_I(inode)) &&
 	    test_bit(BTRFS_ROOT_REF_COWS, &root->state))
-		be_nice = 1;
+		be_nice = true;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -4657,7 +4657,7 @@ delete:
 		} else {
 			break;
 		}
-		should_throttle = 0;
+		should_throttle = false;
 
 		if (found_extent &&
 		    (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
@@ -4676,11 +4676,11 @@ delete:
 			if (be_nice) {
 				if (truncate_space_check(trans, root,
 							 extent_num_bytes)) {
-					should_end = 1;
+					should_end = true;
 				}
 				if (btrfs_should_throttle_delayed_refs(trans,
 								       fs_info))
-					should_throttle = 1;
+					should_throttle = true;
 			}
 		}
 
