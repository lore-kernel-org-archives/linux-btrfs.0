Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:65150 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaE2SeD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 14:34:03 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so863943wev.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 11:34:01 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix transaction leak during fsync call
Date: Thu, 29 May 2014 20:33:44 +0100
Message-Id: <1401392024-5906-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_log_dentry_safe() returns an error, we set ret to 1 and
fall through with the goal of committing the transaction. However,
in the case where the inode doesn't need a full sync, we would call
btrfs_wait_ordered_range() against the target range for our inode,
and if it returned an error, we would return without commiting or
ending the transaction, leaving the transaction open forever.

Since when btrfs_wait_ordered_range() doesn't return an error we
commit the transaction, it doesn't make sense to make a call to
btrfs_wait_ordered_range() because committing the transaction will
wait for all ordered extents to complete anyway.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/file.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8accf94..e0be468 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2022,12 +2022,6 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 				goto out;
 			}
 		}
-		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start,
-						       end - start + 1);
-			if (ret)
-				goto out;
-		}
 		ret = btrfs_commit_transaction(trans, root);
 	} else {
 		ret = btrfs_end_transaction(trans, root);
-- 
1.9.1

