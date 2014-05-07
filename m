Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbaEGQRL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 12:17:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 23238AC7D
	for <linux-btrfs@vger.kernel.org>; Wed,  7 May 2014 16:17:09 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: retrieve more info from FS_INFO ioctl
Date: Wed,  7 May 2014 18:17:06 +0200
Message-Id: <1399479426-17716-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Provide the basic information about filesystem through the ioctl:
* b-tree node size (same as leaf size)
* sector size
* expected alignment of CLONE_RANGE and EXTENT_SAME ioctl arguments

Backward compatibility: if the values are 0, kernel does not provide
this information, the applications should ignore them.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c           |    4 ++++
 include/uapi/linux/btrfs.h |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2ad7de94efef..74530f226e50 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2574,6 +2574,10 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
+	fi_args->nodesize = root->fs_info->super_copy->nodesize;
+	fi_args->sectorsize = root->fs_info->super_copy->sectorsize;
+	fi_args->clone_alignment = root->fs_info->super_copy->sectorsize;
+
 	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
 		ret = -EFAULT;
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b4d69092fbdb..aad9391e0a6d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -181,7 +181,11 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 max_id;				/* out */
 	__u64 num_devices;			/* out */
 	__u8 fsid[BTRFS_FSID_SIZE];		/* out */
-	__u64 reserved[124];			/* pad to 1k */
+	__u32 nodesize;				/* out */
+	__u32 sectorsize;			/* out */
+	__u32 clone_alignment;			/* out */
+	__u32 reserved32;
+	__u64 reserved[122];			/* pad to 1k */
 };
 
 struct btrfs_ioctl_feature_flags {
-- 
1.7.9

