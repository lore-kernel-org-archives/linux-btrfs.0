Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307AbaDXFaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 01:30:15 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3O5U81v011761
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 13:30:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 2/2] Btrfs: fix broken free space cache after the system crashed
Date: Thu, 24 Apr 2014 13:31:56 +0800
Message-ID: <1398317516-29575-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1398317516-29575-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com>
 <1398317516-29575-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we mounted the filesystem after the crash, we got the following
message:
  BTRFS error (device xxx): block group xxxx has wrong amount of free space
  BTRFS error (device xxx): failed to load free space cache for block group xxx

It is because we didn't update the metadata of the allocated space (in extent
tree) until the file data was written into the disk. During this time, there was
no information about the allocated spaces in either the extent tree nor the
free space cache. when we wrote out the free space cache at this time (commit
transaction), those spaces were lost. In fact, only the free space that is
used to store the file data had this problem, the others didn't because
the metadata of them is updated in the same transaction context.

There are many methods which can fix the above problem
- track the allocated space, and write it out when we write out the free
  space cache
- account the size of the allocated space that is used to store the file
  data, if the size is not zero, don't write out the free space cache.

The first one is complex and may make the performance drop down.
This patch chose the second method, we use a per-block-group variant to
account the size of that allocated space. Besides that, we also introduce
a per-block-group read-write semaphore to avoid the race between
the allocation and the free space cache write out.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2
- use the other method to fix the problem.
---
 fs/btrfs/ctree.h            |  13 ++++-
 fs/btrfs/extent-tree.c      | 135 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/free-space-cache.c |  20 +++++++
 fs/btrfs/inode.c            |  41 ++++++++++----
 4 files changed, 165 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2a9d32e..6ffd77b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1235,11 +1235,19 @@ struct btrfs_block_group_cache {
 	spinlock_t lock;
 	u64 pinned;
 	u64 reserved;
+	u64 delalloc_bytes;
 	u64 bytes_super;
 	u64 flags;
 	u64 sectorsize;
 	u64 cache_generation;
 
+	/*
+	 * It is just used for the delayed data space allocation because
+	 * only the data space allocation and the relative metadata update
+	 * can be done cross the transaction.
+	 */
+	struct rw_semaphore data_rwsem;
+
 	/* for raid56, this is a full stripe, without parity */
 	unsigned long full_stripe_len;
 
@@ -3252,7 +3260,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   struct btrfs_key *ins);
 int btrfs_reserve_extent(struct btrfs_root *root, u64 num_bytes,
 			 u64 min_alloc_size, u64 empty_size, u64 hint_byte,
-			 struct btrfs_key *ins, int is_data);
+			 struct btrfs_key *ins, int is_data, int delalloc);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref, int for_cow);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -3266,7 +3274,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
 		      u64 owner, u64 offset, int for_cow);
 
-int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
+int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len,
+			       int delalloc);
 int btrfs_free_and_pin_reserved_extent(struct btrfs_root *root,
 				       u64 start, u64 len);
 void btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c6b6a6e..d049b7e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -103,7 +103,8 @@ static int find_next_key(struct btrfs_path *path, int level,
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups);
 static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				       u64 num_bytes, int reserve);
