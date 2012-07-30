Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50599 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2G3IPU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 04:15:20 -0400
Date: Mon, 30 Jul 2012 11:15:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Btrfs: unlock on error in btrfs_delalloc_reserve_metadata()
Message-ID: <20120730081515.GB15702@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should release this mutex before returning the error code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to linux-next.

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4e1b153..45c69c4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4571,8 +4571,10 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	if (root->fs_info->quota_enabled) {
 		ret = btrfs_qgroup_reserve(root, num_bytes +
 					   nr_extents * root->leafsize);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 			return ret;
+		}
 	}
 
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
