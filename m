Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54865 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3KPRJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 12:09:15 -0500
Received: by mail-wi0-f177.google.com with SMTP id hq4so2236641wib.16
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 09:09:14 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/7] recursive btrfs sub snapshot/delete: create pathjoin() function
Date: Sat, 16 Nov 2013 18:09:02 +0100
Message-Id: <1384621747-25441-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The pathjoin() function creates a path from a list of strings.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 utils.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 64 insertions(+)

diff --git a/utils.c b/utils.c
index f499023..5f4d0ef 100644
--- a/utils.c
+++ b/utils.c
@@ -38,6 +38,7 @@
 #include <linux/kdev_t.h>
 #include <limits.h>
 #include <blkid/blkid.h>
+#include <stdarg.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -2108,3 +2109,65 @@ int lookup_ino_rootid(int fd, u64 *rootid)
 
 	return 0;
 }
+
+/*
+ * Joints a list of string. The list has to be NULL terminated
+ */
+char *pathjoin( char *s, ...)
+{
+	va_list		ap;
+	int 		size;
+	char		*dst;
+
+	if (!s || !strlen(s))
+		return NULL;
+
+	size = strlen(s)+1;
+	va_start(ap, s);
+
+	do {
+		char *p;
+
+		p = va_arg(ap, char *);
+		if (!p)
+			break;
+
+		size += strlen(p)+1;
+	} while(1);
+
+	va_end(ap);
+	size++;
+
+	dst = malloc(size);
+	if (!dst)
+		return NULL;
+
+	strcpy(dst, s);
+	va_start(ap, s);
+
+	do {
+		char *p;
+		int l, l2;
+		p = va_arg(ap, char *);
+		if (!p)
+			break;
+		if (*p == '/')
+			p++;
+
+		l2 = strlen(p);
+		if (!l2)
+			continue;
+		if (p[l2-1] == '/')
+			p[l2-1] = 0;
+
+		l = strlen(dst);
+		if (dst[l-1] != '/')
+			strcat(dst, "/");
+		strcat(dst, p);
+
+	} while(1);
+	va_end(ap);
+
+	return dst;
+
+}
\ No newline at end of file
diff --git a/utils.h b/utils.h
index 6f4b10c..d6c52a6 100644
--- a/utils.h
+++ b/utils.h
@@ -94,5 +94,6 @@ int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
 int btrfs_scan_lblkid(int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
+char *pathjoin(char *, ...);
 
 #endif
-- 
1.8.4.3

