From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Patches for BTRFS (mail-server slow down in 3.0 and more)
Date: Mon, 31 Oct 2011 02:19:18 -0200
Message-ID: <or7h3lztbt.fsf@livre.localdomain>
References: <4EAB270C.60406@malowa.de> <orehxw1kl7.fsf@livre.localdomain>
	<20111029051206.GB4054@shiny.Mikenopa.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Marcel Lohmann <marcel@malowa.de>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111029051206.GB4054@shiny.Mikenopa.local> (Chris Mason's
	message of "Sat, 29 Oct 2011 01:12:06 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Oct 29, 2011, Chris Mason <chris.mason@oracle.com> wrote:

> The last one isn't a bad idea, but please do make a real mount option
> for it ;)

Like this?


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0004-Disable-clustered-allocation-with-o-nocluster.patch

>From af086e7b88637be5c9806181a1d70db9c645cb50 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Sat, 29 Oct 2011 02:20:55 -0200
Subject: [PATCH 4/4] Disable clustered allocation with -o nocluster

Introduce -o nocluster to disable the use of clusters for extent
allocation.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/super.c       |   11 +++++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03912c5..b1138fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1363,6 +1363,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
+#define BTRFS_MOUNT_NO_ALLOC_CLUSTER	(1 << 18)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5be06a..5d7c9a7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4886,7 +4886,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
-	bool use_cluster = true;
+	bool use_cluster = !btrfs_test_opt(root, NO_ALLOC_CLUSTER);
 	u64 ideal_cache_percent = 0;
 	u64 ideal_cache_offset = 0;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..57c7bb1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -162,7 +162,7 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_err,
+	Opt_inode_cache, Opt_nocluster, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -195,6 +195,7 @@ static match_table_t tokens = {
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
 	{Opt_inode_cache, "inode_cache"},
+	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL},
 };
 
@@ -378,9 +379,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag");
+			printk(KERN_INFO "btrfs: enabling auto defrag\n");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
+		case Opt_nocluster:
+			printk(KERN_INFO "btrfs: disabling alloc clustering\n");
+			btrfs_set_opt(info->mount_opt, NO_ALLOC_CLUSTER);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -729,6 +734,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
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



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
