Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([125.16.236.1]:57375 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbcCIMXT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 07:23:19 -0500
Received: from localhost
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 9 Mar 2016 17:52:20 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u29CM5xm48300210
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Mar 2016 17:52:05 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u29CM3gb005084
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Mar 2016 17:52:04 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: chandan@linux.vnet.ibm.com, Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH] btrfs-progs: Replace hardcoded PAGE_CACHE_SIZE with getpagesize().
Date: Wed,  9 Mar 2016 20:22:13 +0800
Message-Id: <1457526133-28575-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

PAGE_CACHE_SIZE is hardcoded to 4K in cmds-restore.c. It makes lzo
decompress fail on ppc64. Fix this through replacing hardcoded 4K
with getpagesize().

Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 cmds-restore.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 161fd91..17a5475 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -56,7 +56,6 @@ static int get_xattrs = 0;
 static int dry_run = 0;
 
 #define LZO_LEN 4
-#define PAGE_CACHE_SIZE 4096
 #define lzo1x_worst_compress(x) ((x) + ((x) / 16) + 64 + 3)
 
 static int decompress_zlib(char *inbuf, char *outbuf, u64 compress_len,
@@ -127,7 +126,7 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		inbuf += LZO_LEN;
 		tot_in += LZO_LEN;
 
-		new_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
+		new_len = lzo1x_worst_compress(getpagesize());
 		ret = lzo1x_decompress_safe((const unsigned char *)inbuf, in_len,
 					    (unsigned char *)outbuf,
 					    (void *)&new_len, NULL);
@@ -144,8 +143,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 		 * If the 4 byte header does not fit to the rest of the page we
 		 * have to move to the next one, unless we read some garbage
 		 */
-		mod_page = tot_in % PAGE_CACHE_SIZE;
-		rem_page = PAGE_CACHE_SIZE - mod_page;
+		mod_page = tot_in % getpagesize();
+		rem_page = getpagesize() - mod_page;
 		if (rem_page < LZO_LEN) {
 			inbuf += rem_page;
 			tot_in += rem_page;
-- 
1.9.1

