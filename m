From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix enospc when there is plenty of space
Date: Fri, 10 Oct 2008 13:55:44 -0400
Message-ID: <20081010175544.GC19500@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rwheeler@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

So there is an odd case where we can possibly return -ENOSPC when there is in
fact space to be had.  I think I finally have a hold on what the problem is, it
only happens with Metadata writes, and happens _very_ infrequently.  What has to
happen is we have to allocate have allocated out of the first logical byte on
the disk, which would set last_alloc to first_logical_byte(root, 0), so
search_start == orig_search_start.  We then need to allocate for normal
metadata, so BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DUP.  We will do a
block lookup for the given search_start, block_group_bits() won't match and
we'll go to choose another block group.  However because search_start matches
orig_search_start we go to see if we can allocate a chunk.  If we are in the
situation that we cannot allocate a chunk, we fail and ENOSPC.  This is kind of
a big flaw of the way find_free_extent works, as it along with find_free_space
loop through _all_ of the block groups, not just the ones that we want to
allocate out of.  This patch completely kills find_free_space and rolls it into
find_free_extent.  I've introduced a sort of state machine into this, which will
make it easier to get cache miss information out of the allocator, and will work
well with my locking changes.

The basic flow is this.  We have the variable loop which is 0, meaning we are in
the hint phase.  We lookup the block group for the hint, and lookup the
space_info for what we want to allocate out of.  If the block group we were
pointed at by the hint either isn't of the correct type, or just doesn't have
the space we need, we set head to space_info->block_groups, so we start at the
beginning of the block groups for this particular space info, and loop through.
This is also where we add the empty_cluster to total_needed.  At this point loop
is set to 1 and we just loop through all of the block groups for this particular
space_info looking for the space we need, just as find_free_space would have
done, except we only hit the block groups we want and not _all_ of the block
groups.  If we come full circle we see if we can allocate a chunk.  If we cannot
of course we exit with -ENOSPC and we are good.  If not we start over at
space_info->block_groups and loop through again, with loop == 2.  If we come
full circle and haven't found what we need then we exit with -ENOSPC.  I've been
running this for a couple of days now and it seems stable, and I haven't yet hit
a -ENOSPC when there was plenty of space left.

Also I've made a groups_sem to handle the group list for the space_info.  This
is part of my locking changes, but is relatively safe and seems better than
holding the space_info spinlock over that entire search time.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8559f39..fad58b9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -508,6 +508,7 @@ struct btrfs_space_info {
 	/* for block groups in our same type */
 	struct list_head block_groups;
 	spinlock_t lock;
+	struct rw_semaphore groups_sem;
 };
 
 struct btrfs_free_space {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 280ac1a..ad648a3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -317,59 +317,6 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 	return cache;
 }
 
-static int noinline find_free_space(struct btrfs_root *root,
-				    struct btrfs_block_group_cache **cache_ret,
-				    u64 *start_ret, u64 num, int data)
-{
-	int ret;
-	struct btrfs_block_group_cache *cache = *cache_ret;
-	struct btrfs_free_space *info = NULL;
-	u64 last;
-	u64 search_start = *start_ret;
-
-	WARN_ON(!mutex_is_locked(&root->fs_info->alloc_mutex));
-	if (!cache)
-		goto out;
-
-	last = max(search_start, cache->key.objectid);
-
-again:
-	ret = cache_block_group(root, cache);
-	if (ret)
-		goto out;
-
-	if (cache->ro || !block_group_bits(cache, data))
-		goto new_group;
-
-	info = btrfs_find_free_space(cache, last, num);
-	if (info) {
-		*start_ret = info->offset;
-		return 0;
-	}
-
-new_group:
-	last = cache->key.objectid + cache->key.offset;
-
-	cache = btrfs_lookup_first_block_group(root->fs_info, last);
-	if (!cache)
-		goto out;
-
-	*cache_ret = cache;
-	goto again;
-
-out:
-	return -ENOSPC;
-}
-
-static u64 div_factor(u64 num, int factor)
-{
-	if (factor == 10)
-		return num;
-	num *= factor;
-	do_div(num, 10);
-	return num;
-}
-
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
@@ -384,6 +331,15 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 	return NULL;
 }
 
