Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37980 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751415Ab3KDVg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:36:58 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] btrfs: remove unused variable from btrfs_search_forward
Date: Mon,  4 Nov 2013 22:34:21 +0100
Message-Id: <1383600869-10085-2-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable blockptr in btrfs_search_forward is not used since commit
de78b51a2852bddccd6535e9e12de65f92787a1e
(btrfs: remove cache only arguments from defrag path)

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/ctree.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 61b5bcd..ea20801 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4911,10 +4911,8 @@ again:
 		 * If it is too old, old, skip to the next one.
 		 */
 		while (slot < nritems) {
-			u64 blockptr;
 			u64 gen;
 
-			blockptr = btrfs_node_blockptr(cur, slot);
 			gen = btrfs_node_ptr_generation(cur, slot);
 			if (gen < min_trans) {
 				slot++;
-- 
1.7.10.4

