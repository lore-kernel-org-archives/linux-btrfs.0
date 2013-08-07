Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50787 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab3HGL3w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 07:29:52 -0400
Received: by mail-wg0-f44.google.com with SMTP id l18so1377387wgh.11
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 04:29:51 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH RFC] Btrfs: track compression algorithm on inodes
Date: Wed,  7 Aug 2013 12:29:44 +0100
Message-Id: <1375874984-31139-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the compression settings (algorithm and force mode) need
to be specified at mount time in order to have newly created files
compressed. If we mount a filesystem with the compress=lzo option
for example, create a directory, add the +c attribute to that directory,
unmount the file system, mount the filesystem again but without any
compression option and create a new file inside that directory, the
new file will not be compressed with the lzo algorithm, but instead
with the zlib method, as the later is the default compress method in
btrfs (explicitly set in open_ctree). Same is true when updating an
existing file that was previously compressed with lzo, after we mount
the filesystem without the lzo compression option specified - the
updated parts of the file will be compressed with zlib instead of lzo.

This change allows to track the compression algorithm (and compress-force
mount option) in the inodes. When the +c attribute is added to a directory
or a file, the corresponding inode will remember the compression method
specified at mount time (and force condition). Finally when a file (or
directory) is created inside a directory with the +c attribute, it will
inherit these settings from the parent directory inode.

Removing the compression attribute of a file (chattr -c) will remove these
compression settings.

** Before this change:

$ mkfs.btrfs -f /dev/sdb3
$ mount -o compress=lzo /dev/sdb3 /mnt/btrfs
$ mkdir /mnt/btrfs/mydir
$ chattr +c /mnt/btrfs/mydir
$ umount /mnt/btrfs
$ mount /dev/sdb3 /mnt/btrfs
$ dd if=/dev/zero of=/mnt/btrfs/mydir/foo bs=10M count=1
$ umount /mnt/btrfs
$ btrfs-debug-tree
(...)
        item 10 key (258 EXTENT_DATA 0) itemoff 3286 itemsize 53
                extent data disk byte 1103101952 nr 4096
                extent data offset 0 nr 131072 ram 131072
                extent compression 1
        item 11 key (258 EXTENT_DATA 131072) itemoff 3233 itemsize 53
                extent data disk byte 1103106048 nr 4096
                extent data offset 0 nr 131072 ram 131072
                extent compression 1
(...)

(a compression code of 1 means zlib)

** After this change:

$ mkfs.btrfs -f /dev/sdb3
$ mount -o compress=lzo /dev/sdb3 /mnt/btrfs
$ mkdir /mnt/btrfs/mydir
$ chattr +c /mnt/btrfs/mydir
$ umount /mnt/btrfs
$ mount /dev/sdb3 /mnt/btrfs
$ dd if=/dev/zero of=/mnt/btrfs/mydir/foo bs=10M count=1
$ umount /mnt/btrfs
$ btrfs-debug-tree
(...)
        item 10 key (258 EXTENT_DATA 0) itemoff 3286 itemsize 53
                extent data disk byte 1103101952 nr 4096
                extent data offset 0 nr 131072 ram 131072
                extent compression 2
        item 11 key (258 EXTENT_DATA 131072) itemoff 3233 itemsize 53
                extent data disk byte 1103106048 nr 4096
                extent data offset 0 nr 131072 ram 131072
                extent compression 2
(...)

(a compression code of 2 means lzo)

This is an RFC patch that is an alternative to the persistent mount
options RFC patch at:

