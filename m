Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbbIJPEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 11:04:00 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix cross stripe boundary check
Date: Thu, 10 Sep 2015 17:02:56 +0200
Message-Id: <1441897376-5572-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 854437ca3c228d8ab3eb24d2efc1c21b5d56a635 ("btrfs-progs:
extent-tree: avoid allocating tree block that crosses stripe boundary")
does not work for 64k nodesize. Due to an off-by-one error, all queries
to check_crossing_stripes will return that all extents cross a stripe
and this will lead to a false ENOSPC. This crashes later

$ ./mkfs.btrfs -n 64k image

./mkfs.btrfs(btrfs_reserve_extent+0xb77)[0x417f38]
./mkfs.btrfs(btrfs_alloc_free_block+0x57)[0x417fe0]
./mkfs.btrfs(__btrfs_cow_block+0x163)[0x408eb7]
./mkfs.btrfs(btrfs_cow_block+0xd0)[0x4097c4]
./mkfs.btrfs(btrfs_search_slot+0x16f)[0x40be4d]
./mkfs.btrfs(btrfs_insert_empty_items+0xc0)[0x40d5f9]
./mkfs.btrfs(btrfs_insert_item+0x99)[0x40da5f]
./mkfs.btrfs(btrfs_make_block_group+0x4d)[0x41705c]
./mkfs.btrfs(main+0xeef)[0x434b56]

CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 volumes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/volumes.h b/volumes.h
index f7761311e8ce..4ecb99314a0c 100644
--- a/volumes.h
+++ b/volumes.h
@@ -156,7 +156,7 @@ struct map_lookup {
 static inline int check_crossing_stripes(u64 start, u64 len)
 {
 	return (start / BTRFS_STRIPE_LEN) !=
-	       ((start + len) / BTRFS_STRIPE_LEN);
+	       ((start + len - 1) / BTRFS_STRIPE_LEN);
 }
 
 int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-- 
2.1.3

