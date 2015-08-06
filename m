Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65444 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbbHFOSC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 10:18:02 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t76EG4sj020893
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 22:16:04 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: Fix wrong comment of btrfs_alloc_tree_block()
Date: Thu, 6 Aug 2015 22:16:23 +0800
Message-ID: <ea1da7b70342496557bfc8f73fc25bdaf3729fa5.1438870557.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These wrong comment was copyed from another function(expired) from
init, this patch fixed them.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a436bd5..792247f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7536,9 +7536,6 @@ static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
 
 /*
  * finds a free extent and does all the dirty work required for allocation
- * returns the key for the extent through ins, and a tree buffer for
- * the first block of the extent through buf.
- *
  * returns the tree buffer or an ERR_PTR on error.
  */
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
-- 
1.8.5.1

