Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753162AbeDCShG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:37:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4B7E2ABC9
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:37:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 16/16] btrfs: open code set_balance_control
Date: Tue,  3 Apr 2018 20:34:38 +0200
Message-Id: <fda7ab82f7fb52c213c72220ac965a66786eed1d.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper is quite simple and I'd like to see the locking in the
caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e93c7ba44d06..db9f72c6af85 100644
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
-- 
2.16.2

