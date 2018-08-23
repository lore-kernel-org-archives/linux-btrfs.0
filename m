Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725979AbeHWJjh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 05:39:37 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30D4DAFD2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 06:11:34 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print-tree: Skip deprecated blockptr / nodesize output
Date: Thu, 23 Aug 2018 14:11:29 +0800
Message-Id: <20180823061129.9412-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When printing tree nodes, we output slots like:
key (EXTENT_TREE ROOT_ITEM 0) block 73625600 (17975) gen 16

The number in the parentheses is blockptr / nodesize.

However this number doesn't really do any thing useful.
And in fact for unaligned metadata block group (block group start bytenr
is not aligned to 16K), the number doesn't even make sense as it's
rounded down.

In factor kernel doesn't ever output such divided result in its
print-tree.c

Remove it so later reader won't wonder what the number means.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index a09ecfbb28f0..31f6fa12522f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1420,9 +1420,8 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 		btrfs_disk_key_to_cpu(&key, &disk_key);
 		printf("\t");
 		btrfs_print_key(&disk_key);
-		printf(" block %llu (%llu) gen %llu\n",
+		printf(" block %llu gen %llu\n",
 		       (unsigned long long)blocknr,
-		       (unsigned long long)blocknr / eb->len,
 		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
 		fflush(stdout);
 	}
-- 
2.18.0
