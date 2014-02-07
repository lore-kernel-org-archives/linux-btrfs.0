Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbaBGNeW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 08:34:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 682D8ABA6
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Feb 2014 13:34:22 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 4/4] Revert "btrfs: add ioctl to export size of global metadata reservation"
Date: Fri,  7 Feb 2014 14:34:19 +0100
Message-Id: <1c60bab48dfcd83840f289bb12b4480fb2fa6d1b.1391779611.git.dsterba@suse.cz>
In-Reply-To: <cover.1391779611.git.dsterba@suse.cz>
References: <cover.1391779611.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 01e219e8069516cdb98594d417b8bb8d906ed30d.

The information from the removed ioctl is newly provided by the existing
SPACE_INFO ioctl where it logically belongs and needs only minor changes
to the userspace code.

The GLOBAL_RSV ioctl hasn't been used anywhere yet, introduced only in
3.14-rc1 so there is no userspace ABI breakage.

CC: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c           | 16 ----------------
 include/uapi/linux/btrfs.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0d938f8f173e..dc64cc28af29 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3557,20 +3557,6 @@ out:
 	return ret;
 }
 
-static long btrfs_ioctl_global_rsv(struct btrfs_root *root, void __user *arg)
-{
-	struct btrfs_block_rsv *block_rsv = &root->fs_info->global_block_rsv;
-	u64 reserved;
-
-	spin_lock(&block_rsv->lock);
-	reserved = block_rsv->reserved;
-	spin_unlock(&block_rsv->lock);
-
-	if (arg && copy_to_user(arg, &reserved, sizeof(reserved)))
-		return -EFAULT;
-	return 0;
-}
-
 /*
  * there are many ways the trans_start and trans_end ioctls can lead
  * to deadlocks.  They should only be used by applications that
@@ -4777,8 +4763,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_logical_to_ino(root, argp);
 	case BTRFS_IOC_SPACE_INFO:
 		return btrfs_ioctl_space_info(root, argp);
-	case BTRFS_IOC_GLOBAL_RSV:
-		return btrfs_ioctl_global_rsv(root, argp);
 	case BTRFS_IOC_SYNC: {
 		int ret;
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 1b8a0f4c9590..b4d69092fbdb 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -558,7 +558,6 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
-#define BTRFS_IOC_GLOBAL_RSV _IOR(BTRFS_IOCTL_MAGIC, 20, __u64)
 #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
-- 
1.8.5.2

