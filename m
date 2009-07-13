From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 4/4] Btrfs: Remove broken sanity check from
 btrfs_rmap_block()
Date: Mon, 13 Jul 2009 15:12:02 +0100
Message-ID: <1247494322.19180.271.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It was never actually doing anything anyway (see the loop condition),
and it would be a PITA to make it work for RAID[56].

Even if it was actually working, it's checking for the wrong thing
anyway. Instead of checking whether we list a block which _doesn't_ land
at the relevant physical location, it should be checking that we _have_
listed all the logical blocks which refer to the required physical
location on all devices.

This function is only called from remove_sb_from_cache() to ensure that
we reserve the logical blocks which would reside at the same physical
location as the superblock copies. So listing more blocks than we need
is actually OK.

With RAID[56] we're going to throw away an entire stripe for each block
we have to ignore, so we _are_ going to list blocks other than the
ones which actually contain the superblock.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 fs/btrfs/volumes.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3ab80e9..f1f10ea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2795,26 +2795,6 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		}
 	}
 
-	for (i = 0; i > nr; i++) {
-		struct btrfs_multi_bio *multi;
-		struct btrfs_bio_stripe *stripe;
-		int ret;
-
-		length = 1;
-		ret = btrfs_map_block(map_tree, WRITE, buf[i],
-				      &length, &multi, 0);
-		BUG_ON(ret);
-
-		stripe = multi->stripes;
-		for (j = 0; j < multi->num_stripes; j++) {
-			if (stripe->physical >= physical &&
-			    physical < stripe->physical + length)
-				break;
-		}
-		BUG_ON(j >= multi->num_stripes);
-		kfree(multi);
-	}
-
 	*logical = buf;
 	*naddrs = nr;
 	*stripe_len = map->stripe_len;
-- 
1.6.2.5

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

