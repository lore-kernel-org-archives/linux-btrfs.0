Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20594 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078AbaFMBri (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 21:47:38 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <akpm@linux-foundation.org>,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v4] lib: add size unit t/p/e to memparse
Date: Fri, 13 Jun 2014 09:42:26 +0800
Message-ID: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For modern filesystems such as btrfs, t/p/e size level operations
are common.
add size unit t/p/e parsing to memparse

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: replace kilobyte with kibibyte, and others
	v2->v3: add missing unit "bytes" in comment
	v3->v4: remove idiotic name for K,M,G,P,T,E
---
 lib/cmdline.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index d4932f7..76a712e 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -121,11 +121,7 @@ EXPORT_SYMBOL(get_options);
  *	@retptr: (output) Optional pointer to next char after parse completes
  *
  *	Parses a string into a number.  The number stored at @ptr is
- *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
- *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
- *	1073741824).  If the number is suffixed with K, M, or G, then
- *	the return value is the number multiplied by one kilobyte, one
- *	megabyte, or one gigabyte, respectively.
+ *	potentially suffixed with K, M, G, T, P, E.
  */
 
 unsigned long long memparse(const char *ptr, char **retptr)
@@ -135,6 +131,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
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

