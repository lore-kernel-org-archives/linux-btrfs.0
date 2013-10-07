Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:55832 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3JGEuu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 00:50:50 -0400
From: Chris Yungmann <yungmann.chris@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Chris Yungmann <yungmann.chris@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: btrfs: suppress compilation warnings
Date: Mon,  7 Oct 2013 00:49:48 -0400
Message-Id: <1381121402-30556-1-git-send-email-yungmann.chris@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch suppresses the following compilation warnings (mostly unused variables):

fs/btrfs/backref.c: In function 'iterate_inode_extrefs':
fs/btrfs/backref.c:1652:6: warning: variable 'slot' set but not used [-Wunused-but-set-variable]
  int slot;
      ^
fs/btrfs/ctree.c: In function 'btrfs_search_forward':
fs/btrfs/ctree.c:4917:8: warning: variable 'blockptr' set but not used [-Wunused-but-set-variable]
    u64 blockptr;
        ^
fs/btrfs/disk-io.c: In function 'csum_dirty_buffer':
fs/btrfs/disk-io.c:468:25: warning: variable 'tree' set but not used [-Wunused-but-set-variable]
  struct extent_io_tree *tree;
                         ^
fs/btrfs/disk-io.c: In function 'btree_readpage_end_io_hook':
fs/btrfs/disk-io.c:579:25: warning: variable 'tree' set but not used [-Wunused-but-set-variable]
  struct extent_io_tree *tree;
                         ^
fs/btrfs/disk-io.c: In function 'btree_writepages':
fs/btrfs/disk-io.c:977:25: warning: variable 'tree' set but not used [-Wunused-but-set-variable]
  struct extent_io_tree *tree;
                         ^
fs/btrfs/disk-io.c: In function 'btrfs_create_tree':
fs/btrfs/disk-io.c:1284:6: warning: variable 'bytenr' set but not used [-Wunused-but-set-variable]
  u64 bytenr;
      ^
fs/btrfs/disk-io.c: In function 'end_workqueue_fn':
fs/btrfs/disk-io.c:1695:24: warning: variable 'fs_info' set but not used [-Wunused-but-set-variable]
  struct btrfs_fs_info *fs_info;
                        ^
fs/btrfs/extent_io.c: In function 'end_bio_extent_writepage':
fs/btrfs/extent_io.c:2349:25: warning: variable 'tree' set but not used [-Wunused-but-set-variable]
  struct extent_io_tree *tree;
                         ^
fs/btrfs/extent_io.c:4099:33: warning: variable 'item' set but not used [-Wunused-but-set-variable]
  struct btrfs_file_extent_item *item;
                                 ^
fs/btrfs/extent_io.c: In function 'extent_fiemap':
fs/btrfs/extent_io.c:4104:16: warning: variable 'emflags' set but not used [-Wunused-but-set-variable]
  unsigned long emflags;
                ^
fs/btrfs/extent-tree.c: In function 'find_free_extent':
fs/btrfs/extent-tree.c:6133:7: warning: variable 'found_uncached_bg' set but not used [-Wunused-but-set-variable]
  bool found_uncached_bg = false;
       ^
fs/btrfs/inode.c: In function 'btrfs_new_inode':
fs/btrfs/inode.c:5356:6: warning: variable 'owner' set but not used [-Wunused-but-set-variable]
  int owner;
      ^
fs/btrfs/inode.c: In function 'btrfs_add_link':
fs/btrfs/inode.c:5544:7: warning: variable 'err' set but not used [-Wunused-but-set-variable]
   int err;
       ^
fs/btrfs/inode.c:5551:7: warning: variable 'err' set but not used [-Wunused-but-set-variable]
   int err;
       ^
fs/btrfs/qgroup.c: In function 'update_qgroup_limit_item':
fs/btrfs/qgroup.c:628:6: warning: variable 'slot' set but not used [-Wunused-but-set-variable]
  int slot;
      ^
fs/btrfs/qgroup.c: In function 'update_qgroup_info_item':
fs/btrfs/qgroup.c:671:6: warning: variable 'slot' set but not used [-Wunused-but-set-variable]
  int slot;
      ^
fs/btrfs/qgroup.c: In function 'btrfs_qgroup_account_ref':
fs/btrfs/qgroup.c:1352:19: warning: variable 'ins' set but not used [-Wunused-but-set-variable]
  struct btrfs_key ins;
                   ^
