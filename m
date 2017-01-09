Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35044 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940010AbdAIOjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2017 09:39:11 -0500
From: Michal Hocko <mhocko@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH 1/2] etrfs: fix up misleading GFP_NOFS usage in btrfs_releasepage
Date: Mon,  9 Jan 2017 15:39:02 +0100
Message-Id: <20170109143903.32280-1-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

b335b0034e25 ("Btrfs: Avoid using __GFP_HIGHMEM with slab allocator")
has reduced the allocation mask in btrfs_releasepage to GFP_NOFS just
to prevent from giving an unappropriate gfp mask to the slab allocator
deeper down the callchain (in alloc_extent_state). This is wrong for
two reasons a) GFP_NOFS might be just too restrictive for the calling
context b) it is better to tweak the gfp mask down when it needs that.

So just remove the mask tweaking from btrfs_releasepage and move it
down to alloc_extent_state where it is needed.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/btrfs/extent_io.c | 5 +++++
 fs/btrfs/inode.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b38150eec6b4..f6ae94a4acad 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -226,6 +226,11 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
 
+	/*
+	 * The given mask might be not appropriate for the slab allocator,
+	 * drop the unsupported bits
+	 */
+	mask &= ~(__GFP_DMA32|__GFP_HIGHMEM);
 	state = kmem_cache_alloc(extent_state_cache, mask);
 	if (!state)
 		return state;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index baa40d34d2c9..d118d4659c28 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8994,7 +8994,7 @@ static int btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	if (PageWriteback(page) || PageDirty(page))
 		return 0;
-	return __btrfs_releasepage(page, gfp_flags & GFP_NOFS);
+	return __btrfs_releasepage(page, gfp_flags);
 }
 
 static void btrfs_invalidatepage(struct page *page, unsigned int offset,
-- 
2.11.0

