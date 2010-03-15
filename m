From: Nick Piggin <npiggin@suse.de>
Subject: [patch] btrfs: fix gfp flags masking
Date: Tue, 16 Mar 2010 02:00:16 +1100
Message-ID: <20100315150016.GC2869@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nick Piggin <npiggin@suse.de>
--
Index: linux-2.6/fs/btrfs/compression.c
===================================================================
--- linux-2.6.orig/fs/btrfs/compression.c
+++ linux-2.6/fs/btrfs/compression.c
@@ -478,7 +478,7 @@ static noinline int add_ra_bio_pages(str
 			goto next;
 		}
 
-		page = alloc_page(mapping_gfp_mask(mapping) | GFP_NOFS);
+		page = alloc_page(mapping_gfp_mask(mapping) & ~__GFP_FS);
 		if (!page)
 			break;
 
