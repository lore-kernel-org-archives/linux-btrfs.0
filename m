From: Sage Weil <sage@newdream.net>
Subject: cloning file data
Date: Thu, 24 Apr 2008 15:47:08 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org, btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi-

I'm working on a clone ioctl that will quickly and efficiently duplicate 
the contents of a file, e.g.

int main(int argc, const char **argv)
{
  int in = open(argv[1], O_RDONLY);
  int out = open(argv[2], O_CREAT|O_TRUNC|O_WRONLY, 0644);
  ioctl(out, BTRFS_IOC_CLONE, in);
  close(in);
  close(out);
  return 0;
}

I've probably got the locking order a bit wrong, lots of error handling is 
missing, and I suspect there's a cleaner way to do the target inode size 
update, but it behaves well enough in my (limited :) testing.  

Oh, and I wasn't certain the 'offset' in file_extent_item could be safely 
ignored when duplicating the extent reference.  My assumption was that it 
is orthogonal to extent allocation and isn't related to the backref.  
However, btrfs_insert_file_extent() always set offset=0.  I'm guessing I 
need to add an argument there and fix up the other callers?

Anyway, any comments or suggestions (on the interface or implemantation) 
are welcome.. :)

sage


diff -r 1791a620d509 inode.c
--- a/inode.c	Thu Apr 24 13:43:27 2008 -0700
+++ b/inode.c	Thu Apr 24 15:10:17 2008 -0700
@@ -18,6 +18,7 @@
 
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -2726,6 +2727,158 @@ long btrfs_ioctl_trans_end(struct file *
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
+	/* do any pending delalloc/csum calc on src, one way or another */
+	filemap_write_and_wait(src->i_mapping);
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
+				printk(" %llu~%llu disk %llu~%llu off %llu\n",
+				       pos, len, ds, dl,
+				       btrfs_file_extent_offset(leaf, extent));
+				btrfs_insert_file_extent(trans, root, 
+							 inode->i_ino, pos,
+							 ds, dl, len);
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
@@ -2744,6 +2897,9 @@ long btrfs_ioctl(struct file *file, unsi
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
+++ b/ioctl.h	Thu Apr 24 15:10:17 2008 -0700
@@ -36,5 +36,6 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_IOC_TRANS_START  _IO(BTRFS_IOCTL_MAGIC, 6)
 #define BTRFS_IOC_TRANS_END    _IO(BTRFS_IOCTL_MAGIC, 7)
 #define BTRFS_IOC_SYNC         _IO(BTRFS_IOCTL_MAGIC, 8)
+#define BTRFS_IOC_CLONE        _IOW(BTRFS_IOCTL_MAGIC, 9, int)
 #endif
 
