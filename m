Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754698AbdGNRgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 13:36:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2FFC2AAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 17:36:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/5] btrfs: defrag: make readahead state allocation failure non-fatal
Date: Fri, 14 Jul 2017 19:35:23 +0200
Message-Id: <42a7e40bf0bc8b52f4e958e76e9a1421a472edce.1500053599.git.dsterba@suse.com>
In-Reply-To: <cover.1500053599.git.dsterba@suse.com>
References: <cover.1500053599.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All sorts of readahead errors are not considered fatal. We can continue
defragmentation without it, with some potential slow down, which will
last only for the current inode.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d260c4c57338..f418d29b0b92 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1304,14 +1304,14 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		extent_thresh = SZ_256K;
 
 	/*
-	 * if we were not given a file, allocate a readahead
-	 * context
+	 * If we were not given a file, allocate a readahead context. As
+	 * readahead is just an optimization, defrag will work without it so
+	 * we don't error out.
 	 */
 	if (!file) {
 		ra = kzalloc(sizeof(*ra), GFP_KERNEL);
-		if (!ra)
-			return -ENOMEM;
-		file_ra_state_init(ra, inode->i_mapping);
+		if (ra)
+			file_ra_state_init(ra, inode->i_mapping);
 	} else {
 		ra = &file->f_ra;
 	}
@@ -1394,8 +1394,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 
 		if (i + cluster > ra_index) {
 			ra_index = max(i, ra_index);
-			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
-				       cluster);
+			if (ra)
+				btrfs_force_ra(inode->i_mapping, ra, file,
+						ra_index, cluster);
 			ra_index += cluster;
 		}
 
-- 
2.13.0

