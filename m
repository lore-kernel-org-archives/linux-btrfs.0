Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60392 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab2IFKoy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:54 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A2hgH017569
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:02:43 +0800
Message-ID: <504874B4.1090607@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:02:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 06/12] Btrfs: add a new "type" field into the block reservation
 structure
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

Sometimes we need choose the method of the reservation according to the type
of the block reservation, such as the reservation for the delayed inode update.
Now we identify the type just by comparing the address of the reservation
variants, it is very ugly if it is a temporary one because we need compare it
with all the common reservation variants. So we add a new "type" field to keep
the type the reservation variants.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- new patch
---
 fs/btrfs/ctree.h         |   16 +++++++++++++---
 fs/btrfs/delayed-inode.c |    4 ++--
 fs/btrfs/disk-io.c       |   15 +++++++++------
 fs/btrfs/extent-tree.c   |    8 +++++---
 fs/btrfs/inode.c         |    8 ++++----
 fs/btrfs/ioctl.c         |    3 ++-
 fs/btrfs/relocation.c    |    3 ++-
 7 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c38734a..171458a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1028,12 +1028,21 @@ struct btrfs_space_info {
 	wait_queue_head_t wait;
 };
 
+#define	BTRFS_BLOCK_RSV_GLOBAL		1
+#define BTRFS_BLOCK_RSV_DELALLOC	2
+#define BTRFS_BLOCK_RSV_TRANS		3
+#define BTRFS_BLOCK_RSV_CHUNK		4
+#define BTRFS_BLOCK_RSV_DELOPS		5
+#define BTRFS_BLOCK_RSV_EMPTY		6
+#define BTRFS_BLOCK_RSV_TEMP		7
+
 struct btrfs_block_rsv {
 	u64 size;
 	u64 reserved;
 	struct btrfs_space_info *space_info;
 	spinlock_t lock;
-	unsigned int full;
+	unsigned short full;
+	unsigned short type;
 };
 
 /*
@@ -2874,8 +2883,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
-void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv);
-struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root);
+void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
+struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
+					      unsigned short type);
 void btrfs_free_block_rsv(struct btrfs_root *root,
 			  struct btrfs_block_rsv *rsv);
 int btrfs_block_rsv_add(struct btrfs_root *root,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 07d5eeb..eb768c4 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -650,7 +650,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 * we're accounted for.
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
-	    src_rsv != &root->fs_info->delalloc_block_rsv)) {
+			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
 		ret = btrfs_block_rsv_add_noflush(root, dst_rsv, num_bytes);
 		/*
 		 * Since we're under a transaction reserve_metadata_bytes could
@@ -668,7 +668,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 						      num_bytes, 1);
 		}
 		return ret;
-	} else if (src_rsv == &root->fs_info->delalloc_block_rsv) {
+	} else if (src_rsv->type == BTRFS_BLOCK_RSV_DELALLOC) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		if (test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
 				       &BTRFS_I(inode)->runtime_flags)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 29c69e6..0c0f8eb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2017,12 +2017,15 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->space_info);
 	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
 	btrfs_mapping_init(&fs_info->mapping_tree);
-	btrfs_init_block_rsv(&fs_info->global_block_rsv);
-	btrfs_init_block_rsv(&fs_info->delalloc_block_rsv);
-	btrfs_init_block_rsv(&fs_info->trans_block_rsv);
-	btrfs_init_block_rsv(&fs_info->chunk_block_rsv);
-	btrfs_init_block_rsv(&fs_info->empty_block_rsv);
-	btrfs_init_block_rsv(&fs_info->delayed_block_rsv);
+	btrfs_init_block_rsv(&fs_info->global_block_rsv,
+			     BTRFS_BLOCK_RSV_GLOBAL);
+	btrfs_init_block_rsv(&fs_info->delalloc_block_rsv,
+			     BTRFS_BLOCK_RSV_DELALLOC);
+	btrfs_init_block_rsv(&fs_info->trans_block_rsv, BTRFS_BLOCK_RSV_TRANS);
+	btrfs_init_block_rsv(&fs_info->chunk_block_rsv, BTRFS_BLOCK_RSV_CHUNK);
+	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
+	btrfs_init_block_rsv(&fs_info->delayed_block_rsv,
+			     BTRFS_BLOCK_RSV_DELOPS);
 	atomic_set(&fs_info->nr_async_submits, 0);
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->async_submit_draining, 0);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ba58024..840bfee 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4114,13 +4114,15 @@ static int block_rsv_migrate_bytes(struct btrfs_block_rsv *src,
 	return 0;
 }
 
-void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv)
+void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type)
 {
 	memset(rsv, 0, sizeof(*rsv));
 	spin_lock_init(&rsv->lock);
+	rsv->type = type;
 }
 
-struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root)
+struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
+					      unsigned short type)
 {
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4129,7 +4131,7 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root)
 	if (!block_rsv)
 		return NULL;
 
-	btrfs_init_block_rsv(block_rsv);
+	btrfs_init_block_rsv(block_rsv, type);
 	block_rsv->space_info = __find_space_info(fs_info,
 						  BTRFS_BLOCK_GROUP_METADATA);
 	return block_rsv;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e954737..d494c11 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2197,7 +2197,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	int ret;
 
 	if (!root->orphan_block_rsv) {
-		block_rsv = btrfs_alloc_block_rsv(root);
+		block_rsv = btrfs_alloc_block_rsv(root, BTRFS_BLOCK_RSV_TEMP);
 		if (!block_rsv)
 			return -ENOMEM;
 	}
@@ -3060,7 +3060,7 @@ out:
 static void __unlink_end_trans(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
 {
-	if (trans->block_rsv == &root->fs_info->global_block_rsv) {
+	if (trans->block_rsv->type == BTRFS_BLOCK_RSV_GLOBAL) {
 		btrfs_block_rsv_release(root, trans->block_rsv,
 					trans->bytes_reserved);
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
@@ -3767,7 +3767,7 @@ void btrfs_evict_inode(struct inode *inode)
 		goto no_delete;
 	}
 
-	rsv = btrfs_alloc_block_rsv(root);
+	rsv = btrfs_alloc_block_rsv(root, BTRFS_BLOCK_RSV_TEMP);
 	if (!rsv) {
 		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
@@ -6783,7 +6783,7 @@ static int btrfs_truncate(struct inode *inode)
 	 * 3) fs_info->trans_block_rsv - this will have 1 items worth left for
 	 * updating the inode.
 	 */
-	rsv = btrfs_alloc_block_rsv(root);
+	rsv = btrfs_alloc_block_rsv(root, BTRFS_BLOCK_RSV_TEMP);
 	if (!rsv)
 		return -ENOMEM;
 	rsv->size = min_size;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a1fbca0..3a16327 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -516,7 +516,8 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	if (!pending_snapshot)
 		return -ENOMEM;
 
-	btrfs_init_block_rsv(&pending_snapshot->block_rsv);
+	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
+			     BTRFS_BLOCK_RSV_TEMP);
 	pending_snapshot->dentry = dentry;
 	pending_snapshot->root = root;
 	pending_snapshot->readonly = readonly;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c5dbd91..f193096 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3674,7 +3674,8 @@ int prepare_to_relocate(struct reloc_control *rc)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root);
+	rc->block_rsv = btrfs_alloc_block_rsv(rc->extent_root,
+					      BTRFS_BLOCK_RSV_TEMP);
 	if (!rc->block_rsv)
 		return -ENOMEM;
 
-- 
1.7.6.5

