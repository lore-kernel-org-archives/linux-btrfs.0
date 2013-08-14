Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:46256 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab3HNQM2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 12:12:28 -0400
Received: from pizpot.store ([192.168.43.236])
 by jorabe.store (RZmta 31.39 OK) with ESMTP id 60542ap7EEUtFo
 for <linux-btrfs@vger.kernel.org>;
 Wed, 14 Aug 2013 18:12:25 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: get rid of sparse warnings
Date: Wed, 14 Aug 2013 18:12:25 +0200
Message-Id: <1376496745-6467-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

make C=2 fs/btrfs/ CF=-D__CHECK_ENDIAN__

I tried to filter out the warnings for which patches have already
been sent to the mailing list, pending for inclusion in btrfs-next.

All these changes should be obviously safe.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
This patch is for the current btrfs-next with 3601bea4 as the
top commit.

 fs/btrfs/backref.c         | 2 +-
 fs/btrfs/check-integrity.c | 2 +-
 fs/btrfs/ctree.c           | 6 +++---
 fs/btrfs/ctree.h           | 3 +++
 fs/btrfs/delayed-ref.c     | 2 +-
 fs/btrfs/disk-io.c         | 8 ++++----
 fs/btrfs/extent_io.c       | 4 ++--
 fs/btrfs/send.c            | 4 ++--
 fs/btrfs/volumes.c         | 3 ---
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index ae798c1..977e9c6 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -365,7 +365,7 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		node = ulist_next(parents, &uiter);
 		ref->parent = node ? node->val : 0;
 		ref->inode_list = node ?
-			(struct extent_inode_elem *)(uintptr_t)node->aux : 0;
+			(struct extent_inode_elem *)(uintptr_t)node->aux : NULL;
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, &uiter))) {
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1f706e9..07f39a3 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2441,7 +2441,7 @@ static int btrfsic_process_written_superblock(
 		int num_copies;
 		int mirror_num;
 		const char *additional_string = NULL;
-		struct btrfs_disk_key tmp_disk_key;
+		struct btrfs_disk_key tmp_disk_key = {0};
 
 		btrfs_set_disk_key_objectid(&tmp_disk_key,
 					    BTRFS_ROOT_ITEM_KEY);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 414a2d7..a9d4a34 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1067,7 +1067,7 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
 	int looped = 0;
 
 	if (!time_seq)
-		return 0;
+		return NULL;
 
 	/*
 	 * the very last operation that's logged for a root is the replacement
@@ -1078,7 +1078,7 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
 		tm = tree_mod_log_search_oldest(fs_info, root_logical,
 						time_seq);
 		if (!looped && !tm)
-			return 0;
+			return NULL;
 		/*
 		 * if there are no tree operation for the oldest root, we simply
 		 * return it. this should only happen if that (old) root is at
@@ -4781,7 +4781,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
  * This may release the path, and so you may lose any locks held at the
  * time you call it.
  */
-int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
+static int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path)
 {
 	struct btrfs_key key;
 	struct btrfs_disk_key found_key;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 15d27bc..9e57794 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3737,6 +3737,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      u64 newer_than, unsigned long max_pages);
 void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
+void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
+			       struct btrfs_ioctl_balance_args *bargs);
+
 
 /* file.c */
 int btrfs_auto_defrag_init(void);
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index f7be9f7..e4d467b 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -241,7 +241,7 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static void inline drop_delayed_ref(struct btrfs_trans_handle *trans,
+static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 				    struct btrfs_delayed_ref_root *delayed_refs,
 				    struct btrfs_delayed_ref_node *ref)
 {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1e8fc2d..ede9584 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1432,8 +1432,8 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
-					struct btrfs_key *key)
+static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
+					       struct btrfs_key *key)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
@@ -3809,8 +3809,8 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->ordered_root_lock);
 }
 
-int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-			       struct btrfs_root *root)
+static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
+				      struct btrfs_root *root)
 {
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a916caf..55d0412 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2954,11 +2954,11 @@ static void __extent_readpages(struct extent_io_tree *tree,
 			       struct bio **bio, int mirror_num,
 			       unsigned long *bio_flags, int rw)
 {
-	u64 start;
+	u64 start = 0;
 	u64 end = 0;
 	u64 page_start;
 	int index;
-	int first_index;
+	int first_index = 0;
 
 	for (index = 0; index < nr_pages; index++) {
 		page_start = page_offset(pages[index]);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0efc2e2..eba9c27 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -54,8 +54,8 @@ struct fs_path {
 
 			char *buf;
 			int buf_len;
-			int reversed:1;
-			int virtual_mem:1;
+			unsigned int reversed:1;
+			unsigned int virtual_mem:1;
 			char inline_buf[];
 		};
 		char pad[PAGE_SIZE];
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6328415..13197b8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3076,9 +3076,6 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 }
 
-void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
-			       struct btrfs_ioctl_balance_args *bargs);
-
 /*
  * Should be called with both balance and volume mutexes held
  */
-- 
1.8.3.4

