From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 35/66] btrfs: btrfs_init_compress should return void
Date: Mon, 24 Oct 2011 21:03:11 -0400
Message-ID: <20111025010854.584600823@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_init_compress doesn't have any failure conditions, so return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.c |    3 +--
 fs/btrfs/compression.h |    2 +-
 fs/btrfs/super.c       |    5 +----
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index cca501b..0c0e842 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -734,7 +734,7 @@ struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_lzo_compress,
 };
 
-int __init btrfs_init_compress(void)
+void __init btrfs_init_compress(void)
 {
 	int i;
 
@@ -744,7 +744,6 @@ int __init btrfs_init_compress(void)
 		atomic_set(&comp_alloc_workspace[i], 0);
 		init_waitqueue_head(&comp_workspace_wait[i]);
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index a12059f..9afb0a6 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,7 +19,7 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
-int btrfs_init_compress(void);
+void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
 int btrfs_compress_pages(int type, struct address_space *mapping,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0152207..26e1dcf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1347,9 +1347,7 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		return err;
 
-	err = btrfs_init_compress();
-	if (err)
-		goto free_sysfs;
+	btrfs_init_compress();
 
 	err = btrfs_init_cachep();
 	if (err)
@@ -1390,7 +1388,6 @@ free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
 	btrfs_exit_compress();
-free_sysfs:
 	btrfs_exit_sysfs();
 	return err;
 }



