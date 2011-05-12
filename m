From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/1] btrfs: use printk_ratelimited instead of printk_ratelimit
Date: Thu, 12 May 2011 18:10:05 +0200
Message-ID: <1305216605-27057-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As per printk_ratelimit comment, it should not be used.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |   21 ++++++---------------
 fs/btrfs/inode.c   |   13 ++++---------
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de7b477..cb9d1b8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -29,6 +29,7 @@
 #include <linux/crc32c.h>
 #include <linux/slab.h>
 #include <linux/migrate.h>
+#include <linux/ratelimit.h>
 #include <asm/unaligned.h>
 #include "compat.h"
 #include "ctree.h"
@@ -254,14 +255,12 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			memcpy(&found, result, csum_size);
 
 			read_extent_buffer(buf, &val, 0, csum_size);
-			if (printk_ratelimit()) {
-				printk(KERN_INFO "btrfs: %s checksum verify "
+			printk_ratelimited(KERN_INFO "btrfs: %s checksum verify "
 				       "failed on %llu wanted %X found %X "
 				       "level %d\n",
 				       root->fs_info->sb->s_id,
 				       (unsigned long long)buf->start, val, found,
 				       btrfs_header_level(buf));
-			}
 			if (result != (char *)&inline_result)
 				kfree(result);
 			return 1;
@@ -296,13 +295,11 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		ret = 0;
 		goto out;
 	}
-	if (printk_ratelimit()) {
-		printk("parent transid verify failed on %llu wanted %llu "
+	printk_ratelimited("parent transid verify failed on %llu wanted %llu "
 		       "found %llu\n",
 		       (unsigned long long)eb->start,
 		       (unsigned long long)parent_transid,
 		       (unsigned long long)btrfs_header_generation(eb));
-	}
 	ret = 1;
 	clear_extent_buffer_uptodate(io_tree, eb, &cached_state);
 out:
@@ -533,12 +530,10 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != start) {
-		if (printk_ratelimit()) {
-			printk(KERN_INFO "btrfs bad tree block start "
+		printk_ratelimited(KERN_INFO "btrfs bad tree block start "
 			       "%llu %llu\n",
 			       (unsigned long long)found_start,
 			       (unsigned long long)eb->start);
-		}
 		ret = -EIO;
 		goto err;
 	}
@@ -550,10 +545,8 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		if (printk_ratelimit()) {
-			printk(KERN_INFO "btrfs bad fsid on block %llu\n",
+		printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
 			       (unsigned long long)eb->start);
-		}
 		ret = -EIO;
 		goto err;
 	}
@@ -2108,11 +2101,9 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (printk_ratelimit()) {
-			printk(KERN_WARNING "lost page write due to "
+		printk_ratelimited(KERN_WARNING "lost page write due to "
 					"I/O error on %s\n",
 				       bdevname(bh->b_bdev, b));
-		}
 		/* note, we dont' set_buffer_write_io_error because we have
 		 * our own ways of dealing with the IO errors
 		 */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5ff52b6..1d1017f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -37,6 +37,7 @@
 #include <linux/posix_acl.h>
 #include <linux/falloc.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -2004,12 +2005,10 @@ good:
 	return 0;
 
 zeroit:
-	if (printk_ratelimit()) {
-		printk(KERN_INFO "btrfs csum failed ino %lu off %llu csum %u "
+	printk_ratelimited(KERN_INFO "btrfs csum failed ino %lu off %llu csum %u "
 		       "private %llu\n", page->mapping->host->i_ino,
 		       (unsigned long long)start, csum,
 		       (unsigned long long)private);
-	}
 	memset(kaddr + offset, 1, end - start + 1);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr, KM_USER0);
@@ -4243,22 +4242,18 @@ void btrfs_dirty_inode(struct inode *inode)
 		btrfs_end_transaction(trans, root);
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
-			if (printk_ratelimit()) {
-				printk(KERN_ERR "btrfs: fail to "
+			printk_ratelimited(KERN_ERR "btrfs: fail to "
 				       "dirty  inode %lu error %ld\n",
 				       inode->i_ino, PTR_ERR(trans));
-			}
 			return;
 		}
 		btrfs_set_trans_block_group(trans, inode);
 
 		ret = btrfs_update_inode(trans, root, inode);
 		if (ret) {
-			if (printk_ratelimit()) {
-				printk(KERN_ERR "btrfs: fail to "
+			printk_ratelimited(KERN_ERR "btrfs: fail to "
 				       "dirty  inode %lu error %d\n",
 				       inode->i_ino, ret);
-			}
 		}
 	}
 	btrfs_end_transaction(trans, root);
-- 
1.7.5.1.169.g505a1

