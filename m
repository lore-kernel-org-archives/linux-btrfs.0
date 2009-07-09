From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] btrfs: Fix partial discard on RAID1
Date: Fri, 10 Jul 2009 00:02:12 +0100
Message-ID: <1247180532.7423.5.camel@macbook.infradead.org>
References: <2c3b11250812290723t74c1f505jb0ffc8c66ebe1ead@mail.gmail.com>
	 <3d0408630901010457p5440f053tbf4fe86b2697c9cc@mail.gmail.com>
	 <2c3b11250901030733y9cf8994w984a4c110f42f4d0@mail.gmail.com>
	 <1247180277.7423.1.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yan Zheng <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Liu Hui <onlyflyer@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247180277.7423.1.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_discard_extent() we were only discarding half of a RAID1 or
RAID10 extent.

We should be telling btrfs_map_block() that we want to write, so it
tells us about _all_ mirrors. If we tell it we're going to read, it'll
only tell us about a single mirror at a time.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
Untested. Does anyone have any real devices that do TRIM yet, or do I
need to hack up an FTL to do it again?

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a5aca39..1496925 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1421,7 +1421,7 @@ static int btrfs_discard_extent(struct btrfs_root
*root, u64 bytenr,
 	struct btrfs_multi_bio *multi = NULL;
 
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
+	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
 			      bytenr, &map_length, &multi, 0);
 	if (!ret) {
 		struct btrfs_bio_stripe *stripe = multi->stripes;

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

