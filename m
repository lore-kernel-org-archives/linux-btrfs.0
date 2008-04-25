From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 11:26:20 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804251119260.23551@cobra.newdream.net>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
 <200804250941.35343.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804250941.35343.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 25 Apr 2008, Chris Mason wrote:
> Very cool.  I'd actually loved to see this wrapped into a program that will 
> cow a directory tree.  Basically the same as cp -al, but with cow instead of 
> linking.

Yeah definitely.  I added a -c/--cow flag to GNU cp, but am having trouble 
coercing autotools into even building on my box.  I'll fiddle with it a 
little later.  Basically, it just tries the ioctl, and goes into the 
regular copy read/write loop if that fails.

> > However, btrfs_insert_file_extent() always set offset=0.  I'm guessing I
> > need to add an argument there and fix up the other callers?
> >
> Yes, you need to preserve the offset.  There's only one place right now that 
> sets a non-zero offset and it inserts the extent by hand for other reasons 
> (if you're brave, file.c:btrfs_drop_extents)

I see.  In this case, since I'm duplicating the forward and backrefs, I 
just added the offset arg to btrfs_insert_file_extent().

> By taking the inode mutex, you protect against file_write and truncates 
> changing the file.  But, we also need to prevent mmaps from changing the file 
> pages as well.  What you want to do lock all the file bytes in the extent 
> tree:
> 
> lock_extent(&BTRFS_I(src_inode)->io_tree, 0, (u64)-1, GFP_NOFS);
> 
> But unfortunately, the code to fill delayed allocation takes that same lock.  
> So you need to loop a bit:
> 
> while(1) {
>     filemap_write_and_wait(src_inode);
>     lock_extent()
>     if (BTRFS_I(src_inode)->delalloc_bytes == 0)
>         break;
>     unlock_extent()
> }
> 
> That should keep you from racing with btrfs_page_mkwrite()

Ah, that's what I was looking for.  The adjusted patch is below!

Thanks-
sage



diff -r 1791a620d509 ctree.h
--- a/ctree.h	Thu Apr 24 13:43:27 2008 -0700
+++ b/ctree.h	Fri Apr 25 10:12:46 2008 -0700
@@ -1135,9 +1135,9 @@ int btrfs_lookup_inode(struct btrfs_tran
 /* file-item.c */
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
-			       u64 objectid, u64 pos, u64 offset,
+			       u64 objectid, u64 pos, u64 disk_offset,
 			       u64 disk_num_bytes,
-			       u64 num_bytes);
+			     u64 num_bytes, u64 offset);
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid,
diff -r 1791a620d509 file-item.c
--- a/file-item.c	Thu Apr 24 13:43:27 2008 -0700
+++ b/file-item.c	Fri Apr 25 10:12:46 2008 -0700
@@ -28,10 +28,10 @@
 			       sizeof(struct btrfs_item) * 2) / \
 			       BTRFS_CRC32_SIZE) - 1))
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       u64 objectid, u64 pos,
-			       u64 offset, u64 disk_num_bytes,
-			       u64 num_bytes)
+			     struct btrfs_root *root,
+			     u64 objectid, u64 pos,
+			     u64 disk_offset, u64 disk_num_bytes,
+			     u64 num_bytes, u64 offset)
 {
 	int ret = 0;
 	struct btrfs_file_extent_item *item;
@@ -53,9 +53,9 @@ int btrfs_insert_file_extent(struct btrf
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0],
 			      struct btrfs_file_extent_item);
-	btrfs_set_file_extent_disk_bytenr(leaf, item, offset);
+	btrfs_set_file_extent_disk_bytenr(leaf, item, disk_offset);
 	btrfs_set_file_extent_disk_num_bytes(leaf, item, disk_num_bytes);
-	btrfs_set_file_extent_offset(leaf, item, 0);
+	btrfs_set_file_extent_offset(leaf, item, offset);
 	btrfs_set_file_extent_num_bytes(leaf, item, num_bytes);
 	btrfs_set_file_extent_generation(leaf, item, trans->transid);
 	btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
