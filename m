Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752685AbeFHMsC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:02 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8702DAF8F
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/15] btrfs-progs: Remove root argument from pin_down_bytes
Date: Fri,  8 Jun 2018 15:47:44 +0300
Message-Id: <1528462078-24490-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This argument is used to obtain a reference to fs_info, which can
already be done from the passed trans handle, so use that instead.
This is in preparation for delayed refs support.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 0643815bd41c..cbc022f6cef6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2098,9 +2098,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
 	return 0;
 }
 
-static int pin_down_bytes(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
-			  u64 bytenr, u64 num_bytes, int is_data)
+static int pin_down_bytes(struct btrfs_trans_handle *trans, u64 bytenr,
+			  u64 num_bytes, int is_data)
 {
 	int err = 0;
 	struct extent_buffer *buf;
@@ -2108,7 +2107,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	if (is_data)
 		goto pinit;
 
-	buf = btrfs_find_tree_block(root->fs_info, bytenr, num_bytes);
+	buf = btrfs_find_tree_block(trans->fs_info, bytenr, num_bytes);
 	if (!buf)
 		goto pinit;
 
@@ -2360,7 +2359,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		}
 
 		if (pin) {
-			ret = pin_down_bytes(trans, root, bytenr, num_bytes,
+			ret = pin_down_bytes(trans, bytenr, num_bytes,
 					     is_data);
 			if (ret > 0)
 				mark_free = 1;
-- 
2.7.4

