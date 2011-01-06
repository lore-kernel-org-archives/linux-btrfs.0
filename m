From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: add extent-same ioctl for dedup
Date: Thu,  6 Jan 2011 13:51:30 -0500
Message-ID: <1294339890-24854-1-git-send-email-josef@redhat.com>
References: <1294338300-24259-2-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294338300-24259-2-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This adds the ability for userspace to tell btrfs which extents match eachother.
You pass in

-a logical offset
-a length
-a list of file descriptors with their logical offset

and this ioctl will split up the extent on the target file and then link all of
the files with the target files extent and free up their original extent.  We
manually memcmp each file we're going to link with the original to make
absolutely sure that the data is truly the same.  There are a few limitations
currently

1) Any data transformation whatsoever.  This includes compression or any
encryption that happens later on.  This is just to make sure we're not deduping
things that don't turn out to be the same stuff on disk as it is
uncompressed/decrypted.

2) Across subvolumes.  This can be fixed later, but this is just to keep odd
problems from happening, like oh say trying to dedup things that are snapshots
of eachother already.  Nothing bad will happen, it's just needless work so just
don't allow it for the time being.

3) If the target file's data is split across extents.  We need one extent to
point everybody at, so if the target file's data spans different extents we
won't work.  In this case I return ERANGE so the userspace app can call defrag
and then try again, but currently I don't do that, so that will have to be fixed
at some point.

