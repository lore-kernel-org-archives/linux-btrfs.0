Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:30075 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2FSKaY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 06:30:24 -0400
Date: Tue, 19 Jun 2012 13:30:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs: small naming cleanup in join_transaction()
Message-ID: <20120619103011.GA7596@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"root->fs_info" and "fs_info" are the same, but "fs_info" is prefered
because it is shorter and that's what is used in the rest of the
function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Also, Smatch doesn't understand that they are the same so it complains
about the locking.

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b72b068..e5f1b15 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -100,8 +100,8 @@ loop:
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
 		cur_trans = fs_info->running_transaction;
 		goto loop;
-	} else if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
-		spin_unlock(&root->fs_info->trans_lock);
+	} else if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		spin_unlock(&fs_info->trans_lock);
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
 		return -EROFS;
 	}
