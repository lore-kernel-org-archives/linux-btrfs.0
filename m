From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 1/3] btrfs: remove struct btrfs_root parameter where unused
Date: Tue, 31 May 2011 12:16:24 +0200
Message-ID: <e7d42ff00936a6db517b304e15b74e81b1acfd96.1306836192.git.sensille@gmx.net>
References: <cover.1306836192.git.sensille@gmx.net>
Cc: julia@diku.dk
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1306836192.git.sensille@gmx.net>
In-Reply-To: <cover.1306836192.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

The following functions had a struct btrfs_root * parameter which went
unused:

btrfs_set_block_group_rw
btrfs_destroy_delayed_refs
btrfs_csum_data
extent_data_ref_count
copy_to_sk

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/compression.c      |    3 +--
 fs/btrfs/ctree.c            |   20 ++++++++++----------
 fs/btrfs/ctree.h            |    5 +----
 fs/btrfs/disk-io.c          |   14 ++++++--------
 fs/btrfs/disk-io.h          |    2 +-
 fs/btrfs/extent-tree.c      |   16 ++++++----------
 fs/btrfs/file-item.c        |    3 +--
 fs/btrfs/free-space-cache.c |    6 +++---
 fs/btrfs/inode.c            |    7 +++----
 fs/btrfs/ioctl.c            |    5 ++---
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/scrub.c            |    7 +++----
 12 files changed, 38 insertions(+), 52 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bfe42b0..2182cc5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -105,7 +105,6 @@ static int check_compressed_csum(struct inode *inode,
 				 u64 disk_start)
 {
 	int ret;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page *page;
 	unsigned long i;
 	char *kaddr;
@@ -120,7 +119,7 @@ static int check_compressed_csum(struct inode *inode,
 		csum = ~(u32)0;
 
 		kaddr = kmap_atomic(page, KM_USER0);
-		csum = btrfs_csum_data(root, kaddr, csum, PAGE_CACHE_SIZE);
+		csum = btrfs_csum_data(kaddr, csum, PAGE_CACHE_SIZE);
 		btrfs_csum_final(csum, (char *)&csum);
 		kunmap_atomic(kaddr, KM_USER0);
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b0e18d9..670bed7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -339,7 +339,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 		if (new_flags != 0) {
-			ret = btrfs_set_disk_extent_flags(trans, root,
+			ret = btrfs_set_disk_extent_flags(trans,
 							  buf->start,
 							  buf->len,
 							  new_flags, 0);
@@ -1763,7 +1763,7 @@ done:
  * fixing up the blocks in ram so the tree is consistent.
  */
 static int fixup_low_keys(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct btrfs_path *path,
+			  struct btrfs_path *path,
 			  struct btrfs_disk_key *key, int level)
 {
 	int i;
@@ -1814,7 +1814,7 @@ int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
-		fixup_low_keys(trans, root, path, &disk_key, 1);
+		fixup_low_keys(trans, path, &disk_key, 1);
 	return 0;
 }
 
@@ -2579,7 +2579,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
+	wret = fixup_low_keys(trans, path, &disk_key, 1);
 	if (wret)
 		ret = wret;
 
@@ -2966,7 +2966,7 @@ again:
 			path->nodes[0] = right;
 			path->slots[0] = 0;
 			if (path->slots[1] == 0) {
-				wret = fixup_low_keys(trans, root,
+				wret = fixup_low_keys(trans,
 						path, &disk_key, 1);
 				if (wret)
 					ret = wret;
@@ -3301,7 +3301,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
-			fixup_low_keys(trans, root, path, &disk_key, 1);
+			fixup_low_keys(trans, path, &disk_key, 1);
 	}
 
 	item = btrfs_item_nr(leaf, slot);
@@ -3532,7 +3532,7 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		ret = fixup_low_keys(trans, path, &disk_key, 1);
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -3638,7 +3638,7 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		ret = fixup_low_keys(trans, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_mark_buffer_dirty(leaf);
@@ -3745,7 +3745,7 @@ static int del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
+		wret = fixup_low_keys(trans, path, &disk_key, level + 1);
 		if (wret)
 			ret = wret;
 	}
@@ -3862,7 +3862,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
+			wret = fixup_low_keys(trans, path,
 					      &disk_key, 1);
 			if (wret)
 				ret = wret;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6c093fa..b51a06c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2148,7 +2148,6 @@ struct extent_buffer *btrfs_init_new_buffer(struct btrfs_trans_handle *trans,
 					    u64 bytenr, u32 blocksize,
 					    int level);
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, struct btrfs_key *ins);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
@@ -2166,7 +2165,6 @@ int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref);
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int is_data);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
@@ -2240,8 +2238,7 @@ void btrfs_block_rsv_release(struct btrfs_root *root,
 			     u64 num_bytes);
 int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
-int btrfs_set_block_group_rw(struct btrfs_root *root,
-			     struct btrfs_block_group_cache *cache);
+int btrfs_set_block_group_rw(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_cache(struct btrfs_fs_info *info);
 u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 98b6a71..c67a1e6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -51,8 +51,7 @@ static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
 static int btrfs_destroy_ordered_operations(struct btrfs_root *root);
 static int btrfs_destroy_ordered_extents(struct btrfs_root *root);
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_root *root);
+static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans);
 static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
 static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
@@ -194,7 +193,7 @@ out:
 	return em;
 }
 
