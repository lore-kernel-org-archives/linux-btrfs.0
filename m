Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45939 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755402Ab1K1UCp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 15:02:45 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJxX3H024269
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 18:01:53 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWiUa012454
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:45 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWiLn020489
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:44 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWhQN020474
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:43 -0200
Message-Id: <14d4c83a6a19048a9cfb93e923399f1a7e2412f0.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sat, 29 Oct 2011 02:20:55 -0200
Subject: [PATCH 17/20] Btrfs: introduce -o cluster and -o nocluster
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce -o nocluster to disable the use of clusters for extent
allocation, and -o cluster to reverse it.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/ctree.h       |    3 ++-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/super.c       |   16 ++++++++++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 04a5dfc..1deaf2d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -971,7 +971,7 @@ struct btrfs_fs_info {
 	 * is required instead of the faster short fsync log commits
 	 */
 	u64 last_trans_log_full_commit;
-	unsigned long mount_opt:20;
+	unsigned long mount_opt:28;
 	unsigned long compress_type:4;
 	u64 max_inline;
 	u64 alloc_start;
@@ -1413,6 +1413,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
 #define BTRFS_MOUNT_RECOVERY		(1 << 18)
+#define BTRFS_MOUNT_NO_ALLOC_CLUSTER	(1 << 19)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7064979..7ddbf9b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5186,7 +5186,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
-	bool use_cluster = true;
+	bool use_cluster = !btrfs_test_opt(root, NO_ALLOC_CLUSTER);
 	bool have_caching_bg = false;
 	u64 ideal_cache_percent = 0;
 	u64 ideal_cache_offset = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8bd9d6d..26b13d7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -164,7 +164,8 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_no_space_cache, Opt_recovery, Opt_err,
+	Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
+	Opt_nocluster, Opt_cluster, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -199,6 +200,8 @@ static match_table_t tokens = {
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
+	{Opt_nocluster, "nocluster"},
+	{Opt_cluster, "cluster"},
 	{Opt_err, NULL},
 };
 
@@ -390,12 +393,19 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag");
+			printk(KERN_INFO "btrfs: enabling auto defrag\n");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
 		case Opt_recovery:
 			printk(KERN_INFO "btrfs: enabling auto recovery");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
+		case Opt_nocluster:
+			printk(KERN_INFO "btrfs: disabling alloc clustering\n");
+			btrfs_set_opt(info->mount_opt, NO_ALLOC_CLUSTER);
+			break;
+		case Opt_cluster:
+			printk(KERN_INFO "btrfs: enabling alloc clustering\n");
+			btrfs_clear_opt(info->mount_opt, NO_ALLOC_CLUSTER);
 			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
@@ -722,6 +732,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",autodefrag");
 	if (btrfs_test_opt(root, INODE_MAP_CACHE))
 		seq_puts(seq, ",inode_cache");
+	if (btrfs_test_opt(root, NO_ALLOC_CLUSTER))
+		seq_puts(seq, ",nocluster");
 	return 0;
 }
 
-- 
1.7.4.4

