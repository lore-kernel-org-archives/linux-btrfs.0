Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34331 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965255AbaDJDto (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:49:44 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 08/16] Btrfs: don't return space for dedup extent
Date: Thu, 10 Apr 2014 11:48:38 +0800
Message-Id: <1397101727-20806-9-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the ordered extent had an IOERR or something else went wrong we need to
return the space for this ordered extent back to the allocator, but if the
extent is marked as a dedup one, we don't free the space because we just
use the existing space instead of allocating new space.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8e031bf..0c1a43e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3213,6 +3213,7 @@ out:
 		 * truncated case if we didn't write out the extent at all.
 		 */
 		if ((ret || !logical_len) &&
+		    !ordered_extent->dedup &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(root, ordered_extent->start,
-- 
1.8.1.4

