From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: allow clone of an arbitrary file range
Date: Thu, 30 Oct 2008 12:32:54 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0810301221050.32010@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This patch adds an additional CLONE_RANGE ioctl to clone an arbitrary 
(block-aligned) file range to another file.  The original CLONE ioctl 
becomes a special case of cloning the entire file range.  The logic is a 
bit more complex now since ranges may be cloned to different offsets, and 
because we may only be cloning the beginning or end of a particular extent 
or checksum item.

An additional sanity check ensures the source and destination files aren't 
the same (which would previously deadlock), although eventually this could 
be extended to allow the duplication of file data at a different offset 
within the same file.

Any extents within the destination range in the target file are dropped.

We currently do not cope with the case where a compressed inline extent 
needs to be split.  This will probably require decompressing the extent 
into a temporary address_space, and inserting just the cloned portion as a 
new compressed inline extent.  For now, just return -EINVAL in this case.  
Note that this never comes up in the more common case of cloning an entire 
file.
    
If you think there will be other users for CLONE_RANGE (userland 
deduplication could probably use it, if combined with some additional 
locking or sanity checks), then that case should be dealt with... but for 
now at least, Ceph doesn't need it.

Thanks- 
sage

---
 fs/btrfs/ioctl.c |  252 +++++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ioctl.h |    9 ++
 2 files changed, 221 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd3c8b5..befcffe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -591,7 +591,8 @@ out:
 	return ret;
 }
 
-long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
+long btrfs_ioctl_clone(struct file *file, unsigned long srcfd, u64 off,
+		       u64 olen, u64 destoff)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -605,12 +606,29 @@ long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
 	u32 nritems;
 	int slot;
 	int ret;
+	u64 len = olen;
+	u64 bs = root->fs_info->sb->s_blocksize;
+	u64 hint_byte;
 
-	src_file = fget(src_fd);
+	/*
+	 * TODO:
+	 * - split compressed inline extents.  annoying: we need to 
+	 *   decompress into destination's address_space (the file offset
+	 *   may change, so source mapping won't do), then recompress (or
+	 *   otherwise reinsert) a subrange.
+	 * - allow ranges within the same file to be cloned (provided
+	 *   they don't overlap)?
+	 */
+
+	src_file = fget(srcfd);
 	if (!src_file)
 		return -EBADF;
 	src = src_file->f_dentry->d_inode;
 
+	ret = -EINVAL;
+	if (src == inode)
+		goto out_fput;
+
 	ret = -EISDIR;
 	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
 		goto out_fput;
@@ -639,27 +657,46 @@ long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
 		mutex_lock(&inode->i_mutex);
 	}
 
-	ret = -ENOTEMPTY;
-	if (inode->i_size)
+	/* determine range to clone */
+	ret = -EINVAL;
+	if (off >= src->i_size || off + len > src->i_size)
 		goto out_unlock;
+	if (len == 0)
+		olen = len = src->i_size - off;
+	/* if we extend to eof, continue to block boundary */
+	if (off + len == src->i_size)
+		len = ((src->i_size + bs-1) & ~(bs-1))
+			- off;
+
+	/* verify the end result is block aligned */
+	if ((off & (bs-1)) ||
+	    ((off + len) & (bs-1)))
+		goto out_unlock;
+
+	printk("final src extent is %llu~%llu\n", off, len);
+	printk("final dst extent is %llu~%llu\n", destoff, len);
 
 	/* do any pending delalloc/csum calc on src, one way or
 	   another, and lock file content */
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
-		lock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
-		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
+		lock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
+		ordered = btrfs_lookup_first_ordered_extent(inode, off+len);
 		if (BTRFS_I(src)->delalloc_bytes == 0 && !ordered)
 			break;
-		unlock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
-		btrfs_wait_ordered_range(src, 0, (u64)-1);
+		btrfs_wait_ordered_range(src, off, off+len);
 	}
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
 
+	/* punch hole in destination first */
+	btrfs_drop_extents(trans, root, inode, off, off+len, 0, &hint_byte);
+
+	/* clone data */
 	key.objectid = src->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
@@ -690,55 +727,178 @@ long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
 		    key.objectid != src->i_ino)
 			break;
 
-		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY ||
-		    btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
+		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
+			struct btrfs_file_extent_item *extent;
+			int type;
 			u32 size;
 			struct btrfs_key new_key;