+				       u64 num_bytes, int reserve,
+				       int delalloc);
 static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
 			       u64 num_bytes);
 int btrfs_pin_extent(struct btrfs_root *root,
@@ -3162,7 +3163,8 @@ again:
 
 	spin_lock(&block_group->lock);
 	if (block_group->cached != BTRFS_CACHE_FINISHED ||
-	    !btrfs_test_opt(root, SPACE_CACHE)) {
+	    !btrfs_test_opt(root, SPACE_CACHE) ||
+	    block_group->delalloc_bytes) {
 		/*
 		 * don't bother trying to write stuff out _if_
 		 * a) we're not cached,
@@ -5412,6 +5414,7 @@ int btrfs_exclude_logged_extents(struct btrfs_root *log,
  * @cache:	The cache we are manipulating
  * @num_bytes:	The number of bytes in question
  * @reserve:	One of the reservation enums
+ * @delalloc:   The blocks are allocated for the delalloc write
  *
  * This is called by the allocator when it reserves space, or by somebody who is
  * freeing space that was never actually used on disk.  For example if you
@@ -5430,7 +5433,7 @@ int btrfs_exclude_logged_extents(struct btrfs_root *log,
  * succeeds.
  */
 static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
-				       u64 num_bytes, int reserve)
+				       u64 num_bytes, int reserve, int delalloc)
 {
 	struct btrfs_space_info *space_info = cache->space_info;
 	int ret = 0;
@@ -5449,12 +5452,18 @@ static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
 						num_bytes, 0);
 				space_info->bytes_may_use -= num_bytes;
 			}
+
+			if (delalloc)
+				cache->delalloc_bytes += num_bytes;
 		}
 	} else {
 		if (cache->ro)
 			space_info->bytes_readonly += num_bytes;
 		cache->reserved -= num_bytes;
 		space_info->bytes_reserved -= num_bytes;
+
+		if (delalloc)
+			cache->delalloc_bytes -= num_bytes;
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
@@ -5980,7 +5989,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
 
 		btrfs_add_free_space(cache, buf->start, buf->len);
-		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE);
+		btrfs_update_reserved_bytes(cache, buf->len, RESERVE_FREE, 0);
 		trace_btrfs_reserved_extent_free(root, buf->start, buf->len);
 		pin = 0;
 	}
@@ -6135,6 +6144,62 @@ enum btrfs_loop_type {
 	LOOP_NO_EMPTY_SIZE = 3,
 };
 
+static inline void
+btrfs_grab_block_group(struct btrfs_block_group_cache *cache,
+		       int delalloc)
+{
+	btrfs_get_block_group(cache);
+	if (delalloc)
+		down_read(&cache->data_rwsem);
+}
+
+static struct btrfs_block_group_cache *
+btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
+		   struct btrfs_free_cluster *cluster,
+		   int delalloc)
+{
+	struct btrfs_block_group_cache *used_bg;
+	bool locked = false;
+again:
+	spin_lock(&cluster->refill_lock);
+	if (locked) {
+		if (used_bg == cluster->block_group)
+			return used_bg;
+
+		up_read(&used_bg->data_rwsem);
+		btrfs_put_block_group(used_bg);
+	}
+
+	used_bg = cluster->block_group;
+	if (!used_bg)
+		return NULL;
+
+	if (used_bg == block_group)
+		return used_bg;
+
+	btrfs_get_block_group(used_bg);
+
+	if (!delalloc)
+		return used_bg;
+
+	if (down_read_trylock(&used_bg->data_rwsem))
+		return used_bg;
+
+	spin_unlock(&cluster->refill_lock);
+	down_read(&used_bg->data_rwsem);
+	locked = true;
+	goto again;
+}
+
+static inline void
+btrfs_release_block_group(struct btrfs_block_group_cache *cache,
+			 int delalloc)
+{
+	if (delalloc)
+		up_read(&cache->data_rwsem);
+	btrfs_put_block_group(cache);
+}
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -6149,7 +6214,7 @@ enum btrfs_loop_type {
 static noinline int find_free_extent(struct btrfs_root *orig_root,
 				     u64 num_bytes, u64 empty_size,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     u64 flags)
+				     u64 flags, int delalloc)
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
@@ -6237,6 +6302,7 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 				up_read(&space_info->groups_sem);
 			} else {
 				index = get_block_group_index(block_group);
+				btrfs_grab_block_group(block_group, delalloc);
 				goto have_block_group;
 			}
 		} else if (block_group) {
@@ -6251,7 +6317,7 @@ search:
 		u64 offset;
 		int cached;
 
-		btrfs_get_block_group(block_group);
+		btrfs_grab_block_group(block_group, delalloc);
 		search_start = block_group->key.objectid;
 
 		/*
@@ -6299,16 +6365,16 @@ have_block_group:
 			 * the refill lock keeps out other
 			 * people trying to start a new cluster
 			 */
-			spin_lock(&last_ptr->refill_lock);
-			used_block_group = last_ptr->block_group;
-			if (used_block_group != block_group &&
-			    (!used_block_group ||
-			     used_block_group->ro ||
-			     !block_group_bits(used_block_group, flags)))
+			used_block_group = btrfs_lock_cluster(block_group,
+							      last_ptr,
+							      delalloc);
+			if (!used_block_group)
 				goto refill_cluster;
 
-			if (used_block_group != block_group)
-				btrfs_get_block_group(used_block_group);
+			if (used_block_group != block_group &&
+			    (used_block_group->ro ||
+			     !block_group_bits(used_block_group, flags)))
+				goto release_cluster;
 
 			offset = btrfs_alloc_from_cluster(used_block_group,
 						last_ptr,
@@ -6322,16 +6388,15 @@ have_block_group:
 						used_block_group,
 						search_start, num_bytes);
 				if (used_block_group != block_group) {
-					btrfs_put_block_group(block_group);
+					btrfs_release_block_group(block_group,
+								  delalloc);
 					block_group = used_block_group;
 				}
 				goto checks;
 			}
 
 			WARN_ON(last_ptr->block_group != used_block_group);
