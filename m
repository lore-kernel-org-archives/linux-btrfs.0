Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40340 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935982Ab3DPRA7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 13:00:59 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EED2A7C064D
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 11:00:58 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id Pr0DOrIGDlvhlazK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 11:00:58 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix csum check when extent lands on block group
Date: Tue, 16 Apr 2013 13:00:56 -0400
Message-ID: <1366131656-8429-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was running fsync() tests and noticed that occasionally I was getting a bunch
of errors from fsck complaining about csums not having corresponding extents.
Thankfully after a few days of debugging this it turned out to be a bug with
fsck.  The csums were for an extent that started at the same offset as a block
group, and were offset within the extent.  So the search put us out at the block
group item and we just walked forward from there, never finding the actual
extent.  This is because the block group item key is higher than the extent item
key, so it comes first.  In order to fix this we need to check and see if we
landed on a block group item and take another step backwards to make sure we end
up at the extent item.  With this patch my reproducer no longer finds csums that
don't have matching extent records.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 9a7696f..030ab77 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2624,6 +2624,7 @@ static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 	key.offset = 0;
 
+
 again:
 	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
 				0, 0);
@@ -2631,8 +2632,27 @@ again:
 		fprintf(stderr, "Error looking up extent record %d\n", ret);
 		btrfs_free_path(path);
 		return ret;
-	} else if (ret && path->slots[0]) {
-		path->slots[0]--;
+	} else if (ret) {
+		if (path->slots[0])
+			path->slots[0]--;
+		else
+			btrfs_prev_leaf(root, path);
+	}
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+	/*
+	 * Block group items come before extent items if they have the same
+	 * bytenr, so walk back one more just in case.  Dear future traveler,
+	 * first congrats on mastering time travel.  Now if it's not too much
+	 * trouble could you go back to 2006 and tell Chris to make the
+	 * BLOCK_GROUP_ITEM_KEY lower than the EXTENT_ITEM_KEY please?
+	 */
+	if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+		if (path->slots[0])
+			path->slots[0]--;
+		else
+			btrfs_prev_leaf(root, path);
 	}
 
 	while (num_bytes) {
-- 
1.7.7.6

