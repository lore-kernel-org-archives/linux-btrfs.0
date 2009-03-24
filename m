From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: clean up find_free_extent
Date: Tue, 24 Mar 2009 15:02:52 -0400
Message-ID: <1237921372-11045-1-git-send-email-jbacik@redhat.com>
References: <1237575593-21101-3-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1237575593-21101-3-git-send-email-jbacik@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

The whole loop=0,1,2 thing was kind of odd and not very self explanatory.  I've
replaced it with a list_for_each_entry on space_info->block_groups.  If we have
a hint we just jump into the loop with the block group and start looking for
space.  If we don't find anything we start at the beginning and start looking.
We never come out of the loop with a ref on the block_group _unless_ we found
space to use, then we drop it after we set the trans block_group.  I've tested
this with my ENOSPC handlers, and profiled it.  Its made the cold-cache-read
faster by a second.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |  266 +++++++++++++++++------------------------------
 1 files changed, 96 insertions(+), 170 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 26fec19..9f6efa6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2552,14 +2552,10 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
 	u64 total_needed = num_bytes;
 	u64 *last_ptr = NULL;
-	u64 last_wanted = 0;
 	struct btrfs_block_group_cache *block_group = NULL;
-	int chunk_alloc_done = 0;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
-	struct list_head *head = NULL, *cur = NULL;
-	int loop = 0;
-	int extra_loop = 0;
+	int using_hint = 0;
 	struct btrfs_space_info *space_info;
 
 	WARN_ON(num_bytes < root->sectorsize);
@@ -2567,6 +2563,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
+	space_info = __find_space_info(root->fs_info, data);
+
 	if (orig_root->ref_cows || empty_size)
 		allowed_chunk_alloc = 1;
 
