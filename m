From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: do not set EXTENT_DIRTY along with EXTENT_DELALLOC
Date: Thu, 29 Sep 2011 15:55:28 +0800
Message-ID: <1317282928-18830-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d418164..00e4ca9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -919,7 +919,7 @@ int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask)
 {
 	return set_extent_bit(tree, start, end,
-			      EXTENT_DELALLOC | EXTENT_DIRTY | EXTENT_UPTODATE,
+			      EXTENT_DELALLOC | EXTENT_UPTODATE,
 			      0, NULL, cached_state, mask);
 }
 
-- 
1.6.5.2

