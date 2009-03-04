From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: group metadata allocations with the root
Date: Wed,  4 Mar 2009 11:33:53 -0500
Message-ID: <1236184433-23490-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch lets each root keep track of a small area of contigous space from
which to allocate from in order to keep blocks for different roots interleaving
themselves on disk.  This happens in two parts

1) If we have not already reserved some space for the root, we go into the
normal allocator.  Here we try and allocate a cluster of free space.  If we are
successfull we give the current allocation what it needs, and then set the
offset and size to the cluster we have found, and remove the entire section from
the free space cache.  Of course if we can't find space this ends up being just
a normal allocation.

2) If we have some reserved space in the root we just use that chunk for the
allocation and return.

This also cleans up some of allocation code.  There will be another patch coming
later to clean it up some more.  Testing the cold-cache read speed we aren't
actually doing anything faster, but we are definitely seeking less, so there is
a clear win there.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    4 +
 fs/btrfs/disk-io.c     |    3 +
 fs/btrfs/extent-tree.c |  167 ++++++++++++++++++++++++------------------------
 3 files changed, 91 insertions(+), 83 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 82491ba..bdf826c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -878,6 +878,10 @@ struct btrfs_root {
 	 * for stat.  It may be used for more later
 	 */
 	struct super_block anon_super;
+
+	spinlock_t alloc_lock;
+	u64 alloc_bytes;
+	u64 alloc_offset;
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index adda739..057fe07 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -926,6 +926,9 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	INIT_LIST_HEAD(&root->anon_super.s_list);
 	INIT_LIST_HEAD(&root->anon_super.s_instances);
 	init_rwsem(&root->anon_super.s_umount);
+	spin_lock_init(&root->alloc_lock);
+	root->alloc_bytes = 0;
+	root->alloc_offset = 0;
 
 	return 0;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6b5966a..1ab5f20 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3084,14 +3084,11 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
 	u64 total_needed = num_bytes;
 	u64 *last_ptr = NULL;
-	u64 last_wanted = 0;
 	struct btrfs_block_group_cache *block_group = NULL;
-	int chunk_alloc_done = 0;
-	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
 	struct list_head *head = NULL, *cur = NULL;
 	int loop = 0;
-	int extra_loop = 0;
+	int fill_root_alloc_info = 0;
 	struct btrfs_space_info *space_info;
 
 	WARN_ON(num_bytes < root->sectorsize);
@@ -3104,30 +3101,21 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA) {
 		last_ptr = &root->fs_info->last_alloc;
-		if (!btrfs_test_opt(root, SSD))
-			empty_cluster = 64 * 1024;
+		if (!btrfs_test_opt(root, SSD)) {
+			fill_root_alloc_info = 1;
+			empty_size += 64 * 1024;
+		}
 	}
 
 	if ((data & BTRFS_BLOCK_GROUP_DATA) && btrfs_test_opt(root, SSD))
 		last_ptr = &root->fs_info->last_data_alloc;
 
-	if (last_ptr) {
-		if (*last_ptr) {
-			hint_byte = *last_ptr;
-			last_wanted = *last_ptr;
-		} else
-			empty_size += empty_cluster;
-	} else {
-		empty_cluster = 0;
-	}
+	if (last_ptr && *last_ptr)
+		hint_byte = *last_ptr;
+
 	search_start = max(search_start, first_logical_byte(root, 0));
 	search_start = max(search_start, hint_byte);
 
-	if (last_wanted && search_start != last_wanted) {
-		last_wanted = 0;
-		empty_size += empty_cluster;
-	}
-
 	total_needed += empty_size;
 	block_group = btrfs_lookup_block_group(root->fs_info, search_start);
 	if (!block_group)
