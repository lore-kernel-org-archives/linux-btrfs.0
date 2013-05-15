Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab3EOHsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:46 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 04/17] Btrfs: remove BUG_ON() in btrfs_read_fs_tree_no_radix()
Date: Wed, 15 May 2013 15:48:18 +0800
Message-Id: <1368604111-25073-5-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have checked if ->node is NULL or not, so it is unnecessary to
use BUG_ON() to check again. Remove it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2a9ae38..8c1e4fb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1513,7 +1513,6 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 	}
 
 	root->commit_root = btrfs_root_node(root);
-	BUG_ON(!root->node); /* -ENOMEM */
 out:
 	if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
 		root->ref_cows = 1;
-- 
1.8.1.4

