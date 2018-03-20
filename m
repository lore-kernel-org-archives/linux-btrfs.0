Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39757 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbeCTIpz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 04:45:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2271AABA3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 08:45:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: Beautify owner when printing leaf/nodes
Date: Tue, 20 Mar 2018 10:45:51 +0200
Message-Id: <1521535551-23388-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently we print the raw values of the owner field of leaf/nodes.
This can result in output like the following:

leaf 30490624 items 2 free space 16061 generation 4 owner 18446744073709551607

With the patch applied the same leaf looks like:

leaf 30490624 items 2 free space 16061 generation 4 owner DATA_RELOC_TREE

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 print-tree.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index d59f9002f54c..a2f6bfc027c9 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1188,11 +1188,12 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 	header_flags_to_str(flags, flags_str);
 	nr = btrfs_header_nritems(eb);
 
-	printf("leaf %llu items %d free space %d generation %llu owner %llu\n",
+	printf("leaf %llu items %d free space %d generation %llu owner ",
 		(unsigned long long)btrfs_header_bytenr(eb), nr,
 		btrfs_leaf_free_space(root, eb),
-		(unsigned long long)btrfs_header_generation(eb),
-		(unsigned long long)btrfs_header_owner(eb));
+		(unsigned long long)btrfs_header_generation(eb));
+	print_objectid(stdout, btrfs_header_owner(eb), 0);
+	printf("\n");
 	printf("leaf %llu flags 0x%llx(%s) backref revision %d\n",
 		btrfs_header_bytenr(eb), flags, flags_str, backref_rev);
 	print_uuids(eb);
@@ -1365,12 +1366,13 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 		btrfs_print_leaf(root, eb);
 		return;
 	}
-	printf("node %llu level %d items %d free %u generation %llu owner %llu\n",
+	printf("node %llu level %d items %d free %u generation %llu owner ",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
 		(u32)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - nr,
-		(unsigned long long)btrfs_header_generation(eb),
-		(unsigned long long)btrfs_header_owner(eb));
+		(unsigned long long)btrfs_header_generation(eb));
+	print_objectid(stdout, btrfs_header_owner(eb), 0);
+	printf("\n");
 	print_uuids(eb);
 	fflush(stdout);
 	for (i = 0; i < nr; i++) {
-- 
2.7.4

