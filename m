Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41924 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3IKThI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 15:37:08 -0400
Received: by mail-wi0-f180.google.com with SMTP id hj3so2611938wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 12:37:07 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: don't leak transaction in btrfs_sync_file()
Date: Wed, 11 Sep 2013 20:36:44 +0100
Message-Id: <1378928204-12641-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_sync_file(), if the call to btrfs_log_dentry_safe() returns
a negative error (for e.g. -ENOMEM via btrfs_log_inode()), we would
return without ending/freeing the transaction.
---
 fs/btrfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5ba87b0..d12107e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1859,8 +1859,8 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	ret = btrfs_log_dentry_safe(trans, root, dentry);
 	if (ret < 0) {
-		mutex_unlock(&inode->i_mutex);
-		goto out;
+		/* Fallthrough and commit/free transaction. */
+		ret = 1;
 	}
 
 	/* we've logged all the items and now have a consistent
-- 
1.7.9.5

