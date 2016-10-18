Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43400 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbcJRICK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:10 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id 9092941B4BC3
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Oct 2016 16:02:05 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: pass correct args to btrfs_async_run_delayed_refs()
Date: Tue, 18 Oct 2016 15:56:13 +0800
Message-Id: <20161018075613.10757-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_truncate_inode_items()->btrfs_async_run_delayed_refs(), we
swap the arg2 and arg3 wrongly, fix this.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2b790bd..2f1372b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4605,8 +4605,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 			if (btrfs_should_throttle_delayed_refs(trans, root))
 				btrfs_async_run_delayed_refs(root,
-							     trans->transid,
-					trans->delayed_ref_updates * 2, 0);
+					trans->delayed_ref_updates * 2,
+					trans->transid, 0);
 			if (be_nice) {
 				if (truncate_space_check(trans, root,
 							 extent_num_bytes)) {
-- 
2.9.0



