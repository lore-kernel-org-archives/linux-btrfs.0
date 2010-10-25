From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs: Allow to specify compress method when defrag
Date: Mon, 25 Oct 2010 15:12:50 +0800
Message-ID: <4CC52DF2.2040803@cn.fujitsu.com>
References: <4CC52D9A.3030709@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CC52D9A.3030709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Update defrag ioctl, so one can choose lzo or zlib when turning
on compression in defrag operation.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    6 +++++-
 fs/btrfs/ioctl.h |    9 ++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ecc49ee..2ea05df 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -584,8 +584,12 @@ static int btrfs_defrag_file(struct file *file,
 		}
 		total_read++;
 		mutex_lock(&inode->i_mutex);
-		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
+		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
 			BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_ZLIB;
+			if (range->compress_type)
+				BTRFS_I(inode)->force_compress =
+					range->compress_type;
+		}
 
 		ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 		if (ret)
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..776a2b4 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -122,8 +122,15 @@ struct btrfs_ioctl_defrag_range_args {
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
-- 
1.7.0.1

