Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56437 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752086AbdK3QK6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 11:10:58 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31D02AE74
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:10:57 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: compression: add helper for type to string conversion
Date: Thu, 30 Nov 2017 17:09:00 +0100
Message-Id: <a82165fb386d2abba1e7366689e3aefada14ed26.1512058075.git.dsterba@suse.com>
In-Reply-To: <cover.1512058075.git.dsterba@suse.com>
References: <cover.1512058075.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are several places opencoding this conversion, add a helper now
that we have 3 compression algorithms.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 15 +++++++++++++++
 fs/btrfs/compression.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 5982c8a71f02..a1a5958ff328 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -45,6 +45,21 @@
 #include "extent_io.h"
 #include "extent_map.h"
 
+static const char* const btrfs_compress_types[] = { "", "lzo", "zlib", "zstd" };
+
+const char* btrfs_compress_type2str(enum btrfs_compression_type type)
+{
+	switch (type) {
+	case BTRFS_COMPRESS_LZO:
+	case BTRFS_COMPRESS_ZLIB:
+	case BTRFS_COMPRESS_ZSTD:
+	case BTRFS_COMPRESS_NONE:
+		return btrfs_compress_types[type];
+	}
+
+	return NULL;
+}
+
 static int btrfs_decompress_bio(struct compressed_bio *cb);
 
 static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 6b692903a23c..677fa4aa0bd7 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -137,6 +137,8 @@ extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
 extern const struct btrfs_compress_op btrfs_zstd_compress;
 
+const char* btrfs_compress_type2str(enum btrfs_compression_type type);
+
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
 
 #endif
-- 
2.15.0

