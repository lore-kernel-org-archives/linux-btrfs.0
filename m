From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: [PATCH] Btrfs: Fix page count calculation
Date: Tue, 18 Jan 2011 13:34:40 +0800
Message-ID: <4D352670.4040603@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

take offset of start position into account when calculating page count.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 66836d8..ef94e46 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -970,8 +970,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		size_t write_bytes = min(iov_iter_count(&i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
-		size_t num_pages = (write_bytes + PAGE_CACHE_SIZE - 1) >>
-					PAGE_CACHE_SHIFT;
+		size_t num_pages = (write_bytes + offset +
+				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
 		WARN_ON(num_pages > nrptrs);
 		memset(pages, 0, sizeof(struct page *) * nrptrs);
@@ -1001,8 +1001,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 
 		copied = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, &i);
-		dirty_pages = (copied + PAGE_CACHE_SIZE - 1) >>
-					PAGE_CACHE_SHIFT;
+		dirty_pages = (copied + offset + PAGE_CACHE_SIZE - 1) >>
+				PAGE_CACHE_SHIFT;
 
 		if (num_pages > dirty_pages) {
 			if (copied > 0)
