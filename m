Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755246AbeDTOYX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E06EDAEBF
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: add zeroing clear operation
Date: Fri, 20 Apr 2018 16:21:50 +0200
Message-Id: <b763205a723aff19e895b7634a19d92a6897a868.1524233244.git.dsterba@suse.com>
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
References: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/extent-tree.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7cde72683b8e..772cb4ccc5f7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -679,6 +679,7 @@ struct btrfs_stripe_hash {
  */
 enum btrfs_clear_op_type {
 	BTRFS_CLEAR_OP_DISCARD = 0,
+	BTRFS_CLEAR_OP_ZERO,
 	BTRFS_NR_CLEAR_OP_TYPES,
 };
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b317f8ee42a9..800aaf45e6bd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2041,6 +2041,9 @@ static int btrfs_issue_clear_op(struct block_device *bdev, u64 start, u64 size,
 	case BTRFS_CLEAR_OP_DISCARD:
 		return blkdev_issue_discard(bdev, start >> 9, size >> 9,
 				GFP_NOFS, 0);
+	case BTRFS_CLEAR_OP_ZERO:
+		return blkdev_issue_zeroout(bdev, start >> 9, size >> 9,
+				GFP_NOFS, 0);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.16.2

