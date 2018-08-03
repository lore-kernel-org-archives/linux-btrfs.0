Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41538 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbeHCHpO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 03:45:14 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E714FAF76
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 05:50:34 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs-progs: Exit gracefull when we failed to alloc dev extent
Date: Fri,  3 Aug 2018 13:50:21 +0800
Message-Id: <20180803055022.9816-6-wqu@suse.com>
In-Reply-To: <20180803055022.9816-1-wqu@suse.com>
References: <20180803055022.9816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another BUG_ON() during fuzz/003:
------
====== RUN MAYFAIL /home/adam/btrfs/btrfs-progs/btrfs check --repair /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-199833-reloc-recovery-crash.raw.restored
[1/7] checking root items
Fixed 0 roots.
[2/7] checking extents
ctree.c:1650: leaf_space_used: Warning: assertion `data_len < 0` failed, value 1
bad key ordering 18 19
bad block 29409280
ERROR: errors found in extent allocation tree or chunk allocation
WARNING: minor unaligned/mismatch device size detected
WARNING: recommended to use 'btrfs rescue fix-device-size' to fix it
[3/7] checking free space cache
[4/7] checking fs roots
ctree.c:1650: leaf_space_used: Warning: assertion `data_len < 0` failed, value 1
bad key ordering 18 19
root 18446744073709551608 missing its root dir, recreating
Unable to find block group for 0
Unable to find block group for 0
Unable to find block group for 0
volumes.c:564: btrfs_alloc_dev_extent: BUG_ON `ret` triggered, value -28
failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --repair /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-199833-reloc-recovery-crash.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 003-multi-check-unmounted
------

However the culprit function btrfs_alloc_dev_extent() has proper error
handler tag err:, just use that tag would solve the problem easily.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index d81b348eb14d..f7a413b71d52 100644
--- a/volumes.c
+++ b/volumes.c
@@ -561,7 +561,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*extent));
-	BUG_ON(ret);
+	if (ret < 0)
+		goto err;
 
 	leaf = path->nodes[0];
 	extent = btrfs_item_ptr(leaf, path->slots[0],
-- 
2.18.0

