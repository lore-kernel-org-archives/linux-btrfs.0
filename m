Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbaCaKHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 06:07:32 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] lib: add size unit t/p/e to memparse
Date: Mon, 31 Mar 2014 18:03:05 +0800
Message-Id: <1396260185-14109-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For modern filesystems such as btrfs, t/p/e size level operations
are common.
add size unit t/p/e parsing to memparse

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 lib/cmdline.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index eb67911..20a55b0 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -119,11 +119,17 @@ char *get_options(const char *str, int nints, int *ints)
  *	@retptr: (output) Optional pointer to next char after parse completes
  *
  *	Parses a string into a number.  The number stored at @ptr is
- *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
- *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
- *	1073741824).  If the number is suffixed with K, M, or G, then
+ *	potentially suffixed with
+ *	%K (for kilobytes, or 1024 bytes),
+ *	%M (for megabytes, or 1048576 bytes),
+ *	%G (for gigabytes, or 1073741824),
+ *	%T (for terabytes, or 1099511627776),
+ *	%P (for petabytes, or 1125899906842624 bytes),
+ *	%E (for exabytes, or 1152921504606846976 bytes).
+ *	If the number is suffixed with K, M, G, T, P, E, then
  *	the return value is the number multiplied by one kilobyte, one
- *	megabyte, or one gigabyte, respectively.
+ *	megabyte, one gigabyte, one terabyte, one petabyte, one exabyte,
+ *	respectively.
  */
 
 unsigned long long memparse(const char *ptr, char **retptr)
@@ -133,6 +139,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
 	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
 
 	switch (*endptr) {
+	case 'E':
+	case 'e':
+		ret <<= 10;
+	case 'P':
+	case 'p':
+		ret <<= 10;
+	case 'T':
+	case 't':
+		ret <<= 10;
 	case 'G':
 	case 'g':
 		ret <<= 10;
-- 
1.8.1.4

