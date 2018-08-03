Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbeHCHpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 03:45:12 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 266C1AF76
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 05:50:33 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs-progs: Fix infinite loop when failed to repair bad key order
Date: Fri,  3 Aug 2018 13:50:20 +0800
Message-Id: <20180803055022.9816-5-wqu@suse.com>
In-Reply-To: <20180803055022.9816-1-wqu@suse.com>
References: <20180803055022.9816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
An infinite loop can be triggered during fuzz/003:
------
====== RUN MAYFAIL /home/adam/btrfs/btrfs-progs/btrfs check --repair /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-199833-reloc-recovery-crash.raw.restored
[1/7] checking root items
Fixed 0 roots.
[2/7] checking extents
ctree.c:1650: leaf_space_used: Warning: assertion `data_len < 0` failed, value 1
bad key ordering 18 19
ctree.c:1650: leaf_space_used: Warning: assertion `data_len < 0` failed, value 1
bad key ordering 18 19
ctree.c:1650: leaf_space_used: Warning: assertion `data_len < 0` failed, value 1
bad key ordering 18 19
...
------

[CAUSE]
In try_to_fix_bad_block() it's possible that btrfs_find_all_roots()
finds no root referring to that tree block, thus we can't do any repair.

However in that case, we still return 0 since the last caller assigning
@ret is btrfs_find_all_roots(), and the ulist while loop doesn't get run
at all.

And since try_to_fix_bad_block() returns 0, check_block() in
check/main.c will return -EAGAIN to re-check the tree block.

This leads to the infinite loop.

[FIX]
Change the default return value from 0 to -EIO in
try_to_fix_bad_block(), so if there is no tree referring to the bad tree
block, it won't cause infinite loop any more.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/check/main.c b/check/main.c
index e6756e0f852b..571edc7ef928 100644
--- a/check/main.c
+++ b/check/main.c
@@ -4051,6 +4051,11 @@ static int try_to_fix_bad_block(struct btrfs_root *root,
 
 	btrfs_init_path(&path);
 	ULIST_ITER_INIT(&iter);
+	/*
+	 * If we found no roots referrening to this tree block, there is no
+	 * chance to fix. So our default ret is -EIO.
+	 */
+	ret = -EIO;
 	while ((node = ulist_next(roots, &iter))) {
 		root_key.objectid = node->val;
 		root_key.type = BTRFS_ROOT_ITEM_KEY;
-- 
2.18.0

