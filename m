Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:34951 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3ILJh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 05:37:57 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so9126050wes.14
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 02:37:56 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: don't leak transaction in btrfs_sync_file()
Date: Thu, 12 Sep 2013 10:37:24 +0100
Message-Id: <1378978644-21280-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1378928204-12641-1-git-send-email-fdmanana@gmail.com>
References: <1378928204-12641-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_sync_file(), if the call to btrfs_log_dentry_safe() returns
a negative error (for e.g. -ENOMEM via btrfs_log_inode()), we would
return without ending/freeing the transaction.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: If btrfs_log_dentry_safe() returns error, don't fall through because
    that will override the final return value, and can make us return
    success (0) instead of an error.

 fs/btrfs/file.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5ba87b0..8c305f5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1860,6 +1860,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	ret = btrfs_log_dentry_safe(trans, root, dentry);
 	if (ret < 0) {
 		mutex_unlock(&inode->i_mutex);
+		btrfs_end_transaction(trans, root);
 		goto out;
 	}
 
-- 
1.7.9.5

