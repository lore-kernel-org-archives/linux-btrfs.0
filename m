Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:34285 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3BFQK1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 11:10:27 -0500
Received: by mail-ye0-f174.google.com with SMTP id m3so384865yen.5
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 08:10:25 -0800 (PST)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [RFC] Btrfs: Allow the compressed extent size limit to be modified.
Date: Wed,  6 Feb 2013 10:10:17 -0600
Message-Id: <1360167017-19632-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Provide for modification of the limit of compressed extent size
utilizing mount-time configuration settings.

The size of compressed extents was limited to 128K, which
leads to fragmentation of the extents (although the extents
themselves may still be located contiguously).  This limit is
put in place to ease the RAM required when spreading compression
across several CPUs, and to make sure the amount of IO required
to do a random read is reasonably small.

This patch is still preliminary.

In this version of the patch, the allowed compressed extent size is
restricted to 128 (the default) and 512. I wanted to extensively test
a single value for a change in compressed extent size before expanding
and testing a wider range of parameters.

I submitted a similar patch about a year and a half ago where the
change was hard-coded and not tuneable.

http://comments.gmane.org/gmane.comp.file-systems.btrfs/10516

---
 fs/btrfs/ctree.h      |  3 +++
 fs/btrfs/disk-io.c    |  1 +
 fs/btrfs/inode.c      |  8 ++++----
 fs/btrfs/relocation.c |  7 ++++---
 fs/btrfs/super.c      | 19 ++++++++++++++++++-
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..f37ec32 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1477,6 +1477,8 @@ struct btrfs_fs_info {
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
 
+	unsigned compressed_extent_size;
+
 	void *bdev_holder;
 
 	/* private scrub information */
@@ -1829,6 +1831,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_COMPR_EXTENT_SIZE (1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 830bc17..2d2be03 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2056,6 +2056,7 @@ int open_ctree(struct super_block *sb,
 	fs_info->trans_no_join = 0;
 	fs_info->free_chunk_space = 0;
 	fs_info->tree_mod_log = RB_ROOT;
+	fs_info->compressed_extent_size = 128;
 
 	/* readahead state */
 	INIT_RADIX_TREE(&fs_info->reada_tree, GFP_NOFS & ~__GFP_WAIT);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 148abeb..5b81b56 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -346,8 +346,8 @@ static noinline int compress_file_range(struct inode *inode,
 	unsigned long nr_pages_ret = 0;
 	unsigned long total_compressed = 0;
 	unsigned long total_in = 0;
-	unsigned long max_compressed = 128 * 1024;
-	unsigned long max_uncompressed = 128 * 1024;
+	unsigned long max_compressed = root->fs_info->compressed_extent_size * 1024;
+	unsigned long max_uncompressed = root->fs_info->compressed_extent_size * 1024;
 	int i;
 	int will_compress;
 	int compress_type = root->fs_info->compress_type;
@@ -361,7 +361,7 @@ static noinline int compress_file_range(struct inode *inode,
 again:
 	will_compress = 0;
 	nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
-	nr_pages = min(nr_pages, (128 * 1024UL) / PAGE_CACHE_SIZE);
+	nr_pages = min(nr_pages, (max_compressed * 1024UL) / PAGE_CACHE_SIZE);
 
 	/*
 	 * we don't want to send crud past the end of i_size through
@@ -386,7 +386,7 @@ again:
 	 *
 	 * We also want to make sure the amount of IO required to do
 	 * a random read is reasonably small, so we limit the size of
-	 * a compressed extent to 128k.
+	 * a compressed extent (default of 128k).
 	 */
 	total_compressed = min(total_compressed, max_uncompressed);
 	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 300e09a..8d6f6bf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -144,7 +144,7 @@ struct tree_block {
 	unsigned int key_ready:1;
 };
 
-#define MAX_EXTENTS 128
+#define MAX_EXTENTS 512
 
 struct file_extent_cluster {
 	u64 start;
@@ -3055,6 +3055,7 @@ int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
 			 struct file_extent_cluster *cluster)
 {
 	int ret;
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 
 	if (cluster->nr > 0 && extent_key->objectid != cluster->end + 1) {
 		ret = relocate_file_extent_cluster(inode, cluster);
@@ -3066,12 +3067,12 @@ int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
 	if (!cluster->nr)
 		cluster->start = extent_key->objectid;
 	else
-		BUG_ON(cluster->nr >= MAX_EXTENTS);
+		BUG_ON(cluster->nr >= fs_info->compressed_extent_size);
 	cluster->end = extent_key->objectid + extent_key->offset - 1;
 	cluster->boundary[cluster->nr] = extent_key->objectid;
 	cluster->nr++;
 
-	if (cluster->nr >= MAX_EXTENTS) {
+	if (cluster->nr >= fs_info->compressed_extent_size) {
 		ret = relocate_file_extent_cluster(inode, cluster);
 		if (ret)
 			return ret;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8982e9..6e9dc69 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -322,7 +322,7 @@ enum {
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
 	Opt_check_integrity_print_mask, Opt_fatal_errors,
-	Opt_err,
+	Opt_compr_extent_size, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -361,6 +361,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
+	{Opt_compr_extent_size, "compressed_extent_size=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_err, NULL},
 };
@@ -612,6 +613,19 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			ret = -EINVAL;
 			goto out;
 #endif
+		case Opt_compr_extent_size:
+			intarg = 0;
+			match_int(&args[0], &intarg);
+			if ((intarg == 128) || (intarg == 512)) {
+				info->compressed_extent_size = intarg;
+				printk(KERN_INFO "btrfs: compressed extent size %d\n",
+				       info->compressed_extent_size);
+			} else {
+				printk(KERN_INFO "btrfs: "
+					"Invalid compressed extent size,"
+					" using default.\n");
+			}
+			break;
 		case Opt_fatal_errors:
 			if (strcmp(args[0].from, "panic") == 0)
 				btrfs_set_opt(info->mount_opt,
@@ -951,6 +965,9 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",skip_balance");
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
+	if (btrfs_test_opt(root, COMPR_EXTENT_SIZE))
+		seq_printf(seq, ",compressed_extent_size=%d",
+			   (unsigned long long)info->compressed_extent_size);
 	return 0;
 }
 
-- 
1.7.12.4

