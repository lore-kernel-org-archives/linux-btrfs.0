Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42065 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260AbbFSDva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 23:51:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5J3nqoa028639
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 11:49:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Add nbytes output for print-tree and reformat inode output
Date: Fri, 19 Jun 2015 11:49:19 +0800
Message-ID: <1434685760-2013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original implement doesn't output nbytes in btrfs_inode.
Add the output and since the output is too long, reformat it to multi
lines.

This is very handy to debug related bugs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 print-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index df63334..a72a979 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -841,10 +841,13 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
-			printf("\t\tinode generation %llu transid %llu size %llu block group %llu mode %o links %u uid %u gid %u rdev %llu flags 0x%llx\n",
+			printf("\t\tinode generation %llu transid %llu size %llu nbytes %llu\n"
+			       "\t\tblock group %llu mode %o links %u uid %u gid %u\n"
+			       "\t\trdev %llu flags 0x%llx\n",
 			       (unsigned long long)btrfs_inode_generation(l, ii),
 			       (unsigned long long)btrfs_inode_transid(l, ii),
 			       (unsigned long long)btrfs_inode_size(l, ii),
+			       (unsigned long long)btrfs_inode_nbytes(l, ii),
 			       (unsigned long long)btrfs_inode_block_group(l,ii),
 			       btrfs_inode_mode(l, ii),
 			       btrfs_inode_nlink(l, ii),
-- 
2.4.4

