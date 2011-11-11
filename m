From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Record end of metadata allocation
Date: Thu, 10 Nov 2011 23:34:10 -0200
Message-ID: <orehxfphm5.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

So I'm trying to figure out what it is that makes clustered allocation
so much faster than unclustered allocation.  E.g., for a nearly
quiescent filesystem with as little as 90MB of metadata, balance-md
(from another patch I posted today) takes some 4.5 seconds (worst case
6s, best case 4s) with clustered allocation, while with -o nocluster it
takes some 6.5s (best case 6s, worst case 7s).  With -o mincluster,
introduced by the patch below (by no means intended for merging, it's
far too hackish) it's some 0.1s faster than with -o nocluster, but
nothing really significant, and I didn't even take care of locking
last_ptr.  So I conclude it's not remembering the search starting point
that makes -o cluster faster.

Anyhow, since this is slightly faster than unclustered allocation, I
suppose we could introduce something along these lines for the -o
nocluster case, no?


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=0009-Add-o-mincluster-option.patch

>From c16a9e53e41e7616e4498534eea25ca1f396d7b4 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Thu, 10 Nov 2011 20:55:40 -0200
Subject: [PATCH 9/9] Add -o mincluster option.

If this option is enabled, save the location of the last successful
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
index 4da27be..caa73b2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5053,7 +5053,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
-	struct btrfs_free_cluster *last_ptr = NULL;
+	struct btrfs_free_cluster *last_ptr = NULL, *save_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
@@ -5095,8 +5095,16 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
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
@@ -5402,6 +5410,8 @@ checks:
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
+		if (save_ptr)
+			save_ptr->window_start = search_start + num_bytes;
 		btrfs_put_block_group(block_group);
 		break;
 loop:
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index afd1129..2706369 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2576,6 +2576,7 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 	cluster->max_size = 0;
 	INIT_LIST_HEAD(&cluster->block_group_list);
 	cluster->block_group = NULL;
+	cluster->window_start = 0;
 }
 
 int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2baba99..dd76fa4 100644
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
@@ -705,9 +711,12 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
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


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
