Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34115 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbaI3IwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 04:52:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8U8qEwt000636
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 16:52:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Check the csum tree node before go through the csum tree
Date: Tue, 30 Sep 2014 16:52:10 +0800
Message-ID: <1412067130-11504-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Some fsfuzzed btrfs image will cause btrfsck segfault.

[REPRODUCER]
Run btrfsck on a csum tree block corrupted image.

[REASON]
check_csums() function call btrfs_search_slot() on csum_tree but doesn't
check whether the csum_tree contains a valid extent_buffer, which causes
the segfault.

[FIX]
Check the csum_root->node before any search.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 9471709..537376a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3905,6 +3905,10 @@ static int check_csums(struct btrfs_root *root)
 	unsigned long leaf_offset;
 
 	root = root->fs_info->csum_root;
+	if (!extent_buffer_uptodate(root->node)) {
+		fprintf(stderr, "No valid csum tree found\n");
+		return -ENOENT;
+	}
 
 	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key.type = BTRFS_EXTENT_CSUM_KEY;
-- 
2.1.1

