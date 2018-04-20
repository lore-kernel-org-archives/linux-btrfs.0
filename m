Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755160AbeDTOY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C830BAEBF
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:28 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: add more zeroout modes for clearing unused space
Date: Fri, 20 Apr 2018 16:21:57 +0200
Message-Id: <aed736d257f7e91cf3b0cf4d1fdfc247212d8bf7.1524233244.git.dsterba@suse.com>
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
References: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c     | 12 +++++++++++-
 include/uapi/linux/btrfs.h |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 285bace8e2c6..bd2ac5779998 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2046,9 +2046,19 @@ static int btrfs_issue_clear_op(struct block_device *bdev, u64 start, u64 size,
 	case BTRFS_CLEAR_OP_DISCARD:
 		return blkdev_issue_discard(bdev, start >> 9, size >> 9,
 				GFP_NOFS, flags);
+	case BTRFS_CLEAR_OP_ZERO_NOUNMAP:
+		flags = BLKDEV_ZERO_NOUNMAP;
+		goto zeroout;
+	case BTRFS_CLEAR_OP_ZERO_NOFALLBACK:
+		flags = BLKDEV_ZERO_NOFALLBACK;
+		goto zeroout;
+	case BTRFS_CLEAR_OP_ZERO_NOUNMAP_NOFALLBACK:
+		flags = BLKDEV_ZERO_NOUNMAP | BLKDEV_ZERO_NOFALLBACK;
+		/* fall through */
 	case BTRFS_CLEAR_OP_ZERO:
+zeroout:
 		return blkdev_issue_zeroout(bdev, start >> 9, size >> 9,
-				GFP_NOFS, 0);
+				GFP_NOFS, flags);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 1becbb241e53..5d1f13045906 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -744,6 +744,11 @@ enum btrfs_clear_op_type {
 	BTRFS_CLEAR_OP_DISCARD = 0,
 	BTRFS_CLEAR_OP_ZERO,
 	BTRFS_CLEAR_OP_DISCARD_SECURE,
+
+	/* Fine tuning for clearing by zeros, see __blkdev_issue_zeroout */
+	BTRFS_CLEAR_OP_ZERO_NOUNMAP,
+	BTRFS_CLEAR_OP_ZERO_NOFALLBACK,
+	BTRFS_CLEAR_OP_ZERO_NOUNMAP_NOFALLBACK,
 	BTRFS_NR_CLEAR_OP_TYPES,
 };
 
-- 
2.16.2

