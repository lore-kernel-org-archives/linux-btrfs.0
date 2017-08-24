Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12353 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751790AbdHXKjw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 06:39:52 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 049FF4724000
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 18:39:53 +0800 (CST)
From: <zhangyu-fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: Check on num_stripes in print_chunk
Date: Thu, 24 Aug 2017 18:38:41 +0800
Message-ID: <20170824103841.16259-1-zhangyu-fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>

[TEST/fuzz] case: 004-simple-dump-tree

Since the wrong key(DATA_RELOC_TREE CHUNK_ITEM 0) in root tree,
error calling print_chunk(), resulting in num_stripes == 0.

ERROR:
     [TEST/fuzz]   004-simple-dump-tree
ctree.h:317: btrfs_chunk_item_size: BUG_ON `num_stripes == 0`
        triggered, value 1

failed (ignored, ret=134): /myproject/btrfs-progs/btrfs
inspect-internal dump-tree
/myproject/btrfs-progs/tests/fuzz-tests/images/
bko-155201-wrong-chunk-item-in-root-tree.raw.restored

test failed for case 004-simple-dump-tree
Makefile:288: recipe for target 'test-fuzz' failed
make: *** [test-fuzz] Error 1

So, check on num_stripes in print_chunk

Signed-off-by: Zhang Yu <zhangyu-fnst@cn.fujitsu.com>
---
 print-tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index a0d3395..08f7edb 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -199,6 +199,15 @@ void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 {
 	int num_stripes = btrfs_chunk_num_stripes(eb, chunk);
 	int i;
+	/*
+	 * check on num_stripes
+	 * Btrfs_chunk contains at least one stripes
+	 */
+	if (num_stripes < 1) {
+		printf("invalid num_stripes: %u\n", num_stripes);
+		return;
+	}
+
 	u32 chunk_item_size = btrfs_chunk_item_size(num_stripes);
 	char chunk_flags_str[32] = {0};
 
-- 
2.9.4



