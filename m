Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62475 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbbBIHAy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:00:54 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t197084B013370
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Feb 2015 15:00:08 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: cleanup: remove no-used alloc_chunk in btrfs_check_data_free_space()
Date: Mon, 9 Feb 2015 14:59:43 +0800
Message-ID: <1423465183-6327-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

int alloc_chunk is never used in this function, remove it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a684086..765e72a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3679,7 +3679,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
-	int ret = 0, committed = 0, alloc_chunk = 1;
+	int ret = 0, committed = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
@@ -3707,7 +3707,7 @@ again:
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
 		 */
-		if (!data_sinfo->full && alloc_chunk) {
+		if (!data_sinfo->full) {
 			u64 alloc_target;
 
 			data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
-- 
1.8.5.1

