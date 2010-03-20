From: Dan Carpenter <error27@gmail.com>
Subject: [patch 1/3] btrfs cleanup: remove dead code
Date: Sat, 20 Mar 2010 14:26:05 +0300
Message-ID: <20100320112605.GY5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, Dan Carpenter <error27@gmail.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

rb_node is never an ERR_PTR() here.  This code confuses smatch.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This doesn't change anything.  It's just a cleanup.  Could you load
it up for linux-next?

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 28d87ba..94668b1 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -335,10 +335,6 @@ struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
 		em = NULL;
 		goto out;
 	}
-	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
-		goto out;
-	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
 	if (end > em->start && start < extent_map_end(em))
 		goto found;