-			if (used_block_group != block_group)
-				btrfs_put_block_group(used_block_group);
-refill_cluster:
+release_cluster:
 			/* If we are on LOOP_NO_EMPTY_SIZE, we can't
 			 * set up a new clusters, so lets just skip it
 			 * and let the allocator find whatever block
@@ -6348,8 +6413,10 @@ refill_cluster:
 			 * succeeding in the unclustered
 			 * allocation.  */
 			if (loop >= LOOP_NO_EMPTY_SIZE &&
-			    last_ptr->block_group != block_group) {
+			    used_block_group != block_group) {
 				spin_unlock(&last_ptr->refill_lock);
+				btrfs_release_block_group(used_block_group,
+							  delalloc);
 				goto unclustered_alloc;
 			}
 
@@ -6359,6 +6426,10 @@ refill_cluster:
 			 */
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
 
+			if (used_block_group != block_group)
+				btrfs_release_block_group(used_block_group,
+							  delalloc);
+refill_cluster:
 			if (loop >= LOOP_NO_EMPTY_SIZE) {
 				spin_unlock(&last_ptr->refill_lock);
 				goto unclustered_alloc;
@@ -6466,7 +6537,7 @@ checks:
 		BUG_ON(offset > search_start);
 
 		ret = btrfs_update_reserved_bytes(block_group, num_bytes,
-						  alloc_type);
+						  alloc_type, delalloc);
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
@@ -6478,13 +6549,13 @@ checks:
 
 		trace_btrfs_reserve_extent(orig_root, block_group,
 					   search_start, num_bytes);
-		btrfs_put_block_group(block_group);
+		btrfs_release_block_group(block_group, delalloc);
 		break;
 loop:
 		failed_cluster_refill = false;
 		failed_alloc = false;
 		BUG_ON(index != get_block_group_index(block_group));
-		btrfs_put_block_group(block_group);
+		btrfs_release_block_group(block_group, delalloc);
 	}
 	up_read(&space_info->groups_sem);
 
