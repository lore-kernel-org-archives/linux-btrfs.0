Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37988 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751415Ab3KDVhA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:37:00 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: remove unused variable from setup_cluster_no_bitmap
Date: Mon,  4 Nov 2013 22:34:26 +0100
Message-Id: <1383600869-10085-7-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable window_start in setup_cluster_no_bitmap is not used since commit
1bb91902dc90e25449893e693ad45605cb08fbe5
(Btrfs: revamp clustered allocation logic)

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/free-space-cache.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4f419ba..05395cd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2419,7 +2419,6 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	struct btrfs_free_space *entry = NULL;
 	struct btrfs_free_space *last;
 	struct rb_node *node;
-	u64 window_start;
 	u64 window_free;
 	u64 max_extent;
 	u64 total_size = 0;
@@ -2441,7 +2440,6 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	}
 
-	window_start = entry->offset;
 	window_free = entry->bytes;
 	max_extent = entry->bytes;
 	first = entry;
-- 
1.7.10.4

