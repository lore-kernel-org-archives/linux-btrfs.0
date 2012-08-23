Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46136 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2HWCMK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 22:12:10 -0400
From: bo.li.liu@oracle.com
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz
Subject: [PATCH v2] Btrfs: fix a dio write regression
Date: Thu, 23 Aug 2012 10:10:38 +0800
Message-Id: <1345687838-18002-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <bo.li.liu@oracle.com>

This bug is introduced by commit 3b8bde746f6f9bd36a9f05f5f3b6e334318176a9
(Btrfs: lock extents as we map them in DIO).

In dio write, we should unlock the section which we didn't do IO on in case that
we fall back to buffered write.  But we need to not only unlock the section
but also cleanup reserved space for the section.

This bug was found while running xfstests 133, with this 133 no longer complains.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v1->v2: apply style comments from David Sterba.

 fs/btrfs/inode.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7131fac..ea6a4ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5993,11 +5993,27 @@ unlock:
 	 * in the case of read we need to unlock only the end area that we
 	 * aren't using if there is any left over space.
 	 */
-	if (lockstart < lockend)
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				 unlock_bits, 1, 0, &cached_state, GFP_NOFS);
-	else
+	if (lockstart < lockend) {
+		if (create && len < lockend - lockstart) {
+			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+					 lockstart + len - 1, unlock_bits, 1, 0,
+					 &cached_state, GFP_NOFS);
+			/*
+			 * Beside unlock, we also need to cleanup reserved space
+			 * for the left range by attaching EXTENT_DO_ACCOUNTING.
+			 */
+			clear_extent_bit(&BTRFS_I(inode)->io_tree,
+					 lockstart + len, lockend,
+					 unlock_bits | EXTENT_DO_ACCOUNTING,
+					 1, 0, NULL, GFP_NOFS);
+		} else {
+			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+					 lockend, unlock_bits, 1, 0,
+					 &cached_state, GFP_NOFS);
+		}
+	} else {
 		free_extent_state(cached_state);
+	}
 
 	free_extent_map(em);
 
-- 
1.7.7.6

