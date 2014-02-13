Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:48093 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaBMTTR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:19:17 -0500
Received: from venice.bhome (151.28.65.181) by outrelay08.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA6A1903102B6A for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:19:16 +0100
Message-ID: <52FD1AB9.30602@libero.it>
Date: Thu, 13 Feb 2014 20:19:21 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/8] Add helpers functions to handle the printing of data
 in tabular format.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>

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
 Makefile       |   2 +-
 string_table.c | 156 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 string_table.h |  36 +++++++++++++
 3 files changed, 193 insertions(+), 1 deletion(-)
 create mode 100644 string_table.c
 create mode 100644 string_table.h

diff --git a/Makefile b/Makefile
index db470b6..5738379 100644
--- a/Makefile
+++ b/Makefile
@@ -9,7 +9,7 @@ CFLAGS = -g -O1 -fno-strict-aliasing
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o list_sort.o
+	  qgroup.o raid6.o free-space-cache.o list_sort.o string_table.o 
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/string_table.c b/string_table.c
new file mode 100644
index 0000000..016356c
--- /dev/null
+++ b/string_table.c
@@ -0,0 +1,156 @@
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
+ * be replaced by a '=====' dimensioned on the basis of the column width
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
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
