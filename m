From: Dan Carpenter <error27@gmail.com>
Subject: [patch] unreached code in ctree.c
Date: Fri, 27 Mar 2009 13:33:51 +0300 (EAT)
Message-ID: <Pine.LNX.4.64.0903270733320.5354@usbsys.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Smatch (http://repo.or.cz/w/smatch.git/) complains about this unreachable 
code so I moved the break; up a line.  Compile tested.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/btrfs/ctree.c	2009-03-27 07:31:42.000000000 +0300
+++ devel/fs/btrfs/ctree.c	2009-03-27 07:32:26.000000000 +0300
@@ -3318,8 +3318,8 @@
 	for (i = 0; i < nr; i++) {
 		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 		    BTRFS_LEAF_DATA_SIZE(root)) {
-			break;
 			nr = i;
+			break;
 		}
 		total_data += data_size[i];
 		total_size += data_size[i] + sizeof(struct btrfs_item);
