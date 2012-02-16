From: Vincenzo Laurenziello <vincenx@fastwebnet.it>
Subject: [PATCH] Cleanup useless lines
Date: Thu, 16 Feb 2012 20:37:00 +0100
Message-ID: <1329421020.20228.5.camel@icarus>
Reply-To: vinx83@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes two useless calls of btrfs_header_nritems() in balance_level().

Signed-off-by: Vincenzo Laurenziello <vinx83@gmail.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
--- a/fs/btrfs/ctree.c	2012-02-13 20:17:29.000000000 +0100
+++ b/fs/btrfs/ctree.c	2012-02-16 19:44:59.830817118 +0100
@@ -966,8 +966,6 @@ static noinline int balance_level(struct
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	btrfs_header_nritems(mid);
-
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
 		btrfs_tree_lock(left);
@@ -997,7 +995,6 @@ static noinline int balance_level(struct
 		wret = push_node_left(trans, root, left, mid, 1);
 		if (wret < 0)
 			ret = wret;
-		btrfs_header_nritems(mid);
 	}
 
 	/*
---


