Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab3LMKbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:31:18 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDAVFAf010075
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:31:15 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove unnecessary filemap writting and waiting after block group relocation
Date: Fri, 13 Dec 2013 18:30:44 +0800
Message-Id: <1386930644-15029-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have commited transaction before, remove redundant filemap writting and
waiting here, it can speed up balance relocation process.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 63708f7..d8a82b8 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4283,11 +4283,6 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		}
 	}
 
-	filemap_write_and_wait_range(fs_info->btree_inode->i_mapping,
-				     rc->block_group->key.objectid,
-				     rc->block_group->key.objectid +
-				     rc->block_group->key.offset - 1);
-
 	WARN_ON(rc->block_group->pinned > 0);
 	WARN_ON(rc->block_group->reserved > 0);
 	WARN_ON(btrfs_block_group_used(&rc->block_group->item) > 0);
-- 
1.8.3.1

