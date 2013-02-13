Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34835 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3BMU7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 15:59:44 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so894088eei.3
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 12:59:43 -0800 (PST)
From: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 1/2] Minor format cleanup.
Date: Wed, 13 Feb 2013 21:59:23 +0100
Message-Id: <d04639dcfe579f19e0ce3d4fe1fa3b034df03998.1360786936.git.philipp.andreas@gmail.com>
In-Reply-To: <cover.1360786935.git.philipp.andreas@gmail.com>
References: <cover.1360786935.git.philipp.andreas@gmail.com>
In-Reply-To: <cover.1360786935.git.philipp.andreas@gmail.com>
References: <cover.1360786935.git.philipp.andreas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean up the format of the definitions of BTRFS_BLOCK_GROUP_RAID5 and
BTRFS_BLOCK_GROUP_RAID6.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 fs/btrfs/ctree.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e3a4fd7..ea688aa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -954,8 +954,8 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
-#define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
-#define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
+#define BTRFS_BLOCK_GROUP_RAID5         (1ULL << 7)
+#define BTRFS_BLOCK_GROUP_RAID6         (1ULL << 8)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 #define BTRFS_NR_RAID_TYPES		7
 
-- 
1.7.12.4

