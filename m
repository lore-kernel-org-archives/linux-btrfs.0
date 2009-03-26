From: Dan Carpenter <error27@gmail.com>
Subject: btrfs:  dereferencing freed memory
Date: Thu, 26 Mar 2009 16:42:48 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261641070.31773@usbsys.site>
References: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0903261633260.31773@usbsys.site>
List-ID: <linux-btrfs.vger.kernel.org>

This was found by smatch (http://repo.or.cz/w/smatch.git/)

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>
--- orig/fs/btrfs/async-thread.c	2009-03-26 16:36:46.000000000 +0300
+++ devel/fs/btrfs/async-thread.c	2009-03-26 16:39:08.000000000 +0300
@@ -278,8 +278,8 @@
 					   workers->num_workers + i);
 		worker->workers = workers;
 		if (IS_ERR(worker->task)) {
-			kfree(worker);
 			ret = PTR_ERR(worker->task);
+			kfree(worker);
 			goto fail;
 		}
 
