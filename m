From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/3] btrfs cleanup: remove more dead code
Date: Sat, 20 Mar 2010 14:37:31 +0300
Message-ID: <20100320113730.GZ5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

rb_node cannot be an ERR_PTR() here so I removed the misleading check.
Also I removed some more dead code at the bottom.

It looks like the code from lookup_extent_mapping() may have been 
copy and pasted into search_extent_mapping()?

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This doesn't change anything.  Could you put it into linux-next?

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 94668b1..010f299 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -380,16 +380,7 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 		em = NULL;
 		goto out;
 	}
-	if (IS_ERR(rb_node)) {
-		em = ERR_PTR(PTR_ERR(rb_node));
-		goto out;
-	}
 	em = rb_entry(rb_node, struct extent_map, rb_node);
-	goto found;
-
-	em = NULL;
-	goto out;
-
 found:
 	atomic_inc(&em->refs);
 out:
