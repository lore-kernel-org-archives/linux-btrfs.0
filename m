Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33497 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbbF1Vrc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 17:47:32 -0400
Received: by padev16 with SMTP id ev16so94763804pad.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 14:47:31 -0700 (PDT)
From: "Davide C. C. Italiano" <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH 2/2] [btrfs] btrfs_rename(): don't ignore btrfs_end_transaction() return
Date: Sun, 28 Jun 2015 17:47:21 -0400
Message-Id: <1435528041-20878-3-git-send-email-dccitaliano@gmail.com>
In-Reply-To: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
References: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Davide Italiano <dccitaliano@gmail.com>

btrfs_end_transaction() can return an error -- this happens, e.g.
if it tries to commit and the transaction was aborted in the meanhwile.
Swallowing the error is wrong, so explicitly return it.

Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 59c475c..7764132 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9199,7 +9199,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		btrfs_end_log_trans(root);
 	}
 out_fail:
-	btrfs_end_transaction(trans, root);
+	ret = btrfs_end_transaction(trans, root);
 out_notrans:
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
-- 
2.4.3

