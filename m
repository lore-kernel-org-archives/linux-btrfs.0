From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: remove dead code
Date: Thu, 26 Mar 2009 17:10:11 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261708330.1976@usbsys.site>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
 <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
List-ID: <linux-btrfs.vger.kernel.org>

merge is always NULL at this point.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/extent_map.c	2009-03-26 17:07:20.000000000 +0300
+++ devel/fs/btrfs/extent_map.c	2009-03-26 17:07:39.000000000 +0300
@@ -234,7 +234,6 @@
 	rb = tree_insert(&tree->map, em->start, &em->rb_node);
 	if (rb) {
 		ret = -EEXIST;
-		free_extent_map(merge);
 		goto out;
 	}
 	atomic_inc(&em->refs);
