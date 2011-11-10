Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45771 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755232Ab1K1Tdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:51 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWlKa020850
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:59 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWjB7012458
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:46 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWjqk020504
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:45 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWi2t020494
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:44 -0200
Message-Id: <47ff8c1a3f6929ce5759eeb65e912887410568e6.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Thu, 10 Nov 2011 20:55:40 -0200
Subject: [PATCH 18/20] Btrfs: add -o mincluster option
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With -o mincluster, we save the location of the last successful
allocation, so as to emulate some of the cluster allocation logic
(though not non-bitmap preference) without actually going through the
exercise of allocating clusters.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c      |   16 +++++++++++++---
 fs/btrfs/free-space-cache.c |    1 +
 fs/btrfs/super.c            |   17 +++++++++++++----
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7ddbf9b..3c649fe 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5172,7 +5172,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
-	struct btrfs_free_cluster *last_ptr = NULL;
+	struct btrfs_free_cluster *last_ptr = NULL, *save_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	struct btrfs_block_group_cache *used_block_group;
 	int empty_cluster = 2 * 1024 * 1024;
@@ -5219,8 +5219,16 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		debug = 1;
 		debugid = atomic_inc_return(&debugcnt);
 		last_ptr = &root->fs_info->meta_alloc_cluster;
-		if (!btrfs_test_opt(root, SSD))
-			empty_cluster = 64 * 1024;
+		if (!btrfs_test_opt(root, SSD)) {
+			/* !SSD && SSD_SPREAD == -o mincluster.  */
+			if (btrfs_test_opt(root, SSD_SPREAD)) {
+				save_ptr = last_ptr;
+				hint_byte = save_ptr->window_start;
+				last_ptr = NULL;
+				use_cluster = false;
+			} else
+				empty_cluster = 64 * 1024;
+		}
 	}
 
 	if ((data & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
@@ -5556,6 +5564,8 @@ checks:
 			btrfs_add_free_space(used_block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
+		if (save_ptr)
+			save_ptr->window_start = search_start + num_bytes;
 		if (used_block_group != block_group)
 			btrfs_put_block_group(used_block_group);
 		btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3aa56e4..953f7dd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2579,6 +2579,7 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	cluster->max_size = 0;
 	INIT_LIST_HEAD(&cluster->block_group_list);
 	cluster->block_group = NULL;
+	cluster->window_start = 0;
 }
 
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 26b13d7..32fe064 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -165,7 +165,7 @@ enum {
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
 	Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
-	Opt_nocluster, Opt_cluster, Opt_err,
+	Opt_nocluster, Opt_cluster, Opt_mincluster, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -202,6 +202,7 @@ static match_table_t tokens = {
 	{Opt_recovery, "recovery"},
 	{Opt_nocluster, "nocluster"},
 	{Opt_cluster, "cluster"},
+	{Opt_mincluster, "mincluster"},
 	{Opt_err, NULL},
 };
 
@@ -407,6 +408,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: enabling alloc clustering\n");
 			btrfs_clear_opt(info->mount_opt, NO_ALLOC_CLUSTER);
 			break;
+		case Opt_mincluster:
+			printk(KERN_INFO "btrfs: enabling minimal alloc clustering\n");
+			btrfs_clear_opt(info->mount_opt, NO_ALLOC_CLUSTER);
+			btrfs_set_opt(info->mount_opt, SSD_SPREAD);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -706,9 +712,12 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	}
 	if (btrfs_test_opt(root, NOSSD))
 		seq_puts(seq, ",nossd");
-	if (btrfs_test_opt(root, SSD_SPREAD))
-		seq_puts(seq, ",ssd_spread");
-	else if (btrfs_test_opt(root, SSD))
+	if (btrfs_test_opt(root, SSD_SPREAD)) {
+		if (btrfs_test_opt(root, SSD))
+			seq_puts(seq, ",ssd_spread");
+		else
+			seq_puts(seq, ",mincluster");
+	} else if (btrfs_test_opt(root, SSD))
 		seq_puts(seq, ",ssd");
 	if (btrfs_test_opt(root, NOTREELOG))
 		seq_puts(seq, ",notreelog");
-- 
1.7.4.4