@@ -6590,7 +6661,7 @@ again:
 int btrfs_reserve_extent(struct btrfs_root *root,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
-			 struct btrfs_key *ins, int is_data)
+			 struct btrfs_key *ins, int is_data, int delalloc)
 {
 	bool final_tried = false;
 	u64 flags;
@@ -6600,7 +6671,7 @@ int btrfs_reserve_extent(struct btrfs_root *root,
 again:
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(root, num_bytes, empty_size, hint_byte, ins,
-			       flags);
+			       flags, delalloc);
 
 	if (ret == -ENOSPC) {
 		if (!final_tried && ins->offset) {
@@ -6625,7 +6696,8 @@ again:
 }
 
 static int __btrfs_free_reserved_extent(struct btrfs_root *root,
-					u64 start, u64 len, int pin)
+					u64 start, u64 len,
+					int pin, int delalloc)
 {
 	struct btrfs_block_group_cache *cache;
 	int ret = 0;
@@ -6644,7 +6716,7 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 		pin_down_extent(root, cache, start, len, 1);
 	else {
 		btrfs_add_free_space(cache, start, len);
-		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE);
+		btrfs_update_reserved_bytes(cache, len, RESERVE_FREE, delalloc);
 	}
 	btrfs_put_block_group(cache);
 
@@ -6654,15 +6726,15 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 }
 
 int btrfs_free_reserved_extent(struct btrfs_root *root,
-					u64 start, u64 len)
+			       u64 start, u64 len, int delalloc)
 {
-	return __btrfs_free_reserved_extent(root, start, len, 0);
+	return __btrfs_free_reserved_extent(root, start, len, 0, delalloc);
 }
 
 int btrfs_free_and_pin_reserved_extent(struct btrfs_root *root,
 				       u64 start, u64 len)
 {
-	return __btrfs_free_reserved_extent(root, start, len, 1);
+	return __btrfs_free_reserved_extent(root, start, len, 1, 0);
 }
 
 static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
@@ -6859,7 +6931,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 
 	ret = btrfs_update_reserved_bytes(block_group, ins->offset,
-					  RESERVE_ALLOC_NO_ACCOUNT);
+					  RESERVE_ALLOC_NO_ACCOUNT, 0);
 	BUG_ON(ret); /* logic error */
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
@@ -6992,7 +7064,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		return ERR_CAST(block_rsv);
 
 	ret = btrfs_reserve_extent(root, blocksize, blocksize,
-				   empty_size, hint, &ins, 0);
+				   empty_size, hint, &ins, 0, 0);
 	if (ret) {
 		unuse_block_rsv(root->fs_info, block_rsv, blocksize);
 		return ERR_PTR(ret);
@@ -8381,6 +8453,7 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
 					       start);
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
+	init_rwsem(&cache->data_rwsem);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 	INIT_LIST_HEAD(&cache->new_bg_list);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a6bd654..2f6df5b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1091,12 +1091,29 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		spin_unlock(&block_group->lock);
 		return 0;
 	}
+
+	if (block_group->delalloc_bytes) {
+		block_group->disk_cache_state = BTRFS_DC_WRITTEN;
+		spin_unlock(&block_group->lock);
+		return 0;
+	}
 	spin_unlock(&block_group->lock);
 
 	inode = lookup_free_space_inode(root, block_group, path);
 	if (IS_ERR(inode))
 		return 0;
 
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA) {
+		down_write(&block_group->data_rwsem);
+		spin_lock(&block_group->lock);
+		if (block_group->delalloc_bytes) {
+			block_group->disk_cache_state = BTRFS_DC_WRITTEN;
+			spin_unlock(&block_group->lock);
+			goto out;
+		}
+		spin_unlock(&block_group->lock);
+	}
+
 	ret = __btrfs_write_out_cache(root, inode, ctl, block_group, trans,
 				      path, block_group->key.objectid);
 	if (ret) {
@@ -1110,6 +1127,9 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 			block_group->key.objectid);
 #endif
 	}