+static u64 div_factor(u64 num, int factor)
+{
+	if (factor == 10)
+		return num;
+	num *= factor;
+	do_div(num, 10);
+	return num;
+}
+
 static struct btrfs_block_group_cache *
 __btrfs_find_block_group(struct btrfs_root *root,
 			 struct btrfs_block_group_cache *hint,
@@ -1446,6 +1402,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 
 	list_add(&found->list, &info->space_info);
 	INIT_LIST_HEAD(&found->block_groups);
+	init_rwsem(&found->groups_sem);
 	spin_lock_init(&found->lock);
 	found->flags = flags;
 	found->total_bytes = total_bytes;
@@ -2208,19 +2165,22 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 				     u64 exclude_start, u64 exclude_nr,
 				     int data)
 {
-	int ret;
-	u64 orig_search_start;
+	int ret = 0;
 	struct btrfs_root * root = orig_root->fs_info->extent_root;
-	struct btrfs_fs_info *info = root->fs_info;
 	u64 total_needed = num_bytes;
 	u64 *last_ptr = NULL;
-	struct btrfs_block_group_cache *block_group;
+	struct btrfs_block_group_cache *block_group = NULL;
 	int chunk_alloc_done = 0;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
+	struct list_head *head = NULL, *cur = NULL;
+	int loop = 0;
+	struct btrfs_space_info *space_info;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
+	ins->objectid = 0;
+	ins->offset = 0;
 
 	if (orig_root->ref_cows || empty_size)
 		allowed_chunk_alloc = 1;
@@ -2239,152 +2199,132 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 		else
 			empty_size += empty_cluster;
 	}
-
 	search_start = max(search_start, first_logical_byte(root, 0));
-	orig_search_start = search_start;
-
 	search_start = max(search_start, hint_byte);
 	total_needed += empty_size;
 
-new_group:
-	block_group = btrfs_lookup_block_group(info, search_start);
-	if (!block_group)
-		block_group = btrfs_lookup_first_block_group(info,
-							     search_start);
+	block_group = btrfs_lookup_block_group(root->fs_info, search_start);
+	space_info = __find_space_info(root->fs_info, data);
 