I think thats all of the special cases.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ioctl.c |  603 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   15 ++
 2 files changed, 618 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f1c9bb4..5d2769e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2231,6 +2231,607 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+static noinline int check_data(struct inode *inode,
+			       char *orig, u64 off, u64 len,
+			       char **cur_buffer)
+{
+	struct page *page;
+	void *addr;
+	char *buffer;
+	pgoff_t index;
+	pgoff_t last_index;
+	int ret = 0;
+	int bytes_copied = 0;
+
+	buffer = kmalloc(len, GFP_NOFS);
+	if (!buffer)
+		return -ENOMEM;
+
+	index = off >> PAGE_CACHE_SHIFT;
+	last_index = (off + len - 1) >> PAGE_CACHE_SHIFT;
+
+	while (index <= last_index) {
+		page = grab_cache_page(inode->i_mapping, index);
+		if (!page) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+
+		addr = kmap(page);
+		memcpy(buffer + bytes_copied, addr, PAGE_CACHE_SIZE);
+		kunmap(page);
+		unlock_page(page);
+		page_cache_release(page);
+		bytes_copied += PAGE_CACHE_SIZE;
+		index++;
+	}
+
+	if (cur_buffer) {
+		*cur_buffer = buffer;
+		return 0;
+	}
+
+	if (memcmp(orig, buffer, len))
+		ret = -EINVAL;
+
+out:
+	kfree(buffer);
+	return ret;
+}
+
+static noinline int split_extent(struct btrfs_trans_handle *trans,
+				 struct inode *inode, u64 start, u64 end,
+				 u64 *bytenr, u64 *bytes, u64 *offset)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	u64 extent_start;
+	u64 extent_end;
+	u64 extent_offset;
+	u64 search_start = start;
+	u64 disk_bytenr;
+	u64 disk_bytes;
+	int ret;
+	int recow;
+	int extent_type;
+
+	btrfs_drop_extent_cache(inode, start, end - 1, 0);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	while (1) {
+		recow = 0;
+		ret = btrfs_lookup_file_extent(trans, root, path,
+					       inode->i_ino, search_start, 1);
+		if (ret < 0)
+			break;
+		if (ret > 0 && path->slots[0] > 0) {
+			path->slots[0]--;
+		} else if (ret > 0 && path->slots[0] == 0) {
+			ret = btrfs_prev_leaf(root, path);
+			if (ret < 0)
+				break;
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+		}
+
+next_slot:
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				break;
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid > inode->i_ino ||
+		    key.type > BTRFS_EXTENT_DATA_KEY || key.offset >= end)
+			break;
+
+		fi = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_file_extent_item);
+		extent_type = btrfs_file_extent_type(leaf, fi);
+		if (extent_type != BTRFS_FILE_EXTENT_REG) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (btrfs_file_extent_compression(leaf, fi) ||
+		    btrfs_file_extent_encryption(leaf, fi) ||
+		    btrfs_file_extent_other_encoding(leaf, fi)) {
+			printk(KERN_ERR "cannot dedup transformed extents\n");
+			ret = -EINVAL;
+			break;
+		}
+
+		extent_start = key.offset;
+		extent_end = extent_start +
+			btrfs_file_extent_num_bytes(leaf, fi);
+		extent_offset = btrfs_file_extent_offset(leaf, fi);
+		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		disk_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
+
+		if (extent_end < search_start) {
+			path->slots[0]++;
+			goto next_slot;
+		}
+
+		search_start = max(key.offset, start);
+		if (recow) {
+			btrfs_release_path(root, path);
+			continue;
+		}
+
+		/*
+		 *     | - range to split - |
+		 *  | -------- extent -------- |
+		 */
+		if (start > key.offset && end < extent_end) {
+			struct btrfs_key new_key;
+
+			memcpy(&new_key, &key, sizeof(new_key));
+			new_key.offset = start;
+			ret = btrfs_duplicate_item(trans, root, path,
+						   &new_key);
+			if (ret == -EAGAIN) {
+				btrfs_release_path(root, path);
+				continue;
+			}
+			if (ret < 0)
+				break;
+
+			leaf = path->nodes[0];
+			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi, start -
+							key.offset);
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			extent_offset += start - key.offset;
+			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_end - start);
+			if (bytes)
+				*bytes = disk_bytes;
+			if (bytenr)
+				*bytenr = disk_bytenr;
+			if (offset)
+				*offset = extent_offset;
+
+			btrfs_mark_buffer_dirty(leaf);
+
+			ret = btrfs_inc_extent_ref(trans, root, disk_bytenr,
+						   disk_bytes, 0,
+						   root->root_key.objectid,
+						   inode->i_ino,
+						   extent_offset);
+			if (ret) {
+				int err;
+				WARN_ON(1);
+				fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					struct btrfs_file_extent_item);
+				btrfs_set_file_extent_num_bytes(leaf, fi,
+					extent_end - extent_start);
+				err = btrfs_del_items(trans, root, path,
+						      path->slots[0], 1);
+				WARN_ON(err);
+				break;
+			}
+
+			new_key.offset = end;
+			ret = btrfs_duplicate_item(trans, root, path, &new_key);
+			if (ret == -EAGAIN) {
+				btrfs_release_path(root, path);
+				continue;
+			}
+			if (ret < 0)
+				break;
+
+			leaf = path->nodes[0];
+			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							end - start);
+
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			extent_offset += end - start;
+			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_end - end);
+
+			ret = btrfs_inc_extent_ref(trans, root, disk_bytenr,
+						   disk_bytes, 0,
+						   root->root_key.objectid,
+						   inode->i_ino, 0);
+			if (ret) {
+				int err;
+				WARN_ON(1);
+				fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					struct btrfs_file_extent_item);
+				btrfs_set_file_extent_num_bytes(leaf, fi,
+						extent_end - start);
+				err = btrfs_del_items(trans, root, path,
+						      path->slots[0], 1);
+				WARN_ON(err);
+				break;
+			}
+			btrfs_mark_buffer_dirty(leaf);
+			ret = 0;
+			break;
+		}
+
+		/*
+		 * | - range to split -|
+		 * | ------ extent ------|
+		 */
+		if (start == key.offset && end < extent_end) {
+			struct btrfs_key new_key;
+
+			memcpy(&new_key, &key, sizeof(new_key));
+			new_key.offset = end;
+			ret = btrfs_duplicate_item(trans, root, path,
+						   &new_key);
+			if (ret == -EAGAIN) {
+				btrfs_release_path(root, path);
+				continue;
+			}
+			if (ret < 0)
+				break;
+
+			leaf = path->nodes[0];
+			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							end - start);
+
+			if (bytes)
+				*bytes = disk_bytes;
+			if (bytenr)
+				*bytenr = disk_bytenr;
+			if (offset)
+				*offset = extent_offset;
+
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			extent_offset += end - start;
+			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_end - end);
+			btrfs_mark_buffer_dirty(leaf);
+
+			ret = btrfs_inc_extent_ref(trans, root, disk_bytenr,
+						   disk_bytes, 0,
+						   root->root_key.objectid,
+						   inode->i_ino,
+						   extent_offset);
+			if (ret) {
+				int err;
+
+				WARN_ON(1);
+				fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					struct btrfs_file_extent_item);
+				btrfs_set_file_extent_num_bytes(leaf, fi,
+						extent_end - start);
+				err = btrfs_del_items(trans, root, path,
+						      path->slots[0], 1);
+				WARN_ON(err);
+				break;
+			}
+			ret = 0;
+			break;
+		}
+
+		if (start == key.offset && end == extent_end) {
+			if (bytes)
+				*bytes = disk_bytes;
+			if (bytenr)
+				*bytenr = disk_bytenr;
+			if (offset)
+				*offset = extent_offset;
+			ret = 0;
+			break;
+		}
+
+		ret = -ERANGE;
+		break;
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+static noinline int link_extent(struct btrfs_trans_handle *trans,
+				struct inode *inode, u64 disk_bytenr,
+				u64 disk_bytes, u64 extent_offset,
+				u64 offset, u64 len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key key;
+	u64 hint;
+	int ret;
+	int err;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, disk_bytes, 0,
+				   root->root_key.objectid, inode->i_ino,
+				   extent_offset);
+	if (ret)
+		return ret;
+
+	ret = btrfs_drop_extents(trans, inode, offset, offset + len,
+				 &hint, 1);
+	if (ret) {
+		err = ret;
+		btrfs_free_path(path);
+		goto out;
+	}
+
+	key.objectid = inode->i_ino;
+	key.offset = offset;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	ret = btrfs_insert_empty_item(trans, root, path, &key, sizeof(*fi));
+
+	/*
+	 * Yes I know, it sucks, but if we don't do this we'll lose data, we
+	 * need to come up with a way to undo the drop_extents so that if this
+	 * part fails we can still at least have the old data.
+	 */
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	fi = btrfs_item_ptr(leaf, path->slots[0],
+			    struct btrfs_file_extent_item);
+
+	btrfs_set_file_extent_generation(leaf, fi, trans->transid);
+	btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_disk_bytenr(leaf, fi, disk_bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, fi, disk_bytes);
+	btrfs_set_file_extent_offset(leaf, fi, extent_offset);
+	btrfs_set_file_extent_num_bytes(leaf, fi, len);
+	btrfs_set_file_extent_ram_bytes(leaf, fi, len);
+	btrfs_set_file_extent_compression(leaf, fi, 0);
+	btrfs_set_file_extent_encryption(leaf, fi, 0);
+	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
+
+	btrfs_mark_buffer_dirty(leaf);
+	inode_add_bytes(inode, len);
+	btrfs_free_path(path);
+
+	return 0;
+out:
+	ret = btrfs_free_extent(trans, root, disk_bytenr, disk_bytes, 0,
+				root->root_key.objectid, inode->i_ino,
+				extent_offset);
+	if (ret)
+		err = ret;
+	return err;
+}
+
+static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
+{
+	while (1) {
+		struct btrfs_ordered_extent *ordered;
+		lock_extent(&BTRFS_I(inode)->io_tree, off,
+			    off + len - 1, GFP_NOFS);
+		ordered = btrfs_lookup_first_ordered_extent(inode,
+							    off + len - 1);
+		if (!ordered &&
+		    !test_range_bit(&BTRFS_I(inode)->io_tree, off,
+				    off + len - 1, EXTENT_DELALLOC, 0, NULL))
+			break;
+		unlock_extent(&BTRFS_I(inode)->io_tree, off, off + len -1,
+			      GFP_NOFS);
+		if (ordered)
+			btrfs_put_ordered_extent(ordered);
+		btrfs_wait_ordered_range(inode, off, len);
+	}
+}
+
+static noinline long btrfs_ioctl_file_extent_same(struct file *file,
+						  void __user *argp)
+{
+	struct btrfs_ioctl_same_args *args;
+	struct btrfs_ioctl_same_args tmp;
+	struct inode *src = file->f_dentry->d_inode;
+	struct btrfs_root *root;
+	struct file *dst_file;
+	struct inode *dst_inode;
+	struct btrfs_trans_handle *trans;
+	char *orig_buffer;
+	u64 off;
+	u64 len;
+	u64 bytenr;
+	u64 bytes;
+	u64 extent_offset;
+	int args_size = 0;
+	int drop_ref = 0;
+	int i;
+	int ret;
+
+	if (copy_from_user(&tmp,
+			   (struct btrfs_ioctl_same_args __user *)argp,
+			   sizeof(tmp)))
+		return -EFAULT;
+
+	args_size = sizeof(tmp) + (tmp.total_files *
+			sizeof(struct btrfs_ioctl_file_extent_info));
+
+	/* lets not let this get out of hand */
+	if (args_size > PAGE_CACHE_SIZE)
+		return -ENOMEM;
+
+	args = kmalloc(args_size, GFP_NOFS);
+	if (!args)
+		return -ENOMEM;
+
+	if (copy_from_user(args,
+			   (struct btrfs_ioctl_same_args __user *)argp,
+			   args_size))
+		return -EFAULT;
+
+	/* Make sure args didn't change magically between copies. */
+	if (memcmp(&tmp, args, sizeof(tmp))) {
+		kfree(args);
+		return -EINVAL;
+	}
+
+	if (S_ISDIR(src->i_mode)) {
+		kfree(args);
+		return -EISDIR;
+	}
+
+	off = args->logical_offset;
+	len = args->length;
+	root = BTRFS_I(src)->root;
+
+	/*
+	 * Since we have to memcmp the data to make sure it does actually match
+	 * eachother we need to allocate 2 buffers to handle this.  So limit the
+	 * blocksize to 1 megabyte to make sure nobody abuses this.
+	 */
+	if (len > 1 * 1024 * 1024)
+		return -ENOMEM;
+
+	lock_extent_range(src, off, len);
+
+	ret = check_data(src, NULL, off, len, &orig_buffer);
+	if (ret) {
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1,
+			      GFP_NOFS);
+		goto out;
+	}
+
+	trans = btrfs_start_transaction(root, args->total_files + 1);
+	if (IS_ERR(trans)) {
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1,
+			      GFP_NOFS);
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	ret = split_extent(trans, src, off, off + len, &bytenr, &bytes,
+			   &extent_offset);
+	if (ret) {
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1,
+			      GFP_NOFS);
+		goto out_trans;
+	}
+
+	ret = btrfs_inc_extent_ref(trans, root, bytenr, bytes, 0,
+				   root->root_key.objectid, src->i_ino,
+				   extent_offset);
+	unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1, GFP_NOFS);
+	if (ret)
+		goto out_trans;
+
+	drop_ref = 1;
+	for (i = 0; i < args->total_files; i++) {
+		struct btrfs_ioctl_file_extent_info *info;
+		info = &args->info[i];
+
+		dst_file = fget(info->fd);
+		if (!dst_file) {
+			printk(KERN_ERR "btrfs: invalid fd %lld\n", info->fd);
+			ret = -EINVAL;
+			break;
+		}
+		dst_inode = dst_file->f_dentry->d_inode;
+		if (S_ISDIR(dst_inode->i_mode)) {
+			fput(dst_file);
+			printk(KERN_ERR "btrfs: file is dir %lld\n", info->fd);
+			ret = -EINVAL;
+			break;
+		}
+
+		if (BTRFS_I(dst_inode)->root != root) {
+			fput(dst_file);
+			printk(KERN_ERR "btrfs: cannot dedup across subvolumes"
+			      " %lld\n", info->fd);
+			ret = -EINVAL;
+			break;
+		}
+
+		off = info->logical_offset;
+		lock_extent_range(dst_inode, off, len);
+		if (check_data(dst_inode, orig_buffer, off, len, NULL)) {
+			printk(KERN_ERR "btrfs: data for fd %lld does not "
+			       "match\n", info->fd);
+			unlock_extent(&BTRFS_I(dst_inode)->io_tree, off,
+				      off + len - 1, GFP_NOFS);
+			fput(dst_file);
+			continue;
+		}
+
+		ret = link_extent(trans, dst_inode, bytenr, bytes,
+				  extent_offset, off, len);
+		if (ret) {
+			unlock_extent(&BTRFS_I(dst_inode)->io_tree, off,
+				      off + len - 1, GFP_NOFS);
+			fput(dst_file);
+			break;
+		}
+
+		unlock_extent(&BTRFS_I(dst_inode)->io_tree, off, off + len - 1,
+			      GFP_NOFS);
+
+		fput(dst_file);
+
+		if (drop_ref) {
+			ret = btrfs_free_extent(trans, root, bytenr, bytes, 0,
+						root->root_key.objectid,
+						src->i_ino, extent_offset);
+			if (ret)
+				break;
+			drop_ref = 0;
+		}
+	}
+
+	if (drop_ref) {
+		btrfs_free_extent(trans, root, bytenr, bytes, 0,
+				  root->root_key.objectid, src->i_ino,
+				  extent_offset);
+	}
+
+out_trans:
+	btrfs_end_transaction(trans, root);
+out:
+	kfree(orig_buffer);
+	kfree(args);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2287,6 +2888,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_start_sync(file, argp);
 	case BTRFS_IOC_WAIT_SYNC:
 		return btrfs_ioctl_wait_sync(file, argp);
+	case BTRFS_IOC_FILE_EXTENT_SAME:
+		return btrfs_ioctl_file_extent_same(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 17c99eb..6f91b59 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -145,6 +145,19 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_file_extent_info {
+	__s64 fd;
+	__u64 logical_offset;
+};
+
+struct btrfs_ioctl_same_args {
+	__u64 logical_offset;
+	__u64 length;
+	__u64 total_files;
+	__u64 unused[5];
+	struct btrfs_ioctl_file_extent_info info[0];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -189,4 +202,6 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_async_vol_args)
+#define BTRFS_IOC_FILE_EXTENT_SAME _IOW(BTRFS_IOCTL_MAGIC, 24, \
+					struct btrfs_ioctl_same_args)
 #endif
-- 
1.6.6.1

