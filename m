From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: clean up find_free_extent
Date: Fri,  6 Mar 2009 11:18:37 -0500
Message-ID: <1236356317-14729-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
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
 fs/btrfs/extent-tree.c |  282 +++++++++++++++++++++++-------------------------
 1 files changed, 135 insertions(+), 147 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1ab5f20..38820b1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3086,9 +3086,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	u64 *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	int allowed_chunk_alloc = 0;
-	struct list_head *head = NULL, *cur = NULL;
-	int loop = 0;
 	int fill_root_alloc_info = 0;
+	int using_hint = 0;
 	struct btrfs_space_info *space_info;
 
 	WARN_ON(num_bytes < root->sectorsize);
@@ -3096,6 +3095,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
+	space_info = __find_space_info(root->fs_info, data);
+
 	if (orig_root->ref_cows || empty_size)
 		allowed_chunk_alloc = 1;
 
@@ -3121,194 +3122,181 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	if (!block_group)
 		block_group = btrfs_lookup_first_block_group(root->fs_info,
 							     search_start);
-	space_info = __find_space_info(root->fs_info, data);
+	if (block_group &&
+	    (!block_group_bits(block_group, data) || block_group->ro)) {
+		put_block_group(block_group);
+		block_group = NULL;
+	}
 
+search:
 	down_read(&space_info->groups_sem);
