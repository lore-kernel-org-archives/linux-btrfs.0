Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57667 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbeEUFTe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 01:19:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 54A4CADA5
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 05:19:33 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs: lzo: Add header length check to avoid slab out of bounds access
Date: Mon, 21 May 2018 13:19:26 +0800
Message-Id: <20180521051927.3715-4-wqu@suse.com>
In-Reply-To: <20180521051927.3715-1-wqu@suse.com>
References: <20180521051927.3715-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Harvey reported that some corrupted compressed extent data can
lead to various kernel memory corruption.

Such corrupted extent data belongs to inode with NODATASUM flags, thus
data csum won't help us detecting such bug.

If lucky enough, kasan could catch it like:
==================================================================
BUG: KASAN: slab-out-of-bounds in lzo_decompress_bio+0x384/0x7a0 [btrfs]
Write of size 4096 at addr ffff8800606cb0f8 by task kworker/u16:0/2338

CPU: 3 PID: 2338 Comm: kworker/u16:0 Tainted: G           O      4.17.0-rc5-custom+ #50
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
Call Trace:
 dump_stack+0xc2/0x16b
 print_address_description+0x6a/0x270
 kasan_report+0x260/0x380
 memcpy+0x34/0x50
 lzo_decompress_bio+0x384/0x7a0 [btrfs]
 end_compressed_bio_read+0x99f/0x10b0 [btrfs]
 bio_endio+0x32e/0x640
 normal_work_helper+0x15a/0xea0 [btrfs]
 process_one_work+0x7e3/0x1470
 worker_thread+0x1b0/0x1170
 kthread+0x2db/0x390
 ret_from_fork+0x22/0x40
...
==================================================================

The offending compressed data has the following info:

Header:			length 32768		(Looks completely valid)
Segment 0 Header:	length 3472882419	(Obvious out of bounds)

Then when handling segment 0, since it's over the current page, we need
the compressed data to workspace, then such large size would trigger
out-of-bounds memory access, screwing up the whole kernel.

Fix it by adding extra checks on header and segment headers to ensure we
won't access out-of-bounds, and even checks the decompressed data won't
be out-of-bounds.

Reported-by: James Harvey <jamespharvey20@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index d0c6789ff78f..4c75dcba3f04 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -281,6 +281,7 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	unsigned long working_bytes;
 	size_t in_len;
 	size_t out_len;
+	size_t max_segment_len = lzo1x_worst_compress(PAGE_SIZE);
 	unsigned long in_offset;
 	unsigned long in_page_bytes_left;
 	unsigned long tot_in;
@@ -294,6 +295,18 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 
 	data_in = kmap(pages_in[0]);
 	tot_len = read_compress_length(data_in);
+	/*
+	 * Compressed data header check.
+	 *
+	 * The real compressed size can't exceed extent length, and all pages
+	 * should be used (a full pending page is not possible).
+	 * If this happens it means the compressed extent is corrupted.
+	 */
+	if (tot_len > min_t(size_t, BTRFS_MAX_COMPRESSED, srclen) ||
+	    tot_len < srclen - PAGE_SIZE) {
+		ret = -EUCLEAN;
+		goto done;
+	}
 
 	tot_in = LZO_LEN;
 	in_offset = LZO_LEN;
@@ -308,6 +321,17 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 		in_offset += LZO_LEN;
 		tot_in += LZO_LEN;
 
+		/*
+		 * Segment header check.
+		 *
+		 * The segment length must not exceed max lzo compression
+		 * size, nor the total compressed size
+		 */
+		if (in_len > max_segment_len || tot_in + in_len > tot_len) {
+			ret = -EUCLEAN;
+			goto done;
+		}
+
 		tot_in += in_len;
 		working_bytes = in_len;
 		may_late_unmap = need_unmap = false;
@@ -358,7 +382,7 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			}
 		}
 
-		out_len = lzo1x_worst_compress(PAGE_SIZE);
+		out_len = max_segment_len;
 		ret = lzo1x_decompress_safe(buf, in_len, workspace->buf,
 					    &out_len);
 		if (need_unmap)
@@ -368,6 +392,15 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 			ret = -EIO;
 			break;
 		}
+		/*
+		 * Decompressed data length check.
+		 * The uncompressed data should not exceed uncompressed extent
+		 * size.
+		 */
+		if (tot_out + out_len > cb->len) {
+			ret = -EUCLEAN;
+			break;
+		}
 
 		buf_start = tot_out;
 		tot_out += out_len;
-- 
2.17.0

