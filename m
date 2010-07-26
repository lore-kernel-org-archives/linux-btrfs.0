From: Ulrich Hecht <uli@suse.de>
Subject: [PATCH] Btrfs: compressed file size ioctl
Date: Mon, 26 Jul 2010 17:30:53 +0200
Message-ID: <1280158253-10515-1-git-send-email-uli@suse.de>
Cc: uli@suse.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Returns a file's size on disk. Had been posted by Chris Ball over a year ago
(http://article.gmane.org/gmane.comp.file-systems.btrfs/2873).  Chris Mason
suggested a couple of improvements back then, which I have implemented in
this version:

- use u64 to return the result
- replaced the loop
	while (1) {
		struct btrfs_ordered_extent *ordered;
		lock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
		ordered = btrfs_lookup_first_ordered_extent(inode, len);
		if (BTRFS_I(inode)->delalloc_bytes == 0 && !ordered)
			break;
		unlock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
		if (ordered)
			btrfs_put_ordered_extent(ordered);
		btrfs_wait_ordered_range(inode, 0, len);
	}
  with
	btrfs_wait_ordered_range(inode, 0, (u64)-1);
- return the uncompressed size on disk for uncompressed filesystems instead
  of EINVAL

Minimal example:

 #include <sys/ioctl.h>
 #include <fcntl.h>
 #include <stdint.h>
 #include <stdio.h>
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_IOC_COMPR_SIZE   _IOR(BTRFS_IOCTL_MAGIC, 21, uint64_t)
int main(int argc, char **argv)
{
  uint64_t size = -1;
  int d = open(argv[1], O_RDONLY);
  ioctl(d, BTRFS_IOC_COMPR_SIZE, &size);
  printf("%zd\n", size);
  return 0;
}

Signed-off-by: Ulrich Hecht <uli@suse.de>
---
 fs/btrfs/ioctl.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    1 +
 2 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..d18401b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1750,6 +1750,107 @@ out_drop_write:
 	return ret;
 }
 
+static long btrfs_ioctl_compsize(struct file *file, void __user *argp)
+{
+	/* This ioctl returns the compressed size of an inode on disk
+	 * by counting the on-disk space used by all of its extents.
+	 */
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u32 nritems;
+	int slot;
+	u64 olen = inode->i_size;
+	u64 len = olen;
+	long ret;
+	u64 compressed_size = 0;
+
+	if (S_ISDIR(inode->i_mode))
+		return -EISDIR;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	path->reada = 2;
+	mutex_lock(&inode->i_mutex);
+
+	/* do any pending delalloc/csum calc on inode, one way or
+	   another, and lock file content */
+	btrfs_wait_ordered_range(inode, 0, (u64)-1);
+
+	/* search for the inode */
+	key.objectid = inode->i_ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	while (1) {
+		/* note the key will change type as we walk through the tree */
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+
+		nritems = btrfs_header_nritems(path->nodes[0]);
+		if (path->slots[0] >= nritems) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0)
+				goto out;
+			if (ret > 0)
+				break;
+			nritems = btrfs_header_nritems(path->nodes[0]);
+		}
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (btrfs_key_type(&key) > BTRFS_EXTENT_DATA_KEY ||
+		    key.objectid != inode->i_ino)
+			break;
+
+		if (btrfs_key_type(&key) == BTRFS_EXTENT_DATA_KEY) {
+			struct btrfs_file_extent_item *extent;
+			int type;
+			u64 datal = 0;
+
+			extent = btrfs_item_ptr(leaf, slot,
+						struct btrfs_file_extent_item);
+			type = btrfs_file_extent_type(leaf, extent);
+			if (type == BTRFS_FILE_EXTENT_REG) {
+				datal = btrfs_file_extent_num_bytes(leaf,
+								    extent);
+				compressed_size +=
+				  btrfs_file_extent_disk_num_bytes(leaf,
+								   extent);
+			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
+				datal = btrfs_file_extent_ram_bytes(leaf,
+								    extent);
+				compressed_size +=
+				  btrfs_file_extent_inline_item_len(leaf,
+					      btrfs_item_nr(leaf, slot));
+			}
+			btrfs_release_path(root, path);
+		}
+
+		btrfs_release_path(root, path);
+		key.offset++;
+	}
+
+	/* We've succeeded in going through all extents; set the final size. */
+	if (copy_to_user(argp, &compressed_size, sizeof(compressed_size)))
+		ret = -EFAULT;
+	else
+		ret = 0;
+
+out:
+	btrfs_release_path(root, path);
+	unlock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
+	mutex_unlock(&inode->i_mutex);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static long btrfs_ioctl_clone_range(struct file *file, void __user *argp)
 {
 	struct btrfs_ioctl_clone_range_args args;
@@ -2034,6 +2135,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
+	case BTRFS_IOC_COMPR_SIZE:
+		return btrfs_ioctl_compsize(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..a01ef1e 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -178,4 +178,5 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 21, u64)
 #endif
-- 
1.7.1

