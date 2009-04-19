From: Chris Ball <cjb@laptop.org>
Subject: [REVIEW] Btrfs: Introduce ioctl for compressed size of file
Date: Sat, 18 Apr 2009 23:56:11 -0400
Message-ID: <m37i1h47qc.fsf_-_@pullcord.laptop.org>
References: <e6ac15e50904052332h2ca9b0e3ube8ceb89ca25d0f1@mail.gmail.com>
	<1239074313.17426.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mp3geek <mp3geek@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1239074313.17426.1.camel@think.oraclecorp.com> (Chris Mason's
	message of "Mon, 06 Apr 2009 23:18:33 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > We need to add an ioctl that reports on the actual size of the
   > compressed file.

Here's an attempt at that ioctl, please review.  The search code is
based on the clone ioctl.  Some specific questions:

* Is the first while() loop necessary?
* Are the semantics of returning -EINVAL when called on an FS with
  compression disabled desirable?

Example usage:

# ls -la english.txt
-rw-r--r-- 1 root root 316601 2009-04-18 22:53 english.txt

# python -c 'import fcntl; file = open("english.txt"); \
  print fcntl.ioctl(file, 0x940f);'
151552

# gzip -1 english.txt; ls -la english.txt.gz
-rw-r--r-- 1 root root 152737 2009-04-18 22:53 english.txt.gz

Thanks,

- Chris.

---
 fs/btrfs/ioctl.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |    1 +
 2 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bca729f..ae50c3b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1013,6 +1013,117 @@ out_drop_write:
 	return ret;
 }
 
+static unsigned long btrfs_ioctl_compsize(struct file *file)
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
+	unsigned long ret;
+	unsigned long compressed_size = 0;
+
+	if (!btrfs_test_opt(root, COMPRESS))
+		return -EINVAL;
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
+	while (1) {
+		struct btrfs_ordered_extent *ordered;
+		lock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
+		ordered = btrfs_lookup_first_ordered_extent(inode, len);
+		if (BTRFS_I(inode)->delalloc_bytes == 0 && !ordered)
+			break;
+		unlock_extent(&BTRFS_I(inode)->io_tree, 0, len, GFP_NOFS);
+		if (ordered)
+			btrfs_put_ordered_extent(ordered);
+		btrfs_wait_ordered_range(inode, 0, len);
+	}
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
+	ret = compressed_size;
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
@@ -1122,6 +1233,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_COMPR_SIZE:
+		return btrfs_ioctl_compsize(file);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index b320b10..bd2f866 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -66,4 +66,5 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
 
+#define BTRFS_IOC_COMPR_SIZE	_IO(BTRFS_IOCTL_MAGIC, 15)
 #endif
-- 
Chris Ball   <cjb@laptop.org>
