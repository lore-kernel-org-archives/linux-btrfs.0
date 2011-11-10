From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: revised -o nocluster, and -o cluster to reverse on remount
Date: Thu, 10 Nov 2011 17:28:16 -0200
Message-ID: <or7h37rd4f.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

Here's a revised version of the -o nocluster patch, updated for cmason's
for-linus branch, and a separate -o cluster option that enables
one to enable and disable this option on remount.

One thing I'm not sure is whether -o remount,nocluster will release a
cluster that may have been allocated before the remount.  Please keep
that in mind before merging the patch.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0004-Disable-clustered-allocation-with-o-nocluster.patch

>From a3323c03f1b3d2cfeb4905268d117426232d4a3b Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sat, 29 Oct 2011 02:20:55 -0200
Subject: [PATCH 4/8] Disable clustered allocation with -o nocluster

Introduce -o nocluster to disable the use of clusters for extent
allocation.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/super.c       |   11 +++++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b9ba59f..324df91 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1410,6 +1410,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
 #define BTRFS_MOUNT_RECOVERY		(1 << 18)
+#define BTRFS_MOUNT_NO_ALLOC_CLUSTER	(1 << 19)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 18ea90c..767edac 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5051,7 +5051,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
-	bool use_cluster = true;
+	bool use_cluster = !btrfs_test_opt(root, NO_ALLOC_CLUSTER);
 	bool have_caching_bg = false;
 	u64 ideal_cache_percent = 0;
 	u64 ideal_cache_offset = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index dcd5aef..988e697 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -164,7 +164,8 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_no_space_cache, Opt_recovery, Opt_err,
+	Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
+	Opt_nocluster, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -199,6 +200,7 @@ static match_table_t tokens = {
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "no_space_cache"},
 	{Opt_recovery, "recovery"},
+	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL},
 };
 
@@ -390,12 +392,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
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
 			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
@@ -721,6 +726,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",autodefrag");
 	if (btrfs_test_opt(root, INODE_MAP_CACHE))
 		seq_puts(seq, ",inode_cache");
+	if (btrfs_test_opt(root, NO_ALLOC_CLUSTER))
+		seq_puts(seq, ",nocluster");
 	return 0;
 }
 
-- 
1.7.4.4


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0005-Add-o-cluster-so-that-nocluster-can-be-disabled-with.patch

>From 572ec833d94278e7eda7c274962165c70d9154e5 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sun, 6 Nov 2011 23:51:08 -0200
Subject: [PATCH 5/8] Add -o cluster, so that nocluster can be disabled with
 remount.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 988e697..2baba99 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -165,7 +165,7 @@ enum {
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
 	Opt_inode_cache, Opt_no_space_cache, Opt_recovery,
-	Opt_nocluster, Opt_err,
+	Opt_nocluster, Opt_cluster, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -201,6 +201,7 @@ static match_table_t tokens = {
 	{Opt_no_space_cache, "no_space_cache"},
 	{Opt_recovery, "recovery"},
 	{Opt_nocluster, "nocluster"},
+	{Opt_cluster, "cluster"},
 	{Opt_err, NULL},
 };
 
@@ -402,6 +403,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: disabling alloc clustering\n");
 			btrfs_set_opt(info->mount_opt, NO_ALLOC_CLUSTER);
 			break;
+		case Opt_cluster:
+			printk(KERN_INFO "btrfs: enabling alloc clustering\n");
+			btrfs_clear_opt(info->mount_opt, NO_ALLOC_CLUSTER);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
-- 
1.7.4.4


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
