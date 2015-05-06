Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbbEFIf2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 04:35:28 -0400
From: xuw2015@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>
Subject: [PATCH] btrfs-progs: replace PAGE_CACHE_SIZE to sysconf(_SC_PAGESIZE)
Date: Wed,  6 May 2015 16:35:22 +0800
Message-Id: <1430901322-10133-1-git-send-email-xuw2015@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: George Wang <xuw2015@gmail.com>

PAGE_CACHE_SIZE is usually 4096. But for some ppc64/ppc64le, it will be 65536.
Just replace this fixed PAGE_CACHE_SIZE to sysconf(_SC_PAGESIZE), which will
be more flexible

Signed-off-by: George Wang <xuw2015@gmail.com>

diff --git a/cmds-restore.c b/cmds-restore.c
index e1411e9..bf839f4 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -54,9 +54,13 @@ static int get_xattrs = 0;
 static int dry_run = 0;
 
 #define LZO_LEN 4
-#define PAGE_CACHE_SIZE 4096
 #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
 
+static inline long pagesize(void)
+{
+	return sysconf(_SC_PAGESIZE);
+}
+
 static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
 			   u64 decompress_len)
 {
@@ -125,7 +129,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		inbuf += LZO_LEN;
 		tot_in += LZO_LEN;
 
-		new_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
+		new_len = lzo1x_worst_compress(pagesize());
 		ret = lzo1x_decompress_safe((const unsigned char *)inbuf, in_len,
 					    (unsigned char *)outbuf,
 					    (void *)&new_len, NULL);
@@ -142,8 +146,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		 * If the 4 byte header does not fit to the rest of the page we
 		 * have to move to the next one, unless we read some garbage
 		 */
-		mod_page = tot_in % PAGE_CACHE_SIZE;
-		rem_page = PAGE_CACHE_SIZE - mod_page;
+		mod_page = tot_in % pagesize();
+		rem_page = pagesize() - mod_page;
 		if (rem_page < LZO_LEN) {
 			inbuf += rem_page;
 			tot_in += rem_page;
-- 
1.9.3

