From: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] btrfs: add -o discard option
Date: Wed, 14 Oct 2009 03:03:11 +0200
Message-ID: <20091014010311.GB21031@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Enable discard by default is not a good idea given the the trim speed
of SSD prototypes we've seen, and the carecteristics for many high-end
arrays.  Turn of discards by default and require the -o discard option
to enable them on.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/ctree.h
===================================================================
--- linux-2.6.orig/fs/btrfs/ctree.h	2009-10-12 09:27:35.011254757 -0300
+++ linux-2.6/fs/btrfs/ctree.h	2009-10-12 09:28:07.165254763 -0300
@@ -1145,6 +1145,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
 #define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
+#define BTRFS_MOUNT_DISCARD		(1 << 10)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
Index: linux-2.6/fs/btrfs/extent-tree.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent-tree.c	2009-10-12 09:28:17.101010793 -0300
+++ linux-2.6/fs/btrfs/extent-tree.c	2009-10-12 09:29:53.590254346 -0300
@@ -1582,6 +1582,9 @@ static int btrfs_discard_extent(struct b
 	u64 map_length = num_bytes;
 	struct btrfs_multi_bio *multi = NULL;
 
+	if (!btrfs_test_opt(root, DISCARD))
+		return 0;
+
 	/* Tell the block device(s) that the sectors can be discarded */
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
 			      bytenr, &map_length, &multi, 0);
Index: linux-2.6/fs/btrfs/super.c
===================================================================
--- linux-2.6.orig/fs/btrfs/super.c	2009-10-12 09:25:56.162010898 -0300
+++ linux-2.6/fs/btrfs/super.c	2009-10-12 09:27:24.529256842 -0300
@@ -66,7 +66,8 @@ enum {
 	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl,
-	Opt_compress, Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_err,
+	Opt_compress, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
+	Opt_discard, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -88,6 +89,7 @@ static match_table_t tokens = {
 	{Opt_notreelog, "notreelog"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
+	{Opt_discard, "discard"},
 	{Opt_err, NULL},
 };
 
@@ -257,6 +259,9 @@ int btrfs_parse_options(struct btrfs_roo
 				       info->metadata_ratio);
 			}
 			break;
+		case Opt_discard:
+			btrfs_set_opt(info->mount_opt, DISCARD);
+			break;
 		default:
 			break;
 		}
