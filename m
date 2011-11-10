From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 5/6] Btrfs: fix deadlock caused by the race between relocation
 and snapshot creation
Date: Thu, 10 Nov 2011 14:30:44 +0800
Message-ID: <4EBB6F94.3030500@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We can not do flushable reservation for the relocation when we create snapshot,
because it may make the transaction commit task and the flush task wait for
each other and the deadlock happens.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e3d2970..00d5510 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -881,8 +881,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_reloc_pre_snapshot(trans, pending, &to_reserve);
 
 	if (to_reserve > 0) {
-		ret = btrfs_block_rsv_add(root, &pending->block_rsv,
-					  to_reserve);
+		ret = btrfs_block_rsv_add_noflush(root, &pending->block_rsv,
+						  to_reserve);
 		if (ret) {
 			pending->error = ret;
 			goto fail;
-- 
1.7.6.4
