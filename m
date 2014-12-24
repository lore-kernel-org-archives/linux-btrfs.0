Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51457 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaLXGru (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 01:47:50 -0500
Received: by mail-pd0-f180.google.com with SMTP id w10so9386291pde.11
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 22:47:49 -0800 (PST)
Received: from localhost.localdomain.localdomain ([36.62.181.87])
        by mx.google.com with ESMTPSA id w8sm21741816pbt.71.2014.12.23.22.47.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Dec 2014 22:47:49 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: call inode_dec_link_count() on mkdir error path
Date: Wed, 24 Dec 2014 14:45:30 +0800
Message-Id: <1419403530-15617-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangshilong1991@gmail.com>

In btrfs_mkdir(), if it fails to create dir, we should
clean up existed items, setting inode's link properly
to make sure it could be cleaned up properly.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8de2335..8a036ed 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6255,8 +6255,10 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 out_fail:
 	btrfs_end_transaction(trans, root);
-	if (drop_on_err)
+	if (drop_on_err) {
+		inode_dec_link_count(inode);
 		iput(inode);
+	}
 	btrfs_balance_delayed_items(root);
 	btrfs_btree_balance_dirty(root);
 	return err;
-- 
1.8.3.1