+			u64 disko = 0, diskl = 0;
+			u64 datao = 0, datal = 0;
+			u8 comp;
 
 			size = btrfs_item_size_nr(leaf, slot);
 			read_extent_buffer(leaf, buf,
 					   btrfs_item_ptr_offset(leaf, slot),
 					   size);
+
+			extent = btrfs_item_ptr(leaf, slot,
+						struct btrfs_file_extent_item);
+			comp = btrfs_file_extent_compression(leaf, extent);
+			type = btrfs_file_extent_type(leaf, extent);
+			if (type == BTRFS_FILE_EXTENT_REG) {
+				disko = btrfs_file_extent_disk_bytenr(leaf, extent);
+				diskl = btrfs_file_extent_disk_num_bytes(leaf, extent);
+				datao = btrfs_file_extent_offset(leaf, extent);
+				datal = btrfs_file_extent_num_bytes(leaf, extent);
+			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
+				/* take upper bound, may be compressed */
+				datal = btrfs_file_extent_ram_bytes(leaf,
+								    extent);
+			}
 			btrfs_release_path(root, path);
 
+			if (key.offset + datal < off ||
+			    key.offset >= off+len)
+				goto next;
+
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.objectid = inode->i_ino;
-			ret = btrfs_insert_empty_item(trans, root, path,
-						      &new_key, size);
-			if (ret)
-				goto out;
+			new_key.offset = key.offset + destoff - off;
 
-			leaf = path->nodes[0];
-			slot = path->slots[0];
-			write_extent_buffer(leaf, buf,
+			if (type == BTRFS_FILE_EXTENT_REG) {
+				ret = btrfs_insert_empty_item(trans, root, path,
+							      &new_key, size);
+				if (ret)
+					goto out;
+
+				leaf = path->nodes[0];
+				slot = path->slots[0];
+				write_extent_buffer(leaf, buf,
 					    btrfs_item_ptr_offset(leaf, slot),
 					    size);
-			btrfs_mark_buffer_dirty(leaf);
-		}
-
-		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
-			struct btrfs_file_extent_item *extent;
-			int found_type;
 
-			extent = btrfs_item_ptr(leaf, slot,
+				extent = btrfs_item_ptr(leaf, slot,
 						struct btrfs_file_extent_item);
-			found_type = btrfs_file_extent_type(leaf, extent);
-			if (found_type == BTRFS_FILE_EXTENT_REG) {
-				u64 ds = btrfs_file_extent_disk_bytenr(leaf,
-								       extent);
-				u64 dl = btrfs_file_extent_disk_num_bytes(leaf,
-								 extent);
-				/* ds == 0 means there's a hole */
-				if (ds != 0) {
+				printk("  orig disk %llu~%llu data %llu~%llu\n",
+				       disko, diskl, datao, datal);
+
+				if (off > key.offset) {
+					datao += off - key.offset;
+					datal -= off - key.offset;
+				}
+				if (key.offset + datao + datal + key.offset >
+				    off + len)
+					datal = off + len - key.offset - datao;
+				/* disko == 0 means it's a hole */
+				if (!disko)
+					datao = 0;
+				printk(" final disk %llu~%llu data %llu~%llu\n",
+				       disko, diskl, datao, datal);
+
+				btrfs_set_file_extent_offset(leaf, extent,
+							     datao);
+				btrfs_set_file_extent_num_bytes(leaf, extent,
+								datal);
+				if (disko) {
+					inode_add_bytes(inode, datal);
 					ret = btrfs_inc_extent_ref(trans, root,
-						     ds, dl, leaf->start,
-						     root->root_key.objectid,
-						     trans->transid,
-						     inode->i_ino);
+						   disko, diskl, leaf->start,
+						   root->root_key.objectid,
+						   trans->transid,
+						   inode->i_ino);
 					BUG_ON(ret);
 				}
+			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
+				u64 skip = 0;
+				u64 trim = 0;
+				if (off > key.offset) {
+					skip = off - key.offset;
+					new_key.offset += skip;
+				}
+				if (key.offset + datal > off+len)
+					trim = key.offset + datal - (off+len);
+				printk("len %lld skip %lld trim %lld\n",
+				       datal, skip, trim);
+				if (comp && (skip || trim)) {
+					printk("btrfs clone_range can't split compressed inline extents yet\n");
+					ret = -EINVAL;
+					goto out;
+				}
+				size -= skip + trim;
+				datal -= skip + trim;
+ 				ret = btrfs_insert_empty_item(trans, root, path,
+							      &new_key, size);
+				if (ret)
+					goto out;
+
+				if (skip) {
+					u32 start = btrfs_file_extent_calc_inline_size(0);
+					memmove(buf+start, buf+start+skip,
+						datal);
+				}
+
+				leaf = path->nodes[0];
+				slot = path->slots[0];
+				write_extent_buffer(leaf, buf,
+					    btrfs_item_ptr_offset(leaf, slot),
+					    size);
+				inode_add_bytes(inode, datal);
 			}
+
+			btrfs_mark_buffer_dirty(leaf);
 		}
+
+		if (btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY) {
+			u32 size;
+			struct btrfs_key new_key;
+			u64 coverslen;
+			int coff, clen;
+
+			size = btrfs_item_size_nr(leaf, slot);
+			coverslen = (size / BTRFS_CRC32_SIZE) <<
+				root->fs_info->sb->s_blocksize_bits;
+			printk("csums for %llu~%llu\n",
+			       key.offset, coverslen);
+			if (key.offset + coverslen < off ||
+			    key.offset >= off+len)
+				goto next;
+
+			read_extent_buffer(leaf, buf,
+					   btrfs_item_ptr_offset(leaf, slot),
+					   size);
+			btrfs_release_path(root, path);
+
+			coff = 0;
+			if (off > key.offset)
+				coff = ((off - key.offset) >>
+					root->fs_info->sb->s_blocksize_bits) *
+					BTRFS_CRC32_SIZE;
+			clen = size - coff;
+			if (key.offset + coverslen > off+len)
+				clen -= ((key.offset+coverslen-off-len) >>
+					 root->fs_info->sb->s_blocksize_bits) *
+					BTRFS_CRC32_SIZE;
+			printk(" will dup %d~%d of %d\n",
+			       coff, clen, size);
+
+			memcpy(&new_key, &key, sizeof(new_key));
+			new_key.objectid = inode->i_ino;
+			new_key.offset = key.offset + destoff - off;
+
+			ret = btrfs_insert_empty_item(trans, root, path,
+						      &new_key, clen);
+			if (ret)
+				goto out;
+
+			leaf = path->nodes[0];
+			slot = path->slots[0];
+			write_extent_buffer(leaf, buf + coff,
+					    btrfs_item_ptr_offset(leaf, slot),
+					    clen);
+			btrfs_mark_buffer_dirty(leaf);
+		}
+
+	next:
 		btrfs_release_path(root, path);
 		key.offset++;
 	}
