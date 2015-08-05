Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11585 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751858AbbHEIDU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:03:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <robert.munteanu@gmail.com>
Subject: [PATCH 2/3] btrfs-progs: fsck: Fix a infinite loop on discount file extent repair
Date: Wed, 5 Aug 2015 16:03:13 +0800
Message-ID: <1438761794-32738-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For a special case, discount file extent repair function will cause
infinite loop.

The case is, if the file loses all its file extent, we won't have a hole
to fill, causing repair function doing nothing, and since the
I_ERR_DISCOUNT doesn't disappear, the fsck will do infinite loop.

For such case, just puch hole to fill all the range to fix it.

Reported-by: Robert Munteanu <robert.munteanu@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 31ed589..4fa8709 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2665,11 +2665,13 @@ static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
 {
 	struct rb_node *node;
 	struct file_extent_hole *hole;
+	int found = 0;
 	int ret = 0;
 
 	node = rb_first(&rec->holes);
 
 	while (node) {
+		found = 1;
 		hole = rb_entry(node, struct file_extent_hole, node);
 		ret = btrfs_punch_hole(trans, root, rec->ino,
 				       hole->start, hole->len);
@@ -2683,6 +2685,13 @@ static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
 			rec->errors &= ~I_ERR_FILE_EXTENT_DISCOUNT;
 		node = rb_first(&rec->holes);
 	}
+	/* special case for a file losing all its file extent */
+	if (!found) {
+		ret = btrfs_punch_hole(trans, root, rec->ino, 0,
+				       round_up(rec->isize, root->sectorsize));
+		if (ret < 0)
+			goto out;
+	}
 	printf("Fixed discount file extents for inode: %llu in root: %llu\n",
 	       rec->ino, root->objectid);
 out:
-- 
2.5.0

