Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:60678 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3BLQ1z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 11:27:55 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so110580eaa.25
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 08:27:52 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH] Btrfs: eliminate a use-after-free in btrfs_balance()
Date: Tue, 12 Feb 2013 18:27:46 +0200
Message-Id: <1360686466-22638-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5af3e8cc introduced a use-after-free at volumes.c:3139: bctl is freed
above in __cancel_balance() in all cases except for balance pause.  Fix this
by moving the offending check a couple statements above, the meaning of the
check is preserved.

Reported-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/volumes.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15f6efd..5d25aed 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3126,6 +3126,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	mutex_lock(&fs_info->balance_mutex);
 	atomic_dec(&fs_info->balance_running);
 
+	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		fs_info->num_tolerated_disk_barrier_failures =
+			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
+	}
+
 	if (bargs) {
 		memset(bargs, 0, sizeof(*bargs));
 		update_ioctl_balance_args(fs_info, 0, bargs);
@@ -3136,11 +3141,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		__cancel_balance(fs_info);
 	}
 
-	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
-		fs_info->num_tolerated_disk_barrier_failures =
-			btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
-	}
-
 	wake_up(&fs_info->balance_wait_q);
 
 	return ret;
-- 
1.7.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
