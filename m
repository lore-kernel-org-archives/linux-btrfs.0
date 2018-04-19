Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754010AbeDSQgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 94997AC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:36:10 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 13/16] btrfs: move and comment read-only check in btrfs_cancel_balance
Date: Thu, 19 Apr 2018 18:33:39 +0200
Message-Id: <d1db2691059cb458d2b44cae473b1cf2ea73ed78.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance cannot be started on a read-only filesystem and will have to
finish/exit before eg. going to read-only via remount.

In case the filesystem is forcibly set to read-only after an error,
balance will finish anyway and if the cancel call is too fast it will
just wait for that to happen.

The last case is when the balance is paused after mount but it's
read-only and cancelling would want to delete the item. The test is
moved after the check if balance is running at all, as it looks more
logical to report "no balance running" instead of "read-only
filesystem".

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a766d2f988c1..9e48a4654d3a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4053,15 +4053,20 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
 
 int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 {
-	if (sb_rdonly(fs_info->sb))
-		return -EROFS;
-
 	mutex_lock(&fs_info->balance_mutex);
 	if (!fs_info->balance_ctl) {
 		mutex_unlock(&fs_info->balance_mutex);
 		return -ENOTCONN;
 	}
 
+	/*
+	 * A paused balance with the item stored on disk can be resumed at
+	 * mount time if the mount is read-write. Otherwise it's still paused
+	 * and we must not allow cancelling as it deletes the item.
+	 */
+	if (sb_rdonly(fs_info->sb))
+		return -EROFS;
+
 	atomic_inc(&fs_info->balance_cancel_req);
 	/*
 	 * if we are running just wait and return, balance item is
-- 
2.16.2