diff -r 1791a620d509 file.c
--- a/file.c	Thu Apr 24 13:43:27 2008 -0700
+++ b/file.c	Fri Apr 25 10:12:46 2008 -0700
@@ -285,7 +285,7 @@ static int noinline dirty_and_release_pa
 			err = btrfs_insert_file_extent(trans, root,
 						       inode->i_ino,
 						       last_pos_in_file,
-						       0, 0, hole_size);
+						       0, 0, hole_size, 0);
 			btrfs_drop_extent_cache(inode, last_pos_in_file,
 					last_pos_in_file + hole_size -1);
 			btrfs_check_file(root, inode);
diff -r 1791a620d509 inode.c
--- a/inode.c	Thu Apr 24 13:43:27 2008 -0700
+++ b/inode.c	Fri Apr 25 10:12:46 2008 -0700
@@ -18,6 +18,7 @@
 
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -134,7 +135,7 @@ static int cow_file_range(struct inode *
 		}
 		ret = btrfs_insert_file_extent(trans, root, inode->i_ino,
 					       start, ins.objectid, ins.offset,
-					       ins.offset);
+					       ins.offset, 0);
 		inode->i_blocks += ins.offset >> 9;
 		btrfs_check_file(root, inode);
 		num_bytes -= cur_alloc_size;
@@ -1046,7 +1047,7 @@ static int btrfs_setattr(struct dentry *
 			err = btrfs_insert_file_extent(trans, root,
 						       inode->i_ino,
 						       hole_start, 0, 0,
-						       hole_size);
+						       hole_size, 0);
 			btrfs_drop_extent_cache(inode, hole_start,
 						hole_size - 1);
 			btrfs_check_file(root, inode);
@@ -2726,6 +2727,168 @@ long btrfs_ioctl_trans_end(struct file *
 	return 0;
 }
 
