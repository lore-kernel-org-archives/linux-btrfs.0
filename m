Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58027 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2K3GDd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 01:03:33 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so97671iay.19
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 22:03:33 -0800 (PST)
From: shhuiw@gmail.com
To: chris.mason@fusionio.com, jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup: assign path->nodes[0]to leaf after ret check in __btrfs_write_out_cache
Date: Fri, 30 Nov 2012 14:02:28 +0800
Message-Id: <50b84c34.82c0320a.0e91.ffffe6bd@mx.google.com>
In-Reply-To: <1354255348-5011-1-git-send-email-y>
References: <n>
 <1354255348-5011-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Sheng-Hui <shhuiw@gmail.com>

If the ret check fails, the assignment is useless.
Move the assignment after the check.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 058fc9b..d7b3286 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1033,7 +1033,6 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				 GFP_NOFS);
 		goto out;
 	}
-	leaf = path->nodes[0];
 	if (ret > 0) {
 		struct btrfs_key found_key;
 		BUG_ON(!path->slots[0]);
@@ -1049,6 +1048,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			goto out;
 		}
 	}
+	leaf = path->nodes[0];
 
 	BTRFS_I(inode)->generation = trans->transid;
 	header = btrfs_item_ptr(leaf, path->slots[0],
-- 
1.6.0.2

