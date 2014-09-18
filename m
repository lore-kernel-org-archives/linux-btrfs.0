Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757263AbaIRDf2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 23:35:28 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8I3ZXBc011054
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 11:35:33 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix page align issue for lzo compress in restore
Date: Thu, 18 Sep 2014 11:34:43 +0800
Message-ID: <1411011283-22079-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When runing restore under lzo compression, "bad compress length"
problems are encountered.
It is because there is a page align problem with the @decompress_lzo,
as follows:
		|------| |----|-| |------|...|------|
		  page         ^    page       page
			       |
			  3 bytes left

	When lzo compress pages im RAM, lzo will ensure that
	the 4 bytes len will be in one page as a whole.
	There is a situation that 3 (or less) bytes are left
	at the end of a page, and then the 4 bytes len is
	stored at the start of the next page.
	But the @decompress_lzo doesn't goto the start of
	the next page and continue to read the next 4 bytes
	which is across two pages, so a random value is fetched
	as a "bad compress length".

So we just switch to the page-aligned start position to read
the len of next piece of data when "bad compress length" is encounterd.
If we still get bad compress length in this case, then there is a
real "bad compress length", and we shall report error.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index 38a131e..8b230ab 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -57,6 +57,9 @@ static int dry_run = 0;
 
 #define LZO_LEN 4
 #define PAGE_CACHE_SIZE 4096
+#define PAGE_CACHE_MASK (~(PAGE_CACHE_SIZE - 1))
+#define PAGE_CACHE_ALIGN(addr) (((addr) + PAGE_CACHE_SIZE - 1)	\
+							& PAGE_CACHE_MASK)
 #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
 
 static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
@@ -101,6 +104,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 	size_t out_len = 0;
 	size_t tot_len;
 	size_t tot_in;
+	size_t tot_in_aligned;
+	int aligned = 0;
 	int ret;
 
 	ret = lzo_init();
@@ -117,6 +122,20 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		in_len = read_compress_length(inbuf);
 
 		if ((tot_in + LZO_LEN + in_len) > tot_len) {
+			/*
+			 * The LZO_LEN bytes is guaranteed to be
+			 * in one page as a whole, so if a page
+			 * has fewer than LZO_LEN bytes left,
+			 * the LZO_LEN bytes should be fetched
+			 * at the start of the next page
+			 */
+			if (!aligned) {
+				tot_in_aligned = PAGE_CACHE_ALIGN(tot_in);
+				inbuf += (tot_in_aligned - tot_in);
+				tot_in = tot_in_aligned;
+				aligned = 1;
+				continue;
+			}
 			fprintf(stderr, "bad compress length %lu\n",
 				(unsigned long)in_len);
 			return -1;
@@ -137,6 +156,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		outbuf += new_len;
 		inbuf += in_len;
 		tot_in += in_len;
+		aligned = 0;
 	}
 
 	*decompress_len = out_len;
-- 
1.8.1.4

