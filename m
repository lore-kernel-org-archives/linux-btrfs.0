Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49078 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751045AbaE2KFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 06:05:17 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4TA5Gjh005256
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 18:05:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs-progs: fsck: finish transaction commit if repair error out
Date: Thu, 29 May 2014 18:01:42 +0800
Message-ID: <1401357704-9752-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfsck fail to repair, we hit something like following:

Check tree block failed, want=29442048, have=0
Check tree block failed, want=29442048, have=0
Check tree block failed, want=29442048, have=0
Check tree block failed, want=29442048, have=0
Check tree block failed, want=29442048, have=0
read block failed check_tree_block
found 98304 bytes used err is 1
total csum bytes: 0
total tree bytes: 0
total fs tree bytes: 0
total extent tree bytes: 0
btree space waste bytes: 0
file data blocks allocated: 0
referenced 0
Btrfs v3.14.2-rc2-63-g3944f15
btrfs: transaction.h:38: btrfs_start_transaction: Assertion `!(root->commit_root)' failed.
Aborted (core dumped)

This is because under repair mode, we will start a transaction, and if we error out,
we don't finish this transaction. So in close_ctree(), it will try
to start and commit transaction which causes the above segmentation.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 5bceb43..00d37b8 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6334,12 +6334,12 @@ again:
 	if (err && !ret)
 		ret = err;
 
+out:
 	if (trans) {
 		err = btrfs_commit_transaction(trans, root);
 		if (!ret)
 			ret = err;
 	}
-out:
 	if (repair) {
 		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
 		root->fs_info->fsck_extent_cache = NULL;
-- 
1.9.0

