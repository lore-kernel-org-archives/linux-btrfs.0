From: Daniel J Blueman <daniel@quora.org>
Subject: [PATCH V2] btrfs: fix message printing
Date: Mon,  7 May 2012 20:35:38 +0800
Message-ID: <1336394138-9261-1-git-send-email-daniel@quora.org>
Cc: "Josef Bacik" <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Daniel J Blueman <daniel@quora.org>
To: "Chris Mason" <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix various messages to include newline and module prefix.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 fs/btrfs/super.c   |    8 ++++----
 fs/btrfs/volumes.c |    6 +++---
 fs/btrfs/zlib.c    |    8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c5f8fca..c0b8727 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -216,7 +216,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno)
 {
-	WARN_ONCE(1, KERN_DEBUG "btrfs: Transaction aborted");
+	WARN_ONCE(1, KERN_DEBUG "btrfs: Transaction aborted\n");
 	trans->aborted = errno;
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
@@ -511,11 +511,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag");
+			printk(KERN_INFO "btrfs: enabling auto defrag\n");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
 		case Opt_recovery:
-			printk(KERN_INFO "btrfs: enabling auto recovery");
+			printk(KERN_INFO "btrfs: enabling auto recovery\n");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
 			break;
 		case Opt_skip_balance:
@@ -1501,7 +1501,7 @@ static int btrfs_interface_init(void)
 static void btrfs_interface_exit(void)
 {
 	if (misc_deregister(&btrfs_misc) < 0)
-		printk(KERN_INFO "misc_deregister failed for control device");
+		printk(KERN_INFO "btrfs: misc_deregister failed for control device\n");
 }
 
 static int __init init_btrfs_fs(void)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1411b99..79b603d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -619,7 +619,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 		bdev = blkdev_get_by_path(device->name, flags, holder);
 		if (IS_ERR(bdev)) {
-			printk(KERN_INFO "open %s failed\n", device->name);
+			printk(KERN_INFO "btrfs: open %s failed\n", device->name);
 			goto error;
 		}
 		filemap_write_and_wait(bdev->bd_inode->i_mapping);
@@ -3719,7 +3719,7 @@ static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 	read_unlock(&em_tree->lock);
 
 	if (!em) {
-		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
+		printk(KERN_CRIT "btrfs: unable to find logical %llu len %llu\n",
 		       (unsigned long long)logical,
 		       (unsigned long long)*length);
 		BUG();
@@ -4129,7 +4129,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	total_devs = bbio->num_stripes;
 	if (map_length < length) {
-		printk(KERN_CRIT "mapping failed logical %llu bio len %llu "
+		printk(KERN_CRIT "btrfs: mapping failed logical %llu bio len %llu "
 		       "len %llu\n", (unsigned long long)logical,
 		       (unsigned long long)length,
 		       (unsigned long long)map_length);
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 92c2065..9acb846 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -97,7 +97,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	*total_in = 0;
 
 	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
-		printk(KERN_WARNING "deflateInit failed\n");
+		printk(KERN_WARNING "btrfs: deflateInit failed\n");
 		ret = -1;
 		goto out;
 	}
@@ -125,7 +125,7 @@ static int zlib_compress_pages(struct list_head *ws,
 	while (workspace->def_strm.total_in < len) {
 		ret = zlib_deflate(&workspace->def_strm, Z_SYNC_FLUSH);
 		if (ret != Z_OK) {
-			printk(KERN_DEBUG "btrfs deflate in loop returned %d\n",
+			printk(KERN_DEBUG "btrfs: deflate in loop returned %d\n",
 			       ret);
 			zlib_deflateEnd(&workspace->def_strm);
 			ret = -1;
@@ -252,7 +252,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	}
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
-		printk(KERN_WARNING "inflateInit failed\n");
+		printk(KERN_WARNING "btrfs: inflateInit failed\n");
 		return -1;
 	}
 	while (workspace->inf_strm.total_in < srclen) {
@@ -336,7 +336,7 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	}
 
 	if (Z_OK != zlib_inflateInit2(&workspace->inf_strm, wbits)) {
-		printk(KERN_WARNING "inflateInit failed\n");
+		printk(KERN_WARNING "btrfs: inflateInit failed\n");
 		return -1;
 	}
 
-- 
1.7.9.5

