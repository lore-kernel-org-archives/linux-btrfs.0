From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/5] Btrfs: fix bug with heavy snapshot and heavy fsync
Date: Mon, 21 Nov 2011 18:10:21 +0800
Message-ID: <1321870224-20241-3-git-send-email-liubo2009@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We've forgotten to update root's last_snapshot gen to the latest sub transid,
so that we will free some extent buffers unexpectedly.  And this will cause
a inconsistent tree crash.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e3d2970..e31cdef 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -927,7 +927,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	record_root_in_trans(trans, root);
-	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
+	btrfs_set_root_last_snapshot(&root->root_item,
+				     trans->transaction->sub_transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 	btrfs_check_and_init_root_item(new_root_item);
 
-- 
1.6.5.2

