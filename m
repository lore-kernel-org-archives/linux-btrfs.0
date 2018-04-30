Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44941 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbeD3DQD (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sun, 29 Apr 2018 23:16:03 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree() check to avoid out-of-boundary memory access
Date: Mon, 30 Apr 2018 11:15:45 +0800
Message-Id: <20180430031545.29891-3-wqu@suse.com>
In-Reply-To: <20180430031545.29891-1-wqu@suse.com>
References: <20180430031545.29891-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_print_tree(), if nr_items is corrupted, it can easily go
beyond extent buffer boundary.

Add extra nr_item check, and only print as many valid slots as possible.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/print-tree.c b/print-tree.c
index 31a851ef4413..55db80bebb2a 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1376,6 +1376,11 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
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
@@ -1386,7 +1391,11 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 	print_uuids(eb);
 	fflush(stdout);
 	for (i = 0; i < nr; i++) {
-		u64 blocknr = btrfs_node_blockptr(eb, i);
+		u64 blocknr;
+
+		if (i > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
+			break;
+		blocknr = btrfs_node_blockptr(eb, i);
 		btrfs_node_key(eb, &disk_key, i);
 		btrfs_disk_key_to_cpu(&key, &disk_key);
 		printf("\t");
-- 
2.17.0

