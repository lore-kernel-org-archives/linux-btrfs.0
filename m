From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make balance code choose wiser when relocating
	block groups V2
Date: Wed, 12 Aug 2009 15:48:56 -0400
Message-ID: <20090812194856.GA8966@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently, we can panic the box if the first block group we go to move is of a
type where there is no space left to move those extents.  For example, if we
fill the disk up with data, and then we try to balance and we have no room to
move the data nor room to allocate new chunks, we will panic.  Change this by
checking to see if we have room to move this chunk around, and if not, return
-ENOSPC and move on to the next chunk.  This will make sure we remove block
groups that are moveable, like if we have alot of empty metadata block groups,
and then that way we make room to be able to balance our data chunks as well.
Tested this with an fs that would panic on btrfs-vol -b normally, but no longer
panics with this patch.

V1->V2:
-actually search for a free extent on the device to make sure we can allocate a
chunk if need be.
-fix btrfs_shrink_device to make sure we actually try to relocate all the
chunks, and then if we can't return -ENOSPC so if we are doing a btrfs-vol -r we
don't remove the device with data still on it.
-check to make sure the block group we are going to relocate isn't the last one
in that particular space
-fix a bug in btrfs_shrink_device where we would change the device's size and
not fix it if we fail to do our relocate

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/extent-tree.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |   75 +++++++++++++++++++++++++++++++----------
 fs/btrfs/volumes.h     |    3 ++
 4 files changed, 148 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fc0ac97..db02e26 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1998,6 +1998,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_root *root);
+int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fb78f5e..99e1073 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7230,6 +7230,93 @@ out:
 }
 #endif
 
+/*
+ * checks to see if its even possible to relocate this block group.
+ *
+ * @return - -1 if it's not a good idea to relocate this block group, 0 if its
+ * ok to go ahead and try.
+ */
+int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
+{
+	struct btrfs_block_group_cache *block_group;
+	struct btrfs_space_info *space_info;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	struct btrfs_device *device;
+	int full = 0;
+	int ret = 0;
+
+	block_group = btrfs_lookup_block_group(root->fs_info, bytenr);
+
+	/* odd, couldn't find the block group, leave it alone */
+	if (!block_group)
+		return -1;
+
+	/* no bytes used, we're good */
+	if (!btrfs_block_group_used(&block_group->item))
+		goto out;
+
+	space_info = block_group->space_info;
+	spin_lock(&space_info->lock);
+
+	full = space_info->full;
+
+	/*
+	 * if this is the last block group we have in this space, we can't
+	 * relocate it.
+	 */
+	if (space_info->total_bytes == block_group->key.offset) {
+		ret = -1;
+		spin_unlock(&space_info->lock);
+		goto out;
+	}
+
+	/*
+	 * need to make sure we have room in the space to handle all of the
+	 * extents from this block group.  If we can, we're good
+	 */
+	if (space_info->bytes_used + space_info->bytes_reserved +
+	    space_info->bytes_pinned + space_info->bytes_readonly +
+	    btrfs_block_group_used(&block_group->item) <
+	    space_info->total_bytes) {
+		spin_unlock(&space_info->lock);
+		goto out;
+	}
+	spin_unlock(&space_info->lock);
+
+	/*
+	 * ok we don't have enough space, but maybe we have free space on our
+	 * devices to allocate new chunks for relocation, so loop through our
+	 * alloc devices and guess if we have enough space.  However, if we
+	 * were marked as full, then we know there aren't enough chunks, and we
+	 * can just return.
+	 */
+	ret = -1;
+	if (full)
+		goto out;
+
+	mutex_lock(&root->fs_info->chunk_mutex);
+	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
+		u64 min_free = btrfs_block_group_used(&block_group->item);
+		u64 dev_offset, max_avail;
+
+		/*
+		 * check to make sure we can actually find a chunk with enough
+		 * space to fit our block group in.
+		 */
+		if (device->total_bytes > device->bytes_used + min_free) {
+			ret = find_free_dev_extent(NULL, device, min_free,
+						   &dev_offset, &max_avail);
+			if (!ret)
+				break;
+			ret = -1;
+		}
+	}
+	mutex_unlock(&root->fs_info->chunk_mutex);
+out:
+	btrfs_put_block_group(block_group);
+	return ret;
+}
+
 static int find_first_block_group(struct btrfs_root *root,
 		struct btrfs_path *path, struct btrfs_key *key)
 {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5dbefd1..8d9c42e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -719,10 +719,9 @@ error:
  * called very infrequently and that a given device has a small number
  * of extents
  */
-static noinline int find_free_dev_extent(struct btrfs_trans_handle *trans,
-					 struct btrfs_device *device,
-					 u64 num_bytes, u64 *start,
-					 u64 *max_avail)
+int find_free_dev_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_device *device, u64 num_bytes,
+			 u64 *start, u64 *max_avail)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root = device->dev_root;
@@ -1736,6 +1735,10 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	extent_root = root->fs_info->extent_root;
 	em_tree = &root->fs_info->mapping_tree.map_tree;
 
+	ret = btrfs_can_relocate(extent_root, chunk_offset);
+	if (ret)
+		return -ENOSPC;
+
 	/* step one, relocate all the extents inside this chunk */
 	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
 	BUG_ON(ret);
