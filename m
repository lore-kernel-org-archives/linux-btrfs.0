Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:46091 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:13 -0400
Received: by mail-qt0-f196.google.com with SMTP id d4-v6so11271525qtn.13
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:57 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t17-v6sm5048043qtj.50.2018.08.30.10.42.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:56 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/35] btrfs: loop in inode_rsv_refill
Date: Thu, 30 Aug 2018 13:42:06 -0400
Message-Id: <20180830174225.2200-17-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With severe fragmentation we can end up with our inode rsv size being
huge during writeout, which would cause us to need to make very large
metadata reservations.  However we may not actually need that much once
writeout is complete.  So instead try to make our reservation, and if we
couldn't make it re-calculate our new reservation size and try again.
If our reservation size doesn't change between tries then we know we are
actually out of space and can error out.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 064db7ebaf67..664b867ae499 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5769,10 +5769,11 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
-	u64 num_bytes = 0;
+	u64 num_bytes = 0, last = 0;
 	u64 qgroup_num_bytes = 0;
 	int ret = -ENOSPC;
 
+again:
 	spin_lock(&block_rsv->lock);
 	if (block_rsv->reserved < block_rsv->size)
 		num_bytes = block_rsv->size - block_rsv->reserved;
@@ -5797,8 +5798,22 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
 		spin_lock(&block_rsv->lock);
 		block_rsv->qgroup_rsv_reserved += qgroup_num_bytes;
 		spin_unlock(&block_rsv->lock);
-	} else
+	} else {
 		btrfs_qgroup_free_meta_prealloc(root, qgroup_num_bytes);
+
+		/*
+		 * If we are fragmented we can end up with a lot of outstanding
+		 * extents which will make our size be much larger than our
+		 * reserved amount.  If we happen to try to do a reservation
+		 * here that may result in us trying to do a pretty hefty
+		 * reservation, which we may not need once delalloc flushing
+		 * happens.  If this is the case try and do the reserve again.
+		 */
+		if (flush == BTRFS_RESERVE_FLUSH_ALL && last != num_bytes) {
+			last = num_bytes;
+			goto again;
+		}
+	}
 	return ret;
 }
 
-- 
2.14.3
