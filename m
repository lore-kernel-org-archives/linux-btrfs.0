Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:52447 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab3ENJhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 05:37:03 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp3) (RZmta 31.27 OK)
	with ESMTP id p03042p4DL65JG for <linux-btrfs@vger.kernel.org>;
	Tue, 14 May 2013 11:37:01 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 8/8] Btrfs: add mount option to force UUID tree checking
Date: Tue, 14 May 2013 11:37:00 +0200
Message-Id: <a87dfbc934e6f330358fb89ebb28012d96e9b017.1368523154.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368523154.git.sbehrens@giantdisaster.de>
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368523154.git.sbehrens@giantdisaster.de>
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This should never be needed, but since all functions are there
to check and rebuild the UUID tree, a mount option is added that
allows to force this check and rebuild procedure.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h   | 1 +
 fs/btrfs/disk-io.c | 3 ++-
 fs/btrfs/super.c   | 8 +++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bdfa18e..fd1d2fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1966,6 +1966,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_RESCAN_UUID_TREE	(1 << 23)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 30513c1..2e94b1a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2831,7 +2831,8 @@ retry_root_backup:
 			close_ctree(tree_root);
 			return ret;
 		}
-	} else if (check_uuid_tree) {
+	} else if (check_uuid_tree ||
+		   btrfs_test_opt(tree_root, RESCAN_UUID_TREE)) {
 		pr_info("btrfs: checking UUID tree\n");
 		ret = btrfs_check_uuid_tree(fs_info);
 		if (ret) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b6af7d3..4602c6a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -317,7 +317,7 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_rescan_uuid_tree,
 	Opt_err,
 };
 
@@ -357,6 +357,7 @@ static match_table_t tokens = {
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
+	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_err, NULL},
 };
@@ -551,6 +552,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_space_cache:
 			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
 			break;
+		case Opt_rescan_uuid_tree:
+			btrfs_set_opt(info->mount_opt, RESCAN_UUID_TREE);
+			break;
 		case Opt_no_space_cache:
 			printk(KERN_INFO "btrfs: disabling disk space caching\n");
 			btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
@@ -925,6 +929,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",space_cache");
 	else
 		seq_puts(seq, ",nospace_cache");
+	if (btrfs_test_opt(root, RESCAN_UUID_TREE))
+		seq_puts(seq, ",rescan_uuid_tree");
 	if (btrfs_test_opt(root, CLEAR_CACHE))
 		seq_puts(seq, ",clear_cache");
 	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
-- 
1.8.2.2

