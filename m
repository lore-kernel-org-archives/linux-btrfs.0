Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36056 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbF1Vr3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 17:47:29 -0400
Received: by pdcu2 with SMTP id u2so104772457pdc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2015 14:47:29 -0700 (PDT)
From: "Davide C. C. Italiano" <dccitaliano@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH 1/2] [btrfs] btrfs_rename: abort transaction in case of error.
Date: Sun, 28 Jun 2015 17:47:20 -0400
Message-Id: <1435528041-20878-2-git-send-email-dccitaliano@gmail.com>
In-Reply-To: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
References: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Davide Italiano <dccitaliano@gmail.com>

btrfs_insert_inode_ref() may fail and we want to make sure
the transaction is aborted before calling btrfs_end_transaction(),
as it already happens everywhere else in this function in case
of error.

Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
---
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8bb0136..59c475c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9114,8 +9114,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					     new_dentry->d_name.len,
 					     old_ino,
 					     btrfs_ino(new_dir), index);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
 			goto out_fail;
+		}
+
 		/*
 		 * this is an ugly little race, but the rename is required
 		 * to make sure that if we crash, the inode is either at the
-- 
2.4.3

