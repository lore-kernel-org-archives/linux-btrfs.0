Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:39614 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3JaFDO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 01:03:14 -0400
Received: by mail-ie0-f178.google.com with SMTP id x13so4026705ief.23
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 22:03:13 -0700 (PDT)
Received: from dshgna ([124.43.179.229])
        by mx.google.com with ESMTPSA id p5sm1692463igj.10.2013.10.30.22.03.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 30 Oct 2013 22:03:12 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:33:04 +0530
From: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: Fix checkpatch.pl warning of spacing issues
Message-ID: <6bd09f3101fa9a6b5c4e30221a37528a861b4cfc.1383193392.git.dulshani.gunawardhana89@gmail.com>
References: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix spacing issues detected via checkpatch.pl in accordance with the
kernel style guidelines.

Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
---
 fs/btrfs/async-thread.c     |  2 +-
 fs/btrfs/compression.c      |  2 +-
 fs/btrfs/ctree.c            |  2 +-
 fs/btrfs/extent-tree.c      |  6 +++---
 fs/btrfs/extent_io.c        |  2 +-
 fs/btrfs/file.c             |  2 +-
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/inode.c            |  6 +++---
 fs/btrfs/ioctl.c            | 14 +++++++-------
 9 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 08cc08f..8aec751 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -262,7 +262,7 @@ static struct btrfs_work *get_next_work(struct btrfs_worker_thread *worker,
 	struct btrfs_work *work = NULL;
 	struct list_head *cur = NULL;
 
-	if(!list_empty(prio_head))
+	if (!list_empty(prio_head))
 		cur = prio_head->next;
 
 	smp_mb();
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 6aad98c..91338d2 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -360,7 +360,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
 	bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
-	if(!bio) {
+	if (!bio) {
 		kfree(cb);
 		return -ENOMEM;
 	}
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0039dde..7f3277e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4014,7 +4014,7 @@ again:
 				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
 					if (data_size && !tried_avoid_double)
 						goto push_for_double;
-					split = 2 ;
+					split = 2;
 				}
 			}
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c135f1c..a892f06 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4985,7 +4985,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 
 	if (to_reserve)
-		trace_btrfs_space_reservation(root->fs_info,"delalloc",
+		trace_btrfs_space_reservation(root->fs_info, "delalloc",
 					      btrfs_ino(inode), to_reserve, 1);
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
@@ -7981,7 +7981,7 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
 
 	spin_lock(&sinfo->lock);
 
-	for(i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		if (!list_empty(&sinfo->block_groups[i]))
 			free_bytes += __btrfs_get_ro_block_group_free_space(
 						&sinfo->block_groups[i]);
@@ -8269,7 +8269,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 
 	release_global_block_rsv(info);
 
-	while(!list_empty(&info->space_info)) {
+	while (!list_empty(&info->space_info)) {
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a4592f4..377efc7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4035,7 +4035,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 	if (offset >= last)
 		return NULL;
 
-	while(1) {
+	while (1) {
 		len = last - offset;
 		if (len == 0)
 			break;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 72da4df..6a49379 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -370,7 +370,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 	u64 root_objectid = 0;
 
 	atomic_inc(&fs_info->defrag_running);
-	while(1) {
+	while (1) {
 		/* Pause the auto defragger. */
 		if (test_bit(BTRFS_FS_STATE_REMOUNTING,
 			     &fs_info->fs_state))
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b4f9904..3d582ba 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2276,7 +2276,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 		goto out;
 
 	entry = rb_entry(node, struct btrfs_free_space, offset_index);
-	while(1) {
+	while (1) {
 		if (entry->bytes < bytes && entry->bytes > *max_extent_size)
 			*max_extent_size = entry->bytes;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c3fa038..a63de09 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6246,7 +6246,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *pag
 	/* adjust the range_start to make sure it doesn't
 	 * go backwards from the start they passed in
 	 */
-	range_start = max(start,range_start);
+	range_start = max(start, range_start);
 	found = found_end - range_start;
 
 	if (found > 0) {
@@ -7050,7 +7050,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			}
 		} else {
 			submit_len += bvec->bv_len;
-			nr_pages ++;
+			nr_pages++;
 			bvec++;
 		}
 	}
@@ -8333,7 +8333,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	int err;
 	int drop_inode = 0;
 	u64 objectid;
-	u64 index = 0 ;
+	u64 index = 0;
 	int name_len;
 	int datasize;
 	unsigned long ptr;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8ef76e6..cc5eff7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -687,7 +687,7 @@ static inline int btrfs_check_sticky(struct inode *dir, struct inode *inode)
  *     nfs_async_unlink().
  */
 
-static int btrfs_may_delete(struct inode *dir,struct dentry *victim,int isdir)
+static int btrfs_may_delete(struct inode *dir, struct dentry *victim, int isdir)
 {
 	int error;
 
@@ -862,7 +862,7 @@ static int find_new_extents(struct btrfs_root *root,
 
 	path->keep_locks = 1;
 
-	while(1) {
+	while (1) {
 		ret = btrfs_search_forward(root, &min_key, &max_key,
 					   path, newer_than);
 		if (ret != 0)
@@ -1930,7 +1930,7 @@ static noinline int search_ioctl(struct inode *inode,
 
 	path->keep_locks = 1;
 
-	while(1) {
+	while (1) {
 		ret = btrfs_search_forward(root, &key, &max_key, path,
 					   sk->min_transid);
 		if (ret != 0) {
@@ -2017,7 +2017,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	key.type = BTRFS_INODE_REF_KEY;
 	key.offset = (u64)-1;
 
-	while(1) {
+	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
@@ -2046,7 +2046,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		}
 
 		*(ptr + len) = '/';
-		read_extent_buffer(l, ptr,(unsigned long)(iref + 1), len);
+		read_extent_buffer(l, ptr, (unsigned long)(iref + 1), len);
 
 		if (key.offset == BTRFS_FIRST_FREE_OBJECTID)
 			break;
@@ -2057,7 +2057,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		dirid = key.objectid;
 	}
 	memmove(name, ptr, total_len);
-	name[total_len]='\0';
+	name[total_len] = '\0';
 	ret = 0;
 out:
 	btrfs_free_path(path);
@@ -2143,7 +2143,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	inode = dentry->d_inode;
 	dest = BTRFS_I(inode)->root;
-	if (!capable(CAP_SYS_ADMIN)){
+	if (!capable(CAP_SYS_ADMIN)) {
 		/*
 		 * Regular user.  Only allow this with a special mount
 		 * option, when the user has write+exec access to the
-- 
1.8.1.2