-u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
+u32 btrfs_csum_data(char *data, u32 seed, size_t len)
 {
 	return crc32c(seed, data, len);
 }
@@ -233,7 +232,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		if (err)
 			return 1;
 		cur_len = min(len, map_len - (offset - map_start));
-		crc = btrfs_csum_data(root, kaddr + offset - map_start,
+		crc = btrfs_csum_data(kaddr + offset - map_start,
 				      crc, cur_len);
 		len -= cur_len;
 		offset += cur_len;
@@ -2259,7 +2258,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			btrfs_set_super_bytenr(sb, bytenr);
 
 			crc = ~(u32)0;
-			crc = btrfs_csum_data(NULL, (char *)sb +
+			crc = btrfs_csum_data((char *)sb +
 					      BTRFS_CSUM_SIZE, crc,
 					      BTRFS_SUPER_INFO_SIZE -
 					      BTRFS_CSUM_SIZE);
@@ -2830,8 +2829,7 @@ static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
 	return 0;
 }
 
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_root *root)
+static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans)
 {
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
@@ -3037,7 +3035,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 		btrfs_destroy_ordered_extents(root);
 
-		btrfs_destroy_delayed_refs(t, root);
+		btrfs_destroy_delayed_refs(t);
 
 		btrfs_block_rsv_release(root,
 					&root->fs_info->trans_block_rsv,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index a0b610a..b5e0a55 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -67,7 +67,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
 int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
-u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
+u32 btrfs_csum_data(char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			int metadata);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 169bd62..2236c77 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1232,8 +1232,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline u32 extent_data_ref_count(struct btrfs_root *root,
-					  struct btrfs_path *path,
+static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 					  struct btrfs_extent_inline_ref *iref)
 {
 	struct btrfs_key key;
@@ -2322,7 +2321,6 @@ out:
 }
 
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
 				int is_data)
 {
@@ -4495,7 +4493,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	} else {
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
-			       extent_data_ref_count(root, path, iref));
+			       extent_data_ref_count(path, iref));
 			if (iref) {
 				BUG_ON(path->slots[0] != extent_slot);
 			} else {
@@ -4533,7 +4531,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
  * removes it from the tree.
  */
 static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root, u64 bytenr)
+				      u64 bytenr)
 {
 	struct btrfs_delayed_ref_head *head;
 	struct btrfs_delayed_ref_root *delayed_refs;
@@ -4630,7 +4628,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 	if (btrfs_header_generation(buf) == trans->transid) {
 		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-			ret = check_ref_cleanup(trans, root, buf->start);
+			ret = check_ref_cleanup(trans, buf->start);
 			if (!ret)
 				goto pin;
 		}
@@ -5502,7 +5500,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, struct btrfs_key *ins)
 {
@@ -5886,7 +5883,7 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 		ret = btrfs_dec_ref(trans, root, eb, 0);
 		BUG_ON(ret);
-		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
+		ret = btrfs_set_disk_extent_flags(trans, eb->start,
 						  eb->len, flag, 0);
 		BUG_ON(ret);
 		wc->flags[level] |= flag;
@@ -6612,8 +6609,7 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
 	return free_bytes;
 }
 
