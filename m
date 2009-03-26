From: Dan Carpenter <error27@gmail.com>
Subject: btrfs:  [patch] remove dead code
Date: Thu, 26 Mar 2009 17:04:38 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261702580.1976@usbsys.site>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
 <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903261650260.31773@usbsys.site>
List-ID: <linux-btrfs.vger.kernel.org>

This is a small clean up.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/disk-io.c	2009-03-26 17:00:57.000000000 +0300
+++ devel/fs/btrfs/disk-io.c	2009-03-26 17:01:44.000000000 +0300
@@ -1387,8 +1387,6 @@
 
 	ret = extent_range_uptodate(io_tree, start + length,
 				    start + buf_len - 1);
-	if (ret == 1)
-		return ret;
 	return ret;
 }
 

