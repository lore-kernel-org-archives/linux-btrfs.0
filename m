Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3LLP0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 10:26:07 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, adilger@dilger.ca, hch@infradead.org,
        mfasheh@suse.com, viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4 v3] btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
Date: Thu, 12 Dec 2013 16:26:00 +0100
Message-Id: <297798211d549d0c0c32994fd0de0ab24c765e77.1386778303.git.dsterba@suse.cz>
In-Reply-To: <cover.1386778302.git.dsterba@suse.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
In-Reply-To: <cover.1386778302.git.dsterba@suse.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Set the EXTENT_DATA_COMPRESSED flag together with EXTENT_ENCODED as
defined by fiemap spec.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ea0ef5..8a28f15 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4158,6 +4158,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	while (!end) {
 		u64 offset_in_extent = 0;
+		u64 em_phys_len;
 
 		/* break if the extent we found is outside the range */
 		if (em->start >= max || extent_map_end(em) < off)
@@ -4182,6 +4183,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		em_end = extent_map_end(em);
 		em_len = em_end - em_start;
 		emflags = em->flags;
+		em_phys_len = em->len;
 		disko = 0;
 		flags = 0;
 
@@ -4220,9 +4222,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 			if (ref_cnt > 1)
 				flags |= FIEMAP_EXTENT_SHARED;
+			em_phys_len = em->block_len;
 		}
-		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 			flags |= FIEMAP_EXTENT_ENCODED;
+			flags |= FIEMAP_EXTENT_DATA_COMPRESSED;
+		}
 
 		free_extent_map(em);
 		em = NULL;
@@ -4244,7 +4249,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			end = 1;
 		}
 		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-					      em_len, 0, flags);
+					      em_len, em_phys_len, flags);
 		if (ret)
 			goto out_free;
 	}
-- 
1.7.9