fs/btrfs/raid56.c: In function 'finish_rmw':
fs/btrfs/raid56.c:1143:6: warning: variable 'p_stripe' set but not used [-Wunused-but-set-variable]
  int p_stripe = -1;
      ^
fs/btrfs/root-tree.c: In function 'btrfs_find_orphan_roots':
fs/btrfs/root-tree.c:230:7: warning: variable 'can_recover' set but not used [-Wunused-but-set-variable]
  bool can_recover = true;
       ^
fs/btrfs/scrub.c: In function 'scrub_fixup_nodatasum':
fs/btrfs/scrub.c:708:24: warning: variable 'fs_info' set but not used [-Wunused-but-set-variable]
  struct btrfs_fs_info *fs_info;
                        ^
fs/btrfs/tree-log.c:1164:63: warning: incorrect type in argument 3 (different signedness)
fs/btrfs/tree-log.c:1164:63:    expected unsigned int [usertype] *namelen
fs/btrfs/tree-log.c:1164:63:    got int *<noident>
fs/btrfs/tree-log.c:1175:60: warning: incorrect type in argument 3 (different signedness)
fs/btrfs/tree-log.c:1175:60:    expected unsigned int [usertype] *namelen
fs/btrfs/tree-log.c:1175:60:    got int *<noident>
fs/btrfs/volumes.c: In function 'btrfs_uuid_scan_kthread':
fs/btrfs/volumes.c:3465:19: warning: variable 'max_key' set but not used [-Wunused-but-set-variable]
  struct btrfs_key max_key;
                   ^

Signed-off-by: Chris Yungmann <yungmann.chris@gmail.com>
---
 fs/btrfs/backref.c     |  4 ++--
 fs/btrfs/ctree.c       |  6 +-----
 fs/btrfs/disk-io.c     | 13 ++-----------
 fs/btrfs/extent-tree.c |  2 --
 fs/btrfs/extent_io.c   |  7 -------
 fs/btrfs/inode.c       | 19 +++++--------------
 fs/btrfs/qgroup.c      |  9 ---------
 fs/btrfs/raid56.c      |  9 ++-------
 fs/btrfs/root-tree.c   |  4 ----
 fs/btrfs/scrub.c       |  2 --
 fs/btrfs/tree-log.c    |  2 +-
 fs/btrfs/volumes.c     |  5 -----
 12 files changed, 13 insertions(+), 69 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 721936a..49bf562 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1681,8 +1681,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 		btrfs_release_path(path);
 
 		leaf = path->nodes[0];
