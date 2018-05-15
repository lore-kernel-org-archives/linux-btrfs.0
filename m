Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42633 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752393AbeEOHg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:36:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 012ADAE04
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 07:36:28 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: lzo: Avoid decompressing obviously corrupted data
Date: Tue, 15 May 2018 15:36:22 +0800
Message-Id: <20180515073622.18732-3-wqu@suse.com>
In-Reply-To: <20180515073622.18732-1-wqu@suse.com>
References: <20180515073622.18732-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike zlib decompression, lzo decompression doesn't need any
initialization, thus we can't detect early corruption from
initialization.

However for lzo compressed extent, its first 4bytes records the real
unaligned compressed data size.
We could use this as a clue, since any compressed extent should not
exceed 128K, thus if we find such compressed data length, we are sure
it's corrupted, then no need to continue decompression.

Normally, such problem won't really bother anyone, as compression relies
on dataCoW and data csum, which means normally such corruption should be
detect by data csum before going into compression.
However due to a bug in compression condition, it's possible to create
compressed extent without csum.

So we still need to do extra check for lzo just in case the compressed
data is corrupted.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
lease note that, even with the binary dump of corrupted extent provided
by the original reporter, James Harvey, I can only reproduce the "decompress
failed" error message, but not the serious memory corruption followed.
So there must be something missing, maybe we need to double check both
btrfs lzo caller and kernel lzo lib.

But anyway, making btrfs lzo compression a little more robust is never a
bad thing.
---
 fs/btrfs/compression.h | 1 +
 fs/btrfs/lzo.c         | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index cc605f7b23fb..317703d9b073 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -6,6 +6,7 @@
 #ifndef BTRFS_COMPRESSION_H
 #define BTRFS_COMPRESSION_H
 
+#include <linux/sizes.h>
 /*
  * We want to make sure that amount of RAM required to uncompress an extent is
  * reasonable, so we limit the total size in ram of a compressed extent to
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 0667ea07f766..7ae2c0925770 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -271,6 +271,10 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 
 	data_in = kmap(pages_in[0]);
 	tot_len = read_compress_length(data_in);
+	if (tot_len > BTRFS_MAX_COMPRESSED) {
+		ret = -EIO;
+		goto done;
+	}
 
 	tot_in = LZO_LEN;
 	in_offset = LZO_LEN;
-- 
2.17.0

