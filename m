From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Update clone file ioctl
Date: Tue, 05 Aug 2008 11:04:07 +0800
Message-ID: <4897C327.7030205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch updates the file clone ioctl for the tree locking and new
data ordered code.

Regards
YZ
---
diff -r 77cbca2f7ae4 ioctl.c
--- a/ioctl.c	Mon Aug 04 10:41:27 2008 -0400
+++ b/ioctl.c	Tue Aug 05 08:29:47 2008 +0800
@@ -518,32 +518,6 @@ out:
 	return ret;
 }
 
-int dup_item_to_inode(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
-		       struct btrfs_path *path,
-		       struct extent_buffer *leaf,
-		       int slot,
-		       struct btrfs_key *key,
-		       u64 destino)
-{
-	char *dup;
-	int len = btrfs_item_size_nr(leaf, slot);
-	struct btrfs_key ckey = *key;
-	int ret = 0;
-
-	dup = kmalloc(len, GFP_NOFS);
-	if (!dup)
-		return -ENOMEM;
-
-	read_extent_buffer(leaf, dup, btrfs_item_ptr_offset(leaf, slot), len);
-	btrfs_release_path(root, path);
-
-	ckey.objectid = destino;
-	ret = btrfs_insert_item(trans, root, &ckey, dup, len);
-	kfree(dup);
-	return ret;
-}
-
 long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
 {
 	struct inode *inode = fdentry(file)->d_inode;
@@ -551,22 +525,41 @@ long btrfs_ioctl_clone(struct file *file
 	struct file *src_file;
 	struct inode *src;
 	struct btrfs_trans_handle *trans;
-	int ret;
-	u64 pos;
+	struct btrfs_ordered_extent *ordered;
 	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	char *buf;
 	struct btrfs_key key;
-	struct extent_buffer *leaf;
+	struct btrfs_key new_key;
+	u32 size;
 	u32 nritems;
 	int slot;
+	int ret;
 
 	src_file = fget(src_fd);
 	if (!src_file)
 		return -EBADF;
 	src = src_file->f_dentry->d_inode;
 
+	ret = -EISDIR;
+	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
+		goto out_fput;
+
 	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb)
+	if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
 		goto out_fput;
+
+	ret = -ENOMEM;
+	buf = vmalloc(btrfs_level_size(root, 0));
+	if (!buf)
+		goto out_fput;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		vfree(buf);
+		goto out_fput;
+	}
+	path->reada = 2;
 
 	if (inode < src) {
 		mutex_lock(&inode->i_mutex);
@@ -583,24 +576,22 @@ long btrfs_ioctl_clone(struct file *file
 	/* do any pending delalloc/csum calc on src, one way or
 	   another, and lock file content */
 	while (1) {
-		filemap_write_and_wait(src->i_mapping);
 		lock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
-		if (BTRFS_I(src)->delalloc_bytes == 0)
+		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
+		if (BTRFS_I(src)->delalloc_bytes == 0 && !ordered)
 			break;
 		unlock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
-	}
-
-	trans = btrfs_start_transaction(root, 0);
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
+		if (ordered)
+			btrfs_put_ordered_extent(ordered);
+		btrfs_wait_ordered_range(src, 0, (u64)-1);
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	BUG_ON(!trans);
+
+	key.objectid = src->i_ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
-	key.type = BTRFS_EXTENT_DATA_KEY;
-	key.objectid = src->i_ino;
-	pos = 0;
-	path->reada = 2;
 
 	while (1) {
 		/*
@@ -611,18 +602,19 @@ long btrfs_ioctl_clone(struct file *file
 		if (ret < 0)
 			goto out;
 
-		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+		nritems = btrfs_header_nritems(path->nodes[0]);
+		if (path->slots[0] >= nritems) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
 				goto out;
 			if (ret > 0)
 				break;
+			nritems = btrfs_header_nritems(path->nodes[0]);
 		}
 		leaf = path->nodes[0];
 		slot = path->slots[0];
+
 		btrfs_item_key_to_cpu(leaf, &key, slot);
-		nritems = btrfs_header_nritems(leaf);
-
 		if (btrfs_key_type(&key) > BTRFS_CSUM_ITEM_KEY ||
 		    key.objectid != src->i_ino)
 			break;
@@ -630,66 +622,64 @@ long btrfs_ioctl_clone(struct file *file
 		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
 			struct btrfs_file_extent_item *extent;
 			int found_type;
-			pos = key.offset;
+
 			extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
 			found_type = btrfs_file_extent_type(leaf, extent);
 			if (found_type == BTRFS_FILE_EXTENT_REG) {
-				u64 len = btrfs_file_extent_num_bytes(leaf,
-								      extent);
 				u64 ds = btrfs_file_extent_disk_bytenr(leaf,
 								       extent);
 				u64 dl = btrfs_file_extent_disk_num_bytes(leaf,
 								 extent);
-				u64 off = btrfs_file_extent_offset(leaf,
-								   extent);
-				btrfs_insert_file_extent(trans, root,
-							 inode->i_ino, pos,
-							 ds, dl, len, off);
 				/* ds == 0 means there's a hole */
 				if (ds != 0) {
-					btrfs_inc_extent_ref(trans, root,
+					ret = btrfs_inc_extent_ref(trans, root,
 						     ds, dl,
 						     root->root_key.objectid,
 						     trans->transid,
-						     inode->i_ino, pos);
+						     inode->i_ino, key.offset);
+					if (ret)
+						goto out;
 				}
-				pos = key.offset + len;
-			} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
-				ret = dup_item_to_inode(trans, root, path,
-							leaf, slot, &key,
-							inode->i_ino);
-				if (ret)
-					goto out;
-				pos = key.offset + btrfs_item_size_nr(leaf,
-								      slot);
 			}
-		} else if (btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
-			ret = dup_item_to_inode(trans, root, path, leaf,
-						slot, &key, inode->i_ino);
-
-			if (ret)
-				goto out;
+		}
+		
+		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY ||
+		    btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
+			size = btrfs_item_size_nr(leaf, slot);
+			read_extent_buffer(leaf, buf,
+					   btrfs_item_ptr_offset(leaf, slot),
+					   size);
+			btrfs_release_path(root, path);
+			memcpy(&new_key, &key, sizeof(new_key));
+			new_key.objectid = inode->i_ino;
+			ret = btrfs_insert_item(trans, root, &new_key, 
+						buf, size);
+			BUG_ON(ret);
+		} else {
+			btrfs_release_path(root, path);
 		}
 		key.offset++;
-		btrfs_release_path(root, path);
-	}
-
+	}
 	ret = 0;
 out:
-	btrfs_free_path(path);
-
-	inode->i_blocks = src->i_blocks;
-	i_size_write(inode, src->i_size);
-	btrfs_update_inode(trans, root, inode);
-
+	btrfs_release_path(root, path);
+	if (ret == 0) {
+		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		inode->i_blocks = src->i_blocks;
+		btrfs_i_size_write(inode, src->i_size);
+		BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
+		ret = btrfs_update_inode(trans, root, inode);
+	}
+	btrfs_end_transaction(trans, root);
 	unlock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
-
-	btrfs_end_transaction(trans, root);
-
+	if (ret)
+		vmtruncate(inode, 0);
 out_unlock:
 	mutex_unlock(&src->i_mutex);
 	mutex_unlock(&inode->i_mutex);
+	vfree(buf);
+	btrfs_free_path(path);
 out_fput:
 	fput(src_file);
 	return ret;