https://patchwork.kernel.org/patch/2839534/

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/btrfs_inode.h   |   10 +++++++++-
 fs/btrfs/ctree.h         |   12 +++++++++++-
 fs/btrfs/delayed-inode.c |    3 +++
 fs/btrfs/inode.c         |   20 ++++++++++++++++++--
 fs/btrfs/ioctl.c         |   30 +++++++++++++++++++++++-------
 5 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d0ae226..4793b34 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -163,9 +163,17 @@ struct btrfs_inode {
 	unsigned reserved_extents;
 
 	/*
-	 * always compress this one file
+	 * Always compress this file, using the algorithm specified in the
+	 * compress field below.
 	 */
 	unsigned force_compress;
+	/*
+	 * Specific compression algorithm for this inode. It overrides the
+	 * one specified in fs_info->compress_type. If set to none, then
+	 * the one in fs_info->compress_type is used (if our flags allow
+	 * for compression).
+	 */
+	unsigned compress;
 
 	struct btrfs_delayed_node *delayed_node;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cbb1263..862922b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -707,11 +707,14 @@ struct btrfs_inode_item {
 	/* modification sequence number for NFS */
 	__le64 sequence;
 
+	/* use as boolean */
+	u8 force_compression;
+	u8 compression;
 	/*
 	 * a little future expansion, for more than this we can
 	 * just grow the inode item and version it
 	 */
-	__le64 reserved[4];
+	u8 reserved[30];
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
 	struct btrfs_timespec mtime;
@@ -2240,6 +2243,9 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_FUNCS(inode_compression, struct btrfs_inode_item, compression, 8);
+BTRFS_SETGET_FUNCS(inode_force_compression, struct btrfs_inode_item,
+		   force_compression, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
@@ -2257,6 +2263,10 @@ BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_compression, struct btrfs_inode_item,
+			 compression, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_force_compression, struct btrfs_inode_item,
+			 force_compression, 8);
 
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fa88297..709f30d 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1734,6 +1734,9 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_transid(inode_item, trans->transid);
 	btrfs_set_stack_inode_rdev(inode_item, inode->i_rdev);
 	btrfs_set_stack_inode_flags(inode_item, BTRFS_I(inode)->flags);
+	btrfs_set_stack_inode_compression(inode_item, BTRFS_I(inode)->compress);
+	btrfs_set_stack_inode_force_compression(inode_item,
+						BTRFS_I(inode)->force_compress);
 	btrfs_set_stack_inode_block_group(inode_item, 0);
 
 	btrfs_set_stack_timespec_sec(btrfs_inode_atime(inode_item),
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 88fe045..ce20d68 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -361,6 +361,9 @@ static noinline int compress_file_range(struct inode *inode,
 	int compress_type = root->fs_info->compress_type;
 	int redirty = 0;
 
+	if (BTRFS_I(inode)->compress != BTRFS_COMPRESS_NONE)
+		compress_type = BTRFS_I(inode)->compress;
+
 	/* if this is a small write inside eof, kick off a defrag */
 	if ((end - start + 1) < 16 * 1024 &&
 	    (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
@@ -420,7 +423,7 @@ again:
 		}
 
 		if (BTRFS_I(inode)->force_compress)
-			compress_type = BTRFS_I(inode)->force_compress;
+			compress_type = BTRFS_I(inode)->compress;
 
 		/*
 		 * we need to call clear_page_dirty_for_io on each
@@ -3389,6 +3392,9 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	BTRFS_I(inode)->last_trans = btrfs_inode_transid(leaf, inode_item);
+	BTRFS_I(inode)->force_compress =
+		btrfs_inode_force_compression(leaf, inode_item);
+	BTRFS_I(inode)->compress = btrfs_inode_compression(leaf, inode_item);
 
 	/*
 	 * If we were modified in the current generation and evicted from memory
@@ -3496,6 +3502,11 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_rdev(leaf, item, inode->i_rdev, &token);
 	btrfs_set_token_inode_flags(leaf, item, BTRFS_I(inode)->flags, &token);
 	btrfs_set_token_inode_block_group(leaf, item, 0, &token);
+	btrfs_set_token_inode_compression(leaf, item, BTRFS_I(inode)->compress,
+					  &token);
+	btrfs_set_token_inode_force_compression(leaf, item,
+						BTRFS_I(inode)->force_compress,
+						&token);
 }
 
 /*
@@ -5466,6 +5477,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
 
 	btrfs_inherit_iflags(inode, dir);
+	if (dir) {
+		BTRFS_I(inode)->force_compress = BTRFS_I(dir)->force_compress;
+		BTRFS_I(inode)->compress = BTRFS_I(dir)->compress;
+	}
 
 	if (S_ISREG(mode)) {
 		if (btrfs_test_opt(root, NODATASUM))
@@ -7788,7 +7803,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->reserved_extents = 0;
 
 	ei->runtime_flags = 0;
-	ei->force_compress = BTRFS_COMPRESS_NONE;
+	ei->force_compress = 0;
+	ei->compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9a864f1..30de2ba 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -277,9 +277,13 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (flags & FS_NOCOMP_FL) {
 		ip->flags &= ~BTRFS_INODE_COMPRESS;
 		ip->flags |= BTRFS_INODE_NOCOMPRESS;
+		ip->compress = BTRFS_COMPRESS_NONE;
+		ip->force_compress = 0;
 	} else if (flags & FS_COMPR_FL) {
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
+		ip->compress = ip->root->fs_info->compress_type;
+		ip->force_compress = btrfs_test_opt(root, FORCE_COMPRESS) != 0;
 	} else {
 		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
@@ -1155,6 +1159,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	int ret;
 	int defrag_count = 0;
 	int compress_type = BTRFS_COMPRESS_ZLIB;
+	unsigned orig_force_compress = 0;
+	unsigned orig_compress = BTRFS_COMPRESS_NONE;
 	int extent_thresh = range->extent_thresh;
 	int max_cluster = (256 * 1024) >> PAGE_CACHE_SHIFT;
 	int cluster = max_cluster;
@@ -1172,6 +1178,17 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			return -EINVAL;
 		if (range->compress_type)
 			compress_type = range->compress_type;
+	} else if (BTRFS_I(inode)->compress != BTRFS_COMPRESS_NONE) {
+		compress_type = BTRFS_I(inode)->compress;
+	}
+
+	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
+		mutex_lock(&inode->i_mutex);
+		orig_force_compress = BTRFS_I(inode)->force_compress;
+		orig_compress = BTRFS_I(inode)->compress;
+		BTRFS_I(inode)->force_compress = 1;
+		BTRFS_I(inode)->compress = compress_type;
+		mutex_unlock(&inode->i_mutex);
 	}
 
 	if (extent_thresh == 0)
@@ -1268,9 +1285,6 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			cluster = max_cluster;
 		}
 
-		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
-			BTRFS_I(inode)->force_compress = compress_type;
-
 		if (i + cluster > ra_index) {
 			ra_index = max(i, ra_index);
 			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
@@ -1335,10 +1349,6 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
 		}
 		atomic_dec(&root->fs_info->async_submit_draining);
-
-		mutex_lock(&inode->i_mutex);
-		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
-		mutex_unlock(&inode->i_mutex);
 	}
 
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
@@ -1348,6 +1358,12 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	ret = defrag_count;
 
 out_ra:
+	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
+		mutex_lock(&inode->i_mutex);
+		BTRFS_I(inode)->force_compress = orig_force_compress;
+		BTRFS_I(inode)->compress = orig_compress;
+		mutex_unlock(&inode->i_mutex);
+	}
 	if (!file)
 		kfree(ra);
 	kfree(pages);
-- 
1.7.9.5

