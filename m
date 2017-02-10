Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36536 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdBJXKu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 18:10:50 -0500
Received: by mail-pg0-f47.google.com with SMTP id v184so14147258pgv.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 15:10:50 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Pat Erley <pat-lkml@erley.org>, kernel-team@fb.com
Subject: [PATCH v2] Btrfs: fix btrfs_decompress_buf2page()
Date: Fri, 10 Feb 2017 15:03:35 -0800
Message-Id: <35a7eac2a55a330a27639e0b38f8d052e6dbee8b.1486767707.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If btrfs_decompress_buf2page() is handed a bio with its page in the
middle of the working buffer, then we adjust the offset into the working
buffer. After we copy into the bio, we advance the iterator by the
number of bytes we copied. Then, we have some logic to handle the case
of discontiguous pages and adjust the offset into the working buffer
again. However, if we didn't advance the bio to a new page, we may enter
this case in error, essentially repeating the adjustment that we already
made when we entered the function. The end result is bogus data in the
bio.

Previously, we only checked for this case when we advanced to a new
page, but the conversion to bio iterators changed that. This restores
the old, correct behavior.

A case I saw when testing with zlib was:

    buf_start = 42769
    total_out = 46865
    working_bytes = total_out - buf_start = 4096
    start_byte = 45056

The condition (total_out > start_byte && buf_start < start_byte) is
true, so we adjust the offset:

    buf_offset = start_byte - buf_start = 2287
    working_bytes -= buf_offset = 1809
    current_buf_start = buf_start = 42769

Then, we copy

    bytes = min(bvec.bv_len, PAGE_SIZE - buf_offset, working_bytes) = 1809
    buf_offset += bytes = 4096
    working_bytes -= bytes = 0
    current_buf_start += bytes = 44578

After bio_advance(), we are still in the same page, so start_byte is the
same. Then, we check (total_out > start_byte && current_buf_start < start_byte),
which is true! So, we adjust the values again:

    buf_offset = start_byte - buf_start = 2287
    working_bytes = total_out - start_byte = 1809
    current_buf_start = buf_start + buf_offset = 45056

But note that working_bytes was already zero before this, so we should
have stopped copying.

Fixes: 974b1adc3b10 ("btrfs: use bio iterators for the decompression handlers")
Reported-by: Pat Erley <pat-lkml@erley.org>
Reviewed-by: Chris Mason <clm@fb.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changed from v1:

- Check if start_byte changed instead of whether bv_offset == 0. This is
  a little more foolproof.

 fs/btrfs/compression.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 7f390849343b..25168852ccde 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1024,6 +1024,7 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 	unsigned long buf_offset;
 	unsigned long current_buf_start;
 	unsigned long start_byte;
+	unsigned long prev_start_byte;
 	unsigned long working_bytes = total_out - buf_start;
 	unsigned long bytes;
 	char *kaddr;
@@ -1071,26 +1072,28 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 		if (!bio->bi_iter.bi_size)
 			return 0;
 		bvec = bio_iter_iovec(bio, bio->bi_iter);
-
+		prev_start_byte = start_byte;
 		start_byte = page_offset(bvec.bv_page) - disk_start;
 
-		/*
-		 * make sure our new page is covered by this
-		 * working buffer
-		 */
-		if (total_out <= start_byte)
-			return 1;
+		if (start_byte != prev_start_byte) {
+			/*
+			 * make sure our new page is covered by this
+			 * working buffer
+			 */
+			if (total_out <= start_byte)
+				return 1;
 
-		/*
-		 * the next page in the biovec might not be adjacent
-		 * to the last page, but it might still be found
-		 * inside this working buffer. bump our offset pointer
-		 */
-		if (total_out > start_byte &&
-		    current_buf_start < start_byte) {
-			buf_offset = start_byte - buf_start;
-			working_bytes = total_out - start_byte;
-			current_buf_start = buf_start + buf_offset;
+			/*
+			 * the next page in the biovec might not be adjacent
+			 * to the last page, but it might still be found
+			 * inside this working buffer. bump our offset pointer
+			 */
+			if (total_out > start_byte &&
+			    current_buf_start < start_byte) {
+				buf_offset = start_byte - buf_start;
+				working_bytes = total_out - start_byte;
+				current_buf_start = buf_start + buf_offset;
+			}
 		}
 	}
 
-- 
2.11.1