-int btrfs_set_block_group_rw(struct btrfs_root *root,
-			      struct btrfs_block_group_cache *cache)
+int btrfs_set_block_group_rw(struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 90d4ee5..dd8afad 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -439,8 +439,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 
 		data = kmap_atomic(bvec->bv_page, KM_USER0);
 		sector_sum->sum = ~(u32)0;
-		sector_sum->sum = btrfs_csum_data(root,
-						  data + bvec->bv_offset,
+		sector_sum->sum = btrfs_csum_data(data + bvec->bv_offset,
 						  sector_sum->sum,
 						  bvec->bv_len);
 		kunmap_atomic(data, KM_USER0);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 70d4579..898f184 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -361,7 +361,7 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 
 		/* First lets check our crc before we do anything fun */
 		cur_crc = ~(u32)0;
-		cur_crc = btrfs_csum_data(root, addr + start_offset, cur_crc,
+		cur_crc = btrfs_csum_data(addr + start_offset, cur_crc,
 					  PAGE_CACHE_SIZE - start_offset);
 		btrfs_csum_final(cur_crc, (char *)&cur_crc);
 		if (cur_crc != *crc) {
@@ -730,7 +730,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			entry++;
 		}
 		*crc = ~(u32)0;
-		*crc = btrfs_csum_data(root, addr + start_offset, *crc,
+		*crc = btrfs_csum_data(addr + start_offset, *crc,
 				       PAGE_CACHE_SIZE - start_offset);
 		kunmap(page);
 
@@ -757,7 +757,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		addr = kmap(page);
 		memcpy(addr, entry->bitmap, PAGE_CACHE_SIZE);
 		*crc = ~(u32)0;
-		*crc = btrfs_csum_data(root, addr, *crc, PAGE_CACHE_SIZE);
+		*crc = btrfs_csum_data(addr, *crc, PAGE_CACHE_SIZE);
 		kunmap(page);
 		btrfs_csum_final(*crc, (char *)crc);
 		crc++;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 39a9d57..25e73f1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1692,7 +1692,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
+	ret = btrfs_alloc_reserved_file_extent(trans,
 					root->root_key.objectid,
 					btrfs_ino(inode), file_pos, &ins);
 	BUG_ON(ret);
@@ -2009,7 +2009,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	if (ret)
 		goto zeroit;
 
-	csum = btrfs_csum_data(root, kaddr + offset, csum,  end - start + 1);
+	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
 	btrfs_csum_final(csum, (char *)&csum);
 	if (csum != private)
 		goto zeroit;
@@ -5678,7 +5678,6 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	struct inode *inode = dip->inode;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start;
 	u32 *private = dip->csums;
 
@@ -5692,7 +5691,7 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 
 			local_irq_save(flags);
 			kaddr = kmap_atomic(page, KM_IRQ0);
-			csum = btrfs_csum_data(root, kaddr + bvec->bv_offset,
+			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
 					       csum, bvec->bv_len);
 			btrfs_csum_final(csum, (char *)&csum);
 			kunmap_atomic(kaddr, KM_IRQ0);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 85e818c..db439a3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1505,8 +1505,7 @@ static noinline int key_in_sk(struct btrfs_key *key,
 	return 1;
 }
 
-static noinline int copy_to_sk(struct btrfs_root *root,
-			       struct btrfs_path *path,
+static noinline int copy_to_sk(struct btrfs_path *path,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
 			       char *buf,
@@ -1640,7 +1639,7 @@ static noinline int search_ioctl(struct inode *inode,
 				ret = 0;
 			goto err;
 		}
-		ret = copy_to_sk(root, path, &key, sk, args->buf,
+		ret = copy_to_sk(path, &key, sk, args->buf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
 		if (ret || num_found >= sk->nr_items)
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ca38eca..d084400 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4043,7 +4043,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
 out:
 	if (err && rw)
-		btrfs_set_block_group_rw(extent_root, rc->block_group);
+		btrfs_set_block_group_rw(rc->block_group);
 	iput(rc->data_inode);
 	btrfs_put_block_group(rc->block_group);
 	kfree(rc);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6dfed0c..1541915 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -467,12 +467,11 @@ static int scrub_checksum_data(struct scrub_dev *sdev,
 	u8 csum[BTRFS_CSUM_SIZE];
 	u32 crc = ~(u32)0;
 	int fail = 0;
-	struct btrfs_root *root = sdev->dev->dev_root;
 
 	if (!spag->have_csum)
 		return 0;
 
-	crc = btrfs_csum_data(root, buffer, crc, PAGE_SIZE);
+	crc = btrfs_csum_data(buffer, crc, PAGE_SIZE);
 	btrfs_csum_final(crc, csum);
 	if (memcmp(csum, spag->csum, sdev->csum_size))
 		fail = 1;
@@ -519,7 +518,7 @@ static int scrub_checksum_tree_block(struct scrub_dev *sdev,
 		   BTRFS_UUID_SIZE))
 		++fail;
 
-	crc = btrfs_csum_data(root, buffer + BTRFS_CSUM_SIZE, crc,
+	crc = btrfs_csum_data(buffer + BTRFS_CSUM_SIZE, crc,
 			      PAGE_SIZE - BTRFS_CSUM_SIZE);
 	btrfs_csum_final(crc, csum);
 	if (memcmp(csum, h->csum, sdev->csum_size))
@@ -560,7 +559,7 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
 		++fail;
 
-	crc = btrfs_csum_data(root, buffer + BTRFS_CSUM_SIZE, crc,
+	crc = btrfs_csum_data(buffer + BTRFS_CSUM_SIZE, crc,
 			      PAGE_SIZE - BTRFS_CSUM_SIZE);
 	btrfs_csum_final(crc, csum);
 	if (memcmp(csum, s->csum, sbio->sdev->csum_size))
-- 
1.7.3.4