+void dup_item_to_inode(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
+		       struct btrfs_path *path,
+		       struct extent_buffer *leaf,
+		       int slot,
+		       struct btrfs_key *key,
+		       u64 destino)
+{
+	struct btrfs_path *cpath = btrfs_alloc_path();
+	int len = btrfs_item_size_nr(leaf, slot);
+	int dstoff;
+	struct btrfs_key ckey = *key;
+	int ret;
+
+	ckey.objectid = destino;
+	ret = btrfs_insert_empty_item(trans, root, cpath, &ckey, len);
+	dstoff = btrfs_item_ptr_offset(cpath->nodes[0], cpath->slots[0]);
+	copy_extent_buffer(cpath->nodes[0], leaf, dstoff,
+			   btrfs_item_ptr_offset(leaf, slot),
+			   len);
+	btrfs_release_path(root, cpath);
+}
+
+long btrfs_ioctl_clone(struct file *file, unsigned long src_fd)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct file *src_file;
+	struct inode *src;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	u64 pos;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	u32 nritems;
+	int nextret;
+	int slot;
+
+	src_file = fget(src_fd);
+	if (!src_file)
+		return -EBADF;
+	src = src_file->f_dentry->d_inode;
+
+	ret = -EXDEV;
+	if (src->i_sb != inode->i_sb)
+		goto out_fput;
+
+	if (inode < src) {
+		mutex_lock(&inode->i_mutex);
+		mutex_lock(&src->i_mutex);
+	} else {
+		mutex_lock(&src->i_mutex);
+		mutex_lock(&inode->i_mutex);	
+	}
+	
+	ret = -ENOTEMPTY;
+	if (inode->i_size)
+		goto out_unlock;
+
+	/* do any pending delalloc/csum calc on src, one way or
+	   another, and lock file content */
+	while (1) {
+		filemap_write_and_wait(src->i_mapping);
+		lock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
+		if (BTRFS_I(src)->delalloc_bytes == 0)
+			break;
+		unlock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
+	}
+
+	mutex_lock(&root->fs_info->fs_mutex);
+	trans = btrfs_start_transaction(root, 0);
+	path = btrfs_alloc_path();
+	pos = 0;
+	while (1) {
+		ret = btrfs_lookup_file_extent(trans, root, path, src->i_ino,
+					       pos, 0);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			if (path->slots[0] == 0) {
+				ret = 0;
+				goto out;
+			}
+			path->slots[0]--;
+		}
+	next_slot:
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+
+		printk("key(%llu %x %llu)\n",
+		       key.objectid, key.type, key.offset);
+		if (btrfs_key_type(&key) > BTRFS_CSUM_ITEM_KEY ||
+		    key.objectid != src->i_ino)
+			goto out;
+		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
+			struct btrfs_file_extent_item *extent;
+			int found_type;
+			u64 len;
+			pos = key.offset;
+			extent = btrfs_item_ptr(leaf, slot,
+						struct btrfs_file_extent_item);
+			found_type = btrfs_file_extent_type(leaf, extent);
+			len = btrfs_file_extent_num_bytes(leaf, extent);
+			if (found_type == BTRFS_FILE_EXTENT_REG) {
+				u64 ds = btrfs_file_extent_disk_bytenr(leaf, 
+								       extent);
+				u64 dl = btrfs_file_extent_disk_num_bytes(leaf, 
+								 extent);
+				u64 off = btrfs_file_extent_offset(leaf, 
+								   extent);
+				printk(" %llu~%llu disk %llu~%llu off %llu\n",
+				       pos, len, ds, dl, off);
+				btrfs_insert_file_extent(trans, root, 
+							 inode->i_ino, pos,
+							 ds, dl, len, off);
+				btrfs_inc_extent_ref(trans, root, ds, dl,
+						     root->root_key.objectid,
+						     trans->transid,
+						     inode->i_ino, pos);
+			} else if (found_type == BTRFS_FILE_EXTENT_INLINE)
+				dup_item_to_inode(trans, root, path, leaf, slot,
+						  &key, inode->i_ino);
+			pos = key.offset + len;
+		} else if (btrfs_key_type(&key) == BTRFS_CSUM_ITEM_KEY)
+			dup_item_to_inode(trans, root, path, leaf, slot, &key, 
+					  inode->i_ino);
+		
+		nritems = btrfs_header_nritems(leaf);
+		if (slot >= nritems - 1) {
+			nextret = btrfs_next_leaf(root, path);
+			if (nextret)
+				goto out;
+		} else {
+			path->slots[0]++;
+		}
+		goto next_slot;
+	}
+
+out:
+	ret = 0;
+	mutex_unlock(&root->fs_info->fs_mutex);	
+
+	i_size_write(inode, src->i_size);
+	inode->i_blocks = src->i_blocks;
+	mark_inode_dirty(inode);
+
+	unlock_extent(&BTRFS_I(src)->io_tree, 0, (u64)-1, GFP_NOFS);
+
+	mutex_lock(&root->fs_info->fs_mutex);	
+	btrfs_end_transaction(trans, root);
+	mutex_unlock(&root->fs_info->fs_mutex);	
+
+out_unlock:
+	mutex_unlock(&src->i_mutex);
+	mutex_unlock(&inode->i_mutex);
+out_fput:
+	fput(src_file);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2744,6 +2907,9 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_trans_end(file);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
+		return 0;
+	case BTRFS_IOC_CLONE:
+		btrfs_ioctl_clone(file, arg);
 		return 0;
 	}
 
diff -r 1791a620d509 ioctl.h
--- a/ioctl.h	Thu Apr 24 13:43:27 2008 -0700
+++ b/ioctl.h	Fri Apr 25 10:12:46 2008 -0700
@@ -36,5 +36,6 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_IOC_TRANS_START  _IO(BTRFS_IOCTL_MAGIC, 6)
 #define BTRFS_IOC_TRANS_END    _IO(BTRFS_IOCTL_MAGIC, 7)
 #define BTRFS_IOC_SYNC         _IO(BTRFS_IOCTL_MAGIC, 8)
+#define BTRFS_IOC_CLONE        _IOW(BTRFS_IOCTL_MAGIC, 9, int)
 #endif
 
