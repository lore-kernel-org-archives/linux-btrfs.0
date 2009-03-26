From: error27@gmail.com
Subject: btrfs:  memory leak on error path
Date: Thu, 26 Mar 2009 16:39:42 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This was found by smatch (http://repo.or.cz/w/smatch.git/)

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/volumes.c	2009-03-26 15:59:39.000000000 +0300
+++ devel/fs/btrfs/volumes.c	2009-03-26 16:00:28.000000000 +0300
@@ -342,6 +342,7 @@
 	return fs_devices;
 error:
 	free_fs_devices(fs_devices);
+	kfree(device);
 	return ERR_PTR(-ENOMEM);
 }
 