+out:
+	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
+		up_write(&block_group->data_rwsem);
 
 	iput(inode);
 	return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ec8766..8928d4d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -685,7 +685,7 @@ retry:
 		ret = btrfs_reserve_extent(root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
-					   0, alloc_hint, &ins, 1);
+					   0, alloc_hint, &ins, 1, 1);
 		if (ret) {
 			int i;
 
@@ -786,7 +786,7 @@ retry:
 out:
 	return ret;
 out_free_reserve:
-	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
+	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 out_free:
 	extent_clear_unlock_delalloc(inode, async_extent->start,
 				     async_extent->start +
@@ -909,7 +909,7 @@ static noinline int cow_file_range(struct inode *inode,
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
-					   &ins, 1);
+					   &ins, 1, 1);
 		if (ret < 0)
 			goto out_unlock;
 
@@ -987,7 +987,7 @@ out:
 	return ret;
 
 out_reserve:
-	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
+	btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 out_unlock:
 	extent_clear_unlock_delalloc(inode, start, end, locked_page,
 				     EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
@@ -2572,6 +2572,21 @@ out_kfree:
 	return NULL;
 }
 
+static void btrfs_release_delalloc_bytes(struct btrfs_root *root,
+					 u64 start, u64 len)
+{
+	struct btrfs_block_group_cache *cache;
+
+	cache = btrfs_lookup_block_group(root->fs_info, start);
+	ASSERT(cache);
+
+	spin_lock(&cache->lock);
+	cache->delalloc_bytes -= len;
+	spin_unlock(&cache->lock);
+
+	btrfs_put_block_group(cache);
+}
+
 /* as ordered data IO finishes, this gets called so we can finish
  * an ordered extent if the range of bytes in the file it covers are
  * fully written.
@@ -2670,6 +2685,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						logical_len, logical_len,
 						compress_type, 0, 0,
 						BTRFS_FILE_EXTENT_REG);
+		if (!ret)
+			btrfs_release_delalloc_bytes(root,
+						     ordered_extent->start,
+						     ordered_extent->disk_len);
 	}
 	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 			   ordered_extent->file_offset, ordered_extent->len,
@@ -2722,7 +2741,7 @@ out:
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(root, ordered_extent->start,
-						   ordered_extent->disk_len);
+						   ordered_extent->disk_len, 1);
 	}
 
 
@@ -6519,21 +6538,21 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 
 	alloc_hint = get_extent_allocation_hint(inode, start, len);
 	ret = btrfs_reserve_extent(root, len, root->sectorsize, 0,
-				   alloc_hint, &ins, 1);
+				   alloc_hint, &ins, 1, 1);
 	if (ret)
 		return ERR_PTR(ret);
 
 	em = create_pinned_em(inode, start, ins.offset, start, ins.objectid,
 			      ins.offset, ins.offset, ins.offset, 0);
 	if (IS_ERR(em)) {
-		btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
+		btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 		return em;
 	}
 
 	ret = btrfs_add_ordered_extent_dio(inode, start, ins.objectid,
 					   ins.offset, ins.offset, 0);
 	if (ret) {
-		btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
+		btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 1);
 		free_extent_map(em);
 		return ERR_PTR(ret);
 	}
@@ -7353,7 +7372,7 @@ free_ordered:
 		if (!test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags) &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
 			btrfs_free_reserved_extent(root, ordered->start,
-						   ordered->disk_len);
+						   ordered->disk_len, 1);
 		btrfs_put_ordered_extent(ordered);
 		btrfs_put_ordered_extent(ordered);
 	}
@@ -8734,7 +8753,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		cur_bytes = min(num_bytes, 256ULL * 1024 * 1024);
 		cur_bytes = max(cur_bytes, min_size);
 		ret = btrfs_reserve_extent(root, cur_bytes, min_size, 0,
-					   *alloc_hint, &ins, 1);
+					   *alloc_hint, &ins, 1, 0);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
@@ -8748,7 +8767,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  BTRFS_FILE_EXTENT_PREALLOC);
 		if (ret) {
 			btrfs_free_reserved_extent(root, ins.objectid,
-						   ins.offset);
+						   ins.offset, 0);
 			btrfs_abort_transaction(trans, root, ret);
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
-- 
1.9.0

