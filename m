Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbaJJRSt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 13:18:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 500A6AB1D
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 17:18:47 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: debug: print more info about inode
Date: Fri, 10 Oct 2014 19:18:43 +0200
Message-Id: <1412961523-14068-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add uid, gid, rdev and flags to btrfs_print_leaf.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 print-tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index 7df5798e539c..70a7acc632f2 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -823,13 +823,17 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
-			printf("\t\tinode generation %llu transid %llu size %llu block group %llu mode %o links %u\n",
+			printf("\t\tinode generation %llu transid %llu size %llu block group %llu mode %o links %u uid %u gid %u rdev %llu flags 0x%llx\n",
 			       (unsigned long long)btrfs_inode_generation(l, ii),
 			       (unsigned long long)btrfs_inode_transid(l, ii),
 			       (unsigned long long)btrfs_inode_size(l, ii),
 			       (unsigned long long)btrfs_inode_block_group(l,ii),
 			       btrfs_inode_mode(l, ii),
-			       btrfs_inode_nlink(l, ii));
+			       btrfs_inode_nlink(l, ii),
+			       btrfs_inode_uid(l, ii),
+			       btrfs_inode_gid(l, ii),
+			       (unsigned long long)btrfs_inode_rdev(l,ii),
+			       (unsigned long long)btrfs_inode_flags(l,ii));
 			break;
 		case BTRFS_INODE_REF_KEY:
 			iref = btrfs_item_ptr(l, i, struct btrfs_inode_ref);
-- 
2.1.1

