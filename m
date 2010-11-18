From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 5/6] btrfs: Allow to specify compress method when defrag
Date: Thu, 18 Nov 2010 10:11:26 +0800
Message-ID: <4CE48B4E.6020408@cn.fujitsu.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE48ABB.5070302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Update defrag ioctl, so one can choose lzo or zlib when turning
on compression in defrag operation.

Changelog:

v1 -> v2
- Add incompability flag.
- Fix to check invalid compress type.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   24 +++++++++++++++++++++++-
 fs/btrfs/ioctl.h |    9 ++++++++-
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 460bd70..1714c48 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -626,9 +626,11 @@ static int btrfs_defrag_file(struct file *file,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct page *page;
+	struct btrfs_super_block *disk_super;
 	unsigned long last_index;
 	unsigned long ra_pages = root->fs_info->bdi.ra_pages;
 	unsigned long total_read = 0;
+	u64 features;
 	u64 page_start;
 	u64 page_end;
 	u64 last_len = 0;
@@ -636,6 +638,18 @@ static int btrfs_defrag_file(struct file *file,
 	u64 defrag_end = 0;
 	unsigned long i;
 	int ret;
+	int compress_type = BTRFS_COMPRESS_ZLIB;
+
+	if (range->compress_type > BTRFS_COMPRESS_TYPES)
+		return -EINVAL;
+
+	/*
+	 * Compression will be enabled only if BTRFS_DEFRAG_RANGE_COMPRESS
+	 * is set, and the default is zlib if compression method is not
+	 * specified.
+	 */
+	if (range->compress_type)
+		compress_type = range->compress_type;
 
 	if (inode->i_size == 0)
 		return 0;
@@ -671,7 +685,7 @@ static int btrfs_defrag_file(struct file *file,
 		total_read++;
 		mutex_lock(&inode->i_mutex);
 		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
-			BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_ZLIB;
+			BTRFS_I(inode)->force_compress = compress_type;
 
 		ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 		if (ret)
@@ -773,6 +787,14 @@ loop_unlock:
 		mutex_unlock(&inode->i_mutex);
 	}
 
+	disk_super = &root->fs_info->super_copy;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS &&
+	    compress_type == BTRFS_COMPRESS_LZO) {
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
+
 	return 0;
 
 err_reservations:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 17c99eb..0821367 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -129,8 +129,15 @@ struct btrfs_ioctl_defrag_range_args {
 	 */
 	__u32 extent_thresh;
 
+	/*
+	 * which compression method to use if turning on compression
+	 * for this defrag operation.  If unspecified, zlib will
+	 * be used
+	 */
+	__u32 compress_type;
+
 	/* spare for later */
-	__u32 unused[5];
+	__u32 unused[4];
 };
 
 struct btrfs_ioctl_space_info {
-- 1.7.3.1 
