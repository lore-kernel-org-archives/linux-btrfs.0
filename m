From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: remove setting of extra cur_trans
Date: Wed, 09 Nov 2011 09:49:39 +0900
Message-ID: <201111090049.AA00037@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because cur_trans is set after it has the branch, it is not
necessary to set it here.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/transaction.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 960835e..0d28c8f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -84,7 +84,6 @@ loop:
 		 * to redo the trans_no_join checks above
 		 */
 		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
-		cur_trans = root->fs_info->running_transaction;
 		goto loop;
 	}
 

