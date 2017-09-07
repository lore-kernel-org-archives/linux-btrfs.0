Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:27327 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752142AbdIGCZp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Sep 2017 22:25:45 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 299124727AA4
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Sep 2017 10:25:40 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fnstml-btrfs@cn.fujitsu.com>, <zhangyu-fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: print: Check on num_stripes in print_chunk
Date: Thu, 7 Sep 2017 10:28:25 +0800
Message-ID: <20170907022825.19334-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>

In fuzz-tests/004-simple-dump-tree:
Since there is one wrong item(DATA_RELOC_TREE CHUNK_ITEM 0) in root
tree.
It fails as follow:

ctree.h:317: btrfs_chunk_item_size: BUG_ON `num_stripes == 0` triggered, value 1
btrfs-progs/btrfs(+0x2496f)[0x564a031e996f]
btrfs-progs/btrfs(print_chunk+0x20f)[0x564a031ea091]
btrfs-progs/btrfs(btrfs_print_leaf+0xfcb)[0x564a031ebaea]
btrfs-progs/btrfs(btrfs_print_tree+0x3d)[0x564a031ec311]
btrfs-progs/btrfs(cmd_inspect_dump_tree+0x4e6)[0x564a0323a6e1]
btrfs-progs/btrfs(handle_command_group+0x44)[0x564a031d6414]
btrfs-progs/btrfs(cmd_inspect+0x15)[0x564a03211b98]
btrfs-progs/btrfs(main+0x88)[0x564a031d65d0]
/usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f2c7fa584ca]
btrfs-progs/btrfs(_start+0x2a)[0x564a031d616a]
        item 8 key (DATA_RELOC_TREE CHUNK_ITEM 0) itemoff 1574 itemsize 439
failed (ignored, ret=134): btrfs-progs/btrfs inspect-internal dump-tree btrfs-progs/tes\
ts/fuzz-tests/images/bko-155201-wrong-chunk-item-in-root-tree.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 004-simple-dump-tree

Solve it by checking on num_stripes in print_chunk().

Signed-off-by: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
---
change log:
v2:
  Move statements after the declaration block in print_chunk().
---
 print-tree.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index 5927ed35..ca7b3aa1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -199,9 +199,19 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	u16 num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
-	u32 chunk_item_size = btrfs_chunk_item_size(num_stripes);
+	u32 chunk_item_size;
 	char chunk_flags_str[32] = {0};
 
+	/*
+	 * check on num_stripes
+	 * Btrfs_chunk contains at least one stripes
+	 */
+	if (num_stripes < 1) {
+		printf("\t\tinvalid num_stripes: %u\n", num_stripes);
+		return;
+	}
+
+	chunk_item_size = btrfs_chunk_item_size(num_stripes);
 	if ((unsigned long)chunk + chunk_item_size > eb->len) {
 		printf("\t\tchunk item invalid\n");
 		return;
-- 
2.14.1



