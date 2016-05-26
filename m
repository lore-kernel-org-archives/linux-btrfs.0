Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55161 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbcEZCgR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 22:36:17 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id D94B74056403
	for <linux-btrfs@vger.kernel.org>; Thu, 26 May 2016 10:36:02 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: corrupt-block: Add support to corrupt extent for skinny metadata
Date: Thu, 26 May 2016 10:36:02 +0800
Message-Id: <1464230162-7657-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For skinny metadata case, btrfs-corrupt-block can't corrupt a metadata
extent due to the type judgment doesn't include BTRFS_METADATA_ITEM_KEY.

Fix it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 2cc9704..020afab 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -210,6 +210,7 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 			break;
 
 		if (key.type != BTRFS_EXTENT_ITEM_KEY &&
+		    key.type != BTRFS_METADATA_ITEM_KEY &&
 		    key.type != BTRFS_TREE_BLOCK_REF_KEY &&
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY &&
 		    key.type != BTRFS_EXTENT_REF_V0_KEY &&
-- 
2.8.2



