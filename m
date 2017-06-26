Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43421 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbdFZSfj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 14:35:39 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [Patch v2] Btrfs-progs: fix infinite loop in find_free_extent
Date: Mon, 26 Jun 2017 11:34:41 -0600
Message-Id: <20170626173441.28275-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the found %ins is crossing a stripe len, ie. BTRFS_STRIPE_LEN, we'd
search again with a stripe-aligned %search_start.  The current code
calculates %search_start by adding a wrong offset, in order to fix it, the
start position of the block group should be taken, otherwise, it'll end up
with looking at the same block group forever.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: - enhance commit log with more details.
    - fix typo on bg_cache->key.objectid.

 extent-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 3e32e43..2c73d46 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2614,8 +2614,9 @@ check_failed:
 				goto no_bg_cache;
 			bg_offset = ins->objectid - bg_cache->key.objectid;
 
-			search_start = round_up(bg_offset + num_bytes,
-						BTRFS_STRIPE_LEN) + bg_offset;
+			search_start = round_up(
+				bg_offset + num_bytes, BTRFS_STRIPE_LEN) +
+				bg_cache->key.objectid;
 			goto new_group;
 		}
 no_bg_cache:
-- 
2.5.0

