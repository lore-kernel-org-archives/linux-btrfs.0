Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab2LEKwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Dec 2012 05:52:24 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qB5AqRQe019281
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Dec 2012 18:52:27 +0800
Message-ID: <50BF2780.4080701@cn.fujitsu.com>
Date: Wed, 05 Dec 2012 18:52:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/6] Btrfs: don't auto defrag a file when doing directIO
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we runt the direct IO, we should not run auto defrag, because it may
introduce buffered IO vs direcIO problem, and make direct IO slow down.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5fc0990..b08e4b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5674,9 +5674,6 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	if (IS_ERR(trans))
 		return ERR_CAST(trans);
 
-	if (start <= BTRFS_I(inode)->disk_i_size && len < 64 * 1024)
-		btrfs_add_inode_defrag(trans, inode);
-
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	alloc_hint = get_extent_allocation_hint(inode, start, len);
-- 
1.7.11.7
