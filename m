Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52138 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3CRJT3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 05:19:29 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 18 Mar 2013 05:19:28 -0400
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/2] btrfs: Cleanup some redundant codes in btrfs_lookup_csums_range()
Date: Mon, 18 Mar 2013 17:18:09 +0800
Message-Id: <1363598290-12258-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/file-item.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ec16020..1ba85b4 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -356,11 +356,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
-		    key.type != BTRFS_EXTENT_CSUM_KEY)
-			break;
-
-		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		if (key.offset > end)
+		    key.type != BTRFS_EXTENT_CSUM_KEY ||
+		    key.offset > end)
 			break;
 
 		if (key.offset > start)
-- 
1.7.11.7

