Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32807 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbF3EPW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 00:15:22 -0400
Received: by pdjd13 with SMTP id d13so3556483pdj.0
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 21:15:22 -0700 (PDT)
From: "Davide C. C. Italiano" <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com, Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH 2/2] [btrfs] btrfs_rename(): don't ignore btrfs_end_transaction() return
Date: Tue, 30 Jun 2015 00:15:15 -0400
Message-Id: <1435637715-16332-1-git-send-email-dccitaliano@gmail.com>
In-Reply-To: <1435528041-20878-3-git-send-email-dccitaliano@gmail.com>
References: <1435528041-20878-3-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Davide Italiano <dccitaliano@gmail.com>

btrfs_end_transaction() can return an error -- this happens, e.g.
if it tries to commit and the transaction was aborted in the meanhwile.
Swallowing the error is wrong, so explicitly return it.

Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 59c475c..61b26be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9199,7 +9199,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		btrfs_end_log_trans(root);
 	}
 out_fail:
-	btrfs_end_transaction(trans, root);
+	if (!ret)
+		ret = btrfs_end_transaction(trans, root);
 out_notrans:
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&root->fs_info->subvol_sem);
-- 
2.4.3