-	while (1) {
+	if (block_group) {
+		using_hint = 1;
+		goto have_block_group;
+	}
+
+	list_for_each_entry(block_group, &space_info->block_groups, list) {
 		struct btrfs_free_space *free_space;
+		u64 start, end;
+		int used;
 
-		if (!block_group)
-			goto new_group_no_lock;
+		atomic_inc(&block_group->count);
+		search_start = block_group->key.objectid;
+
+have_block_group:
+		used = 0;
+		start = block_group->key.objectid;
+		end = block_group->key.objectid + block_group->key.offset;
 
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
-
 		if (unlikely(block_group->ro))
-			goto new_group;
+			goto loop;
 
 		free_space = btrfs_find_free_space(block_group, search_start,
 						   total_needed);
-		if (free_space) {
-			u64 start = block_group->key.objectid;
-			u64 end = block_group->key.objectid +
-				block_group->key.offset;
-			int used = 0;
-
-			search_start = stripe_align(root, free_space->offset);
-
-			/* move on to the next group */
-			if (search_start + num_bytes >= search_end)
-				goto new_group;
-
-			/* move on to the next group */
-			if (search_start + num_bytes > end)
-				goto new_group;
-
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
-					continue;
-				}
-
-				/* else we go to the next block group */
-				goto new_group;
-			}
+		if (!free_space)
+			goto loop;
 
-			ins->objectid = search_start;
-			ins->offset = num_bytes;
+		search_start = stripe_align(root, free_space->offset);
 
-			if (!fill_root_alloc_info) {
-				btrfs_remove_free_space_lock(block_group,
-							     search_start,
-							     num_bytes);
-				mutex_unlock(&block_group->alloc_mutex);
-				break;
-			}
+		/* past where we're allowed to search */
+		if (search_start + num_bytes >= search_end)
+			goto loop;
 
-			spin_lock(&orig_root->alloc_lock);
-			if (orig_root->alloc_bytes >= num_bytes) {
-				ins->objectid = orig_root->alloc_offset;
-				orig_root->alloc_offset += num_bytes;
-				orig_root->alloc_bytes -= num_bytes;
+		/* past the end of this block group */
+		if (search_start + num_bytes > end)
+			goto loop;
 
-				if (!orig_root->alloc_bytes) {
-					orig_root->alloc_bytes = total_needed;
-					orig_root->alloc_offset = search_start;
-					used = 1;
-				}
-				spin_unlock(&orig_root->alloc_lock);
-			} else if (orig_root->alloc_bytes) {
-				u64 offset = orig_root->alloc_offset;
-				u64 bytes = orig_root->alloc_bytes;
+		/* in the excluded area */
+		if (exclude_nr &&
+		    (search_start + num_bytes > exclude_start &&
+		     search_start < exclude_start + exclude_nr)) {
+			search_start = exclude_start + exclude_nr;
 
-				used = 1;
-				orig_root->alloc_offset = search_start +
-					num_bytes;
-				orig_root->alloc_bytes = total_needed -
-					num_bytes;
-				spin_unlock(&orig_root->alloc_lock);
-
-				btrfs_add_free_space_lock(block_group, offset,
-							  bytes);
-			} else {
-				used = 1;
-				orig_root->alloc_offset = search_start +
-					num_bytes;
-				orig_root->alloc_bytes = total_needed -
-					num_bytes;
-				spin_unlock(&orig_root->alloc_lock);
+			/*
+			 * if we are still within the block group, just adjust
+			 * the search start and try again
+			 */
+			if (search_start >= start && search_start < end) {
+				mutex_unlock(&block_group->alloc_mutex);
+				goto have_block_group;
 			}
+			goto loop;
+		}
 
-			if (used)
-				btrfs_remove_free_space_lock(block_group,
-							     search_start,
-							     total_needed);
+		ins->objectid = search_start;
+		ins->offset = num_bytes;
 
-			/* we are all good, lets return */
+		/* we arent allocating space for our orig_root */
+		if (!fill_root_alloc_info) {
+			btrfs_remove_free_space_lock(block_group, search_start,
+						     num_bytes);
 			mutex_unlock(&block_group->alloc_mutex);
+
+			if (last_ptr)
+				*last_ptr = search_start + num_bytes;
 			break;
 		}
-new_group:
-		mutex_unlock(&block_group->alloc_mutex);
-		put_block_group(block_group);
-		block_group = NULL;
-new_group_no_lock:
+
+		spin_lock(&orig_root->alloc_lock);
+
 		/*
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
+		 * Need to figure out if somebody had already reserved space for
+		 * this root.  If so use that area if there is enough space.  If
+		 * there is not enough space, free it up and use this newly
+		 * found area.
 		 */
-		if (loop == 0) {
-			head = &space_info->block_groups;
-			cur = head->next;
-			loop++;
-		} else if (loop == 1 && cur == head) {
-			int keep_going;
-
-			/* at this point we give up on the empty_size
-			 * allocations and just try to allocate the min
-			 * space, if empty_size was set.
-			 */
-			total_needed -= empty_size;
-			keep_going = empty_size;
-			fill_root_alloc_info = 0;
-			loop++;
-
-			if (allowed_chunk_alloc) {
-				up_read(&space_info->groups_sem);
-				ret = do_chunk_alloc(trans, root, num_bytes +
-						     2 * 1024 * 1024, data, 1);
-				down_read(&space_info->groups_sem);
-				if (!ret)
-					keep_going = 1;
-			} else if (!allowed_chunk_alloc) {
-				space_info->force_alloc = 1;
+		if (orig_root->alloc_bytes >= num_bytes) {
+			ins->objectid = orig_root->alloc_offset;
+			orig_root->alloc_offset += num_bytes;
+			orig_root->alloc_bytes -= num_bytes;
+
+			if (!orig_root->alloc_bytes) {
+				orig_root->alloc_bytes = total_needed;
+				orig_root->alloc_offset = search_start;
+				used = 1;
 			}
+			spin_unlock(&orig_root->alloc_lock);
+		} else if (orig_root->alloc_bytes) {
+			u64 offset = orig_root->alloc_offset;
+			u64 bytes = orig_root->alloc_bytes;
 
-			if (keep_going)
-				cur = head->next;
-			else
-				break;
-		} else if (cur == head) {
-			break;
+			orig_root->alloc_offset = search_start + num_bytes;
+			orig_root->alloc_bytes = total_needed - num_bytes;
+			used = 1;
+			spin_unlock(&orig_root->alloc_lock);
+
+			btrfs_add_free_space_lock(block_group, offset, bytes);
+		} else {
+			orig_root->alloc_offset = search_start + num_bytes;
+			orig_root->alloc_bytes = total_needed - num_bytes;
+			used = 1;
+			spin_unlock(&orig_root->alloc_lock);
 		}
 
-		block_group = list_entry(cur, struct btrfs_block_group_cache,
-					 list);
-		atomic_inc(&block_group->count);
+		if (used) {
+			btrfs_remove_free_space_lock(block_group, search_start,
+						     total_needed);
+			if (last_ptr)
+				*last_ptr = search_start + total_needed;
+		}
 
-		search_start = block_group->key.objectid;
-		cur = cur->next;
+		mutex_unlock(&block_group->alloc_mutex);
+		break;
+
+loop:
+		mutex_unlock(&block_group->alloc_mutex);
+		put_block_group(block_group);
+		if (using_hint) {
+			block_group =
+				list_entry(space_info->block_groups.next,
+					   struct btrfs_block_group_cache,
+					   list);
+			using_hint = 0;
+		}
+	}
+	up_read(&space_info->groups_sem);
+
+	if (!ins->objectid && (empty_size || allowed_chunk_alloc)) {
+		int try_again = empty_size;
+
+		block_group = NULL;
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
 	}
 
-	/* we found what we needed */
 	if (ins->objectid) {
 		if (!(data & BTRFS_BLOCK_GROUP_DATA))
 			trans->block_group = block_group->key.objectid;
 
-		if (last_ptr)
-			*last_ptr = ins->objectid + ins->offset;
+		put_block_group(block_group);
 		ret = 0;
 	}
 
-	if (block_group)
-		put_block_group(block_group);
-
-	up_read(&space_info->groups_sem);
 	return ret;
 }
 
-- 
1.5.4.3

