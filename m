Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36153 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbbHEIDT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:03:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <robert.munteanu@gmail.com>
Subject: [PATCH 1/3] btrfs-progs: fsck: Print correct file hole
Date: Wed, 5 Aug 2015 16:03:12 +0800
Message-ID: <1438761794-32738-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1438761794-32738-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a file lost all its file extents, fsck will unable to print out the
hole.

Add an extra judgment to print out the hole range.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 50bb6f3..31ed589 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -616,15 +616,20 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 	if (errors & I_ERR_FILE_EXTENT_DISCOUNT) {
 		struct file_extent_hole *hole;
 		struct rb_node *node;
+		int found = 0;
 
 		node = rb_first(&rec->holes);
 		fprintf(stderr, "Found file extent holes:\n");
 		while (node) {
+			found = 1;
 			hole = rb_entry(node, struct file_extent_hole, node);
-			fprintf(stderr, "\tstart: %llu, len:%llu\n",
+			fprintf(stderr, "\tstart: %llu, len: %llu\n",
 				hole->start, hole->len);
 			node = rb_next(node);
 		}
+		if (!found)
+			fprintf(stderr, "\tstart: 0, len: %llu\n",
+				round_up(rec->isize, root->sectorsize));
 	}
 }
 
-- 
2.5.0

