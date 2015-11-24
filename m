Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8141 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbbKXFTF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 00:19:05 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: calestyo@scientia.net
Subject: [PATCH] btrfs-progs: fsck: Fix a false alert where extent record has wrong metadata flag
Date: Tue, 24 Nov 2015 13:16:51 +0800
Message-Id: <1448342211-21558-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In process_extent_item(), it gives 'metadata' initial value 0, but for
non-skinny-metadata case, metadata extent can't be judged just from key
type and it forgot that case.

This causes a lot of false alert in non-skinny-metadata filesystem.

Fix it by set correct metadata value before calling add_extent_rec().

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index fd661d9..c235702 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5134,6 +5134,10 @@ static int process_extent_item(struct btrfs_root *root,
 
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	refs = btrfs_extent_refs(eb, ei);
+	if (btrfs_extent_flags(eb, ei) == BTRFS_EXTENT_FLAG_TREE_BLOCK)
+		metadata = 1;
+	else
+		metadata = 0;
 
 	add_extent_rec(extent_cache, NULL, 0, key.objectid, num_bytes,
 		       refs, 0, 0, 0, metadata, 1, num_bytes);
-- 
2.6.2

