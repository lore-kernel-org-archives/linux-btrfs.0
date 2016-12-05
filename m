Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24505 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751439AbcLEJKY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:10:24 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/4] btrfs-progs: check: Fix false alert on generation mismatch for tree reloc tree
Date: Mon,  5 Dec 2016 17:07:56 +0800
Message-Id: <20161205090756.7960-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
References: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For fs with tree reloc tree(under balancing), lowmem mode will report
false alert like:
ERROR: extent[62914560 4096] backref generation mismatch, wanted: <=9,
have: 13

This is because lowmem mode adds a more restrict check, to ensure
generation in fs tree won't be smaller than extent tree.

In fact such assumption is not right for tree reloc tree, so remove such
check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index d0e1977..c5f6f70 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10155,12 +10155,10 @@ static int check_extent_data_item(struct btrfs_root *root,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_extent_data_ref *dref;
 	u64 owner;
-	u64 file_extent_gen;
 	u64 disk_bytenr;
 	u64 disk_num_bytes;
 	u64 extent_num_bytes;
 	u64 extent_flags;
-	u64 extent_gen;
 	u32 item_size;
 	unsigned long end;
 	unsigned long ptr;
@@ -10172,7 +10170,6 @@ static int check_extent_data_item(struct btrfs_root *root,
 
 	btrfs_item_key_to_cpu(eb, &fi_key, slot);
 	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
-	file_extent_gen = btrfs_file_extent_generation(eb, fi);
 
 	/* Nothing to check for hole and inline data extents */
 	if (btrfs_file_extent_type(eb, fi) == BTRFS_FILE_EXTENT_INLINE ||
@@ -10221,7 +10218,6 @@ static int check_extent_data_item(struct btrfs_root *root,
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 
 	extent_flags = btrfs_extent_flags(leaf, ei);
-	extent_gen = btrfs_extent_generation(leaf, ei);
 
 	if (!(extent_flags & BTRFS_EXTENT_FLAG_DATA)) {
 		error(
@@ -10231,14 +10227,6 @@ static int check_extent_data_item(struct btrfs_root *root,
 		err |= BACKREF_MISMATCH;
 	}
 
-	if (file_extent_gen < extent_gen) {
-		error(
-"extent[%llu %llu] backref generation mismatch, wanted: <=%llu, have: %llu",
-			disk_bytenr, disk_num_bytes, file_extent_gen,
-			extent_gen);
-		err |= BACKREF_MISMATCH;
-	}
-
 	/* Check data backref inside that extent item */
 	item_size = btrfs_item_size_nr(leaf, path.slots[0]);
 	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
-- 
2.10.2



