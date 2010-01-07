From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: remove dead code
Date: Thu, 7 Jan 2010 18:25:44 +0300
Message-ID: <20100107152544.GC8134@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

rb_node cannot be an ERR_PTR() here.  Both implimentations of __tree_search()
return either a valid pointer or NULL.

It doesn't make a runtime difference but without this patch smatch thinks that
lookup_extent_mapping() can return an ERR_PTR().  It can wait until 2.6.34 
obviously.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/extent_map.c	2010-01-07 10:50:30.000000000 +0300
+++ devel/fs/btrfs/extent_map.c	2010-01-07 10:50:40.000000000 +0300
@@ -349,10 +349,6 @@ struct extent_map *lookup_extent_mapping
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
