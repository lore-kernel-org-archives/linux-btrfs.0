Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752020AbeEGPqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 11:46:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F0CEAEE6
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 15:46:43 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove redundant btrfs_balance_control::fs_info
Date: Mon,  7 May 2018 17:44:03 +0200
Message-Id: <20180507154403.1628-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fs_info is always available from the context so we don't need to
store it in the structure.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c   | 3 +--
 fs/btrfs/volumes.c | 7 +++----
 fs/btrfs/volumes.h | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f0e62e4f8fe7..d1f7b7f91700 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4428,7 +4428,6 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 		goto out_bargs;
 	}
 
-	bctl->fs_info = fs_info;
 	if (arg) {
 		memcpy(&bctl->data, &bargs->data, sizeof(bctl->data));
 		memcpy(&bctl->meta, &bargs->meta, sizeof(bctl->meta));
@@ -4454,7 +4453,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	 */
 	need_unlock = false;
 
-	ret = btrfs_balance(bctl, bargs);
+	ret = btrfs_balance(fs_info, bctl, bargs);
 	bctl = NULL;
 
 	if (arg) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1ea6c7b7f732..738b32df38e1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3769,10 +3769,10 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
 /*
  * Should be called with balance mutexe held
  */
-int btrfs_balance(struct btrfs_balance_control *bctl,
+int btrfs_balance(struct btrfs_fs_info *fs_info,
+		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs)
 {
-	struct btrfs_fs_info *fs_info = bctl->fs_info;
 	u64 meta_target, data_target;
 	u64 allowed;
 	int mixed = 0;
@@ -3940,7 +3940,7 @@ static int balance_kthread(void *data)
 	mutex_lock(&fs_info->balance_mutex);
 	if (fs_info->balance_ctl) {
 		btrfs_info(fs_info, "continuing balance");
-		ret = btrfs_balance(fs_info->balance_ctl, NULL);
+		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
 	}
 	mutex_unlock(&fs_info->balance_mutex);
 
@@ -4002,7 +4002,6 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_balance_item);
 
-	bctl->fs_info = fs_info;
 	bctl->flags = btrfs_balance_flags(leaf, item);
 	bctl->flags |= BTRFS_BALANCE_RESUME;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3a6dbbce650a..a957c1f09dc2 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -352,8 +352,6 @@ struct map_lookup {
 struct btrfs_balance_args;
 struct btrfs_balance_progress;
 struct btrfs_balance_control {
-	struct btrfs_fs_info *fs_info;
-
 	struct btrfs_balance_args data;
 	struct btrfs_balance_args meta;
 	struct btrfs_balance_args sys;
@@ -433,7 +431,8 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
-int btrfs_balance(struct btrfs_balance_control *bctl,
+int btrfs_balance(struct btrfs_fs_info *fs_info,
+		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
-- 
2.16.2

