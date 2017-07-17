Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36785 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751314AbdGQSrZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 14:47:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 773D6AAB9
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 18:47:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: allow defrag compress to override NOCOMPRESS attribute
Date: Mon, 17 Jul 2017 20:46:10 +0200
Message-Id: <afb29965ae24123bf6b5aa4d9390f42292a1796c.1500317040.git.dsterba@suse.com>
In-Reply-To: <cover.1500317040.git.dsterba@suse.com>
References: <cover.1500317040.git.dsterba@suse.com>
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
 fs/btrfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 14677535610b..d28441831ac6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -399,12 +399,12 @@ static inline int inode_need_compress(struct inode *inode)
 	/* force compress */
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
 		return 1;
-	/* bad compression ratios */
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
-		return 0;
 	/* defrag ioctl */
 	if (BTRFS_I(inode)->defrag_compress)
 		return 1;
+	/* bad compression ratios */
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
+		return 0;
 	if (btrfs_test_opt(fs_info, COMPRESS) ||
 	    BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
 	    BTRFS_I(inode)->prop_compress)
-- 
2.13.0

