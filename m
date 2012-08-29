Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2H2ENj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 00:13:39 -0400
Message-ID: <503D96DC.7050701@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 12:13:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dave@jikos.cz>
Subject: [PATCH 6/7] Btrfs: fix corrupted metadata in the snapshot
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we delete a inode, we will remove all the delayed items including delayed
inode update, and then truncate all the relative metadata. If there is lots of
metadata, we will end the current transaction, and start a new transaction to
truncate the left metadata. In this way, we will leave a inode item that its
link counter is > 0, and also may leave some directory index items in fs/file tree
after the current transaction ends. In other words, the metadata in this fs/file tree
is inconsistent. If we create a snapshot for this tree now, we will find a inode with
corrupted metadata in the new snapshot, and we won't continue to drop the left metadata,
because its link counter is not 0.

We fix this problem by updating the inode item before the current transaction ends.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cae4c32..02eeecb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3736,7 +3736,7 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv, *global_rsv;
-	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	u64 min_size = btrfs_calc_trunc_metadata_size(root, 2);
 	unsigned long nr;
 	int ret;
 
@@ -3818,6 +3818,9 @@ void btrfs_evict_inode(struct inode *inode)
 		if (ret != -EAGAIN)
 			break;
 
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
-- 
1.7.6.5
