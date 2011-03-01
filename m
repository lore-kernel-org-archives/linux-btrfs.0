From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of btrfs_alloc_path()
Date: Tue, 01 Mar 2011 15:48:31 +0900
Message-ID: <201103010648.AA00009@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Adding the check on the return value of btrfs_alloc_path() to several places.
And, some of callers are modified by this change.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/compression.c |   11 +++++++----
 fs/btrfs/dir-item.c    |   13 +++++++++----
 fs/btrfs/file-item.c   |    2 ++
 fs/btrfs/inode.c       |   23 +++++++++++++++++------
 4 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4d2110e..6a700e8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -657,8 +657,9 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			atomic_inc(&cb->pending_bios);
 
 			if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-				btrfs_lookup_bio_sums(root, inode, comp_bio,
-						      sums);
+				ret = btrfs_lookup_bio_sums(root, inode,
+							comp_bio, sums);
+				BUG_ON(ret);
 			}
 			sums += (comp_bio->bi_size + root->sectorsize - 1) /
 				root->sectorsize;
@@ -683,8 +684,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
 	BUG_ON(ret);
 
-	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-		btrfs_lookup_bio_sums(root, inode, comp_bio, sums);
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
+		ret = btrfs_lookup_bio_sums(root, inode, comp_bio, sums);
+		BUG_ON(ret);
+	}
 
 	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
 	BUG_ON(ret);
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index f0cad5a..8bba23a 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -142,6 +142,10 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	key.offset = btrfs_name_hash(name, name_len);
 
 	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	path->leave_spinning = 1;
 
 	data_size = sizeof(*dir_item) + name_len;
@@ -151,7 +155,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		ret = PTR_ERR(dir_item);
 		if (ret == -EEXIST)
 			goto second_insert;
-		goto out;
+		goto out_free;
 	}
 
 	leaf = path->nodes[0];
@@ -170,7 +174,7 @@ second_insert:
 	/* FIXME, use some real flag for selecting the extra index */
 	if (root == root->fs_info->tree_root) {
 		ret = 0;
-		goto out;
+		goto out_free;
 	}
 	btrfs_release_path(root, path);
 
@@ -180,7 +184,7 @@ second_insert:
 					name, name_len);
 	if (IS_ERR(dir_item)) {
 		ret2 = PTR_ERR(dir_item);
-		goto out;
+		goto out_free;
 	}
 	leaf = path->nodes[0];
 	btrfs_cpu_key_to_disk(&disk_key, location);
@@ -192,8 +196,9 @@ second_insert:
 	name_ptr = (unsigned long)(dir_item + 1);
 	write_extent_buffer(leaf, name, name_ptr, name_len);
 	btrfs_mark_buffer_dirty(leaf);
-out:
+out_free:
 	btrfs_free_path(path);
+out:
 	if (ret)
 		return ret;
 	if (ret2)
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4f19a3e..7715a56 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -169,6 +169,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	if (bio->bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 44b9266..ac058c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1460,8 +1460,11 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
 			return btrfs_submit_compressed_read(inode, bio,
 						    mirror_num, bio_flags);
-		} else if (!skip_sum)
-			btrfs_lookup_bio_sums(root, inode, bio, NULL);
+		} else if (!skip_sum) {
+			ret = btrfs_lookup_bio_sums(root, inode, bio, NULL);
+			if (ret)
+				return ret;
+		}
 		goto mapit;
 	} else if (!skip_sum) {
 		/* csum items have already been cloned */
@@ -1894,10 +1897,10 @@ static int btrfs_io_failed_hook(struct bio *failed_bio,
 	else
 		rw = READ;
 
-	BTRFS_I(inode)->io_tree.ops->submit_bio_hook(inode, rw, bio,
+	ret = BTRFS_I(inode)->io_tree.ops->submit_bio_hook(inode, rw, bio,
 						      failrec->last_mirror,
 						      failrec->bio_flags, 0);
-	return 0;
+	return ret;
 }
 
 /*
@@ -4234,6 +4237,10 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 		filp->f_pos = 2;
 	}
 	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	path->reada = 2;
 
 	btrfs_set_key_type(&key, key_type);
@@ -4337,6 +4344,7 @@ nopos:
 	ret = 0;
 err:
 	btrfs_free_path(path);
+out:
 	return ret;
 }
 
@@ -5925,9 +5933,12 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 				   __btrfs_submit_bio_start_direct_io,
 				   __btrfs_submit_bio_done);
 		goto err;
-	} else if (!skip_sum)
-		btrfs_lookup_bio_sums_dio(root, inode, bio,
+	} else if (!skip_sum) {
+		ret = btrfs_lookup_bio_sums_dio(root, inode, bio,
 					  file_offset, csums);
+		if (ret)
+			goto err;
+	}
 
 	ret = btrfs_map_bio(root, rw, bio, 0, 1);
 err:


