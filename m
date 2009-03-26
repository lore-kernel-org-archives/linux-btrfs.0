From: Dan Carpenter <error27@gmail.com>
Subject: btrfs:  returning under lock
Date: Thu, 26 Mar 2009 16:45:26 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903261643560.31773@usbsys.site>
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

--- orig/fs/btrfs/transaction.c	2009-03-26 16:25:37.000000000 +0300
+++ devel/fs/btrfs/transaction.c	2009-03-26 16:26:36.000000000 +0300
@@ -914,8 +914,10 @@
 	}
 
 	pinned_copy = kmalloc(sizeof(*pinned_copy), GFP_NOFS);
-	if (!pinned_copy)
+	if (!pinned_copy) {
+		mutex_unlock(&root->fs_info->trans_mutex);
 		return -ENOMEM;
+	}
 
 	extent_io_tree_init(pinned_copy,
 			     root->fs_info->btree_inode->i_mapping, GFP_NOFS);
