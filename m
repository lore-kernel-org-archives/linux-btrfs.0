Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60649 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab2HDHpJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Aug 2012 03:45:09 -0400
Date: Sat, 4 Aug 2012 15:45:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        BTRFS FILE SYSTEM <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: fix second lock in btrfs_delete_delayed_items()
Message-ID: <20120804074502.GB13700@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix a real bug caught by coccinelle.

fs/btrfs/delayed-inode.c:1013:1-11: second lock on line 1013

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 fs/btrfs/delayed-inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux.orig/fs/btrfs/delayed-inode.c	2012-08-03 15:36:21.763560787 +0800
+++ linux/fs/btrfs/delayed-inode.c	2012-08-04 15:37:33.370210331 +0800
@@ -1028,9 +1028,10 @@ do_again:
 		btrfs_release_delayed_item(prev);
 		ret = 0;
 		btrfs_release_path(path);
-		if (curr)
+		if (curr) {
+			mutex_unlock(&node->mutex);
 			goto do_again;
-		else
+		} else
 			goto delete_fail;
 	}
 
