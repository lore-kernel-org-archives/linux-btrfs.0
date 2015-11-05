Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14111 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030983AbbKEIdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Nov 2015 03:33:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA58WP2M026809
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Nov 2015 16:32:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Allow btrfs_leaf_free_space to accept NULL root
Date: Thu, 5 Nov 2015 16:32:59 +0800
Message-ID: <1446712380-7654-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs_leaf_free_space() function is used to determine the leaf/node
size.
It's OK to use root->nodesize to determine nodesize, but in fact,
extent_buffer->len can also be used to determine the nodesize if caller
can ensure it's a tree block.

So this patch will add support for NULL root for btrfs_leaf_free_space()
function, to allow btrfs_print_leaf() functions to be called in gdb or
to debug temporary btrfs in make_btrfs() without a valid root.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/ctree.c b/ctree.c
index 1434007..46153e3 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1619,13 +1619,14 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
  */
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf)
 {
+	u32 nodesize = (root ? BTRFS_LEAF_DATA_SIZE(root) : leaf->len);
 	int nritems = btrfs_header_nritems(leaf);
 	int ret;
-	ret = BTRFS_LEAF_DATA_SIZE(root) - leaf_space_used(leaf, 0, nritems);
+	ret = nodesize - leaf_space_used(leaf, 0, nritems);
 	if (ret < 0) {
-		printk("leaf free space ret %d, leaf data size %lu, used %d nritems %d\n",
-		       ret, (unsigned long) BTRFS_LEAF_DATA_SIZE(root),
-		       leaf_space_used(leaf, 0, nritems), nritems);
+		printk("leaf free space ret %d, leaf data size %u, used %d nritems %d\n",
+		       ret, nodesize, leaf_space_used(leaf, 0, nritems),
+		       nritems);
 	}
 	return ret;
 }
-- 
2.6.2