-	/*
-	 * Ok this looks a little tricky, buts its really simple.  First if we
-	 * didn't find a block group obviously we want to start over.
-	 * Secondly, if the block group we found does not match the type we
-	 * need, and we have a last_ptr and its not 0, chances are the last
-	 * allocation we made was at the end of the block group, so lets go
-	 * ahead and skip the looking through the rest of the block groups and
-	 * start at the beginning.  This helps with metadata allocations,
-	 * since you are likely to have a bunch of data block groups to search
-	 * through first before you realize that you need to start over, so go
-	 * ahead and start over and save the time.
-	 */
-	if (!block_group || (!block_group_bits(block_group, data) &&
-			     last_ptr && *last_ptr)) {
-		if (search_start != orig_search_start) {
-			if (last_ptr && *last_ptr) {
-				total_needed += empty_cluster;
-				*last_ptr = 0;
-			}
-			search_start = orig_search_start;
-			goto new_group;
-		} else if (!chunk_alloc_done && allowed_chunk_alloc) {
-			ret = do_chunk_alloc(trans, root,
-					     num_bytes + 2 * 1024 * 1024,
-					     data, 1);
-			if (ret < 0)
-				goto error;
-			BUG_ON(ret);
-			chunk_alloc_done = 1;
-			search_start = orig_search_start;
-			goto new_group;
-		} else {
-			ret = -ENOSPC;
-			goto error;
-		}
-	}
-
-	/*
-	 * this is going to seach through all of the existing block groups it
-	 * can find, so if we don't find something we need to see if we can
-	 * allocate what we need.
-	 */
-	ret = find_free_space(root, &block_group, &search_start,
-			      total_needed, data);
-	if (ret == -ENOSPC) {
+	down_read(&space_info->groups_sem);
+	while (1) {
+		struct btrfs_free_space *free_space;
 		/*
-		 * instead of allocating, start at the original search start
-		 * and see if there is something to be found, if not then we
-		 * allocate
+		 * the only way this happens if our hint points to a block
+		 * group thats not of the proper type, while looping this
+		 * should never happen
 		 */
-		if (search_start != orig_search_start) {
-			if (last_ptr && *last_ptr) {
-				*last_ptr = 0;
-				total_needed += empty_cluster;
-			}
-			search_start = orig_search_start;
+		if (unlikely(!block_group_bits(block_group, data)))
 			goto new_group;
-		}
 
-		/*
-		 * we've already allocated, we're pretty screwed
-		 */
-		if (chunk_alloc_done) {
-			goto error;
-		} else if (!allowed_chunk_alloc && block_group &&
-			   block_group_bits(block_group, data)) {
-			block_group->space_info->force_alloc = 1;
-			goto error;
-		} else if (!allowed_chunk_alloc) {
-			goto error;
-		}
+		ret = cache_block_group(root, block_group);
+		if (ret)
+			break;
 
-		ret = do_chunk_alloc(trans, root, num_bytes + 2 * 1024 * 1024,
-				     data, 1);
-		if (ret < 0)
-			goto error;
+		if (block_group->ro)
+			goto new_group;
 
-		BUG_ON(ret);
-		chunk_alloc_done = 1;
-		if (block_group)
-			search_start = block_group->key.objectid +
+		free_space = btrfs_find_free_space(block_group, search_start,
+						   total_needed);
+		if (free_space) {
+			u64 start = block_group->key.objectid;
+			u64 end = block_group->key.objectid +
 				block_group->key.offset;
-		else
-			search_start = orig_search_start;
-		goto new_group;
-	}
 
-	if (ret)
-		goto error;
+			search_start = stripe_align(root, free_space->offset);
 
-	search_start = stripe_align(root, search_start);
-	ins->objectid = search_start;
-	ins->offset = num_bytes;
+			/* move on to the next group */
+			if (search_start + num_bytes >= search_end)
+				goto new_group;
 
-	if (ins->objectid + num_bytes >= search_end) {
-		search_start = orig_search_start;
-		if (chunk_alloc_done) {
-			ret = -ENOSPC;
-			goto error;
+			/* move on to the next group */
+			if (search_start + num_bytes > end)
+				goto new_group;
+
+			if (exclude_nr > 0 &&
+			    (search_start + num_bytes > exclude_start &&
+			     search_start < exclude_start + exclude_nr)) {
+				search_start = exclude_start + exclude_nr;
+				/*
+				 * if search_start is still in this block group
+				 * then we just re-search this block group
+				 */
+				if (search_start >= start &&
+				    search_start < end)
+					continue;
+
+				/* else we go to the next block group */
+				goto new_group;
+			}
+
+			ins->objectid = search_start;
+			ins->offset = num_bytes;
+			/* we are all good, lets return */
+			break;
 		}
-		goto new_group;
-	}
+new_group:
+		/*
+		 * Here's how this works.
+		 * loop == 0: we were searching a block group via a hint
+		 *		and didn't find anything, so we start at
+		 *		the head of the block groups and keep searching
+		 * loop == 1: we're searching through all of the block groups
+		 *		if we hit the head again we have searched
+		 *		all of the block groups for this space and we
+		 *		need to try and allocate, if we cant error out.
+		 * loop == 2: we allocated more space and are looping through
+		 *		all of the block groups again.
+		 */
+		if (loop == 0) {
+			head = &space_info->block_groups;
+			cur = head;
 
-	if (ins->objectid + num_bytes >
-	    block_group->key.objectid + block_group->key.offset) {
-		if (search_start == orig_search_start && chunk_alloc_done) {
-			ret = -ENOSPC;
-			goto error;
+			if (last_ptr && *last_ptr) {
+				total_needed += empty_cluster;
+				*last_ptr = 0;
+			}
+			loop++;
+		} else if (loop == 1 && cur == head) {
+			if (allowed_chunk_alloc && !chunk_alloc_done) {
+				up_read(&space_info->groups_sem);
+				ret = do_chunk_alloc(trans, root, num_bytes +
+						     2 * 1024 * 1024, data, 1);
+				if (ret < 0)
+					break;
+				down_read(&space_info->groups_sem);
+				loop++;
+				head = &space_info->block_groups;
+				cur = head;
+				chunk_alloc_done = 1;
+			} else if (!allowed_chunk_alloc) {
+				space_info->force_alloc = 1;
+				break;
+			} else {
+				break;
+			}
+		} else if (cur == head) {
+			break;
 		}
-		search_start = block_group->key.objectid +
-			block_group->key.offset;
-		goto new_group;
-	}
 
-	if (exclude_nr > 0 && (ins->objectid + num_bytes > exclude_start &&
-	    ins->objectid < exclude_start + exclude_nr)) {
-		search_start = exclude_start + exclude_nr;
-		goto new_group;
+		block_group = list_entry(cur, struct btrfs_block_group_cache,
+					 list);
+		search_start = block_group->key.objectid;
+		cur = cur->next;
 	}
 
-	if (!(data & BTRFS_BLOCK_GROUP_DATA))
-		trans->block_group = block_group;
+	/* we found what we needed */
+	if (ins->objectid) {
+		if (!(data & BTRFS_BLOCK_GROUP_DATA))
+			trans->block_group = block_group;
 
-	ins->offset = num_bytes;
-	if (last_ptr) {
-		*last_ptr = ins->objectid + ins->offset;
-		if (*last_ptr ==
-		    btrfs_super_total_bytes(&root->fs_info->super_copy))
-			*last_ptr = 0;
+		if (last_ptr)
+			*last_ptr = ins->objectid + ins->offset;
+		ret = 0;
+	} else if (!ret) {
+		ret = -ENOSPC;
 	}
 
-	ret = 0;
-error:
+	up_read(&space_info->groups_sem);
 	return ret;
 }
 
@@ -2397,7 +2337,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 	       info->total_bytes - info->bytes_used - info->bytes_pinned -
 	       info->bytes_reserved, (info->full) ? "" : "not ");
 
-	spin_lock(&info->lock);
+	down_read(&info->groups_sem);
 	list_for_each(l, &info->block_groups) {
 		cache = list_entry(l, struct btrfs_block_group_cache, list);
 		spin_lock(&cache->lock);
@@ -2409,7 +2349,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 		btrfs_dump_free_space(cache, bytes);
 		spin_unlock(&cache->lock);
 	}
-	spin_unlock(&info->lock);
+	up_read(&info->groups_sem);
 }
 
 static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
@@ -5079,9 +5019,9 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 
 		rb_erase(&block_group->cache_node,
 			 &info->block_group_cache_tree);
-		spin_lock(&block_group->space_info->lock);
+		down_write(&block_group->space_info->groups_sem);
 		list_del(&block_group->list);
-		spin_unlock(&block_group->space_info->lock);
+		up_write(&block_group->space_info->groups_sem);
 		kfree(block_group);
 	}
 	spin_unlock(&info->block_group_cache_lock);
