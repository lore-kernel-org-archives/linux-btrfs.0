From: Diego Calleja <diegocg@gmail.com>
Subject: [PATCH] Remove code duplication in comp_keys
Date: Fri, 24 Jul 2009 00:54:53 +0200
Message-ID: <200907240054.53667.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

comp_keys is duplicating what is done in btrfs_comp_cpu_keys, so just
call it.

Signed-off-by: Diego Calleja <diegocg@gmail.com>
---
 fs/btrfs/ctree.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

Index: linux/fs/btrfs/ctree.c
===================================================================
--- linux.orig/fs/btrfs/ctree.c	2009-07-24 00:47:20.936410297 +0200
+++ linux/fs/btrfs/ctree.c	2009-07-24 00:48:02.368160146 +0200
@@ -557,19 +557,7 @@ static int comp_keys(struct btrfs_disk_k
 
 	btrfs_disk_key_to_cpu(&k1, disk);
 
-	if (k1.objectid > k2->objectid)
-		return 1;
-	if (k1.objectid < k2->objectid)
-		return -1;
-	if (k1.type > k2->type)
-		return 1;
-	if (k1.type < k2->type)
-		return -1;
-	if (k1.offset > k2->offset)
-		return 1;
-	if (k1.offset < k2->offset)
-		return -1;
-	return 0;
+	return btrfs_comp_cpu_keys(&k1, k2);
 }
 
 /*

