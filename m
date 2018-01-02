Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbeABRYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 12:24:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 60B96ACC8
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Jan 2018 17:24:35 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: drop unused parameters from mount_subvol
Date: Tue,  2 Jan 2018 18:22:25 +0100
Message-Id: <20180102172225.22691-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Recent patches reworking the mount path left some unused parameters. We
pass a vfsmount to mount_subvol, the flags and data (ie. mount options)
have been already applied and we will not need them.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a35ac567384a..1434f288a397 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1395,8 +1395,7 @@ static inline int is_subvolume_inode(struct inode *inode)
 }
 
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
-				   int flags, const char *device_name,
-				   char *data, struct vfsmount *mnt)
+				   const char *device_name, struct vfsmount *mnt)
 {
 	struct dentry *root;
 	int ret;
@@ -1691,8 +1690,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	/* mount_subvol() will free subvol_name and mnt_root */
-	root = mount_subvol(subvol_name, subvol_objectid, flags, device_name,
-			data, mnt_root);
+	root = mount_subvol(subvol_name, subvol_objectid, device_name, mnt_root);
 
 out:
 	return root;
-- 
2.15.1

