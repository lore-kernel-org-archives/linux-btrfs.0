From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 6/7] Btrfs: Always use 64bit inode number
Date: Mon, 25 Apr 2011 16:59:48 +0800
Message-ID: <4DB53804.60207@cn.fujitsu.com>
References: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5378B.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

There's a potential problem in 32bit system when we exhaust 32bit inode
numbers and start to allocate big inode numbers, because btrfs uses
inode->i_ino in many places.

So here we always use BTRFS_I(inode)->location.objectid, which is an
u64 variable.

There are 2 exceptions that BTRFS_I(inode)->location.objectid !=
inode->i_ino: the btree inode (0 vs 1) and empty subvol dirs (256 vs 2),
and inode->i_ino will be used in those cases.

Another reason to make this change is I'm going to use a special inode
to save free ino cache, and the inode number must be > (u64)-256.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    9 ++
 fs/btrfs/compression.c |    5 +-
 fs/btrfs/export.c      |   25 ++++---
 fs/btrfs/extent-tree.c |   10 +-
 fs/btrfs/extent_io.c   |    4 +-
 fs/btrfs/file-item.c   |    5 +-
 fs/btrfs/file.c        |   27 ++++---
 fs/btrfs/inode.c       |  197 +++++++++++++++++++++++++-----------------------
 fs/btrfs/ioctl.c       |   18 ++--
 fs/btrfs/relocation.c  |   24 +++---
 fs/btrfs/transaction.c |    4 +-
 fs/btrfs/tree-log.c    |   54 +++++++-------
 fs/btrfs/xattr.c       |    8 +-
 13 files changed, 208 insertions(+), 182 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 57c3bb2..8842a41 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -166,6 +166,15 @@ static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 	return container_of(inode, struct btrfs_inode, vfs_inode);
 }
 
