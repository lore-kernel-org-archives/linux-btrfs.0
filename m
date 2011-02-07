From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH v2] btrfs: fix return value check of btrfs_start_transaction()
Date: Mon, 07 Feb 2011 14:12:16 +0900
Message-ID: <201102070512.AA00007@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The error check of btrfs_start_transaction() is added, and the mistake
of the error check on several places is corrected. 

[NOTE]
This is a short-term solution.
 With this patch:
  - The panic isn't done by the NULL pointer reference etc. (even if
    BUG_ON() is increased temporarily)
  - The error code is returned in the place where the error can be
    easily returned.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
V1->V2:
 - In btrfs_init_new_device(), if btrfs_start_transaction() failed,
   it is necessary to free device->name.

 fs/btrfs/extent-tree.c |    7 +++++--
 fs/btrfs/inode.c       |    1 +
 fs/btrfs/ioctl.c       |   10 ++++++++--
 fs/btrfs/relocation.c  |    3 +++
 fs/btrfs/super.c       |    2 ++
 fs/btrfs/tree-log.c    |    1 +
 fs/btrfs/volumes.c     |   20 ++++++++++++++++++--
 7 files changed, 38 insertions(+), 6 deletions(-)

diff -urNp linux-2.6.38-rc3/fs/btrfs/extent-tree.c linux-2.6.38-rc3.new/fs/btrfs/extent-tree.c
--- linux-2.6.38-rc3/fs/btrfs/extent-tree.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/extent-tree.c	2011-02-07 11:53:34.000000000 +0900
@@ -6221,6 +6221,8 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	BUG_ON(!wc);
 
 	trans = btrfs_start_transaction(tree_root, 0);
+	BUG_ON(IS_ERR(trans));
+
 	if (block_rsv)
 		trans->block_rsv = block_rsv;
 
@@ -6318,6 +6320,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 
 			btrfs_end_transaction_throttle(trans, tree_root);
 			trans = btrfs_start_transaction(tree_root, 0);
+			BUG_ON(IS_ERR(trans));
 			if (block_rsv)
 				trans->block_rsv = block_rsv;
 		}
@@ -7535,7 +7538,7 @@ int btrfs_cleanup_reloc_trees(struct btr
 
 	if (found) {
 		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 		ret = btrfs_commit_transaction(trans, root);
 		BUG_ON(ret);
 	}
@@ -7779,7 +7782,7 @@ static noinline int relocate_one_extent(
 
 
 	trans = btrfs_start_transaction(extent_root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
diff -urNp linux-2.6.38-rc3/fs/btrfs/inode.c linux-2.6.38-rc3.new/fs/btrfs/inode.c
--- linux-2.6.38-rc3/fs/btrfs/inode.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/inode.c	2011-02-07 11:53:34.000000000 +0900
@@ -2354,6 +2354,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 */
 		if (is_bad_inode(inode)) {
 			trans = btrfs_start_transaction(root, 0);
+			BUG_ON(IS_ERR(trans));
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
diff -urNp linux-2.6.38-rc3/fs/btrfs/ioctl.c linux-2.6.38-rc3.new/fs/btrfs/ioctl.c
--- linux-2.6.38-rc3/fs/btrfs/ioctl.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/ioctl.c	2011-02-07 11:53:34.000000000 +0900
@@ -907,6 +907,10 @@ static noinline int btrfs_ioctl_resize(s
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 0);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out_unlock;
+		}
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
 	} else {
@@ -2138,9 +2142,9 @@ static long btrfs_ioctl_default_subvol(s
 	path->leave_spinning = 1;
 
 	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
+	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
-		return -ENOMEM;
+		return PTR_ERR(trans);
 	}
 
 	dir_id = btrfs_super_root_dir(&root->fs_info->super_copy);
@@ -2334,6 +2338,8 @@ static noinline long btrfs_ioctl_start_s
 	u64 transid;
 
 	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	transid = trans->transid;
 	btrfs_commit_transaction_async(trans, root, 0);
 
diff -urNp linux-2.6.38-rc3/fs/btrfs/relocation.c linux-2.6.38-rc3.new/fs/btrfs/relocation.c
--- linux-2.6.38-rc3/fs/btrfs/relocation.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/relocation.c	2011-02-07 11:53:34.000000000 +0900
@@ -2028,6 +2028,7 @@ static noinline_for_stack int merge_relo
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
+		BUG_ON(IS_ERR(trans));
 		trans->block_rsv = rc->block_rsv;
 
 		ret = btrfs_block_rsv_check(trans, root, rc->block_rsv,
@@ -3657,6 +3658,7 @@ static noinline_for_stack int relocate_b
 
 	while (1) {
 		trans = btrfs_start_transaction(rc->extent_root, 0);
+		BUG_ON(IS_ERR(trans));
 
 		if (update_backref_cache(trans, &rc->backref_cache)) {
 			btrfs_end_transaction(trans, rc->extent_root);
@@ -4022,6 +4024,7 @@ static noinline_for_stack int mark_garba
 	int ret;
 
 	trans = btrfs_start_transaction(root->fs_info->tree_root, 0);
+	BUG_ON(IS_ERR(trans));
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
diff -urNp linux-2.6.38-rc3/fs/btrfs/super.c linux-2.6.38-rc3.new/fs/btrfs/super.c
--- linux-2.6.38-rc3/fs/btrfs/super.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/super.c	2011-02-07 11:53:34.000000000 +0900
@@ -623,6 +623,8 @@ int btrfs_sync_fs(struct super_block *sb
 	btrfs_wait_ordered_extents(root, 0, 0);
 
 	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
 }
diff -urNp linux-2.6.38-rc3/fs/btrfs/tree-log.c linux-2.6.38-rc3.new/fs/btrfs/tree-log.c
--- linux-2.6.38-rc3/fs/btrfs/tree-log.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/tree-log.c	2011-02-07 11:53:34.000000000 +0900
@@ -3080,6 +3080,7 @@ int btrfs_recover_log_trees(struct btrfs
 	BUG_ON(!path);
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 0);
+	BUG_ON(IS_ERR(trans));
 
 	wc.trans = trans;
 	wc.pin = 1;
diff -urNp linux-2.6.38-rc3/fs/btrfs/volumes.c linux-2.6.38-rc3.new/fs/btrfs/volumes.c
--- linux-2.6.38-rc3/fs/btrfs/volumes.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.new/fs/btrfs/volumes.c	2011-02-07 11:55:01.000000000 +0900
@@ -1213,6 +1213,10 @@ static int btrfs_rm_dev_item(struct btrf
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1606,6 +1610,13 @@ int btrfs_init_new_device(struct btrfs_r
 	}
 
 	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		kfree(device->name);
+		kfree(device);
+		ret = PTR_ERR(trans);
+		goto error;
+	}
+
 	lock_chunks(root);
 
 	device->writeable = 1;
@@ -1873,7 +1884,7 @@ static int btrfs_relocate_chunk(struct b
 		return ret;
 
 	trans = btrfs_start_transaction(root, 0);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	lock_chunks(root);
 
@@ -2047,7 +2058,7 @@ int btrfs_balance(struct btrfs_root *dev
 		BUG_ON(ret);
 
 		trans = btrfs_start_transaction(dev_root, 0);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 
 		ret = btrfs_grow_device(trans, device, old_size);
 		BUG_ON(ret);
@@ -2213,6 +2224,11 @@ again:
 
 	/* Shrinking succeeded, else we would be at "done". */
 	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto done;
+	}
+
 	lock_chunks(root);
 
 	device->disk_total_bytes = new_size;


