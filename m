From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: Re: [PATCH] Btrfs: cleanup btrfs_alloc_path()'s caller code
Date: Tue, 12 Apr 2011 07:46:42 +0900
Message-ID: <BANLkTik5YWVX1rs0HhOd8p4n6SY1mh-UmA@mail.gmail.com>
References: <1302315790-29605-1-git-send-email-yoshinori.sano@gmail.com>
	<4DA27373.40205@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA27373.40205@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for your review.
I modified the previous patch.

Specifically, all the callers that calls the following are modified
because of the lack of return value check:
- btrfs_drop_snapshot()
- btrfs_update_inode()
- wc->process_func()

However, BUG_ON() code are increased by this modification.

Regards,

Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
---
 fs/btrfs/dir-item.c         |    2 +
 fs/btrfs/extent-tree.c      |   12 +++++++---
 fs/btrfs/file-item.c        |    6 +++-
 fs/btrfs/file.c             |    3 +-
 fs/btrfs/free-space-cache.c |    4 ++-
 fs/btrfs/inode.c            |   44 ++++++++++++++++++++++++++++--------------
 fs/btrfs/relocation.c       |    4 ++-
 fs/btrfs/root-tree.c        |    6 +++-
 fs/btrfs/transaction.c      |    9 ++++++-
 fs/btrfs/tree-log.c         |   24 +++++++++++++++-------
 fs/btrfs/volumes.c          |    8 +++++-
 11 files changed, 84 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c62f02f..e60bf8e 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -142,6 +142,8 @@ int btrfs_insert_dir_item(struct
btrfs_trans_handle *trans, struct btrfs_root
 	key.offset = btrfs_name_hash(name, name_len);

 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->leave_spinning = 1;

 	data_size = sizeof(*dir_item) + name_len;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f619c3c..b830db8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -645,7 +645,8 @@ int btrfs_lookup_extent(struct btrfs_root *root,
u64 start, u64 len)
 	struct btrfs_path *path;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	key.objectid = start;
 	key.offset = len;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -5531,7 +5532,8 @@ static int alloc_reserved_tree_block(struct
btrfs_trans_handle *trans,
 	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;

 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -6302,7 +6304,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int level;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;

 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	BUG_ON(!wc);
@@ -8699,7 +8702,8 @@ int btrfs_remove_block_group(struct
btrfs_trans_handle *trans,
 	spin_unlock(&cluster->refill_lock);

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;

 	inode = lookup_free_space_inode(root, block_group, path);
 	if (!IS_ERR(inode)) {
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a6a9d4e..097911e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -281,7 +281,8 @@ int btrfs_lookup_csums_range(struct btrfs_root
*root, u64 start, u64 end,
 	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;

 	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key.offset = start;
@@ -665,7 +666,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		btrfs_super_csum_size(&root->fs_info->super_copy);

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	sector_sum = sums->sums;
 again:
 	next_offset = (u64)-1;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e621ea5..fe623ea 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -599,7 +599,8 @@ int btrfs_mark_extent_written(struct
btrfs_trans_handle *trans,
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 again:
 	recow = 0;
 	split = start;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f561c95..101b96c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -522,6 +522,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	int num_checksums;
 	int entries = 0;
 	int bitmaps = 0;
+	int err;
 	int ret = 0;
 	bool next_page = false;

@@ -853,7 +854,8 @@ out_free:
 		BTRFS_I(inode)->generation = 0;
 	}
 	kfree(checksums);
-	btrfs_update_inode(trans, root, inode);
+	err = btrfs_update_inode(trans, root, inode);
+	BUG_ON(err);
 	iput(inode);
 	return ret;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cc60228..c023053 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -201,9 +201,9 @@ static noinline int insert_inline_extent(struct
btrfs_trans_handle *trans,
 	 * could end up racing with unlink.
 	 */
 	BTRFS_I(inode)->disk_i_size = inode->i_size;
-	btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode);

-	return 0;
+	return ret;
 fail:
 	btrfs_free_path(path);
 	return err;
@@ -1007,6 +1007,7 @@ static noinline int csum_exist_in_range(struct
btrfs_root *root,

 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, bytenr,
 				       bytenr + num_bytes - 1, &list);
+	BUG_ON(ret);
 	if (ret == 0 && list_empty(&list))
 		return 0;

@@ -1050,7 +1051,8 @@ static noinline int run_delalloc_nocow(struct
inode *inode,
 	bool nolock = false;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	if (root == root->fs_info->tree_root) {
 		nolock = true;
 		trans = btrfs_join_transaction_nolock(root, 1);
@@ -1496,13 +1498,15 @@ static noinline int add_pending_csums(struct
btrfs_trans_handle *trans,
 			     struct inode *inode, u64 file_offset,
 			     struct list_head *list)
 {
+	int ret;
 	struct btrfs_ordered_sum *sum;

 	btrfs_set_trans_block_group(trans, inode);

 	list_for_each_entry(sum, list, list) {
-		btrfs_csum_file_blocks(trans,
+		ret = btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
+		BUG_ON(ret);
 	}
 	return 0;
 }
@@ -1625,8 +1629,8 @@ static int insert_reserved_file_extent(struct
btrfs_trans_handle *trans,
 	int ret;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
-
+	if (!path)
+		return -ENOMEM;
 	path->leave_spinning = 1;

 	/*
@@ -2493,7 +2497,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	int ret;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BUG_ON(!path); /* FIXME, should not use BUG_ON */
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));

 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
@@ -2631,7 +2635,8 @@ noinline int btrfs_update_inode(struct
btrfs_trans_handle *trans,
 	int ret;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	path->leave_spinning = 1;
 	ret = btrfs_lookup_inode(trans, root, path,
 				 &BTRFS_I(inode)->location, 1);
@@ -2735,7 +2740,7 @@ err:

 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-	btrfs_update_inode(trans, root, dir);
+	ret = btrfs_update_inode(trans, root, dir);
 out:
 	return ret;
 }
@@ -3290,7 +3295,8 @@ int btrfs_truncate_inode_items(struct
btrfs_trans_handle *trans,
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	path->reada = -1;

 	key.objectid = inode->i_ino;
@@ -3817,7 +3823,8 @@ static int btrfs_inode_by_name(struct inode
*dir, struct dentry *dentry,
 	int ret = 0;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (path)
+		return -ENOMEM;

 	di = btrfs_lookup_dir_item(NULL, root, path, dir->i_ino, name,
 				    namelen, 0);
@@ -4523,7 +4530,8 @@ static struct inode *btrfs_new_inode(struct
btrfs_trans_handle *trans,
 	int owner;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return ERR_PTR(-ENOMEM);

 	inode = new_inode(root->fs_info->sb);
 	if (!inode)
@@ -4737,7 +4745,8 @@ static int btrfs_mknod(struct inode *dir, struct
dentry *dentry,
 	else {
 		inode->i_op = &btrfs_special_inode_operations;
 		init_special_inode(inode, inode->i_mode, rdev);
-		btrfs_update_inode(trans, root, inode);
+		err = btrfs_update_inode(trans, root, inode);
+		BUG_ON(err);
 	}
 	btrfs_update_inode_block_group(trans, inode);
 	btrfs_update_inode_block_group(trans, dir);
@@ -5854,7 +5863,8 @@ again:

 	add_pending_csums(trans, inode, ordered->file_offset, &ordered->list);
 	btrfs_ordered_update_i_size(inode, 0, ordered);
-	btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, ordered->file_offset,
 			     ordered->file_offset + ordered->len - 1,
@@ -7235,7 +7245,11 @@ static int btrfs_symlink(struct inode *dir,
struct dentry *dentry,
 		goto out_unlock;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		err = -ENOMEM;
+		drop_inode = 1;
+		goto out_unlock;
+	}
 	key.objectid = inode->i_ino;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 58250e0..d336517 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2228,7 +2228,8 @@ again:
 		} else {
 			list_del_init(&reloc_root->root_list);
 		}
-		btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0);
+		ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0);
+		BUG_ON(ret);
 	}

 	if (found) {
@@ -4243,6 +4244,7 @@ int btrfs_reloc_clone_csums(struct inode *inode,
u64 file_pos, u64 len)
 	disk_bytenr = file_pos + BTRFS_I(inode)->index_cnt;
 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, disk_bytenr,
 				       disk_bytenr + len - 1, &list);
+	BUG_ON(ret);

 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 6928bff..c330cad 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -40,7 +40,8 @@ int btrfs_search_root(struct btrfs_root *root, u64
search_start,
 	search_key.offset = (u64)-1;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 again:
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
@@ -141,7 +142,8 @@ int btrfs_update_root(struct btrfs_trans_handle
*trans, struct btrfs_root
 	unsigned long ptr;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5b158da..c53469c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1417,6 +1417,8 @@ int btrfs_commit_transaction(struct
btrfs_trans_handle *trans,
  */
 int btrfs_clean_old_snapshots(struct btrfs_root *root)
 {
+	int err;
+	int update_ref;
 	LIST_HEAD(list);
 	struct btrfs_fs_info *fs_info = root->fs_info;

@@ -1430,9 +1432,12 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)

 		if (btrfs_header_backref_rev(root->node) <
 		    BTRFS_MIXED_BACKREF_REV)
-			btrfs_drop_snapshot(root, NULL, 0);
+			update_ref = 0;
 		else
-			btrfs_drop_snapshot(root, NULL, 1);
+			update_ref = 1;
+
+		err = btrfs_drop_snapshot(root, NULL, update_ref);
+		BUG_ON(err);
 	}
 	return 0;
 }
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c50271a..eff407c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -638,7 +638,8 @@ static noinline int replay_one_extent(struct
btrfs_trans_handle *trans,
 	}

 	inode_set_bytes(inode, saved_nbytes);
-	btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
 out:
 	if (inode)
 		iput(inode);
@@ -909,7 +910,8 @@ insert:
 			     btrfs_inode_ref_index(eb, ref));
 	BUG_ON(ret);

-	btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);

 out:
 	ref_ptr = (unsigned long)(ref + 1) + namelen;
@@ -1004,7 +1006,8 @@ static noinline int
fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	btrfs_release_path(root, path);
 	if (nlink != inode->i_nlink) {
 		inode->i_nlink = nlink;
-		btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;

@@ -1099,7 +1102,8 @@ static noinline int link_to_fixup_dir(struct
btrfs_trans_handle *trans,
 	btrfs_release_path(root, path);
 	if (ret == 0) {
 		btrfs_inc_nlink(inode);
-		btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
 	} else if (ret == -EEXIST) {
 		ret = 0;
 	} else {
@@ -1601,7 +1605,8 @@ static int replay_one_buffer(struct btrfs_root
*log, struct extent_buffer *eb,
 		return 0;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;

 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
@@ -1707,7 +1712,8 @@ static noinline int walk_down_log_tree(struct
btrfs_trans_handle *trans,
 			return -ENOMEM;

 		if (*level == 1) {
-			wc->process_func(root, next, wc, ptr_gen);
+			ret = wc->process_func(root, next, wc, ptr_gen);
+			BUG_ON(ret);

 			path->slots[*level]++;
 			if (wc->free) {
@@ -1772,8 +1778,9 @@ static noinline int walk_up_log_tree(struct
btrfs_trans_handle *trans,
 				parent = path->nodes[*level + 1];

 			root_owner = btrfs_header_owner(parent);
-			wc->process_func(root, path->nodes[*level], wc,
+			ret = wc->process_func(root, path->nodes[*level], wc,
 				 btrfs_header_generation(path->nodes[*level]));
+			BUG_ON(ret);
 			if (wc->free) {
 				struct extent_buffer *next;

@@ -1840,8 +1847,9 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,

 	/* was the root node processed? if not, catch it here */
 	if (path->nodes[orig_level]) {
-		wc->process_func(log, path->nodes[orig_level], wc,
+		ret = wc->process_func(log, path->nodes[orig_level], wc,
 			 btrfs_header_generation(path->nodes[orig_level]));
+		BUG_ON(ret);
 		if (wc->free) {
 			struct extent_buffer *next;

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..fa84172 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1058,7 +1058,8 @@ static noinline int find_next_chunk(struct
btrfs_root *root,
 	struct btrfs_key found_key;

 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;

 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -2067,7 +2068,10 @@ int btrfs_balance(struct btrfs_root *dev_root)

 	/* step two, relocate all the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		mutex_unlock(&dev_root->fs_info->volume_mutex);
+		return -ENOMEM;
+	}

 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
-- 
1.7.1
