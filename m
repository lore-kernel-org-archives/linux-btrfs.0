Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31415 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761136AbcIOARj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 20:17:39 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH] Btrfs: memset to avoid stale content in btree node block
Date: Wed, 14 Sep 2016 17:22:57 -0700
Message-Id: <1473898977-29406-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During updating btree, we could push items between sibling
nodes/leaves, for leaves data sections starts reversely from
the end of the block while for nodes we only have key pairs
which are stored one by one from the start of the block.

So we could do try to push key pairs from one node to the next
node right in the tree, and after that, we update the node's
nritems to reflect the correct end while leaving the stale
content in the node.  One may intentionally corrupt the fs
image and access the stale content by bumping the nritems and
causes various crashes.

This takes the in-memory @nritems as the correct one and
gets to memset the unused part of a btree node.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c2325c3..56c9dee 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3732,6 +3732,17 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 		bio_flags = EXTENT_BIO_TREE_LOG;
 
+	/* set btree node beyond nritems with 0 to avoid stale content */
+	if (btrfs_header_level(eb) > 0) {
+		u32 nritems;
+		unsigned long end;
+
+		nritems = btrfs_header_nritems(eb);
+		end = btrfs_node_key_ptr_offset(nritems);
+
+		memset_extent_buffer(eb, 0, end, eb->len - end);
+	}
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
