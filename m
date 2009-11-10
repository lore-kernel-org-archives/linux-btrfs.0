From: Dan Carpenter <error27@gmail.com>
Subject: [patch] avoid null deref in unpin_extent_cache()
Date: Tue, 10 Nov 2009 11:01:43 +0200 (SAST)
Message-ID: <alpine.DEB.2.00.0911072313580.30287@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I re-orderred the checks to avoid dereferencing "em" if it was null.

Found by smatch static checker.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/extent_map.c	2009-11-08 14:01:09.000000000 +0200
+++ devel/fs/btrfs/extent_map.c	2009-11-08 14:01:44.000000000 +0200
@@ -208,7 +208,7 @@
 	write_lock(&tree->lock);
 	em = lookup_extent_mapping(tree, start, len);
 
-	WARN_ON(em->start != start || !em);
+	WARN_ON(!em || em->start != start);
 
 	if (!em)
 		goto out;
