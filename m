From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH 1/2] [RFC] Btrfs: Increase limit on size of compressed extent
Date: Tue,  3 May 2011 14:28:14 -0500
Message-ID: <1304450895-15586-2-git-send-email-mitch.harder@sabayonlinux.org>
References: <1304450895-15586-1-git-send-email-mitch.harder@sabayonlinux.org>
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304450895-15586-1-git-send-email-mitch.harder@sabayonlinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

The size of compressed extents was limited to 128K, which
leads to fragmentation of the extents (although the extents
themselves may still be located contiguously).  This limit is
put in place to ease the RAM required when spreading compression
across several CPUs, and to make sure the amount of IO required
to do a random read is reasonably small.

Increase this limit to 512K.
---
 fs/btrfs/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 870869a..7ef2b34 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -333,8 +333,8 @@ static noinline int compress_file_range(struct inode *inode,
 	unsigned long nr_pages_ret = 0;
 	unsigned long total_compressed = 0;
 	unsigned long total_in = 0;
-	unsigned long max_compressed = 128 * 1024;
-	unsigned long max_uncompressed = 128 * 1024;
+	unsigned long max_compressed = 512 * 1024;
+	unsigned long max_uncompressed = 512 * 1024;
 	int i;
 	int will_compress;
 	int compress_type = root->fs_info->compress_type;
@@ -343,7 +343,7 @@ static noinline int compress_file_range(struct inode *inode,
 again:
 	will_compress = 0;
 	nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
-	nr_pages = min(nr_pages, (128 * 1024UL) / PAGE_CACHE_SIZE);
+	nr_pages = min(nr_pages, (512 * 1024UL) / PAGE_CACHE_SIZE);
 
 	/*
 	 * we don't want to send crud past the end of i_size through
@@ -368,7 +368,7 @@ again:
 	 *
 	 * We also want to make sure the amount of IO required to do
 	 * a random read is reasonably small, so we limit the size of
-	 * a compressed extent to 128k.
+	 * a compressed extent to 512k (was 128k).
 	 */
 	total_compressed = min(total_compressed, max_uncompressed);
 	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
-- 
1.7.3.4