-		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-		ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+		item_size = btrfs_item_size_nr(leaf, slot);
+		ptr = btrfs_item_ptr_offset(leaf, slot);
 		cur_offset = 0;
 
 		while (cur_offset < item_size) {
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 33e9dbd..c93f133 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4914,11 +4914,7 @@ again:
 		 * If it is too old, old, skip to the next one.
 		 */
 		while (slot < nritems) {
-			u64 blockptr;
-			u64 gen;
-
-			blockptr = btrfs_node_blockptr(cur, slot);
-			gen = btrfs_node_ptr_generation(cur, slot);
+			u64 gen = btrfs_node_ptr_generation(cur, slot);
 			if (gen < min_trans) {
 				slot++;
 				continue;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ade6c0e..24460f5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -465,13 +465,10 @@ static int btree_read_extent_buffer_pages(struct btrfs_root *root,
 
 static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 {
-	struct extent_io_tree *tree;
 	u64 start = page_offset(page);
 	u64 found_start;
 	struct extent_buffer *eb;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-
 	eb = (struct extent_buffer *)page->private;
 	if (page != eb->pages[0])
 		return 0;
@@ -576,7 +573,6 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 				      u64 phy_offset, struct page *page,
 				      u64 start, u64 end, int mirror)
 {
-	struct extent_io_tree *tree;
 	u64 found_start;
 	int found_level;
 	struct extent_buffer *eb;
@@ -587,7 +583,6 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	if (!page->private)
 		goto out;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	eb = (struct extent_buffer *)page->private;
 
 	/* the pending IO might have been the only thing that kept this buffer
@@ -974,11 +969,9 @@ static int btree_migratepage(struct address_space *mapping,
 static int btree_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	struct extent_io_tree *tree;
 	struct btrfs_fs_info *fs_info;
 	int ret;
 
-	tree = &BTRFS_I(mapping->host)->io_tree;
 	if (wbc->sync_mode == WB_SYNC_NONE) {
 
 		if (wbc->for_kupdate)
@@ -1305,7 +1298,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 
 	bytenr = leaf->start;
 	memset_extent_buffer(leaf, 0, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(leaf, leaf->start);
+	btrfs_set_header_bytenr(leaf, bytenr);
 	btrfs_set_header_generation(leaf, trans->transid);
 	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(leaf, objectid);
@@ -1324,7 +1317,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 
 	root->root_item.flags = 0;
 	root->root_item.byte_limit = 0;
-	btrfs_set_root_bytenr(&root->root_item, leaf->start);
+	btrfs_set_root_bytenr(&root->root_item, bytenr);
 	btrfs_set_root_generation(&root->root_item, trans->transid);
 	btrfs_set_root_level(&root->root_item, 0);
 	btrfs_set_root_refs(&root->root_item, 1);
@@ -1692,12 +1685,10 @@ static void end_workqueue_fn(struct btrfs_work *work)
 {
 	struct bio *bio;
 	struct end_io_wq *end_io_wq;
-	struct btrfs_fs_info *fs_info;
 	int error;
 
 	end_io_wq = container_of(work, struct end_io_wq, work);
 	bio = end_io_wq->bio;
-	fs_info = end_io_wq->info;
 
 	error = end_io_wq->error;
 	bio->bi_private = end_io_wq->private;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a07d510..fdaa15e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6130,7 +6130,6 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	int index = __get_raid_index(flags);
 	int alloc_type = (flags & BTRFS_BLOCK_GROUP_DATA) ?
 		RESERVE_ALLOC_NO_ACCOUNT : RESERVE_ALLOC;
-	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
 	bool use_cluster = true;
@@ -6248,7 +6247,6 @@ search:
 have_block_group:
 		cached = block_group_cache_done(block_group);
 		if (unlikely(!cached)) {
-			found_uncached_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
 			ret = 0;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b48942f..edcf111 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2346,13 +2346,11 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 static void end_bio_extent_writepage(struct bio *bio, int err)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
 
 	do {
 		struct page *page = bvec->bv_page;
-		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
 		/* We always issue full-page reads, but if some block
 		 * in a page fails to read, blk_update_request() will
@@ -4096,12 +4094,10 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	struct btrfs_path *path;
-	struct btrfs_file_extent_item *item;
 	int end = 0;
 	u64 em_start = 0;
 	u64 em_len = 0;
 	u64 em_end = 0;
-	unsigned long emflags;
 
 	if (len == 0)
 		return -EINVAL;
@@ -4126,8 +4122,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 	WARN_ON(!ret);
 	path->slots[0]--;
-	item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-			      struct btrfs_file_extent_item);
 	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
 	found_type = btrfs_key_type(&found_key);
 
@@ -4195,7 +4189,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			offset_in_extent = em_start - em->start;
 		em_end = extent_map_end(em);
 		em_len = em_end - em_start;
-		emflags = em->flags;
 		disko = 0;
 		flags = 0;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13b470c..b7530cc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5353,7 +5353,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	u32 sizes[2];
 	unsigned long ptr;
 	int ret;
-	int owner;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5399,11 +5398,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	 */
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
 
-	if (S_ISDIR(mode))
-		owner = 0;
-	else
-		owner = 1;
-
 	key[0].objectid = objectid;
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
 	key[0].offset = 0;
@@ -5541,17 +5535,14 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 fail_dir_item:
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
-		int err;
-		err = btrfs_del_root_ref(trans, root->fs_info->tree_root,
-				 key.objectid, root->root_key.objectid,
-				 parent_ino, &local_index, name, name_len);
+		btrfs_del_root_ref(trans, root->fs_info->tree_root,
+				   key.objectid, root->root_key.objectid,
+				   parent_ino, &local_index, name, name_len);
 
 	} else if (add_backref) {
 		u64 local_index;
-		int err;
-
-		err = btrfs_del_inode_ref(trans, root, name, name_len,
-					  ino, parent_ino, &local_index);
+		btrfs_del_inode_ref(trans, root, name, name_len,
+				    ino, parent_ino, &local_index);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..1d47df8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -625,7 +625,6 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	struct extent_buffer *l;
 	struct btrfs_qgroup_limit_item *qgroup_limit;
 	int ret;
-	int slot;
 
 	key.objectid = 0;
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
@@ -643,7 +642,6 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 		goto out;
 
 	l = path->nodes[0];
-	slot = path->slots[0];
 	qgroup_limit = btrfs_item_ptr(l, path->slots[0],
 				      struct btrfs_qgroup_limit_item);
 	btrfs_set_qgroup_limit_flags(l, qgroup_limit, flags);
@@ -668,7 +666,6 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	struct extent_buffer *l;
 	struct btrfs_qgroup_info_item *qgroup_info;
 	int ret;
-	int slot;
 
 	key.objectid = 0;
 	key.type = BTRFS_QGROUP_INFO_KEY;
@@ -686,7 +683,6 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 		goto out;
 
 	l = path->nodes[0];
-	slot = path->slots[0];
 	qgroup_info = btrfs_item_ptr(l, path->slots[0],
 				 struct btrfs_qgroup_info_item);
 	btrfs_set_qgroup_info_generation(l, qgroup_info, trans->transid);
@@ -1349,7 +1345,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 			     struct btrfs_delayed_ref_node *node,
 			     struct btrfs_delayed_extent_op *extent_op)
 {
-	struct btrfs_key ins;
 	struct btrfs_root *quota_root;
 	u64 ref_root;
 	struct btrfs_qgroup *qgroup;
@@ -1363,10 +1358,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 	BUG_ON(!fs_info->quota_root);
 
-	ins.objectid = node->bytenr;
-	ins.offset = node->num_bytes;
-	ins.type = BTRFS_EXTENT_ITEM_KEY;
-
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		struct btrfs_delayed_tree_ref *ref;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d0ecfbd..783769b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1140,7 +1140,6 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
 	int q_stripe = -1;
 	struct bio_list bio_list;
 	struct bio *bio;
@@ -1149,14 +1148,10 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 	bio_list_init(&bio_list);
 
-	if (bbio->num_stripes - rbio->nr_data == 1) {
-		p_stripe = bbio->num_stripes - 1;
-	} else if (bbio->num_stripes - rbio->nr_data == 2) {
-		p_stripe = bbio->num_stripes - 2;
+	if (bbio->num_stripes - rbio->nr_data == 2)
 		q_stripe = bbio->num_stripes - 1;
-	} else {
+	else if (bbio->num_stripes - rbio->nr_data != 1)
 		BUG();
-	}
 
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ec71ea4..13c00bc 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -227,10 +227,6 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 	struct btrfs_root *root;
 	int err = 0;
 	int ret;
-	bool can_recover = true;
-
-	if (tree_root->fs_info->sb->s_flags & MS_RDONLY)
-		can_recover = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a18e0e2..84139c6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -705,13 +705,11 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 	struct scrub_fixup_nodatasum *fixup;
 	struct scrub_ctx *sctx;
 	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_fs_info *fs_info;
 	struct btrfs_path *path;
 	int uncorrectable = 0;
 
 	fixup = container_of(work, struct scrub_fixup_nodatasum, work);
 	sctx = fixup->sctx;
-	fs_info = fixup->root->fs_info;
 
 	path = btrfs_alloc_path();
 	if (!path) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 964c583..0e8c87e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1118,7 +1118,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 	unsigned long ref_ptr;
 	unsigned long ref_end;
 	char *name;
-	int namelen;
+	unsigned int namelen;
 	int ret;
 	int search_done = 0;
 	int log_ref_ver = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fe0f2ef..e08bdf2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3462,7 +3462,6 @@ static int btrfs_uuid_scan_kthread(void *data)
 	struct btrfs_fs_info *fs_info = data;
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_key key;
-	struct btrfs_key max_key;
 	struct btrfs_path *path = NULL;
 	int ret = 0;
 	struct extent_buffer *eb;
@@ -3481,10 +3480,6 @@ static int btrfs_uuid_scan_kthread(void *data)
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	key.offset = 0;
 
-	max_key.objectid = (u64)-1;
-	max_key.type = BTRFS_ROOT_ITEM_KEY;
-	max_key.offset = (u64)-1;
-
 	path->keep_locks = 1;
 
 	while (1) {
-- 
1.8.4

