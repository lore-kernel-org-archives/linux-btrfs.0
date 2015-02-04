Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58963 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751483AbbBDHTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:19:32 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IDD4020224
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/7] btrfs-progs: Introduce btrfs_next_slot() function to iterate to next slot in given level.
Date: Wed, 4 Feb 2015 15:16:46 +0800
Message-ID: <1423034213-14018-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will help a lot in level by level iteration.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index c52d3de..0dfe733 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2340,13 +2340,18 @@ static inline int btrfs_next_tree_block(struct btrfs_root *root,
 	return btrfs_next_leaf(root, path);
 }
 
+static inline int btrfs_next_slot(struct btrfs_root *root,
+				  struct btrfs_path *p, int level)
+{
+	++p->slots[level];
+	if (p->slots[level] >= btrfs_header_nritems(p->nodes[level]))
+		return btrfs_next_tree_block(root, p);
+	return 0;
+}
 static inline int btrfs_next_item(struct btrfs_root *root,
 				  struct btrfs_path *p)
 {
-	++p->slots[0];
-	if (p->slots[0] >= btrfs_header_nritems(p->nodes[0]))
-		return btrfs_next_leaf(root, p);
-	return 0;
+	return btrfs_next_slot(root, p, 0);
 }
 
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
-- 
2.2.2