+static inline u64 btrfs_ino(struct inode *inode)
+{
+	u64 ino = BTRFS_I(inode)->location.objectid;
+
+	if (ino <= BTRFS_FIRST_FREE_OBJECTID)
+		ino = inode->i_ino;
+	return ino;
+}
+
 static inline void btrfs_i_size_write(struct inode *inode, u64 size)
 {
 	i_size_write(inode, size);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 41d1d7c..369d506 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -125,9 +125,10 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr, KM_USER0);
 
 		if (csum != *cb_sum) {
-			printk(KERN_INFO "btrfs csum failed ino %lu "
+			printk(KERN_INFO "btrfs csum failed ino %llu "
 			       "extent %llu csum %u "
-			       "wanted %u mirror %d\n", inode->i_ino,
+			       "wanted %u mirror %d\n",
+			       (unsigned long long)btrfs_ino(inode),
 			       (unsigned long long)disk_start,
 			       csum, *cb_sum, cb->mirror_num);
 			ret = -EIO;
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index ff27d7a..7fa283e 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -28,7 +28,7 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 	len  = BTRFS_FID_SIZE_NON_CONNECTABLE;
 	type = FILEID_BTRFS_WITHOUT_PARENT;
 
-	fid->objectid = inode->i_ino;
+	fid->objectid = btrfs_ino(inode);
 	fid->root_objectid = BTRFS_I(inode)->root->objectid;
 	fid->gen = inode->i_generation;
 
@@ -174,13 +174,13 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	if (!path)
 		return ERR_PTR(-ENOMEM);
 
-	if (dir->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(dir) == BTRFS_FIRST_FREE_OBJECTID) {
 		key.objectid = root->root_key.objectid;
 		key.type = BTRFS_ROOT_BACKREF_KEY;
 		key.offset = (u64)-1;
 		root = root->fs_info->tree_root;
 	} else {
-		key.objectid = dir->i_ino;
+		key.objectid = btrfs_ino(dir);
 		key.type = BTRFS_INODE_REF_KEY;
 		key.offset = (u64)-1;
 	}
@@ -240,6 +240,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	struct btrfs_key key;
 	int name_len;
 	int ret;
+	u64 ino;
 
 	if (!dir || !inode)
 		return -EINVAL;
@@ -247,19 +248,21 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	if (!S_ISDIR(dir->i_mode))
 		return -EINVAL;
 
+	ino = btrfs_ino(inode);
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
-	if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+	if (ino == BTRFS_FIRST_FREE_OBJECTID) {
 		key.objectid = BTRFS_I(inode)->root->root_key.objectid;
 		key.type = BTRFS_ROOT_BACKREF_KEY;
 		key.offset = (u64)-1;
 		root = root->fs_info->tree_root;
 	} else {
-		key.objectid = inode->i_ino;
-		key.offset = dir->i_ino;
+		key.objectid = ino;
+		key.offset = btrfs_ino(dir);
 		key.type = BTRFS_INODE_REF_KEY;
 	}
 
@@ -268,7 +271,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 		btrfs_free_path(path);
 		return ret;
 	} else if (ret > 0) {
-		if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+		if (ino == BTRFS_FIRST_FREE_OBJECTID) {
 			path->slots[0]--;
 		} else {
 			btrfs_free_path(path);
@@ -277,11 +280,11 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	}
 	leaf = path->nodes[0];
 
-	if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
-	       rref = btrfs_item_ptr(leaf, path->slots[0],
+	if (ino == BTRFS_FIRST_FREE_OBJECTID) {
+		rref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);
-	       name_ptr = (unsigned long)(rref + 1);
-	       name_len = btrfs_root_ref_name_len(leaf, rref);
+		name_ptr = (unsigned long)(rref + 1);
+		name_len = btrfs_root_ref_name_len(leaf, rref);
 	} else {
 		iref = btrfs_item_ptr(leaf, path->slots[0],
 				      struct btrfs_inode_ref);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 904eae1..a0e818c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7009,8 +7009,8 @@ static noinline int get_new_locations(struct inode *reloc_inode,
 
 	cur_pos = extent_key->objectid - offset;
 	last_byte = extent_key->objectid + extent_key->offset;
-	ret = btrfs_lookup_file_extent(NULL, root, path, reloc_inode->i_ino,
-				       cur_pos, 0);
+	ret = btrfs_lookup_file_extent(NULL, root, path,
+				       btrfs_ino(reloc_inode), cur_pos, 0);
 	if (ret < 0)
 		goto out;
 	if (ret > 0) {
@@ -7033,7 +7033,7 @@ static noinline int get_new_locations(struct inode *reloc_inode,
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 		if (found_key.offset != cur_pos ||
 		    found_key.type != BTRFS_EXTENT_DATA_KEY ||
-		    found_key.objectid != reloc_inode->i_ino)
+		    found_key.objectid != btrfs_ino(reloc_inode))
 			break;
 
 		fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -7179,7 +7179,7 @@ next:
 				break;
 		}
 
-		if (inode && key.objectid != inode->i_ino) {
+		if (inode && key.objectid != btrfs_ino(inode)) {
 			BUG_ON(extent_locked);
 			btrfs_release_path(root, path);
 			mutex_unlock(&inode->i_mutex);
@@ -7488,7 +7488,7 @@ static noinline int invalidate_extent_cache(struct btrfs_root *root,
 			continue;
 		if (btrfs_file_extent_disk_bytenr(leaf, fi) == 0)
 			continue;
-		if (!inode || inode->i_ino != key.objectid) {
+		if (!inode || btrfs_ino(inode) != key.objectid) {
 			iput(inode);
 			inode = btrfs_ilookup(target_root->fs_info->sb,
 					      key.objectid, target_root, 1);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ae0bff..41d313a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3030,7 +3030,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	 * because there might be preallocation past i_size
 	 */
 	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
-				       path, inode->i_ino, -1, 0);
+				       path, btrfs_ino(inode), -1, 0);
 	if (ret < 0) {
 		btrfs_free_path(path);
 		return ret;
@@ -3043,7 +3043,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	found_type = btrfs_key_type(&found_key);
 
 	/* No extents, but there might be delalloc bits */
-	if (found_key.objectid != inode->i_ino ||
+	if (found_key.objectid != btrfs_ino(inode) ||
 	    found_type != BTRFS_EXTENT_DATA_KEY) {
 		/* have to trust i_size as the end */
 		last = (u64)-1;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a6a9d4e..1d9410e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -208,8 +208,9 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
 					printk(KERN_INFO "btrfs no csum found "
-					       "for inode %lu start %llu\n",
-					       inode->i_ino,
+					       "for inode %llu start %llu\n",
+					       (unsigned long long)
+					       btrfs_ino(inode),
 					       (unsigned long long)offset);
 				}
 				item = NULL;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 75899a0..bef0204 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -298,6 +298,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct btrfs_key new_key;
+	u64 ino = btrfs_ino(inode);
 	u64 search_start = start;
 	u64 disk_bytenr = 0;
 	u64 num_bytes = 0;
@@ -318,14 +319,14 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans, struct inode *inode,
 
 	while (1) {
 		recow = 0;
-		ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
+		ret = btrfs_lookup_file_extent(trans, root, path, ino,
 					       search_start, -1);
 		if (ret < 0)
 			break;
 		if (ret > 0 && path->slots[0] > 0 && search_start == start) {
 			leaf = path->nodes[0];
 			btrfs_item_key_to_cpu(leaf, &key, path->slots[0] - 1);
-			if (key.objectid == inode->i_ino &&
+			if (key.objectid == ino &&
 			    key.type == BTRFS_EXTENT_DATA_KEY)
 				path->slots[0]--;
 		}
@@ -346,7 +347,7 @@ next_slot:
 		}
 
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		if (key.objectid > inode->i_ino ||
+		if (key.objectid > ino ||
 		    key.type > BTRFS_EXTENT_DATA_KEY || key.offset >= end)
 			break;
 
@@ -592,6 +593,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	int del_slot = 0;
 	int recow;
 	int ret;
+	u64 ino = btrfs_ino(inode);
 
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
@@ -600,7 +602,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 again:
 	recow = 0;
 	split = start;
-	key.objectid = inode->i_ino;
+	key.objectid = ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = split;
 
@@ -612,8 +614,7 @@ again:
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-	BUG_ON(key.objectid != inode->i_ino ||
-	       key.type != BTRFS_EXTENT_DATA_KEY);
+	BUG_ON(key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY);
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	BUG_ON(btrfs_file_extent_type(leaf, fi) !=
@@ -630,7 +631,7 @@ again:
 		other_start = 0;
 		other_end = start;
 		if (extent_mergeable(leaf, path->slots[0] - 1,
-				     inode->i_ino, bytenr, orig_offset,
+				     ino, bytenr, orig_offset,
 				     &other_start, &other_end)) {
 			new_key.offset = end;
 			btrfs_set_item_key_safe(trans, root, path, &new_key);
@@ -653,7 +654,7 @@ again:
 		other_start = end;
 		other_end = 0;
 		if (extent_mergeable(leaf, path->slots[0] + 1,
-				     inode->i_ino, bytenr, orig_offset,
+				     ino, bytenr, orig_offset,
 				     &other_start, &other_end)) {
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
@@ -702,7 +703,7 @@ again:
 
 		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
 					   root->root_key.objectid,
-					   inode->i_ino, orig_offset);
+					   ino, orig_offset);
 		BUG_ON(ret);
 
 		if (split == start) {
@@ -718,7 +719,7 @@ again:
 	other_start = end;
 	other_end = 0;
 	if (extent_mergeable(leaf, path->slots[0] + 1,
-			     inode->i_ino, bytenr, orig_offset,
+			     ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
 		if (recow) {
 			btrfs_release_path(root, path);
@@ -729,13 +730,13 @@ again:
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					inode->i_ino, orig_offset);
+					ino, orig_offset);
 		BUG_ON(ret);
 	}
 	other_start = 0;
 	other_end = start;
 	if (extent_mergeable(leaf, path->slots[0] - 1,
-			     inode->i_ino, bytenr, orig_offset,
+			     ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
 		if (recow) {
 			btrfs_release_path(root, path);
@@ -746,7 +747,7 @@ again:
 		del_nr++;
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
-					inode->i_ino, orig_offset);
+					ino, orig_offset);
 		BUG_ON(ret);
 	}
 	if (del_nr == 0) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 77dd0a7..adec228 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -138,7 +138,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	path->leave_spinning = 1;
 	btrfs_set_trans_block_group(trans, inode);
 
-	key.objectid = inode->i_ino;
+	key.objectid = btrfs_ino(inode);
 	key.offset = start;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
 	datasize = btrfs_file_extent_calc_inline_size(cur_size);
@@ -1049,6 +1049,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	int nocow;
 	int check_prev = 1;
 	bool nolock = false;
+	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -1063,14 +1064,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	cow_start = (u64)-1;
 	cur_offset = start;
 	while (1) {
-		ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
+		ret = btrfs_lookup_file_extent(trans, root, path, ino,
 					       cur_offset, 0);
 		BUG_ON(ret < 0);
 		if (ret > 0 && path->slots[0] > 0 && check_prev) {
 			leaf = path->nodes[0];
 			btrfs_item_key_to_cpu(leaf, &found_key,
 					      path->slots[0] - 1);
-			if (found_key.objectid == inode->i_ino &&
+			if (found_key.objectid == ino &&
 			    found_key.type == BTRFS_EXTENT_DATA_KEY)
 				path->slots[0]--;
 		}
@@ -1091,7 +1092,7 @@ next_slot:
 		num_bytes = 0;
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-		if (found_key.objectid > inode->i_ino ||
+		if (found_key.objectid > ino ||
 		    found_key.type > BTRFS_EXTENT_DATA_KEY ||
 		    found_key.offset > end)
 			break;
@@ -1126,7 +1127,7 @@ next_slot:
 				goto out_check;
 			if (btrfs_extent_readonly(root, disk_bytenr))
 				goto out_check;
-			if (btrfs_cross_ref_exist(trans, root, inode->i_ino,
+			if (btrfs_cross_ref_exist(trans, root, ino,
 						  found_key.offset -
 						  extent_offset, disk_bytenr))
 				goto out_check;
@@ -1643,7 +1644,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				 &hint, 0);
 	BUG_ON(ret);
 
-	ins.objectid = inode->i_ino;
+	ins.objectid = btrfs_ino(inode);
 	ins.offset = file_pos;
 	ins.type = BTRFS_EXTENT_DATA_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &ins, sizeof(*fi));
@@ -1674,7 +1675,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 	ret = btrfs_alloc_reserved_file_extent(trans, root,
 					root->root_key.objectid,
-					inode->i_ino, file_pos, &ins);
+					btrfs_ino(inode), file_pos, &ins);
 	BUG_ON(ret);
 	btrfs_free_path(path);
 
@@ -2004,8 +2005,9 @@ good:
 
 zeroit:
 	if (printk_ratelimit()) {
-		printk(KERN_INFO "btrfs csum failed ino %lu off %llu csum %u "
-		       "private %llu\n", page->mapping->host->i_ino,
+		printk(KERN_INFO "btrfs csum failed ino %llu off %llu csum %u "
+		       "private %llu\n",
+		       (unsigned long long)btrfs_ino(page->mapping->host),
 		       (unsigned long long)start, csum,
 		       (unsigned long long)private);
 	}
@@ -2243,7 +2245,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	/* insert an orphan item to track this unlinked/truncated file */
 	if (insert >= 1) {
-		ret = btrfs_insert_orphan_item(trans, root, inode->i_ino);
+		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		BUG_ON(ret);
 	}
 
@@ -2280,7 +2282,7 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	spin_unlock(&root->orphan_lock);
 
 	if (trans && delete_item) {
-		ret = btrfs_del_orphan_item(trans, root, inode->i_ino);
+		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
 		BUG_ON(ret);
 	}
 
@@ -2542,7 +2544,8 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	 * try to precache a NULL acl entry for files that don't have
 	 * any xattrs or acls
 	 */
-	maybe_acls = acls_after_inode_item(leaf, path->slots[0], inode->i_ino);
+	maybe_acls = acls_after_inode_item(leaf, path->slots[0],
+					   btrfs_ino(inode));
 	if (!maybe_acls)
 		cache_no_acl(inode);
 
@@ -2688,6 +2691,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	u64 index;
+	u64 ino = btrfs_ino(inode);
+	u64 dir_ino = btrfs_ino(dir);
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -2696,7 +2701,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 
 	path->leave_spinning = 1;
-	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
+	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				    name, name_len, -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
@@ -2713,17 +2718,16 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	btrfs_release_path(root, path);
 
-	ret = btrfs_del_inode_ref(trans, root, name, name_len,
-				  inode->i_ino,
-				  dir->i_ino, &index);
+	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
+				  dir_ino, &index);
 	if (ret) {
 		printk(KERN_INFO "btrfs failed to delete reference to %.*s, "
-		       "inode %lu parent %lu\n", name_len, name,
-		       inode->i_ino, dir->i_ino);
+		       "inode %llu parent %llu\n", name_len, name,
+		       (unsigned long long)ino, (unsigned long long)dir_ino);
 		goto err;
 	}
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
+	di = btrfs_lookup_dir_index_item(trans, root, path, dir_ino,
 					 index, name, name_len, -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
@@ -2737,7 +2741,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	btrfs_release_path(root, path);
 
 	ret = btrfs_del_inode_ref_in_log(trans, root, name, name_len,
-					 inode, dir->i_ino);
+					 inode, dir_ino);
 	BUG_ON(ret != 0 && ret != -ENOENT);
 
 	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
@@ -2815,12 +2819,14 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	int check_link = 1;
 	int err = -ENOSPC;
 	int ret;
+	u64 ino = btrfs_ino(inode);
+	u64 dir_ino = btrfs_ino(dir);
 
 	trans = btrfs_start_transaction(root, 10);
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
-	if (inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+	if (ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return ERR_PTR(-ENOSPC);
 
 	/* check if there is someone else holds reference */
@@ -2879,7 +2885,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 
 	if (ret == 0 && S_ISREG(inode->i_mode)) {
 		ret = btrfs_lookup_file_extent(trans, root, path,
-					       inode->i_ino, (u64)-1, 0);
+					       ino, (u64)-1, 0);
 		if (ret < 0) {
 			err = ret;
 			goto out;
@@ -2895,7 +2901,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 		goto out;
 	}
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
+	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				dentry->d_name.name, dentry->d_name.len, 0);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
@@ -2912,7 +2918,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 
 	ref = btrfs_lookup_inode_ref(trans, root, path,
 				dentry->d_name.name, dentry->d_name.len,
-				inode->i_ino, dir->i_ino, 0);
+				ino, dir_ino, 0);
 	if (IS_ERR(ref)) {
 		err = PTR_ERR(ref);
 		goto out;
@@ -2923,7 +2929,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	index = btrfs_inode_ref_index(path->nodes[0], ref);
 	btrfs_release_path(root, path);
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino, index,
+	di = btrfs_lookup_dir_index_item(trans, root, path, dir_ino, index,
 				dentry->d_name.name, dentry->d_name.len, 0);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
@@ -2998,12 +3004,13 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	u64 index;
 	int ret;
+	u64 dir_ino = btrfs_ino(dir);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
+	di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
 				   name, name_len, -1);
 	BUG_ON(!di || IS_ERR(di));
 
@@ -3016,10 +3023,10 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
-				 dir->i_ino, &index, name, name_len);
+				 dir_ino, &index, name, name_len);
 	if (ret < 0) {
 		BUG_ON(ret != -ENOENT);
-		di = btrfs_search_dir_index_item(root, path, dir->i_ino,
+		di = btrfs_search_dir_index_item(root, path, dir_ino,
 						 name, name_len);
 		BUG_ON(!di || IS_ERR(di));
 
@@ -3029,7 +3036,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		index = key.offset;
 	}
 
-	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
+	di = btrfs_lookup_dir_index_item(trans, root, path, dir_ino,
 					 index, name, name_len, -1);
 	BUG_ON(!di || IS_ERR(di));
 
@@ -3058,7 +3065,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	unsigned long nr = 0;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
-	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+	    btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID)
 		return -ENOTEMPTY;
 
 	trans = __unlink_start_trans(dir, dentry);
@@ -3067,7 +3074,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	btrfs_set_trans_block_group(trans, dir);
 
-	if (unlikely(inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
+	if (unlikely(btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, root, dir,
 					  BTRFS_I(inode)->location.objectid,
 					  dentry->d_name.name,
@@ -3299,6 +3306,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	int encoding;
 	int ret;
 	int err = 0;
+	u64 ino = btrfs_ino(inode);
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -3309,7 +3317,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	BUG_ON(!path);
 	path->reada = -1;
 
-	key.objectid = inode->i_ino;
+	key.objectid = ino;
 	key.offset = (u64)-1;
 	key.type = (u8)-1;
 
@@ -3337,7 +3345,7 @@ search_again:
 		found_type = btrfs_key_type(&found_key);
 		encoding = 0;
 
-		if (found_key.objectid != inode->i_ino)
+		if (found_key.objectid != ino)
 			break;
 
 		if (found_type < min_type)
@@ -3456,7 +3464,7 @@ delete:
 			ret = btrfs_free_extent(trans, root, extent_start,
 						extent_num_bytes, 0,
 						btrfs_header_owner(leaf),
-						inode->i_ino, extent_offset);
+						ino, extent_offset);
 			BUG_ON(ret);
 		}
 
@@ -3655,7 +3663,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				break;
 
 			err = btrfs_insert_file_extent(trans, root,
-					inode->i_ino, cur_offset, 0,
+					btrfs_ino(inode), cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
 			if (err)
@@ -3812,7 +3820,7 @@ void btrfs_evict_inode(struct inode *inode)
 
 	if (!(root == root->fs_info->tree_root ||
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
-		btrfs_return_ino(root, inode->i_ino);
+		btrfs_return_ino(root, btrfs_ino(inode));
 
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
@@ -3839,7 +3847,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	di = btrfs_lookup_dir_item(NULL, root, path, dir->i_ino, name,
+	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
 				    namelen, 0);
 	if (IS_ERR(di))
 		ret = PTR_ERR(di);
@@ -3892,7 +3900,7 @@ static int fixup_tree_root_location(struct btrfs_root *root,
 
 	leaf = path->nodes[0];
 	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_ref);
-	if (btrfs_root_ref_dirid(leaf, ref) != dir->i_ino ||
+	if (btrfs_root_ref_dirid(leaf, ref) != btrfs_ino(dir) ||
 	    btrfs_root_ref_name_len(leaf, ref) != dentry->d_name.len)
 		goto out;
 
@@ -3931,6 +3939,7 @@ static void inode_tree_add(struct inode *inode)
 	struct btrfs_inode *entry;
 	struct rb_node **p;
 	struct rb_node *parent;
+	u64 ino = btrfs_ino(inode);
 again:
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
@@ -3943,9 +3952,9 @@ again:
 		parent = *p;
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
 
-		if (inode->i_ino < entry->vfs_inode.i_ino)
+		if (ino < btrfs_ino(&entry->vfs_inode))
 			p = &parent->rb_left;
-		else if (inode->i_ino > entry->vfs_inode.i_ino)
+		else if (ino > btrfs_ino(&entry->vfs_inode))
 			p = &parent->rb_right;
 		else {
 			WARN_ON(!(entry->vfs_inode.i_state &
@@ -4009,9 +4018,9 @@ again:
 		prev = node;
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
 
-		if (objectid < entry->vfs_inode.i_ino)
+		if (objectid < btrfs_ino(&entry->vfs_inode))
 			node = node->rb_left;
-		else if (objectid > entry->vfs_inode.i_ino)
+		else if (objectid > btrfs_ino(&entry->vfs_inode))
 			node = node->rb_right;
 		else
 			break;
@@ -4019,7 +4028,7 @@ again:
 	if (!node) {
 		while (prev) {
 			entry = rb_entry(prev, struct btrfs_inode, rb_node);
-			if (objectid <= entry->vfs_inode.i_ino) {
+			if (objectid <= btrfs_ino(&entry->vfs_inode)) {
 				node = prev;
 				break;
 			}
@@ -4028,7 +4037,7 @@ again:
 	}
 	while (node) {
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
-		objectid = entry->vfs_inode.i_ino + 1;
+		objectid = btrfs_ino(&entry->vfs_inode) + 1;
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
@@ -4066,7 +4075,7 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
 static int btrfs_find_actor(struct inode *inode, void *opaque)
 {
 	struct btrfs_iget_args *args = opaque;
-	return args->ino == inode->i_ino &&
+	return args->ino == btrfs_ino(inode) &&
 		args->root == BTRFS_I(inode)->root;
 }
 
@@ -4244,9 +4253,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	/* special case for "." */
 	if (filp->f_pos == 0) {
-		over = filldir(dirent, ".", 1,
-			       1, inode->i_ino,
-			       DT_DIR);
+		over = filldir(dirent, ".", 1, 1, btrfs_ino(inode), DT_DIR);
 		if (over)
 			return 0;
 		filp->f_pos = 1;
@@ -4265,7 +4272,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
-	key.objectid = inode->i_ino;
+	key.objectid = btrfs_ino(inode);
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
@@ -4420,8 +4427,9 @@ void btrfs_dirty_inode(struct inode *inode)
 		if (IS_ERR(trans)) {
 			if (printk_ratelimit()) {
 				printk(KERN_ERR "btrfs: fail to "
-				       "dirty  inode %lu error %ld\n",
-				       inode->i_ino, PTR_ERR(trans));
+				       "dirty  inode %llu error %ld\n",
+				       (unsigned long long)btrfs_ino(inode),
+				       PTR_ERR(trans));
 			}
 			return;
 		}
@@ -4431,8 +4439,9 @@ void btrfs_dirty_inode(struct inode *inode)
 		if (ret) {
 			if (printk_ratelimit()) {
 				printk(KERN_ERR "btrfs: fail to "
-				       "dirty  inode %lu error %d\n",
-				       inode->i_ino, ret);
+				       "dirty  inode %llu error %d\n",
+				       (unsigned long long)btrfs_ino(inode),
+				       ret);
 			}
 		}
 	}
@@ -4452,7 +4461,7 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	struct extent_buffer *leaf;
 	int ret;
 
-	key.objectid = inode->i_ino;
+	key.objectid = btrfs_ino(inode);
 	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
 	key.offset = (u64)-1;
 
@@ -4484,7 +4493,7 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-	if (found_key.objectid != inode->i_ino ||
+	if (found_key.objectid != btrfs_ino(inode) ||
 	    btrfs_key_type(&found_key) != BTRFS_DIR_INDEX_KEY) {
 		BTRFS_I(inode)->index_cnt = 2;
 		goto out;
@@ -4657,29 +4666,29 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(parent_inode)->root;
+	u64 ino = btrfs_ino(inode);
+	u64 parent_ino = btrfs_ino(parent_inode);
 
-	if (unlikely(inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &BTRFS_I(inode)->root->root_key, sizeof(key));
 	} else {
-		key.objectid = inode->i_ino;
+		key.objectid = ino;
 		btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 		key.offset = 0;
 	}
 
-	if (unlikely(inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 					 key.objectid, root->root_key.objectid,
-					 parent_inode->i_ino,
-					 index, name, name_len);
+					 parent_ino, index, name, name_len);
 	} else if (add_backref) {
-		ret = btrfs_insert_inode_ref(trans, root,
-					     name, name_len, inode->i_ino,
-					     parent_inode->i_ino, index);
+		ret = btrfs_insert_inode_ref(trans, root, name, name_len, ino,
+					     parent_ino, index);
 	}
 
 	if (ret == 0) {
 		ret = btrfs_insert_dir_item(trans, root, name, name_len,
-					    parent_inode->i_ino, &key,
+					    parent_ino, &key,
 					    btrfs_inode_type(inode), index);
 		BUG_ON(ret);
 
@@ -4738,7 +4747,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, dir->i_ino, objectid,
+				dentry->d_name.len, btrfs_ino(dir), objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
@@ -4800,7 +4809,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, dir->i_ino, objectid,
+				dentry->d_name.len, btrfs_ino(dir), objectid,
 				BTRFS_I(dir)->block_group, mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
@@ -4928,7 +4937,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 		goto out_fail;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, dir->i_ino, objectid,
+				dentry->d_name.len, btrfs_ino(dir), objectid,
 				BTRFS_I(dir)->block_group, S_IFDIR | mode,
 				&index);
 	if (IS_ERR(inode)) {
@@ -5049,7 +5058,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	u64 bytenr;
 	u64 extent_start = 0;
 	u64 extent_end = 0;
-	u64 objectid = inode->i_ino;
+	u64 objectid = btrfs_ino(inode);
 	u32 found_type;
 	struct btrfs_path *path = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -5557,7 +5566,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
+	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
 				       offset, 0);
 	if (ret < 0)
 		goto out;
@@ -5574,7 +5583,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	ret = 0;
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, slot);
-	if (key.objectid != inode->i_ino ||
+	if (key.objectid != btrfs_ino(inode) ||
 	    key.type != BTRFS_EXTENT_DATA_KEY) {
 		/* not our file or wrong item type, must cow */
 		goto out;
@@ -5608,7 +5617,7 @@ static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
 	 * look for other files referencing this extent, if we
 	 * find any we must cow
 	 */
-	if (btrfs_cross_ref_exist(trans, root, inode->i_ino,
+	if (btrfs_cross_ref_exist(trans, root, btrfs_ino(inode),
 				  key.offset - backref_offset, disk_bytenr))
 		goto out;
 
@@ -5798,9 +5807,10 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 
 			flush_dcache_page(bvec->bv_page);
 			if (csum != *private) {
-				printk(KERN_ERR "btrfs csum failed ino %lu off"
+				printk(KERN_ERR "btrfs csum failed ino %llu off"
 				      " %llu csum %u private %u\n",
-				      inode->i_ino, (unsigned long long)start,
+				      (unsigned long long)btrfs_ino(inode),
+				      (unsigned long long)start,
 				      csum, *private);
 				err = -EIO;
 			}
@@ -5947,9 +5957,9 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 
 	if (err) {
-		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
+		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
 		      "sector %#Lx len %u err no %d\n",
-		      dip->inode->i_ino, bio->bi_rw,
+		      (unsigned long long)btrfs_ino(dip->inode), bio->bi_rw,
 		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
 		dip->errors = 1;
 
@@ -6859,8 +6869,8 @@ void btrfs_destroy_inode(struct inode *inode)
 
 	spin_lock(&root->orphan_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		printk(KERN_INFO "BTRFS: inode %lu still on the orphan list\n",
-		       inode->i_ino);
+		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
+		       (unsigned long long)btrfs_ino(inode));
 		list_del_init(&BTRFS_I(inode)->i_orphan);
 	}
 	spin_unlock(&root->orphan_lock);
@@ -6999,16 +7009,17 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u64 index = 0;
 	u64 root_objectid;
 	int ret;
+	u64 old_ino = btrfs_ino(old_inode);
 
-	if (new_dir->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+	if (btrfs_ino(new_dir) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
 
 	/* we only allow rename subvolume link between subvolumes */
-	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
+	if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
 		return -EXDEV;
 
-	if (old_inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
-	    (new_inode && new_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID))
+	if (old_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
+	    (new_inode && btrfs_ino(new_inode) == BTRFS_FIRST_FREE_OBJECTID))
 		return -ENOTEMPTY;
 
 	if (S_ISDIR(old_inode->i_mode) && new_inode &&
@@ -7024,7 +7035,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		filemap_flush(old_inode->i_mapping);
 
 	/* close the racy window with snapshot create/destroy ioctl */
-	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		down_read(&root->fs_info->subvol_sem);
 	/*
 	 * We want to reserve the absolute worst case amount of items.  So if
@@ -7049,15 +7060,15 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (ret)
 		goto out_fail;
 
-	if (unlikely(old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		/* force full log commit if subvolume involved. */
 		root->fs_info->last_trans_log_full_commit = trans->transid;
 	} else {
 		ret = btrfs_insert_inode_ref(trans, dest,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
-					     old_inode->i_ino,
-					     new_dir->i_ino, index);
+					     old_ino,
+					     btrfs_ino(new_dir), index);
 		if (ret)
 			goto out_fail;
 		/*
@@ -7073,10 +7084,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
 	 */
-	if (new_inode && new_inode->i_size &&
-	    old_inode && S_ISREG(old_inode->i_mode)) {
+	if (new_inode && new_inode->i_size && S_ISREG(old_inode->i_mode))
 		btrfs_add_ordered_operation(trans, root, old_inode);
-	}
 
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
@@ -7085,7 +7094,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_dentry->d_parent != new_dentry->d_parent)
 		btrfs_record_unlink_dir(trans, old_dir, old_inode, 1);
 
-	if (unlikely(old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)) {
+	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
 		ret = btrfs_unlink_subvol(trans, root, old_dir, root_objectid,
 					old_dentry->d_name.name,
@@ -7102,7 +7111,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (new_inode) {
 		new_inode->i_ctime = CURRENT_TIME;
-		if (unlikely(new_inode->i_ino ==
+		if (unlikely(btrfs_ino(new_inode) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 			root_objectid = BTRFS_I(new_inode)->location.objectid;
 			ret = btrfs_unlink_subvol(trans, dest, new_dir,
@@ -7130,7 +7139,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			     new_dentry->d_name.len, 0, index);
 	BUG_ON(ret);
 
-	if (old_inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+	if (old_ino != BTRFS_FIRST_FREE_OBJECTID) {
 		struct dentry *parent = dget_parent(new_dentry);
 		btrfs_log_new_name(trans, old_inode, old_dir, parent);
 		dput(parent);
@@ -7139,7 +7148,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 out_fail:
 	btrfs_end_transaction_throttle(trans, root);
 out_notrans:
-	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
 
 	return ret;
@@ -7284,7 +7293,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, dir->i_ino, objectid,
+				dentry->d_name.len, btrfs_ino(dir), objectid,
 				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
 				&index);
 	err = PTR_ERR(inode);
@@ -7315,7 +7324,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
-	key.objectid = inode->i_ino;
+	key.objectid = btrfs_ino(inode);
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
 	datasize = btrfs_file_extent_calc_inline_size(name_len);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e1835f8..01dccb4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -416,7 +416,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	BUG_ON(ret);
 
 	ret = btrfs_insert_dir_item(trans, root,
-				    name, namelen, dir->i_ino, &key,
+				    name, namelen, btrfs_ino(dir), &key,
 				    BTRFS_FT_DIR, index);
 	if (ret)
 		goto fail;
@@ -427,7 +427,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
-				 dir->i_ino, index, name, namelen);
+				 btrfs_ino(dir), index, name, namelen);
 
 	BUG_ON(ret);
 
@@ -1123,7 +1123,7 @@ static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 	int ret = 0;
 	u64 flags = 0;
 
-	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID)
+	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID)
 		return -EINVAL;
 
 	down_read(&root->fs_info->subvol_sem);
@@ -1150,7 +1150,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	if (root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
 
-	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID)
+	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID)
 		return -EINVAL;
 
 	if (copy_from_user(&flags, arg, sizeof(flags)))
@@ -1633,7 +1633,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 			goto out_dput;
 	}
 
-	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
 		err = -EINVAL;
 		goto out_dput;
 	}
@@ -1919,7 +1919,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	}
 
 	/* clone data */
-	key.objectid = src->i_ino;
+	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
 
@@ -1946,7 +1946,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (btrfs_key_type(&key) > BTRFS_EXTENT_DATA_KEY ||
-		    key.objectid != src->i_ino)
+		    key.objectid != btrfs_ino(src))
 			break;
 
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
@@ -1989,7 +1989,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				goto next;
 
 			memcpy(&new_key, &key, sizeof(new_key));
-			new_key.objectid = inode->i_ino;
+			new_key.objectid = btrfs_ino(inode);
 			if (off <= key.offset)
 				new_key.offset = key.offset + destoff - off;
 			else
@@ -2043,7 +2043,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 					ret = btrfs_inc_extent_ref(trans, root,
 							disko, diskl, 0,
 							root->root_key.objectid,
-							inode->i_ino,
+							btrfs_ino(inode),
 							new_key.offset - datao);
 					BUG_ON(ret);
 				}
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e6cb893..7b75e0c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1410,9 +1410,9 @@ again:
 		prev = node;
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
 
-		if (objectid < entry->vfs_inode.i_ino)
+		if (objectid < btrfs_ino(&entry->vfs_inode))
 			node = node->rb_left;
-		else if (objectid > entry->vfs_inode.i_ino)
+		else if (objectid > btrfs_ino(&entry->vfs_inode))
 			node = node->rb_right;
 		else
 			break;
@@ -1420,7 +1420,7 @@ again:
 	if (!node) {
 		while (prev) {
 			entry = rb_entry(prev, struct btrfs_inode, rb_node);
-			if (objectid <= entry->vfs_inode.i_ino) {
+			if (objectid <= btrfs_ino(&entry->vfs_inode)) {
 				node = prev;
 				break;
 			}
@@ -1435,7 +1435,7 @@ again:
 			return inode;
 		}
 
-		objectid = entry->vfs_inode.i_ino + 1;
+		objectid = btrfs_ino(&entry->vfs_inode) + 1;
 		if (cond_resched_lock(&root->inode_lock))
 			goto again;
 
@@ -1471,7 +1471,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 		return -ENOMEM;
 
 	bytenr -= BTRFS_I(reloc_inode)->index_cnt;
-	ret = btrfs_lookup_file_extent(NULL, root, path, reloc_inode->i_ino,
+	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(reloc_inode),
 				       bytenr, 0);
 	if (ret < 0)
 		goto out;
@@ -1559,11 +1559,11 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 			if (first) {
 				inode = find_next_inode(root, key.objectid);
 				first = 0;
-			} else if (inode && inode->i_ino < key.objectid) {
+			} else if (inode && btrfs_ino(inode) < key.objectid) {
 				btrfs_add_delayed_iput(inode);
 				inode = find_next_inode(root, key.objectid);
 			}
-			if (inode && inode->i_ino == key.objectid) {
+			if (inode && btrfs_ino(inode) == key.objectid) {
 				end = key.offset +
 				      btrfs_file_extent_num_bytes(leaf, fi);
 				WARN_ON(!IS_ALIGNED(key.offset,
@@ -1894,6 +1894,7 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 	struct inode *inode = NULL;
 	u64 objectid;
 	u64 start, end;
+	u64 ino;
 
 	objectid = min_key->objectid;
 	while (1) {
@@ -1906,17 +1907,18 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 		inode = find_next_inode(root, objectid);
 		if (!inode)
 			break;
+		ino = btrfs_ino(inode);
 
-		if (inode->i_ino > max_key->objectid) {
+		if (ino > max_key->objectid) {
 			iput(inode);
 			break;
 		}
 
-		objectid = inode->i_ino + 1;
+		objectid = ino + 1;
 		if (!S_ISREG(inode->i_mode))
 			continue;
 
-		if (unlikely(min_key->objectid == inode->i_ino)) {
+		if (unlikely(min_key->objectid == ino)) {
 			if (min_key->type > BTRFS_EXTENT_DATA_KEY)
 				continue;
 			if (min_key->type < BTRFS_EXTENT_DATA_KEY)
@@ -1929,7 +1931,7 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 			start = 0;
 		}
 
-		if (unlikely(max_key->objectid == inode->i_ino)) {
+		if (unlikely(max_key->objectid == ino)) {
 			if (max_key->type < BTRFS_EXTENT_DATA_KEY)
 				continue;
 			if (max_key->type > BTRFS_EXTENT_DATA_KEY) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aef6c81..f4c1184 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -972,7 +972,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				dentry->d_name.name, dentry->d_name.len,
-				parent_inode->i_ino, &key,
+				btrfs_ino(parent_inode), &key,
 				BTRFS_FT_DIR, index);
 	BUG_ON(ret);
 
@@ -1014,7 +1014,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 */
 	ret = btrfs_add_root_ref(trans, tree_root, objectid,
 				 parent_root->root_key.objectid,
-				 parent_inode->i_ino, index,
+				 btrfs_ino(parent_inode), index,
 				 dentry->d_name.name, dentry->d_name.len);
 	BUG_ON(ret);
 	dput(parent);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c50271a..4323dc6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -519,7 +519,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	 * file.  This must be done before the btrfs_drop_extents run
 	 * so we don't try to drop this extent.
 	 */
-	ret = btrfs_lookup_file_extent(trans, root, path, inode->i_ino,
+	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
 				       start, 0);
 
 	if (ret == 0 &&
@@ -832,7 +832,7 @@ again:
 	read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
 
 	/* if we already have a perfect match, we're done */
-	if (inode_in_dir(root, path, dir->i_ino, inode->i_ino,
+	if (inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
 			 btrfs_inode_ref_index(eb, ref),
 			 name, namelen)) {
 		goto out;
@@ -960,8 +960,9 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	unsigned long ptr;
 	unsigned long ptr_end;
 	int name_len;
+	u64 ino = btrfs_ino(inode);
 
-	key.objectid = inode->i_ino;
+	key.objectid = ino;
 	key.type = BTRFS_INODE_REF_KEY;
 	key.offset = (u64)-1;
 
@@ -980,7 +981,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &key,
 				      path->slots[0]);
-		if (key.objectid != inode->i_ino ||
+		if (key.objectid != ino ||
 		    key.type != BTRFS_INODE_REF_KEY)
 			break;
 		ptr = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
@@ -1011,10 +1012,10 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	if (inode->i_nlink == 0) {
 		if (S_ISDIR(inode->i_mode)) {
 			ret = replay_dir_deletes(trans, root, NULL, path,
-						 inode->i_ino, 1);
+						 ino, 1);
 			BUG_ON(ret);
 		}
-		ret = insert_orphan_item(trans, root, inode->i_ino);
+		ret = insert_orphan_item(trans, root, ino);
 		BUG_ON(ret);
 	}
 	btrfs_free_path(path);
@@ -2197,6 +2198,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 	int bytes_del = 0;
+	u64 dir_ino = btrfs_ino(dir);
 
 	if (BTRFS_I(dir)->logged_trans < trans->transid)
 		return 0;
@@ -2212,7 +2214,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
+	di = btrfs_lookup_dir_item(trans, log, path, dir_ino,
 				   name, name_len, -1);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
@@ -2224,7 +2226,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 	}
 	btrfs_release_path(log, path);
-	di = btrfs_lookup_dir_index_item(trans, log, path, dir->i_ino,
+	di = btrfs_lookup_dir_index_item(trans, log, path, dir_ino,
 					 index, name, name_len, -1);
 	if (IS_ERR(di)) {
 		err = PTR_ERR(di);
@@ -2242,7 +2244,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (bytes_del) {
 		struct btrfs_key key;
 
-		key.objectid = dir->i_ino;
+		key.objectid = dir_ino;
 		key.offset = 0;
 		key.type = BTRFS_INODE_ITEM_KEY;
 		btrfs_release_path(log, path);
@@ -2300,7 +2302,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 	log = root->log_root;
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, inode->i_ino,
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 	if (ret == -ENOSPC) {
@@ -2366,13 +2368,14 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	int nritems;
 	u64 first_offset = min_offset;
 	u64 last_offset = (u64)-1;
+	u64 ino = btrfs_ino(inode);
 
 	log = root->log_root;
-	max_key.objectid = inode->i_ino;
+	max_key.objectid = ino;
 	max_key.offset = (u64)-1;
 	max_key.type = key_type;
 
-	min_key.objectid = inode->i_ino;
+	min_key.objectid = ino;
 	min_key.type = key_type;
 	min_key.offset = min_offset;
 
@@ -2385,9 +2388,8 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	 * we didn't find anything from this transaction, see if there
 	 * is anything at all
 	 */
-	if (ret != 0 || min_key.objectid != inode->i_ino ||
-	    min_key.type != key_type) {
-		min_key.objectid = inode->i_ino;
+	if (ret != 0 || min_key.objectid != ino || min_key.type != key_type) {
+		min_key.objectid = ino;
 		min_key.type = key_type;
 		min_key.offset = (u64)-1;
 		btrfs_release_path(root, path);
@@ -2396,7 +2398,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 			btrfs_release_path(root, path);
 			return ret;
 		}
-		ret = btrfs_previous_item(root, path, inode->i_ino, key_type);
+		ret = btrfs_previous_item(root, path, ino, key_type);
 
 		/* if ret == 0 there are items for this type,
 		 * create a range to tell us the last key of this type.
@@ -2414,7 +2416,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	}
 
 	/* go backward to find any previous key */
-	ret = btrfs_previous_item(root, path, inode->i_ino, key_type);
+	ret = btrfs_previous_item(root, path, ino, key_type);
 	if (ret == 0) {
 		struct btrfs_key tmp;
 		btrfs_item_key_to_cpu(path->nodes[0], &tmp, path->slots[0]);
@@ -2449,8 +2451,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 		for (i = path->slots[0]; i < nritems; i++) {
 			btrfs_item_key_to_cpu(src, &min_key, i);
 
-			if (min_key.objectid != inode->i_ino ||
-			    min_key.type != key_type)
+			if (min_key.objectid != ino || min_key.type != key_type)
 				goto done;
 			ret = overwrite_item(trans, log, dst_path, src, i,
 					     &min_key);
@@ -2471,7 +2472,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 			goto done;
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &tmp, path->slots[0]);
-		if (tmp.objectid != inode->i_ino || tmp.type != key_type) {
+		if (tmp.objectid != ino || tmp.type != key_type) {
 			last_offset = (u64)-1;
 			goto done;
 		}
@@ -2497,8 +2498,7 @@ done:
 		 * is valid
 		 */
 		ret = insert_dir_log_key(trans, log, path, key_type,
-					 inode->i_ino, first_offset,
-					 last_offset);
+					 ino, first_offset, last_offset);
 		if (ret)
 			err = ret;
 	}
@@ -2742,6 +2742,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int nritems;
 	int ins_start_slot = 0;
 	int ins_nr;
+	u64 ino = btrfs_ino(inode);
 
 	log = root->log_root;
 
@@ -2754,11 +2755,11 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	}
 
-	min_key.objectid = inode->i_ino;
+	min_key.objectid = ino;
 	min_key.type = BTRFS_INODE_ITEM_KEY;
 	min_key.offset = 0;
 
-	max_key.objectid = inode->i_ino;
+	max_key.objectid = ino;
 
 	/* today the code can only do partial logging of directories */
 	if (!S_ISDIR(inode->i_mode))
@@ -2781,8 +2782,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 		if (inode_only == LOG_INODE_EXISTS)
 			max_key_type = BTRFS_XATTR_ITEM_KEY;
-		ret = drop_objectid_items(trans, log, path,
-					  inode->i_ino, max_key_type);
+		ret = drop_objectid_items(trans, log, path, ino, max_key_type);
 	} else {
 		ret = btrfs_truncate_inode_items(trans, log, inode, 0, 0);
 	}
@@ -2800,7 +2800,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			break;
 again:
 		/* note, ins_nr might be > 0 here, cleanup outside the loop */
-		if (min_key.objectid != inode->i_ino)
+		if (min_key.objectid != ino)
 			break;
 		if (min_key.type > max_key.type)
 			break;
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 07b9bc3..a8af771 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -44,7 +44,7 @@ ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 		return -ENOMEM;
 
 	/* lookup the xattr by name */
-	di = btrfs_lookup_xattr(NULL, root, path, inode->i_ino, name,
+	di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode), name,
 				strlen(name), 0);
 	if (!di) {
 		ret = -ENODATA;
@@ -103,7 +103,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	/* first lets see if we already have this xattr */
-	di = btrfs_lookup_xattr(trans, root, path, inode->i_ino, name,
+	di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode), name,
 				strlen(name), -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
@@ -136,7 +136,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	}
 
 	/* ok we have to create a completely new xattr */
-	ret = btrfs_insert_xattr_item(trans, root, path, inode->i_ino,
+	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
 				      name, name_len, value, size);
 	BUG_ON(ret);
 out:
@@ -190,7 +190,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	 * NOTE: we set key.offset = 0; because we want to start with the
 	 * first xattr that we find and walk forward
 	 */
-	key.objectid = inode->i_ino;
+	key.objectid = btrfs_ino(inode);
 	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
 	key.offset = 0;
 
-- 
1.7.3.1
