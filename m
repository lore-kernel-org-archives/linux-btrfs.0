Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934096AbdBQSG0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 13:06:26 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0C801ABCC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 18:06:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/5] btrfs: export compression buffer limits in a header
Date: Fri, 17 Feb 2017 19:05:55 +0100
Message-Id: <7b0a1e010fc4bf6e22dce274aa9400d942459e14.1487354456.git.dsterba@suse.com>
In-Reply-To: <cover.1487354456.git.dsterba@suse.com>
References: <cover.1487354456.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the buffer limit definitions out of compress_file_range.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.h | 15 +++++++++++++++
 fs/btrfs/inode.c       | 10 ----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index e453f42b3bbf..c9d7e552cfa8 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -19,6 +19,21 @@
 #ifndef __BTRFS_COMPRESSION_
 #define __BTRFS_COMPRESSION_
 
+/*
+ * We want to make sure that amount of RAM required to uncompress an extent is
+ * reasonable, so we limit the total size in ram of a compressed extent to
+ * 128k.  This is a crucial number because it also controls how easily we can
+ * spread reads across cpus for decompression.
+ *
+ * We also want to make sure the amount of IO required to do a random read is
+ * reasonably small, so we limit the size of a compressed extent to 128k.
+ */
+
+/* Maximum length of compressed data stored on disk */
+#define BTRFS_MAX_COMPRESSED		(SZ_128K)
+/* Maximum size of data before compression */
+#define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
+
 void btrfs_init_compress(void);
 void btrfs_exit_compress(void);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 801d1b3fd9d7..bc547608ff1a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -470,16 +470,6 @@ static noinline void compress_file_range(struct inode *inode,
 	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
 		goto cleanup_and_bail_uncompressed;
 
-	/* we want to make sure that amount of ram required to uncompress
-	 * an extent is reasonable, so we limit the total size in ram
-	 * of a compressed extent to 128k.  This is a crucial number
-	 * because it also controls how easily we can spread reads across
-	 * cpus for decompression.
-	 *
-	 * We also want to make sure the amount of IO required to do
-	 * a random read is reasonably small, so we limit the size of
-	 * a compressed extent to 128k.
-	 */
 	total_compressed = min(total_compressed, max_uncompressed);
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
-- 
2.10.1

