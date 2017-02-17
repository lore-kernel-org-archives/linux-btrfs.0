Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934766AbdBQQ2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:28:21 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6B375AB9A
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 16:28:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: constify buffers used by compression helpers
Date: Fri, 17 Feb 2017 17:27:46 +0100
Message-Id: <83151b9cb8c34a742855715f7de55752f4c7a29e.1487348702.git.dsterba@suse.com>
In-Reply-To: <cover.1487348702.git.dsterba@suse.com>
References: <cover.1487348702.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 2 +-
 fs/btrfs/compression.h | 2 +-
 fs/btrfs/lzo.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 903c32c9eb22..c76312405f5c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1015,7 +1015,7 @@ void btrfs_exit_compress(void)
  *
  * total_out is the last byte of the buffer
  */
-int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
+int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 			      unsigned long total_out, u64 disk_start,
 			      struct bio *bio)
 {
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 09879579fbc8..1c700bb20b52 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -32,7 +32,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
 			 unsigned long max_out);
 int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen);
-int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
+int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
 			      unsigned long total_out, u64 disk_start,
 			      struct bio *bio);
 
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 45d26980caf9..e074b85aa054 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -76,7 +76,7 @@ static inline void write_compress_length(char *buf, size_t len)
 	memcpy(buf, &dlen, LZO_LEN);
 }
 
-static inline size_t read_compress_length(char *buf)
+static inline size_t read_compress_length(const char *buf)
 {
 	__le32 dlen;
 
-- 
2.10.1

