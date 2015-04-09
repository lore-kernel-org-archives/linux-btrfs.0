Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22081 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbbDIEg1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 00:36:27 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t394ZJqI019941
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Apr 2015 12:35:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 9/9] btrfs: cleanup unused alloc_chunk varible
Date: Thu, 9 Apr 2015 12:34:44 +0800
Message-ID: <1360b5275dc1fe722c688ab558f2e32ab414a1a3.1428554023.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Remove int alloc_chunk in btrfs_check_data_free_space() for not
necessary.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d5ec383..b009987 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3641,7 +3641,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
-	int ret = 0, need_commit = 2, have_pinned_space, alloc_chunk = 1;
+	int ret = 0, need_commit = 2, have_pinned_space;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
@@ -3669,7 +3669,7 @@ again:
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
 		 */
-		if (!data_sinfo->full && alloc_chunk) {
+		if (!data_sinfo->full) {
 			u64 alloc_target;
 
 			data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
-- 
1.8.5.1

