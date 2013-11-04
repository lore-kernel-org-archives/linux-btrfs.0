Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3KDPMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:40 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCUOP031733
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] Btrfs: pick up the code for the item number calculation in flush_space()
Date: Mon, 4 Nov 2013 23:13:22 +0800
Message-Id: <1383578006-22691-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch picked up the code that was used to calculate the number of
the items for which we need reserve space, and we will use it in the next
patch.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ed6eceb..32dcf80 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4004,6 +4004,18 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 	}
 }
 
+static inline int calc_reclaim_items_nr(struct btrfs_root *root, u64 to_reclaim)
+{
+	u64 bytes;
+	int nr;
+
+	bytes = btrfs_calc_trans_metadata_size(root, 1);
+	nr = (int)div64_u64(to_reclaim, bytes);
+	if (!nr)
+		nr = 1;
+	return nr;
+}
+
 /*
  * shrink metadata reservation for delalloc
  */
@@ -4149,16 +4161,11 @@ static int flush_space(struct btrfs_root *root,
 	switch (state) {
 	case FLUSH_DELAYED_ITEMS_NR:
 	case FLUSH_DELAYED_ITEMS:
-		if (state == FLUSH_DELAYED_ITEMS_NR) {
-			u64 bytes = btrfs_calc_trans_metadata_size(root, 1);
-
-			nr = (int)div64_u64(num_bytes, bytes);
-			if (!nr)
-				nr = 1;
-			nr *= 2;
-		} else {
+		if (state == FLUSH_DELAYED_ITEMS_NR)
+			nr = calc_reclaim_items_nr(root, num_bytes) * 2;
+		else
 			nr = -1;
-		}
+
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
-- 
1.8.1.4

