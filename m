Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751658AbdBMOa6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:30:58 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D6A0AD45
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:52 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/7] btrfs: remove unnecessary mutex lock in qgroup_account_snapshot
Date: Mon, 13 Feb 2017 15:30:23 +0100
Message-Id: <3cbce23df222f19adcd56ad73597495d0265d9fc.1486995885.git.dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The quota status used to be tracked as a variable, so the mutex was
needed (until "Btrfs: add a flags field to btrfs_fs_info" afcdd129e05a9).
Since the status is a bit modified atomically and we don't hold the
mutex beyond the check, we can drop it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 48aabb367f73..5eefd77bafc7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1364,12 +1364,8 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	 * enabled. If this check races with the ioctl, rescan will
 	 * kick in anyway.
 	 */
-	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-		mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		return 0;
-	}
-	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 
 	/*
 	 * We are going to commit transaction, see btrfs_commit_transaction()
-- 
2.10.1

