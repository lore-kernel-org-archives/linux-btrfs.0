From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 3/6] scrub: print paths of corrupted files
Date: Mon, 13 Jun 2011 21:10:36 +0200
Message-ID: <4dff2bfbba0f059cf91185c290d0c78bf9f6648d.1307991539.git.list.btrfs@jan-o-sch.net>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1307991539.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1307991539.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

While scrubbing, we may encounter various errors. Previously, a logical
address was printed to the log only. Now, all paths belonging to that
address are resolved and printed separately. That should work for hardlinks
as well as reflinks.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/scrub.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 00e4e58..e294d76 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -27,6 +27,7 @@
 #include "volumes.h"
 #include "disk-io.h"
 #include "ordered-data.h"
+#include "backref.h"
 
 /*
  * This is only the first step towards a full-features scrub. It reads all
@@ -106,6 +107,19 @@ struct scrub_dev {
 	spinlock_t		stat_lock;
 };
 
+struct scrub_warning {
+	struct btrfs_path	*path;
+	u64			extent_item_size;
+	char			*scratch_buf;
+	char			*msg_buf;
+	const char		*errstr;
+	u64			sector;
+	u64			logical;
+	struct btrfs_device	*dev;
+	int			msg_bufsize;
+	int			scratch_bufsize;
+};
+
 static void scrub_free_csums(struct scrub_dev *sdev)
 {
 	while (!list_empty(&sdev->csum_list)) {
@@ -201,6 +215,121 @@ nomem:
 	return ERR_PTR(-ENOMEM);
 }
 
+static int scrub_print_warning_inode(u64 inum, loff_t offset, void *ctx)
+{
+	u64 isize;
+	int ret;
+	struct extent_buffer *eb_i;
+	struct btrfs_inode_item *ii;
+	struct scrub_warning *swarn = ctx;
+	struct btrfs_fs_info *fs_info = swarn->dev->dev_root->fs_info;
+	struct inode_fs_paths ipath;
+
+	ret = inode_item_info(inum, 0, fs_info->fs_root, swarn->path);
+	if (ret) {
+err:
+		printk(KERN_WARNING "btrfs: %s at logical %llu on dev "
+			"%s, sector %llu, inode %llu, offset %llu: path "
+			"resolving failed with ret=%d\n", swarn->errstr,
+			swarn->logical, swarn->dev->name, swarn->sector, inum,
+			offset, ret);
+		return 0;
+	}
+	eb_i = swarn->path->nodes[0];
+	ii = btrfs_item_ptr(eb_i, swarn->path->slots[0],
+				struct btrfs_inode_item);
+	btrfs_release_path(swarn->path);
+
+	isize = btrfs_inode_size(eb_i, ii);
+
+	ipath.left = swarn->msg_bufsize - 1;
+	ipath.dest = swarn->msg_buf;
+	ipath.path = swarn->path;
+	ipath.scratch_buf = swarn->scratch_buf;
+	ipath.scratch_bufsize = swarn->scratch_bufsize;
+	ipath.fs_root = fs_info->fs_root;
+	ipath.eb_i = eb_i;
+
+	ret = paths_from_inode(inum, &ipath);
+	if (ret < 0)
+		goto err;
+
+	printk(KERN_WARNING "btrfs: %s at logical %llu on dev "
+		"%s, sector %llu, inode %llu, offset %llu, "
+		"length %llu, links %u (path:%s)\n", swarn->errstr,
+		swarn->logical, swarn->dev->name, swarn->sector, inum, offset,
+		min(isize - offset, (u64)PAGE_SIZE),
+		btrfs_inode_nlink(eb_i, ii), swarn->msg_buf);
+
+	return 0;
+}
+
+static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
+				int ix)
+{
+	struct btrfs_device *dev = sbio->sdev->dev;
+	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_key found_key;
+	struct extent_buffer *eb;
+	struct btrfs_extent_item *ei;
+	struct scrub_warning swarn;
+	u32 item_size;
+	int ret;
+	u64 ref_root;
+	u64 ref_level;
+	unsigned long ptr = 0;
+	static const int bufsize = 4096;
+	loff_t extent_item_offset;
+
+	path = btrfs_alloc_path();
+
+	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
+	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
+	swarn.sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
+	swarn.logical = sbio->logical + ix * PAGE_SIZE;
+	swarn.errstr = errstr;
+	swarn.dev = dev;
+	swarn.msg_bufsize = bufsize;
+	swarn.scratch_bufsize = bufsize;
+
+	if (!path || !swarn.scratch_buf || !swarn.msg_buf)
+		goto out;
+
+	ret = data_extent_from_logical(fs_info->extent_root,
+					swarn.logical, path, &found_key);
+	if (ret < 0)
+		goto out;
+
+	extent_item_offset = swarn.logical - found_key.objectid;
+	swarn.extent_item_size = found_key.offset;
+
+	eb = path->nodes[0];
+	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
+	item_size = btrfs_item_size_nr(eb, path->slots[0]);
+
+	btrfs_release_path(path);
+
+	if (ret) {
+		ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
+						&ref_root, &ref_level);
+		printk(KERN_WARNING "%s at logical %llu on dev %s, "
+			"sector %llu: metadata %s (level %llu) in tree %llu\n",
+			errstr, swarn.logical, dev->name, swarn.sector,
+			ref_level ? "node" : "leaf", ret < 0 ? -1 : ref_level,
+			ret < 0 ? -1 : ref_root);
+	} else {
+		swarn.path = path;
+		iterate_extent_inodes(eb, ei, extent_item_offset, item_size,
+					scrub_print_warning_inode, &swarn);
+	}
+
+out:
+	btrfs_free_path(path);
+	kfree(swarn.scratch_buf);
+	kfree(swarn.msg_buf);
+}
+
 /*
  * scrub_recheck_error gets called when either verification of the page
  * failed or the bio failed to read, e.g. with EIO. In the latter case,
@@ -218,6 +347,11 @@ static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
 			if (scrub_fixup_check(sbio, ix) == 0)
 				return 0;
 		}
+		if (printk_ratelimit())
+			scrub_print_warning("i/o error", sbio, ix);
+	} else {
+		if (printk_ratelimit())
+			scrub_print_warning("checksum error", sbio, ix);
 	}
 
 	spin_lock(&sdev->stat_lock);
@@ -333,7 +467,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
 	spin_unlock(&sdev->stat_lock);
 
 	if (printk_ratelimit())
-		printk(KERN_ERR "btrfs: fixed up at %llu\n",
+		printk(KERN_ERR "btrfs: fixed up error at logical %llu\n",
 		       (unsigned long long)logical);
 	return;
 
@@ -344,8 +478,8 @@ uncorrectable:
 	spin_unlock(&sdev->stat_lock);
 
 	if (printk_ratelimit())
-		printk(KERN_ERR "btrfs: unable to fixup at %llu\n",
-			 (unsigned long long)logical);
+		printk(KERN_ERR "btrfs: unable to fixup (regular) error at "
+			"logical %llu\n", (unsigned long long)logical);
 }
 
 static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
-- 
1.7.3.4

