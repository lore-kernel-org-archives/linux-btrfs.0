Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48562 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2HVKMm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 06:12:42 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7MACe4X013090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 10:12:40 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7MACdxA002064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 10:12:40 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7MACdUi017982
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 05:12:39 -0500
From: bo.li.liu@oracle.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a dio write regression
Date: Wed, 22 Aug 2012 18:11:14 +0800
Message-Id: <1345630274-16242-1-git-send-email-bo.li.liu@oracle.com>
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
 fs/btrfs/inode.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7131fac..e4ab92b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5993,10 +5993,24 @@ unlock:
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
+					 lockstart + len, lockend, unlock_bits |
+					 EXTENT_DO_ACCOUNTING, 1, 0, NULL,
+					 GFP_NOFS);
+		} else
+			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+					 lockend, unlock_bits, 1, 0,
+					 &cached_state, GFP_NOFS);
+	} else
 		free_extent_state(cached_state);
 
 	free_extent_map(em);
-- 
1.7.7.6

