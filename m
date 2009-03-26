From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: remove dead code #3
Date: Thu, 26 Mar 2009 17:20:38 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261716270.1976@usbsys.site>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
 <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
List-ID: <linux-btrfs.vger.kernel.org>

kzalloc() already initialized ->error to zero.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/volumes.c	2009-03-26 17:14:13.000000000 +0300
+++ devel/fs/btrfs/volumes.c	2009-03-26 17:14:55.000000000 +0300
@@ -2422,10 +2422,8 @@
 		multi = kzalloc(btrfs_multi_bio_size(stripes_allocated),
 				GFP_NOFS);
 		if (!multi)
 			return -ENOMEM;
-
-		atomic_set(&multi->error, 0);
 	}
 
 	spin_lock(&em_tree->lock);
 	em = lookup_extent_mapping(em_tree, logical, *length);
