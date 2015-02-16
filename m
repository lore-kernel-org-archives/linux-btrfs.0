Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25436 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbbBPJdI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 04:33:08 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t1G9X7Dw013845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 09:33:07 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id t1G9X7Zm008776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 09:33:07 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id t1G9X6sv008741
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 09:33:06 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup alloc_chunk
Date: Mon, 16 Feb 2015 17:32:58 +0800
Message-Id: <1424079178-21976-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"alloc_chunk" is used to avoid alloc_chunk for free space cache inode, but since
it's safe now to do that, let's just remove it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
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
1.8.1.4

