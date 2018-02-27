Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753225AbeB0OvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 09:51:18 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DA04FACED
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 14:51:16 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: move btrfs_listxattr prototype to xattr.h
Date: Tue, 27 Feb 2018 15:48:59 +0100
Message-Id: <0c8c0798219f450876a78b2bb20db3277bd21877.1519742886.git.dsterba@suse.com>
In-Reply-To: <cover.1519742886.git.dsterba@suse.com>
References: <cover.1519742886.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a proper header for xattr handlers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 3 ---
 fs/btrfs/xattr.h | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a462ab85c49..736ba2805d03 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3282,9 +3282,6 @@ void btrfs_exit_sysfs(void);
 int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info);
 void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 
-/* xattr.c */
-ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
-
 /* super.c */
 int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags);
diff --git a/fs/btrfs/xattr.h b/fs/btrfs/xattr.h
index 57c638730617..e215a3212a2a 100644
--- a/fs/btrfs/xattr.h
+++ b/fs/btrfs/xattr.h
@@ -28,6 +28,7 @@ int btrfs_getxattr(struct inode *inode, const char *name,
 int btrfs_setxattr(struct btrfs_trans_handle *trans,
 			    struct inode *inode, const char *name,
 			    const void *value, size_t size, int flags);
+ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
 				     struct inode *inode, struct inode *dir,
-- 
2.16.2

