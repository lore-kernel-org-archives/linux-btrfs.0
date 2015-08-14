Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34023 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbbHNKd0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 02/23] Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
Date: Fri, 14 Aug 2015 18:32:47 +0800
Message-Id: <1439548388-29686-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/ctree.h   | 2 +-
 fs/btrfs/disk-io.c | 4 ++--
 fs/btrfs/sysfs.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index afce306..4484063 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4005,7 +4005,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 int btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info);
+void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 376a6ef..8571025 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3108,7 +3108,7 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 
 fail_sysfs:
-	btrfs_sysfs_remove_one(fs_info);
+	btrfs_sysfs_remove_mounted(fs_info);
 
 fail_fsdev_sysfs:
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
@@ -3791,7 +3791,7 @@ void close_ctree(struct btrfs_root *root)
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

