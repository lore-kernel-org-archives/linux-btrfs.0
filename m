Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm19.bullet.mail.ird.yahoo.com ([77.238.189.76]:22504 "HELO
	nm19.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759061Ab3BWNpM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 08:45:12 -0500
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
Date: Sat, 23 Feb 2013 14:46:04 +0100
Message-Id: <1361627171-8246-2-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

This patch adds some helpers to manage the strings allocation and
deallocation.
The function string_list_add(char *) adds the passed string to a list;
the function string_list_free() frees all the strings together.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile      |    3 ++-
 string_list.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 string_list.h |   23 +++++++++++++++++++++
 3 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 string_list.c
 create mode 100644 string_list.h

diff --git a/Makefile b/Makefile
index 596bf93..0d6c43a 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
-	  send-stream.o send-utils.o qgroup.o raid6.o
+	  send-stream.o send-utils.o qgroup.o raid6.o \
+	  string_list.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o
diff --git a/string_list.c b/string_list.c
new file mode 100644
index 0000000..8d8cc1f
--- /dev/null
+++ b/string_list.c
@@ -0,0 +1,63 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+/* To store the strings */
+static void **strings_to_free;
+static int count_string_to_free;
+
+/* 
+ * Add a string to the dynamic allocated string list
+ */
+char *string_list_add(char *s)
+{
+	int  size;
+
+	size = sizeof(void *) * ++count_string_to_free;
+	strings_to_free = realloc(strings_to_free, size);
+
+	/* if we don't have enough memory, we have more serius
+	   problem than that a wrong handling of not enough memory */
+	if (!strings_to_free) {
+		fprintf(stderr, "add_string_to_free(): Not enough memory\n");
+		count_string_to_free = 0;
+		return NULL;
+	}
+
+	strings_to_free[count_string_to_free-1] = s;
+	return s;
+}
+
+/*
+ * Free the dynamic allocated strings list
+ */
+void string_list_free()
+{
+	int	i;
+	for (i = 0 ; i < count_string_to_free ; i++)
+		free(strings_to_free[i]);
+
+	free(strings_to_free);
+
+	strings_to_free = 0;
+	count_string_to_free = 0;
+}
+
+
diff --git a/string_list.h b/string_list.h
new file mode 100644
index 0000000..f974fbc
--- /dev/null
+++ b/string_list.h
@@ -0,0 +1,23 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef STRING_LIST_H
+#define STRING_LIST_H
+
+void string_list_add(char *s);
+void string_list_free();
+
+#endif
-- 
1.7.10.4