@@ -1807,12 +1810,15 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
 	struct btrfs_key found_key;
 	u64 chunk_tree = chunk_root->root_key.objectid;
 	u64 chunk_type;
+	bool retried = false;
+	int failed = 0;
 	int ret;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
+again:
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
@@ -1842,7 +1848,10 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
 			ret = btrfs_relocate_chunk(chunk_root, chunk_tree,
 						   found_key.objectid,
 						   found_key.offset);
-			BUG_ON(ret);
+			if (ret == -ENOSPC)
+				failed++;
+			else if (ret)
+				BUG();
 		}
 
 		if (found_key.offset == 0)
@@ -1850,6 +1859,14 @@ static int btrfs_relocate_sys_chunks(struct btrfs_root *root)
 		key.offset = found_key.offset - 1;
 	}
 	ret = 0;
+	if (failed && !retried) {
+		failed = 0;
+		retried = true;
+		goto again;
+	} else if (failed && retried) {
+		WARN_ON(1);
+		ret = -ENOSPC;
+	}
 error:
 	btrfs_free_path(path);
 	return ret;
@@ -1894,6 +1911,8 @@ int btrfs_balance(struct btrfs_root *dev_root)
 			continue;
 
 		ret = btrfs_shrink_device(device, old_size - size_to_free);
+		if (ret == -ENOSPC)
+			break;
 		BUG_ON(ret);
 
 		trans = btrfs_start_transaction(dev_root, 1);
@@ -1938,9 +1957,8 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		chunk = btrfs_item_ptr(path->nodes[0],
 				       path->slots[0],
 				       struct btrfs_chunk);
-		key.offset = found_key.offset;
 		/* chunk zero is special */
-		if (key.offset == 0)
+		if (found_key.offset == 0)
 			break;
 
 		btrfs_release_path(chunk_root, path);
@@ -1948,7 +1966,8 @@ int btrfs_balance(struct btrfs_root *dev_root)
 					   chunk_root->root_key.objectid,
 					   found_key.objectid,
 					   found_key.offset);
-		BUG_ON(ret);
+		BUG_ON(ret && ret != -ENOSPC);
+		key.offset = found_key.offset - 1;
 	}
 	ret = 0;
 error:
@@ -1974,10 +1993,13 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	u64 chunk_offset;
 	int ret;
 	int slot;
+	int failed = 0;
+	bool retried = false;
 	struct extent_buffer *l;
 	struct btrfs_key key;
 	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
 	u64 old_total = btrfs_super_total_bytes(super_copy);
+	u64 old_size = device->total_bytes;
 	u64 diff = device->total_bytes - new_size;
 
 	if (new_size >= device->total_bytes)
@@ -1987,12 +2009,6 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	if (!path)
 		return -ENOMEM;
 
-	trans = btrfs_start_transaction(root, 1);
-	if (!trans) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
 	path->reada = 2;
 
 	lock_chunks(root);
@@ -2001,8 +2017,8 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	if (device->writeable)
 		device->fs_devices->total_rw_bytes -= diff;
 	unlock_chunks(root);
-	btrfs_end_transaction(trans, root);
 
+again:
 	key.objectid = device->devid;
 	key.offset = (u64)-1;
 	key.type = BTRFS_DEV_EXTENT_KEY;
@@ -2017,6 +2033,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 			goto done;
 		if (ret) {
 			ret = 0;
+			btrfs_release_path(root, path);
 			break;
 		}
 
@@ -2024,14 +2041,18 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		slot = path->slots[0];
 		btrfs_item_key_to_cpu(l, &key, path->slots[0]);
 
-		if (key.objectid != device->devid)
+		if (key.objectid != device->devid) {
+			btrfs_release_path(root, path);
 			break;
+		}
 
 		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
 		length = btrfs_dev_extent_length(l, dev_extent);
 
-		if (key.offset + length <= new_size)
+		if (key.offset + length <= new_size) {
+			btrfs_release_path(root, path);
 			break;
+		}
 
 		chunk_tree = btrfs_dev_extent_chunk_tree(l, dev_extent);
 		chunk_objectid = btrfs_dev_extent_chunk_objectid(l, dev_extent);
@@ -2040,8 +2061,26 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 
 		ret = btrfs_relocate_chunk(root, chunk_tree, chunk_objectid,
 					   chunk_offset);
-		if (ret)
+		if (ret && ret != -ENOSPC)
 			goto done;
+		if (ret == -ENOSPC)
+			failed++;
+		key.offset -= 1;
+	}
+
+	if (failed && !retried) {
+		failed = 0;
+		retried = true;
+		goto again;
+	} else if (failed && retried) {
+		ret = -ENOSPC;
+		lock_chunks(root);
+
+		device->total_bytes = old_size;
+		if (device->writeable)
+			device->fs_devices->total_rw_bytes += diff;
+		unlock_chunks(root);
+		goto done;
 	}
 
 	/* Shrinking succeeded, else we would be at "done". */
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139a83..31b0fab 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -181,4 +181,7 @@ int btrfs_balance(struct btrfs_root *dev_root);
 void btrfs_unlock_volumes(void);
 void btrfs_lock_volumes(void);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
+int find_free_dev_extent(struct btrfs_trans_handle *trans,
+			 struct btrfs_device *device, u64 num_bytes,
+			 u64 *start, u64 *max_avail);
 #endif
-- 
1.5.4.3

