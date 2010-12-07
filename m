From: "Jan Beulich" <JBeulich@novell.com>
Subject: [PATCH] btrfs: avoid compiler warnings
Date: Tue, 07 Dec 2010 14:54:09 +0000
Message-ID: <4CFE58A102000078000266EC@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <linux-btrfs@vger.kernel.org>
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

... regarding an unused function when !MIGRATION, and regarding a
printk() format string vs argument mismatch.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 fs/btrfs/disk-io.c |    6 ++----
 fs/btrfs/inode.c   |    6 +++---
 2 files changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.37-rc5/fs/btrfs/disk-io.c
+++ 2.6.37-rc5-btrfs-warnings/fs/btrfs/disk-io.c
@@ -696,6 +696,7 @@ static int btree_submit_bio_hook(struct 
 				   __btree_submit_bio_done);
 }
 
+#ifdef CONFIG_MIGRATION
 static int btree_migratepage(struct address_space *mapping,
 			struct page *newpage, struct page *page)
 {
@@ -712,12 +713,9 @@ static int btree_migratepage(struct addr
 	if (page_has_private(page) &&
 	    !try_to_release_page(page, GFP_KERNEL))
 		return -EAGAIN;
-#ifdef CONFIG_MIGRATION
 	return migrate_page(mapping, newpage, page);
-#else
-	return -ENOSYS;
-#endif
 }
+#endif
 
 static int btree_writepage(struct page *page, struct writeback_control *wbc)
 {
--- linux-2.6.37-rc5/fs/btrfs/inode.c
+++ 2.6.37-rc5-btrfs-warnings/fs/btrfs/inode.c
@@ -5712,9 +5712,9 @@ static void btrfs_end_dio_bio(struct bio
 
 	if (err) {
 		printk(KERN_ERR "btrfs direct IO failed ino %lu rw %lu "
-		      "disk_bytenr %lu len %u err no %d\n",
-		      dip->inode->i_ino, bio->bi_rw, bio->bi_sector,
-		      bio->bi_size, err);
+		      "sector %#Lx len %u err no %d\n",
+		      dip->inode->i_ino, bio->bi_rw,
+		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
 		dip->errors = 1;
 
 		/*



