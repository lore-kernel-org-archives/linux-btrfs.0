Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754010AbeDSQgS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9EABAC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:36:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 16/16] btrfs: open code set_balance_control
Date: Thu, 19 Apr 2018 18:33:46 +0200
Message-Id: <c84931a5b66dec08d99914321a8277432e55a0e0.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper is quite simple and I'd like to see the locking in the
caller.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 445380c4ac72..6bab436a94d5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3178,21 +3178,6 @@ static void update_balance_args(struct btrfs_balance_control *bctl)
 	}
 }
 
-/*
- * Should be called with balance mutex held to protect against checking the
- * balance status or progress. Same goes for reset_balance_state.
- */
-static void set_balance_control(struct btrfs_balance_control *bctl)
-{
-	struct btrfs_fs_info *fs_info = bctl->fs_info;
-
-	BUG_ON(fs_info->balance_ctl);
-
-	spin_lock(&fs_info->balance_lock);
-	fs_info->balance_ctl = bctl;
-	spin_unlock(&fs_info->balance_lock);
-}
-
 /*
  * Clear the balance status in fs_info and delete the balance item from disk.
  */
@@ -3878,7 +3863,10 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 
 	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
 		BUG_ON(ret == -EEXIST);
-		set_balance_control(bctl);
+		BUG_ON(fs_info->balance_ctl);
+		spin_lock(&fs_info->balance_lock);
+		fs_info->balance_ctl = bctl;
+		spin_unlock(&fs_info->balance_lock);
 	} else {
 		BUG_ON(ret != -EEXIST);
 		spin_lock(&fs_info->balance_lock);
@@ -4015,7 +4003,10 @@ int btrfs_recover_balance(struct btrfs_fs_info *fs_info)
 	"cannot set exclusive op status to balance, resume manually");
 
 	mutex_lock(&fs_info->balance_mutex);
-	set_balance_control(bctl);
+	BUG_ON(fs_info->balance_ctl);
+	spin_lock(&fs_info->balance_lock);
+	fs_info->balance_ctl = bctl;
+	spin_unlock(&fs_info->balance_lock);
 	mutex_unlock(&fs_info->balance_mutex);
 out:
 	btrfs_free_path(path);
-- 
2.16.2

