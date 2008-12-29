From: Diego Calleja <diegocg@gmail.com>
Subject: [PATCH] __must_check btrfs_alloc_path()
Date: Mon, 29 Dec 2008 22:02:04 +0100
Message-ID: <20081229220204.65d99bb1@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

IMHO it's a good thing to add __must_check in new code where it has sense.


Index: btrfs-unstable-standalone/ctree.c
===================================================================
--- btrfs-unstable-standalone.orig/ctree.c	2008-12-29 21:57:15.366588465 +0100
+++ btrfs-unstable-standalone/ctree.c	2008-12-29 21:58:06.878588402 +0100
@@ -43,7 +43,7 @@
 	memset(p, 0, sizeof(*p));
 }
 
-struct btrfs_path *btrfs_alloc_path(void)
+struct btrfs_path __must_check *btrfs_alloc_path(void)
 {
 	struct btrfs_path *path;
 	path = kmem_cache_alloc(btrfs_path_cachep, GFP_NOFS);