@@ -747,13 +907,13 @@ out:
 	btrfs_release_path(root, path);
 	if (ret == 0) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		inode_set_bytes(inode, inode_get_bytes(src));
-		btrfs_i_size_write(inode, src->i_size);
+		if (destoff + olen > inode->i_size)
+			btrfs_i_size_write(inode, destoff + olen);
 		BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
 		ret = btrfs_update_inode(trans, root, inode);
 	}
 	btrfs_end_transaction(trans, root);
-	unlock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
+	unlock_extent(&BTRFS_I(src)->io_tree, off, off+len, GFP_NOFS);
 	if (ret)
 		vmtruncate(inode, 0);
 out_unlock:
@@ -766,6 +926,16 @@ out_fput:
 	return ret;
 }
 
+long btrfs_ioctl_clone_range(struct file *file, unsigned long argptr)
+{
+	struct btrfs_ioctl_clone_range_args args;
+
+	if (copy_from_user(&args, (void *)argptr, sizeof(args)))
+		return -EFAULT;
+	return btrfs_ioctl_clone(file, args.src_fd, args.src_offset,
+				 args.src_length, args.dest_offset);
+}
+
 /*
  * there are many ways the trans_start and trans_end ioctls can lead
  * to deadlocks.  They should only be used by applications that
@@ -849,7 +1019,9 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_CLONE:
-		return btrfs_ioctl_clone(file, arg);
+		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
+	case BTRFS_IOC_CLONE_RANGE:
+		return btrfs_ioctl_clone_range(file, arg);
 	case BTRFS_IOC_TRANS_START:
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 85ed35a..989ba8a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -52,4 +52,13 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_IOC_BALANCE _IOW(BTRFS_IOCTL_MAGIC, 12, \
 				   struct btrfs_ioctl_vol_args)
 
+struct btrfs_ioctl_clone_range_args {
+  __s64 src_fd;
+  __u64 src_offset, src_length;
+  __u64 dest_offset;
+};
+
+#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
+				  struct btrfs_ioctl_clone_range_args)
+
 #endif