@@ -5142,9 +5082,9 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 					&space_info);
 		BUG_ON(ret);
 		cache->space_info = space_info;
-		spin_lock(&space_info->lock);
-		list_add(&cache->list, &space_info->block_groups);
-		spin_unlock(&space_info->lock);
+		down_write(&space_info->groups_sem);
+		list_add_tail(&cache->list, &space_info->block_groups);
+		up_write(&space_info->groups_sem);
 
 		ret = btrfs_add_block_group_cache(root->fs_info, cache);
 		BUG_ON(ret);
@@ -5190,9 +5130,9 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
-	spin_lock(&cache->space_info->lock);
-	list_add(&cache->list, &cache->space_info->block_groups);
-	spin_unlock(&cache->space_info->lock);
+	down_write(&cache->space_info->groups_sem);
+	list_add_tail(&cache->list, &cache->space_info->block_groups);
+	up_write(&cache->space_info->groups_sem);
 
 	ret = btrfs_add_block_group_cache(root->fs_info, cache);
 	BUG_ON(ret);
@@ -5231,9 +5171,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	btrfs_remove_free_space_cache(block_group);
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
-	spin_lock(&block_group->space_info->lock);
+	down_write(&block_group->space_info->groups_sem);
 	list_del(&block_group->list);
-	spin_unlock(&block_group->space_info->lock);
+	up_write(&block_group->space_info->groups_sem);
 
 	/*
 	memset(shrink_block_group, 0, sizeof(*shrink_block_group));
