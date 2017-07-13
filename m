Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35482 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751193AbdGMNUA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 09:20:00 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15923AC7F
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 13:19:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS attribute
Date: Thu, 13 Jul 2017 15:18:44 +0200
Message-Id: <20170713131844.706-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the BTRFS_INODE_NOCOMPRESS will prevent any compression on a
given file, except when the mount is force-compress. As users have
reported on IRC, this will also prevent compression when requested by
defrag (btrfs fi defrag -c file).

The nocompress flag is set automatically by filesystem when the ratios
are bad and the user would have to manually drop the bit in order to
make defrag -c work. This is not good from the usability perspective.

This patch will raise priority for the defrag -c over nocompress, ie.
any file with NOCOMPRESS bit set will get defragmented. The bit will
remain untouched.

Alternate option was to also drop the nocompress bit and keep the
decision logic as is, but I think this is not the right solution.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d3c6ac960fd..ea2f02ec0394 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -399,12 +399,14 @@ static inline int inode_need_compress(struct inode *inode)
 	/* force compress */
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
 		return 1;
+	/* force compress when called from defrag */
+	if (BTRFS_I(inode)->force_compress)
+		return 1;
 	/* bad compression ratios */
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
 		return 0;
 	if (btrfs_test_opt(fs_info, COMPRESS) ||
-	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
-	    BTRFS_I(inode)->force_compress)
+	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)
 		return 1;
 	return 0;
 }
-- 
2.13.0

