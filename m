Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37841 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbbHNKdZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 01/23] Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
Date: Fri, 14 Aug 2015 18:32:46 +0800
Message-Id: <1439548388-29686-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/sysfs.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 938efe3..afce306 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4004,7 +4004,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 /* sysfs.c */
 int btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
-int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info);
+int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info);
 
 /* xattr.c */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cc15514b..376a6ef 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2928,7 +2928,7 @@ retry_root_backup:
 		goto fail_fsdev_sysfs;
 	}
 
-	ret = btrfs_sysfs_add_one(fs_info);
+	ret = btrfs_sysfs_add_mounted(fs_info);
 	if (ret) {
 		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
 		goto fail_fsdev_sysfs;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 603b0cc..cabf840 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -736,7 +736,7 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 	return error;
 }
 
-int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
+int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 {
 	int error;
 	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
-- 
2.4.1

