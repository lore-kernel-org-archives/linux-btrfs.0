Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:43961 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbFRAF3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 20:05:29 -0400
From: Robert Marklund <robbelibobban@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robert Marklund <robbelibobban@gmail.com>
Subject: [PATCH] check: check so offset is not bigger then the leaf
Date: Thu, 18 Jun 2015 01:59:13 +0200
Message-Id: <1434585553-8697-1-git-send-email-robbelibobban@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This could crash before because of dangerous dangling
offset of pointer.

Signed-off-by: Robert Marklund <robbelibobban@gmail.com>
---
 cmds-check.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 778f141..da36758 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8906,6 +8906,16 @@ static int build_roots_info_cache(struct btrfs_fs_info *info)
 			goto next;
 
 		ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+
+		if ((long long)ei > info->extent_root->leafsize) {
+			 fprintf(stderr, "Bad leaf = %p, slot = %d\n", leaf, slot);
+			 fprintf(stderr, "item ptr = %p\n", ei);
+			 fprintf(stderr, "objectid = %llx\n", found_key.objectid);
+			 fprintf(stderr, "type     = %x\n", found_key.type);
+			 fprintf(stderr, "offset   = %llx\n", found_key.offset);
+			 goto next;
+		}
+
 		flags = btrfs_extent_flags(leaf, ei);
 
 		if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
-- 
2.1.0

