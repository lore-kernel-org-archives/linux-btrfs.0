Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756088AbeEJBuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 21:50:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 65571AF43
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 01:50:03 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree() check to avoid out-of-boundary memory access
Date: Thu, 10 May 2018 09:50:01 +0800
Message-Id: <20180510015001.31200-1-wqu@suse.com>
In-Reply-To: <20180430031545.29891-3-wqu@suse.com>
References: <20180430031545.29891-3-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_print_tree(), if nr_items is corrupted, it can easily go
beyond extent buffer boundary.

Add extra nr_item check, and only print as many valid slots as possible.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Use better loop condition suggested by Su.
---
 print-tree.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index 31a851ef4413..1c2533a9678d 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1364,6 +1364,7 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 {
 	u32 i;
 	u32 nr;
+	u32 ptr_num;
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key key;
@@ -1376,6 +1377,11 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 		btrfs_print_leaf(eb);
 		return;
 	}
+	/* We are crossing eb boundary, this node must be corrupted */
+	if (nr > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
+		warning(
+		"node nr_items corrupted, has %u limit %u, continue print anyway",
+			nr, BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb));
 	printf("node %llu level %d items %d free %u generation %llu owner ",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
@@ -1385,8 +1391,10 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 	printf("\n");
 	print_uuids(eb);
 	fflush(stdout);
-	for (i = 0; i < nr; i++) {
+	ptr_num = BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb);
+	for (i = 0; i < nr && i < ptr_num; i++) {
 		u64 blocknr = btrfs_node_blockptr(eb, i);
+
 		btrfs_node_key(eb, &disk_key, i);
 		btrfs_disk_key_to_cpu(&key, &disk_key);
 		printf("\t");
-- 
2.17.0

