From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: [PATCH] Btrfs: Fix page leak in compressed writeback path
Date: Mon, 06 Dec 2010 15:02:36 +0800
Message-ID: <4CFC8A8C.6010203@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

"start + num_bytes >= actual_end" can happen when compressed page writeback races
with file truncation. In that case we need unlock and release pages past the end
of file.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8039390..2ea98d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -495,7 +495,7 @@ again:
 		add_async_extent(async_cow, start, num_bytes,
 				 total_compressed, pages, nr_pages_ret);
 
-		if (start + num_bytes < end && start + num_bytes < actual_end) {
+		if (start + num_bytes < end) {
 			start += num_bytes;
 			pages = NULL;
 			cond_resched();
