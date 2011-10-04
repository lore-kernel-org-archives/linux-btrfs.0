From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 34/65] btrfs: btrfs_init_compress should return void
Date: Mon, 03 Oct 2011 23:23:04 -0400
Message-ID: <20111004032303.818166320@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_init_compress doesn't have any failure conditions, so return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.h |    2 +-
 fs/btrfs/super.c       |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -732,7 +734,7 @@ struct btrfs_compress_op *btrfs_compress
 	&btrfs_lzo_compress,
 };
 
-int __init btrfs_init_compress(void)
+void __init btrfs_init_compress(void)
 {
 	int i;
 
@@ -742,7 +744,6 @@ int __init btrfs_init_compress(void)
 		atomic_set(&comp_alloc_workspace[i], 0);
 		init_waitqueue_head(&comp_workspace_wait[i]);
 	}
-	return 0;
 }
 
 /*

--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
-int btrfs_init_compress(void);
+void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1283,9 +1283,7 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		return err;
 
-	err = btrfs_init_compress();
-	if (err)
-		goto free_sysfs;
+	btrfs_init_compress();
 
 	err = btrfs_init_cachep();
 	if (err)
@@ -1326,7 +1324,6 @@ free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
 	btrfs_exit_compress();
-free_sysfs:
 	btrfs_exit_sysfs();
 	return err;
 }




