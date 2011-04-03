From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: [PATCH] Btrfs: fix memory leak in start_transaction()
Date: Sun,  3 Apr 2011 21:31:28 +0900
Message-ID: <1301833888-31238-1-git-send-email-yoshinori.sano@gmail.com>
Cc: chris.mason@oracle.com, Yoshinori Sano <yoshinori.sano@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Free btrfs_trans_handle when join_transaction() fails
in start_transaction()

Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
---
 fs/btrfs/transaction.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ce48eb5..d01cc24 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -197,6 +197,7 @@ again:
 
 	ret = join_transaction(root);
 	if (ret < 0) {
+		kmem_cache_free(btrfs_trans_handle_cachep, h);
 		if (type != TRANS_JOIN_NOLOCK)
 			mutex_unlock(&root->fs_info->trans_mutex);
 		return ERR_PTR(ret);
-- 
1.7.1

