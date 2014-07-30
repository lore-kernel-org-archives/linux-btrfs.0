Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbaG3RSv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 13:18:51 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, adilger@dilger.ca, hch@infradead.org,
        mfasheh@suse.com, viro@zeniv.linux.org.uk, david@fromorbit.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
Date: Wed, 30 Jul 2014 19:18:49 +0200
Message-Id: <e5169714fe455897e50208721b6d92828ba9ea22.1406739708.git.dsterba@suse.cz>
In-Reply-To: <cover.1406739708.git.dsterba@suse.cz>
References: <cover.1406739708.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Compressed extents set the physical length and the corresponging extent
flags.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c85da2e54ce7..12771d64b74e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4272,6 +4272,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	while (!end) {
 		u64 offset_in_extent = 0;
+		u64 em_phys_len = 0;
 
 		/* break if the extent we found is outside the range */
 		if (em->start >= max || extent_map_end(em) < off)
@@ -4334,8 +4335,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			if (ref_cnt > 1)
 				flags |= FIEMAP_EXTENT_SHARED;
 		}
-		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
-			flags |= FIEMAP_EXTENT_ENCODED;
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
+			flags |= FIEMAP_EXTENT_ENCODED |
+				 FIEMAP_EXTENT_DATA_COMPRESSED |
+				 FIEMAP_EXTENT_PHYS_LENGTH;
+			em_phys_len = em->block_len;
+		}
 
 		free_extent_map(em);
 		em = NULL;
@@ -4357,7 +4362,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			end = 1;
 		}
 		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-					      em_len, 0, flags);
+					      em_len, em_phys_len, flags);
 		if (ret)
 			goto out_free;
 	}
-- 
1.8.4.5

