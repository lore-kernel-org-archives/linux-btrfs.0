Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759726AbcAUScS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 13:32:18 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DD7D6AC20
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 18:32:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: synchronize incompat feature bits with sysfs files
Date: Thu, 21 Jan 2016 19:32:11 +0100
Message-Id: <14e46e04958df740c6c6a94849f176159a333f13.1453400624.git.dsterba@suse.com>
In-Reply-To: <cover.1453400624.git.dsterba@suse.com>
References: <cover.1453400624.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The files under /sys/fs/UUID/features get out of sync with the actual
incompat bits set for the filesystem if they change after mount (eg. the
LZO compression).

Synchronize the feature bits with the sysfs files representing them
right after we set/clear them.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-tree.c | 7 +++++++
 fs/btrfs/ioctl.c           | 4 ++++
 fs/btrfs/super.c           | 4 ++++
 fs/btrfs/volumes.c         | 2 ++
 4 files changed, 17 insertions(+)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 393e36bd5845..94e887f5ec4e 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -23,6 +23,7 @@
 #include "locking.h"
 #include "free-space-tree.h"
 #include "transaction.h"
+#include "sysfs.h"
 
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 					struct btrfs_fs_info *fs_info,
@@ -1169,6 +1170,9 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	}
 
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
+	btrfs_sysfs_feature_update(fs_info,
+		BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE, FEAT_COMPAT_RO);
+
 	fs_info->creating_free_space_tree = 0;
 
 	ret = btrfs_commit_transaction(trans, tree_root);
@@ -1237,6 +1241,9 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(trans);
 
 	btrfs_clear_fs_compat_ro(fs_info, FREE_SPACE_TREE);
+	btrfs_sysfs_feature_update(fs_info,
+		BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE, FEAT_COMPAT_RO);
+
 	fs_info->free_space_root = NULL;
 
 	ret = clear_free_space_tree(trans, free_space_root);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e392dd67f0ba..209dcfa9ab33 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1455,6 +1455,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
 		btrfs_set_fs_incompat(root->fs_info, COMPRESS_LZO);
+		btrfs_sysfs_feature_update(root->fs_info,
+			BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO, FEAT_INCOMPAT);
 	}
 
 	ret = defrag_count;
@@ -4063,6 +4065,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	btrfs_free_path(path);
 
 	btrfs_set_fs_incompat(root->fs_info, DEFAULT_SUBVOL);
+	btrfs_sysfs_feature_update(root->fs_info,
+		BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL, FEAT_INCOMPAT);
 	btrfs_end_transaction(trans, root);
 out:
 	mnt_drop_write_file(file);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 86f7fdc05633..5a1bab11984d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -58,6 +58,7 @@
 #include "dev-replace.h"
 #include "free-space-cache.h"
 #include "backref.h"
+#include "sysfs.h"
 #include "tests/btrfs-tests.h"
 
 #include "qgroup.h"
@@ -477,6 +478,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
+				btrfs_sysfs_feature_update(root->fs_info,
+					BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO,
+					FEAT_INCOMPAT);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c32abbca9d77..73bcd1322c1d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4468,6 +4468,8 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 		return;
 
 	btrfs_set_fs_incompat(info, RAID56);
+	btrfs_sysfs_feature_update(info, BTRFS_FEATURE_INCOMPAT_RAID56,
+		FEAT_INCOMPAT);
 }
 
 #define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r)		\
-- 
2.6.3

