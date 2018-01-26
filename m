Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34399 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752282AbeAZIau (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:50 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 9F23B49F19BA
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:47 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 05/15] btrfs-progs: lowmem check: let check_dir_item() continue if find wrong inode_item
Date: Fri, 26 Jan 2018 16:35:09 +0800
Message-ID: <20180126083519.28373-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check_dir_item can handle missed/mismatched inode item well.
Let it continue to check corresponding dir_item/index and inode_ref.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e33dd7db0048..eb65a18fe64b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5984,15 +5984,12 @@ begin:
 		ret = btrfs_search_slot(NULL, root, &location, path, 0, 0);
 		if (ret) {
 			tmp_err |= INODE_ITEM_MISSING;
-			goto next;
-		}
-
-		ii = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				    struct btrfs_inode_item);
-		mode = btrfs_inode_mode(path->nodes[0], ii);
-		if (imode_to_type(mode) != filetype) {
-			tmp_err |= INODE_ITEM_MISMATCH;
-			goto next;
+		} else {
+			ii = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_inode_item);
+			mode = btrfs_inode_mode(path->nodes[0], ii);
+			if (imode_to_type(mode) != filetype)
+				tmp_err |= INODE_ITEM_MISMATCH;
 		}
 
 		/* Check relative INODE_REF/INODE_EXTREF */
-- 
2.16.1



