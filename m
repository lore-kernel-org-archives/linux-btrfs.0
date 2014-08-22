Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15504 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755634AbaHVDmv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 23:42:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s7M3gk1Q008074
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 11:42:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: corrupt-block: fix a delete and use bug corrupting extent tree.
Date: Fri, 22 Aug 2014 11:42:49 +0800
Message-ID: <1408678969-9218-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When corrupting extent tree, corrupt-block will iterate each child
node/leaf of a node.
However, when a node's child is leaf, btrfs_corrupt_extent_leaf() may
delete some item in the leaf, which may cause the children number of the
parent node decrease.

Before this patch, corrupt-block will read out the nritems only *ONCE*
and iterate the 'nritems' times.
When btrfs_corrupt_extent_leaf() deletes enough item, causing the
nritems of btrfs_header decreased, the last few iteration will access
non-existed node, which will cause the delete and use bug like
the following:
---
\# ./btrfs-corrupt-block -E /dev/vdc
deleting extent record: key 40714240 168 16384
Couldn't map the block 3459802452797161472
btrfs-corrupt-block: volumes.c:1137: btrfs_num_copies: Assertion
`!(!ce)' failed.
Aborted
---

This patch will update the nritmes in each iteration to avoid the bug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 6ecbe47..486ea19 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -264,12 +264,10 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 				      struct extent_buffer *eb)
 {
 	int i;
-	u32 nr;
 
 	if (!eb)
 		return;
 
-	nr = btrfs_header_nritems(eb);
 	if (btrfs_is_leaf(eb)) {
 		btrfs_corrupt_extent_leaf(trans, root, eb);
 		return;
@@ -280,7 +278,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 			return;
 	}
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < btrfs_header_nritems(eb); i++) {
 		struct extent_buffer *next;
 
 		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
-- 
2.0.4