@@ -2580,10 +2578,9 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		last_ptr = &root->fs_info->last_data_alloc;
 
 	if (last_ptr) {
-		if (*last_ptr) {
+		if (*last_ptr)
 			hint_byte = *last_ptr;
-			last_wanted = *last_ptr;
-		} else
+		else
 			empty_size += empty_cluster;
 	} else {
 		empty_cluster = 0;
@@ -2591,187 +2588,125 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	search_start = max(search_start, first_logical_byte(root, 0));
 	search_start = max(search_start, hint_byte);
 
-	if (last_wanted && search_start != last_wanted) {
-		last_wanted = 0;
+	if (search_start == hint_byte) {
+		using_hint = 1;
+		block_group = btrfs_lookup_block_group(root->fs_info,
+						       search_start);
+		if (block_group && block_group_bits(block_group, data)) {
+			total_needed += empty_size;
+			down_read(&space_info->groups_sem);
+			goto have_block_group;
+		} else if (block_group) {
+			put_block_group(block_group);
+		}
+
 		empty_size += empty_cluster;
+		using_hint = 0;
 	}
 
-	total_needed += empty_size;
-	block_group = btrfs_lookup_block_group(root->fs_info, search_start);
-	if (!block_group)
-		block_group = btrfs_lookup_first_block_group(root->fs_info,
-							     search_start);
-	space_info = __find_space_info(root->fs_info, data);
-
+search:
 	down_read(&space_info->groups_sem);
-	while (1) {
+	list_for_each_entry(block_group, &space_info->block_groups, list) {
 		struct btrfs_free_space *free_space;
-		/*
-		 * the only way this happens if our hint points to a block
-		 * group thats not of the proper type, while looping this
-		 * should never happen
-		 */
-		if (empty_size)
-			extra_loop = 1;
 
-		if (!block_group)
-			goto new_group_no_lock;
+		atomic_inc(&block_group->count);
+		search_start = block_group->key.objectid;
 
+have_block_group:
 		if (unlikely(!block_group->cached)) {
 			mutex_lock(&block_group->cache_mutex);
 			ret = cache_block_group(root, block_group);
 			mutex_unlock(&block_group->cache_mutex);
-			if (ret)
+			if (ret) {
+				put_block_group(block_group);
 				break;
+			}
 		}
 
 		mutex_lock(&block_group->alloc_mutex);
-		if (unlikely(!block_group_bits(block_group, data)))
-			goto new_group;
 
 		if (unlikely(block_group->ro))
-			goto new_group;
+			goto loop;
 
 		free_space = btrfs_find_free_space(block_group, search_start,
 						   total_needed);
-		if (free_space) {
-			u64 start = block_group->key.objectid;
-			u64 end = block_group->key.objectid +
-				block_group->key.offset;
+		if (!free_space)
+			goto loop;
 
-			search_start = stripe_align(root, free_space->offset);
+		search_start = stripe_align(root, free_space->offset);
 
-			/* move on to the next group */
-			if (search_start + num_bytes >= search_end)
-				goto new_group;
+		/* move on to the next group */
+		if (search_start + num_bytes >= search_end)
+			goto loop;
 
-			/* move on to the next group */
-			if (search_start + num_bytes > end)
-				goto new_group;
+		/* move on to the next group */
+		if (search_start + num_bytes >
+		    block_group->key.objectid + block_group->key.offset)
+			goto loop;
 
-			if (last_wanted && search_start != last_wanted) {
-				total_needed += empty_cluster;
-				empty_size += empty_cluster;
-				last_wanted = 0;
-				/*
-				 * if search_start is still in this block group
-				 * then we just re-search this block group
-				 */
-				if (search_start >= start &&
-				    search_start < end) {
-					mutex_unlock(&block_group->alloc_mutex);
-					continue;
-				}
+		if (using_hint && search_start > hint_byte)
+			goto loop;
 
-				/* else we go to the next block group */
-				goto new_group;
-			}
+		if (exclude_nr > 0 &&
+		    (search_start + num_bytes > exclude_start &&
+		     search_start < exclude_start + exclude_nr)) {
+			search_start = exclude_start + exclude_nr;
 
-			if (exclude_nr > 0 &&
-			    (search_start + num_bytes > exclude_start &&
-			     search_start < exclude_start + exclude_nr)) {
-				search_start = exclude_start + exclude_nr;
-				/*
-				 * if search_start is still in this block group
-				 * then we just re-search this block group
-				 */
-				if (search_start >= start &&
-				    search_start < end) {
-					mutex_unlock(&block_group->alloc_mutex);
-					last_wanted = 0;
-					continue;
-				}
-
-				/* else we go to the next block group */
-				goto new_group;
+			/*
+			 * if search_start is still in this block group
+			 * then we just re-search this block group
+			 */
+			if (search_start >= block_group->key.objectid &&
+			    search_start < (block_group->key.objectid +
+					    block_group->key.offset)) {
+				mutex_unlock(&block_group->alloc_mutex);
+				goto have_block_group;
 			}
+			goto loop;
+		}
 
-			ins->objectid = search_start;
-			ins->offset = num_bytes;
+		ins->objectid = search_start;
+		ins->offset = num_bytes;
 
-			btrfs_remove_free_space_lock(block_group, search_start,
-						     num_bytes);
-			/* we are all good, lets return */
-			mutex_unlock(&block_group->alloc_mutex);
-			break;
-		}
-new_group:
+		btrfs_remove_free_space_lock(block_group, search_start,
+					     num_bytes);
+		/* we are all good, lets return */
+		mutex_unlock(&block_group->alloc_mutex);
+		break;
+loop:
 		mutex_unlock(&block_group->alloc_mutex);
 		put_block_group(block_group);
-		block_group = NULL;
-new_group_no_lock:
-		/* don't try to compare new allocations against the
-		 * last allocation any more
-		 */
-		last_wanted = 0;
-
-		/*
-		 * Here's how this works.
-		 * loop == 0: we were searching a block group via a hint
-		 *		and didn't find anything, so we start at
-		 *		the head of the block groups and keep searching
-		 * loop == 1: we're searching through all of the block groups
-		 *		if we hit the head again we have searched
-		 *		all of the block groups for this space and we
-		 *		need to try and allocate, if we cant error out.
-		 * loop == 2: we allocated more space and are looping through
-		 *		all of the block groups again.
-		 */
-		if (loop == 0) {
-			head = &space_info->block_groups;
-			cur = head->next;
-			loop++;
-		} else if (loop == 1 && cur == head) {
-			int keep_going;
-
-			/* at this point we give up on the empty_size
-			 * allocations and just try to allocate the min
-			 * space.
-			 *
-			 * The extra_loop field was set if an empty_size
-			 * allocation was attempted above, and if this
-			 * is try we need to try the loop again without
-			 * the additional empty_size.
-			 */
-			total_needed -= empty_size;
-			empty_size = 0;
-			keep_going = extra_loop;
-			loop++;
-
-			if (allowed_chunk_alloc && !chunk_alloc_done) {
-				up_read(&space_info->groups_sem);
-				ret = do_chunk_alloc(trans, root, num_bytes +
-						     2 * 1024 * 1024, data, 1);
-				down_read(&space_info->groups_sem);
-				if (ret < 0)
-					goto loop_check;
-				head = &space_info->block_groups;
-				/*
-				 * we've allocated a new chunk, keep
-				 * trying
-				 */
-				keep_going = 1;
-				chunk_alloc_done = 1;
-			} else if (!allowed_chunk_alloc) {
-				space_info->force_alloc = 1;
-			}
-loop_check:
-			if (keep_going) {
-				cur = head->next;
-				extra_loop = 0;
-			} else {
-				break;
-			}
-		} else if (cur == head) {
-			break;
+		if (using_hint) {
+			empty_size += empty_cluster;
+			total_needed += empty_cluster;
+			using_hint = 0;
+			up_read(&space_info->groups_sem);
+			goto search;
 		}
+	}
+	up_read(&space_info->groups_sem);
 
-		block_group = list_entry(cur, struct btrfs_block_group_cache,
-					 list);
-		atomic_inc(&block_group->count);
+	if (!ins->objectid && (empty_size || allowed_chunk_alloc)) {
+		int try_again = empty_size;
 
-		search_start = block_group->key.objectid;
-		cur = cur->next;
+		total_needed -= empty_size;
+		empty_size = 0;
+
+		if (allowed_chunk_alloc) {
+			ret = do_chunk_alloc(trans, root, num_bytes +
+					     2 * 1024 * 1024, data, 1);
+			if (!ret)
+				try_again = 1;
+			allowed_chunk_alloc = 0;
+		} else {
+			space_info->force_alloc = 1;
+		}
+
+		if (try_again)
+			goto search;
+		ret = -ENOSPC;
+	} else if (!ins->objectid) {
+		ret = -ENOSPC;
 	}
 
 	/* we found what we needed */
@@ -2781,19 +2716,10 @@ loop_check:
 
 		if (last_ptr)
 			*last_ptr = ins->objectid + ins->offset;
+		put_block_group(block_group);
 		ret = 0;
-	} else if (!ret) {
-		printk(KERN_ERR "btrfs searching for %llu bytes, "
-		       "num_bytes %llu, loop %d, allowed_alloc %d\n",
-		       (unsigned long long)total_needed,
-		       (unsigned long long)num_bytes,
-		       loop, allowed_chunk_alloc);
-		ret = -ENOSPC;
 	}
-	if (block_group)
-		put_block_group(block_group);
 
-	up_read(&space_info->groups_sem);
 	return ret;
 }
 
-- 
1.5.4.3

