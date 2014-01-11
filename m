Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48594 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAKV3L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 16:29:11 -0500
Received: by mail-wg0-f53.google.com with SMTP id k14so5404723wgh.32
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 13:29:10 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix btrfs_search_slot_for_read backwards iteration
Date: Sat, 11 Jan 2014 21:28:54 +0000
Message-Id: <1389475734-19236-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the current path's leaf slot is 0, we do search for the previous
leaf (via btrfs_prev_leaf) and set the new path's leaf slot to a
value corresponding to the number of items - 1 of the former leaf.
Fix this by using the slot set by btrfs_prev_leaf, decrementing it
by 1 if it's equal to the leaf's number of items.

Use of btrfs_search_slot_for_read() for backward iteration is used in
particular by the send feature, which could miss items when the input
leaf has less items than its previous leaf.

This could be reproduced by running btrfs/007 from xfstests in a loop.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9e9de68..7f4fe10 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3142,7 +3142,9 @@ again:
 			if (ret < 0)
 				return ret;
 			if (!ret) {
-				p->slots[0] = btrfs_header_nritems(leaf) - 1;
+				leaf = p->nodes[0];
+				if (p->slots[0] == btrfs_header_nritems(leaf))
+					p->slots[0]--;
 				return 0;
 			}
 			if (!return_any)
-- 
1.7.9.5