@@ -3138,13 +3126,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	down_read(&space_info->groups_sem);
 	while (1) {
 		struct btrfs_free_space *free_space;
-		/*
-		 * the only way this happens if our hint points to a block
-		 * group thats not of the proper type, while looping this
-		 * should never happen
-		 */
-		if (empty_size)
-			extra_loop = 1;
 
 		if (!block_group)
 			goto new_group_no_lock;
@@ -3170,6 +3151,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 			u64 start = block_group->key.objectid;
 			u64 end = block_group->key.objectid +
 				block_group->key.offset;
+			int used = 0;
 
 			search_start = stripe_align(root, free_space->offset);
 
@@ -3181,24 +3163,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 			if (search_start + num_bytes > end)
 				goto new_group;
 
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
-
-				/* else we go to the next block group */
-				goto new_group;
-			}
-
 			if (exclude_nr > 0 &&
 			    (search_start + num_bytes > exclude_start &&
 			     search_start < exclude_start + exclude_nr)) {
@@ -3210,7 +3174,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				if (search_start >= start &&
 				    search_start < end) {
 					mutex_unlock(&block_group->alloc_mutex);
-					last_wanted = 0;
 					continue;
 				}
 
@@ -3221,8 +3184,53 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 			ins->objectid = search_start;
 			ins->offset = num_bytes;
 
-			btrfs_remove_free_space_lock(block_group, search_start,
-						     num_bytes);
+			if (!fill_root_alloc_info) {
+				btrfs_remove_free_space_lock(block_group,
+							     search_start,
+							     num_bytes);
+				mutex_unlock(&block_group->alloc_mutex);
+				break;
+			}
+
+			spin_lock(&orig_root->alloc_lock);
+			if (orig_root->alloc_bytes >= num_bytes) {
+				ins->objectid = orig_root->alloc_offset;
+				orig_root->alloc_offset += num_bytes;
+				orig_root->alloc_bytes -= num_bytes;
+
+				if (!orig_root->alloc_bytes) {
+					orig_root->alloc_bytes = total_needed;
+					orig_root->alloc_offset = search_start;
+					used = 1;
+				}
+				spin_unlock(&orig_root->alloc_lock);
+			} else if (orig_root->alloc_bytes) {
+				u64 offset = orig_root->alloc_offset;
+				u64 bytes = orig_root->alloc_bytes;
+
+				used = 1;
+				orig_root->alloc_offset = search_start +
+					num_bytes;
+				orig_root->alloc_bytes = total_needed -
+					num_bytes;
+				spin_unlock(&orig_root->alloc_lock);
+
+				btrfs_add_free_space_lock(block_group, offset,
+							  bytes);
+			} else {
+				used = 1;
+				orig_root->alloc_offset = search_start +
+					num_bytes;
+				orig_root->alloc_bytes = total_needed -
+					num_bytes;
+				spin_unlock(&orig_root->alloc_lock);
+			}
+
+			if (used)
+				btrfs_remove_free_space_lock(block_group,
+							     search_start,
+							     total_needed);
+
 			/* we are all good, lets return */
 			mutex_unlock(&block_group->alloc_mutex);
 			break;
@@ -3232,11 +3240,6 @@ new_group:
 		put_block_group(block_group);
 		block_group = NULL;
 new_group_no_lock:
-		/* don't try to compare new allocations against the
-		 * last allocation any more
-		 */
-		last_wanted = 0;
-
 		/*
 		 * Here's how this works.
 		 * loop == 0: we were searching a block group via a hint
@@ -3258,42 +3261,28 @@ new_group_no_lock:
 
 			/* at this point we give up on the empty_size
 			 * allocations and just try to allocate the min
-			 * space.
-			 *
-			 * The extra_loop field was set if an empty_size
-			 * allocation was attempted above, and if this
-			 * is try we need to try the loop again without
-			 * the additional empty_size.
+			 * space, if empty_size was set.
 			 */
 			total_needed -= empty_size;
-			empty_size = 0;
-			keep_going = extra_loop;
+			keep_going = empty_size;
+			fill_root_alloc_info = 0;
 			loop++;
 
-			if (allowed_chunk_alloc && !chunk_alloc_done) {
+			if (allowed_chunk_alloc) {
 				up_read(&space_info->groups_sem);
 				ret = do_chunk_alloc(trans, root, num_bytes +
 						     2 * 1024 * 1024, data, 1);
 				down_read(&space_info->groups_sem);
-				if (ret < 0)
-					goto loop_check;
-				head = &space_info->block_groups;
-				/*
-				 * we've allocated a new chunk, keep
-				 * trying
-				 */
-				keep_going = 1;
-				chunk_alloc_done = 1;
+				if (!ret)
+					keep_going = 1;
 			} else if (!allowed_chunk_alloc) {
 				space_info->force_alloc = 1;
 			}
-loop_check:
-			if (keep_going) {
+
+			if (keep_going)
 				cur = head->next;
-				extra_loop = 0;
-			} else {
+			else
 				break;
-			}
 		} else if (cur == head) {
 			break;
 		}
@@ -3314,14 +3303,8 @@ loop_check:
 		if (last_ptr)
 			*last_ptr = ins->objectid + ins->offset;
 		ret = 0;
-	} else if (!ret) {
-		printk(KERN_ERR "btrfs searching for %llu bytes, "
-		       "num_bytes %llu, loop %d, allowed_alloc %d\n",
-		       (unsigned long long)total_needed,
-		       (unsigned long long)num_bytes,
-		       loop, allowed_chunk_alloc);
-		ret = -ENOSPC;
 	}
+
 	if (block_group)
 		put_block_group(block_group);
 
@@ -3370,7 +3353,24 @@ static int __btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *info = root->fs_info;
 
 	data = btrfs_get_alloc_profile(root, data);
+
 again:
+	if (data & BTRFS_BLOCK_GROUP_METADATA && !btrfs_test_opt(root, SSD)) {
+		u64 total = num_bytes + empty_size;
+
+		spin_lock(&root->alloc_lock);
+		if (root->alloc_bytes >= total) {
+			ins->objectid = root->alloc_offset;
+			ins->offset = num_bytes;
+			btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
+			root->alloc_bytes -= num_bytes;
+			root->alloc_offset += num_bytes;
+			spin_unlock(&root->alloc_lock);
+			return 0;
+		}
+		spin_unlock(&root->alloc_lock);
+	}
+
 	/*
 	 * the only place that sets empty_size is btrfs_realloc_node, which
 	 * is not called recursively on allocations
@@ -3388,6 +3388,7 @@ again:
 	}
 
 	WARN_ON(num_bytes < root->sectorsize);
+
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
 			       search_start, search_end, hint_byte, ins,
 			       trans->alloc_exclude_start,
-- 
1.5.4.3

