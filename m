Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbeHCHpH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 03:45:07 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3E83AFA5
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 05:50:27 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs-progs: Exit gracefully if we hit ENOSPC when allocating tree block
Date: Fri,  3 Aug 2018 13:50:17 +0800
Message-Id: <20180803055022.9816-2-wqu@suse.com>
In-Reply-To: <20180803055022.9816-1-wqu@suse.com>
References: <20180803055022.9816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running test fuzz/003, we could hit the following BUG_ON:
------
====== RUN MAYFAIL /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-155621-bad-block-group-offset.raw.restored
Unable to find block group for 0
Unable to find block group for 0
Unable to find block group for 0
extent-tree.c:2657: alloc_tree_block: BUG_ON `ret` triggered, value -28
failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-155621-bad-block-group-offset.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 003-multi-check-unmounted
------

Just remove that BUG_ON() and allow us to exit gracefully.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index b9d51b388c9a..a1f711ece7a8 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2654,7 +2654,10 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_reserve_extent(trans, root, num_bytes, empty_size,
 				   hint_byte, search_end, ins, 0);
-	BUG_ON(ret);
+	if (ret < 0) {
+		btrfs_free_delayed_extent_op(extent_op);
+		return ret;
+	}
 
 	if (key)
 		memcpy(&extent_op->key, key, sizeof(extent_op->key));
-- 
2.18.0

