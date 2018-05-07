Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbeEGHrC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 03:47:02 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CB111AE95
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 07:47:01 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: print-tree: Avoid segfault for heavily corrupted item pointers
Date: Mon,  7 May 2018 15:46:27 +0800
Message-Id: <20180507074628.1563-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Normally corrupted leaf should be caught by csum check, but sometimes
corrupted item pointers (out of leaf range) can still pass csum check.
In fact, our fsck/005 test case image has such corrupted item pointer
and btrfs check can surprisingly fix it.

Anyway, make print-tree to skip such item and remaining slots to avoid
segfault.

Please note that, in btrfs-progs we can't put such check into
check_tree_block() nor do kernel level comprehensive check as under
certain case, btrfs-progs can handle or even repair it.
A restrict check_tree_block() or backporting kernel btrfs_check_leaf()
could break such test cases and reduce the utility of btrfs-progs.

Issue: #128
Reported-by: Hubert Kario <kario@wit.edu.pl>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/print-tree.c b/print-tree.c
index a1a7954abdae..aaff0f618b7e 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1179,6 +1179,7 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 	struct btrfs_item *item;
 	struct btrfs_disk_key disk_key;
 	char flags_str[128];
+	u32 leaf_data_size = BTRFS_LEAF_DATA_SIZE(fs_info);
 	u32 i;
 	u32 nr;
 	u64 flags;
@@ -1207,6 +1208,23 @@ void btrfs_print_leaf(struct extent_buffer *eb)
 		u32 type;
 		u64 offset;
 
+		/*
+		 * Extra check on item pointers
+		 * Here we don't need to be as restrict as kernel leaf check.
+		 * Only need to ensure all pointers are pointing range inside
+		 * the leaf, thus no segfault.
+		 */
+		if (btrfs_item_offset_nr(eb, i) > leaf_data_size ||
+		    btrfs_item_size_nr(eb, i) + btrfs_item_offset_nr(eb, i) >
+		    leaf_data_size) {
+			error(
+"leaf %llu slot %u pointer invalid, offset %u size %u leaf data limit %u",
+			      btrfs_header_bytenr(eb), i,
+			      btrfs_item_offset_nr(eb, i),
+			      btrfs_item_size_nr(eb, i), leaf_data_size);
+			error("skip remaining slots");
+			break;
+		}
 		item = btrfs_item_nr(i);
 		item_size = btrfs_item_size(eb, item);
 		/* Untyped extraction of slot from btrfs_item_ptr */
-- 
2.17.0

