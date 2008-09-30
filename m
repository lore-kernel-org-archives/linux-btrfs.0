From: Jim Meyering <jim@meyering.net>
Subject: NULL-deref and leak fixes: rebased against new git tree
Date: Tue, 30 Sep 2008 10:13:05 +0200
Message-ID: <877i8uvypa.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I posted two patches during the wrong week (plumbers),
so you may have missed them on the mailing list:

    http://article.gmane.org/gmane.comp.file-systems.btrfs/1222
    http://article.gmane.org/gmane.comp.file-systems.btrfs/1223

Since then, the official tree converted to using git, so I've
rebased the patches against it and adjusted the log messages:


>From 494bed7b1f361c13d22b9c4e0a0e7205e2eb3d19 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Sun, 14 Sep 2008 22:08:09 +0200
Subject: [PATCH] Btrfs: disk-io.c (open_ctree): Don't deref. NULL upon failed kzalloc

---
 fs/btrfs/disk-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5ee10d3..a20b034 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1371,7 +1371,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	struct btrfs_super_block *disk_super;
 
-	if (!extent_root || !tree_root || !fs_info) {
+	if (!extent_root || !tree_root || !fs_info
+	    || !chunk_root || !dev_root) {
 		err = -ENOMEM;
 		goto fail;
 	}
-- 
1.6.0.2.27.gea240


>From 5a675eb3d8b745cd6d3fba59cc122eca8ad45b80 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Tue, 30 Sep 2008 10:05:21 +0200
Subject: [PATCH] Btrfs: disk-io.c (open_ctree): avoid leaks-upon-allocation-failure

---
 fs/btrfs/disk-io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a20b034..d956b0e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1699,6 +1699,8 @@ fail:
 	kfree(tree_root);
 	bdi_destroy(&fs_info->bdi);
 	kfree(fs_info);
+	kfree(chunk_root);
+	kfree(dev_root);
 	return ERR_PTR(err);
 }
 
-- 
1.6.0.2.27.gea240

