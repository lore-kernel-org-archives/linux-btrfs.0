Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35141 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331AbbGHHmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 03:42:42 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 2/6] Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
Date: Wed,  8 Jul 2015 15:32:50 +0800
Message-Id: <1436340774-10909-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
References: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/disk-io.c | 4 ++--
 fs/btrfs/sysfs.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b6b2226..eed1127 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4008,7 +4008,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 int btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info);
+void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 552dcbe..4eaa554 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3067,7 +3067,7 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 
 fail_sysfs:
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 
 fail_fsdev_sysfs:
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
@@ -3748,7 +3748,7 @@ void close_ctree(struct btrfs_root *root)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
 
 	btrfs_free_fs_roots(fs_info);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index cabf840..095a302 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -545,7 +545,7 @@ void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 	}
 }
 
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
+void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 {
 	btrfs_reset_fs_info_ptr(fs_info);
 
@@ -776,7 +776,7 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 
 	return 0;
 failure:
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 	return error;
 }
 
-- 
2.4.1

