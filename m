Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753948AbeDSQgC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8DB4FAC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:36:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 09/16] btrfs: cleanup helpers that reset balance state
Date: Thu, 19 Apr 2018 18:33:30 +0200
Message-Id: <7d7e38bf1b3031fda1b4493d4849ca8ec94d8bc6.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function __cancel_balance name is confusing with the cancel
operation of balance and it really resets the state of balance back to
zero. The unset_balance_control helper is called only from one place and
simple enough to be inlined.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c   |  8 ++++----
 fs/btrfs/volumes.c | 29 +++++++++++++----------------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 582bde5b7eda..6724029443fa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4653,10 +4653,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 
 do_balance:
 	/*
-	 * Ownership of bctl and filesystem flag BTRFS_FS_EXCL_OP
-	 * goes to to btrfs_balance.  bctl is freed in __cancel_balance,
-	 * or, if restriper was paused all the way until unmount, in
-	 * free_fs_info.  The flag should be cleared after __cancel_balance.
+	 * Ownership of bctl and filesystem flag BTRFS_FS_EXCL_OP goes to
+	 * btrfs_balance.  bctl is freed in reset_balance_state, or, if
+	 * restriper was paused all the way until unmount, in free_fs_info.
+	 * The flag should be cleared after reset_balance_state.
 	 */
 	need_unlock = false;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 83fbe9d624f5..3b8085b5655d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3192,7 +3192,7 @@ static void update_balance_args(struct btrfs_balance_control *bctl)
 /*
  * Should be called with both balance and volume mutexes held to
  * serialize other volume operations (add_dev/rm_dev/resize) with
- * restriper.  Same goes for unset_balance_control.
+ * restriper.  Same goes for reset_balance_state.
  */
 static void set_balance_control(struct btrfs_balance_control *bctl)
 {
@@ -3205,9 +3205,13 @@ static void set_balance_control(struct btrfs_balance_control *bctl)
 	spin_unlock(&fs_info->balance_lock);
 }
 
-static void unset_balance_control(struct btrfs_fs_info *fs_info)
+/*
+ * Clear the balance status in fs_info and delete the balance item from disk.
+ */
+static void reset_balance_state(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
+	int ret;
 
 	BUG_ON(!fs_info->balance_ctl);
 
@@ -3216,6 +3220,9 @@ static void unset_balance_control(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->balance_lock);
 
 	kfree(bctl);
+	ret = del_balance_item(fs_info);
+	if (ret)
+		btrfs_handle_fs_error(fs_info, ret, NULL);
 }
 
 /*
@@ -3752,16 +3759,6 @@ static inline int balance_need_close(struct btrfs_fs_info *fs_info)
 		 atomic_read(&fs_info->balance_cancel_req) == 0);
 }
 
-static void __cancel_balance(struct btrfs_fs_info *fs_info)
-{
-	int ret;
-
-	unset_balance_control(fs_info);
-	ret = del_balance_item(fs_info);
-	if (ret)
-		btrfs_handle_fs_error(fs_info, ret, NULL);
-}
-
 /* Non-zero return value signifies invalidity */
 static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
 		u64 allowed)
@@ -3916,7 +3913,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 
 	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
 	    balance_need_close(fs_info)) {
-		__cancel_balance(fs_info);
+		reset_balance_state(fs_info);
 		clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	}
 
@@ -3925,7 +3922,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	return ret;
 out:
 	if (bctl->flags & BTRFS_BALANCE_RESUME)
-		__cancel_balance(fs_info);
+		reset_balance_state(fs_info);
 	else
 		kfree(bctl);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
@@ -4095,13 +4092,13 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 			   atomic_read(&fs_info->balance_running) == 0);
 		mutex_lock(&fs_info->balance_mutex);
 	} else {
-		/* __cancel_balance needs volume_mutex */
+		/* reset_balance_state needs volume_mutex */
 		mutex_unlock(&fs_info->balance_mutex);
 		mutex_lock(&fs_info->volume_mutex);
 		mutex_lock(&fs_info->balance_mutex);
 
 		if (fs_info->balance_ctl) {
-			__cancel_balance(fs_info);
+			reset_balance_state(fs_info);
 			clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 		}
 
-- 
2.16.2

