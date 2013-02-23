Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm8.bullet.mail.ird.yahoo.com ([77.238.189.23]:31363 "HELO
	nm8.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759094Ab3BWNpS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 08:45:18 -0500
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/8] Add helpers functions to handle the printing of data in tabular format.
Date: Sat, 23 Feb 2013 14:46:07 +0100
Message-Id: <1361627171-8246-5-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

This patch adds some functions to manage the printing of the data in
tabular format.

The function
	struct string_table *table_create(int columns, int rows)
creates an (empty) table.

The functions
	char *table_printf(struct string_table *tab, int column,
		int row, char *fmt, ...)
	char *table_vprintf(struct string_table *tab, int column,
		int row, char *fmt, va_list ap)
populate the table with text. To align the text to the left, the text
shall be prefixed with '<', otherwise the text shall be prefixed by a
'>'. If the first character is a '=', the the text is replace by a
sequence of '=' to fill the column width.

The function
	void table_free(struct string_table *)
frees all the data associated to the table.

The function
	void table_dump(struct string_table *tab)
prints the table on stdout.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Makefile       |    2 +-
 string_table.c |  157 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 string_table.h |   36 +++++++++++++
 3 files changed, 194 insertions(+), 1 deletion(-)
 create mode 100644 string_table.c
 create mode 100644 string_table.h

diff --git a/Makefile b/Makefile
index bd792b6..fd1b312 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
 	  send-stream.o send-utils.o qgroup.o raid6.o \
-	  string_list.o
+	  string_list.o string_table.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-fi-disk_usage.o
diff --git a/string_table.c b/string_table.c
new file mode 100644
index 0000000..9784422
--- /dev/null
+++ b/string_table.c
@@ -0,0 +1,157 @@
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
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdarg.h>
+
+#include "string_table.h"
+
+/*
+ *  This function create an array of char * which will represent a table
+ */
+struct string_table *table_create(int columns, int rows)
+{
+	struct string_table *p;
+	int size;
+	
+	
+	size = sizeof( struct string_table ) + 
+		rows * columns* sizeof(char *);
+	p = calloc(1, size);
+
+	if (!p) return NULL;
+
+	p->ncols = columns;
+	p->nrows = rows;
+
+	return p;
+}
+
+/*
+ * This function is like a vprintf, but store the results in a cell of
+ * the table.
+ * If fmt  starts with '<', the text is left aligned; if fmt starts with
+ * '>' the text is right aligned. If fmt is equal to '=' the text will
+ * be replaced by a '=====' dimensioned in the basis of the column width
+ */
+char *table_vprintf(struct string_table *tab, int column, int row,
+			  char *fmt, va_list ap)
+{
+	int idx = tab->ncols*row+column;
+	char *msg = calloc(100, sizeof(char));
+
+	if (!msg)
+		return NULL;
+
+	if (tab->cells[idx])
+		free(tab->cells[idx]);
+	tab->cells[idx] = msg;
+	vsnprintf(msg, 99, fmt, ap);
+
+	return msg;
+}
+
+
+/*
+ * This function is like a printf, but store the results in a cell of
+ * the table.
+ */
+char *table_printf(struct string_table *tab, int column, int row,
+			  char *fmt, ...)
+{
+	va_list ap;
+	char *ret;
+
+	va_start(ap, fmt);
+	ret = table_vprintf(tab, column, row, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+/*
+ * This function dumps the table. Every "=" string will be replaced by
+ * a "=======" length as the column
+ */
+void table_dump(struct string_table *tab)
+{
+	int	sizes[tab->ncols];
+	int	i, j;
+
+	for (i = 0 ; i < tab->ncols ; i++) {
+		sizes[i] = 0;
+		for (j = 0 ; j < tab->nrows ; j++) {
+			int idx = i + j*tab->ncols;
+			int s;
+
+			if (!tab->cells[idx])
+				continue;
+
+			s = strlen(tab->cells[idx]) - 1;
+			if (s < 1 || tab->cells[idx][0] == '=')
+				continue;
+
+			if (s > sizes[i])
+				sizes[i] = s;
+		}
+	}
+
+
+	for (j = 0 ; j < tab->nrows ; j++) {
+		for (i = 0 ; i < tab->ncols ; i++) {
+
+			int idx = i + j*tab->ncols;
+			char *s = tab->cells[idx];
+
+			if (!s|| !strlen(s)) {
+				printf("%*s", sizes[i], "");
+			} else if (s && s[0] == '=') {
+				int k = sizes[i];
+				while(k--)
+					putchar('=');
+			} else {
+				printf("%*s",
+					s[0] == '<' ? -sizes[i] : sizes[i],
+					s+1);
+			} 
+			if (i != (tab->ncols - 1))
+				putchar(' ');
+		}
+		putchar('\n');
+	}
+
+}
+
+/*
+ *  Deallocate a tabular and all its content
+ */
+
+void table_free(struct string_table *tab)
+{
+
+	int	i, count;
+
+	count = tab->ncols * tab->nrows;
+
+	for (i=0 ; i < count ; i++)
+		if (tab->cells[i])
+			free(tab->cells[i]);
+
+	free(tab);
+
+}
diff --git a/string_table.h b/string_table.h
new file mode 100644
index 0000000..83c4425
--- /dev/null
+++ b/string_table.h
@@ -0,0 +1,36 @@
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
+#ifndef STRING_TABLE_H
+#define STRING_TABLE_H
+
+struct string_table {
+
+	int	ncols, nrows;
+	char	*cells[];
+
+};
+
+
+struct string_table *table_create(int columns, int rows);
+char *table_printf(struct string_table *tab, int column, int row,
+			  char *fmt, ...);
+char *table_vprintf(struct string_table *tab, int column, int row,
+			  char *fmt, va_list ap);
+void table_dump(struct string_table *tab);
+void table_free(struct string_table *);
+
+#endif
-- 
1.7.10.4

