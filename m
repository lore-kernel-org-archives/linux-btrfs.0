Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36482 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdF1Vva (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 17:51:30 -0400
Received: by mail-io0-f182.google.com with SMTP id z62so43527244ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 14:51:30 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id j12sm1779243iod.12.2017.06.28.14.51.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jun 2017 14:51:28 -0700 (PDT)
Date: Wed, 28 Jun 2017 21:51:27 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Add qgroup_auto_cleanup mount flag to automatically
 cleanup qgroups
Message-ID: <20170628215125.GA23319@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces a new mount option - qgroup_auto_cleanup.
The purpose of this mount option is to cause btrfs to automatically
delete qgroups on subvolume deletion. This only cleans up the
associated level-0 qgroup, and not qgroups that are above it.

Since this behaviour is API-changing it is opt-in. Existing software,
and scripts may be doing qgroup cleanup on subvolume deletion explicitly,
and the absence of a qgroup may cause failure.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/ioctl.c | 15 +++++++++++++++
 fs/btrfs/super.c | 15 ++++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5bdd3666..b3d54e4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1336,6 +1336,7 @@ static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
 #define BTRFS_MOUNT_FRAGMENT_METADATA	(1 << 25)
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 #define BTRFS_MOUNT_NOLOGREPLAY		(1 << 27)
+#define BTRFS_MOUNT_QGROUP_AUTO_CLEANUP	(1 << 28)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
 #define BTRFS_DEFAULT_MAX_INLINE	(2048)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78c..e9901c4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2546,6 +2546,21 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 			goto out_end_trans;
 		}
 	}
+	/*
+	 * Attempt to automatically remove the automatically attached qgroup
+	 * setup in btrfs_qgroup_inherit. As a matter of convention, the id
+	 * is the same as the subvolume id.
+	 *
+	 * This can fail non-fatally for level 0 qgroups, therefore we do
+	 * not abort the transaction if this fails, nor return an error.
+	 */
+	if (btrfs_test_opt(fs_info, QGROUP_AUTO_CLEANUP)) {
+		ret = btrfs_remove_qgroup(trans, fs_info,
+					  dest->root_key.objectid, 0);
+		if (ret && ret != -ENOENT)
+			btrfs_warn(fs_info,
+				   "Failed to cleanup qgroup. err: %d", ret);
+	}
 
 out_end_trans:
 	trans->block_rsv = NULL;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74e4779..d83c841 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -321,7 +321,8 @@ enum {
 	Opt_commit_interval, Opt_barrier, Opt_nodefrag, Opt_nodiscard,
 	Opt_noenospc_debug, Opt_noflushoncommit, Opt_acl, Opt_datacow,
 	Opt_datasum, Opt_treelog, Opt_noinode_cache, Opt_usebackuproot,
-	Opt_nologreplay, Opt_norecovery,
+	Opt_nologreplay, Opt_norecovery, Opt_qgroup_auto_cleanup,
+	Opt_no_qgroup_auto_cleanup,
 #ifdef CONFIG_BTRFS_DEBUG
 	Opt_fragment_data, Opt_fragment_metadata, Opt_fragment_all,
 #endif
@@ -381,6 +382,8 @@ static const match_table_t tokens = {
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_commit_interval, "commit=%d"},
+	{Opt_qgroup_auto_cleanup, "qgroup_auto_cleanup"},
+	{Opt_no_qgroup_auto_cleanup, "no_qgroup_auto_cleanup"},
 #ifdef CONFIG_BTRFS_DEBUG
 	{Opt_fragment_data, "fragment=data"},
 	{Opt_fragment_metadata, "fragment=metadata"},
@@ -798,6 +801,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 			}
 			break;
+		case Opt_qgroup_auto_cleanup:
+			 btrfs_set_and_info(info, QGROUP_AUTO_CLEANUP,
+					    "enabling qgroup auto cleanup");
+			break;
+		case Opt_no_qgroup_auto_cleanup:
+			btrfs_clear_and_info(info, QGROUP_AUTO_CLEANUP,
+					     "disabling qgroup auto cleanup");
+			break;
 #ifdef CONFIG_BTRFS_DEBUG
 		case Opt_fragment_all:
 			btrfs_info(info, "fragmenting all space");
@@ -1287,6 +1298,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",fatal_errors=panic");
 	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
 		seq_printf(seq, ",commit=%d", info->commit_interval);
+	if (btrfs_test_opt(info, QGROUP_AUTO_CLEANUP))
+		seq_puts(seq, ",qgroup_auto_cleanup");
 #ifdef CONFIG_BTRFS_DEBUG
 	if (btrfs_test_opt(info, FRAGMENT_DATA))
 		seq_puts(seq, ",fragment=data");
-- 
2.9.3

