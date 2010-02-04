From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 2/6] btrfs-progs: Add debug-btrfs command
Date: Thu,  4 Feb 2010 23:14:03 +0530
Message-ID: <1265305447-30780-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Makefile                       |    3 ++
 debugbtrfs/Makefile            |   44 +++++++++++++++++++++++++++++
 debugbtrfs/cmds.c              |   27 ++++++++++++++++++
 debugbtrfs/debug_btrfs.c       |   59 ++++++++++++++++++++++++++++++++++++++++
 debugbtrfs/debug_btrfs.h       |   29 +++++++++++++++++++
 debugbtrfs/debug_btrfs_cmds.ct |   24 ++++++++++++++++
 6 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100644 debugbtrfs/Makefile
 create mode 100644 debugbtrfs/cmds.c
 create mode 100644 debugbtrfs/debug_btrfs.c
 create mode 100644 debugbtrfs/debug_btrfs.h
 create mode 100644 debugbtrfs/debug_btrfs_cmds.ct

diff --git a/Makefile b/Makefile
index a30c212..3efd405 100644
--- a/Makefile
+++ b/Makefile
@@ -12,6 +12,9 @@ bindir = $(prefix)/bin
 LIBS=-luuid
 
 SUBDIRS=lib misc man
+ifneq ($(E2FSPRGS_BUILD_DIR),)
+	SUBDIRS += debugbtrfs
+endif
 
 # make C=1 to enable sparse
 ifdef C
diff --git a/debugbtrfs/Makefile b/debugbtrfs/Makefile
new file mode 100644
index 0000000..348160b
--- /dev/null
+++ b/debugbtrfs/Makefile
@@ -0,0 +1,44 @@
+CC=gcc
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+CFLAGS = -g -Werror -Os -I$(E2FSPRGS_BUILD_DIR)/lib/ -I../lib/
+
+#
+CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
+		-Wuninitialized -Wshadow -Wundef
+DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+INSTALL= install
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+LIBS=-L$(E2FSPRGS_BUILD_DIR)/lib/ss -lss -ldl -lcom_err -luuid
+TOPDIR=../
+
+MK_CMDS= _SS_DIR_OVERRIDE=$(E2FSPRGS_BUILD_DIR)/lib/ss $(E2FSPRGS_BUILD_DIR)/lib/ss/mk_cmds
+
+progs = debug-btrfs
+
+# make C=1 to enable sparse
+ifdef C
+	check=sparse $(CHECKFLAGS)
+else
+	check=ls
+endif
+
+.c.o:
+	$(check) $<
+	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+all: $(progs)
+
+debug_btrfs_cmds.c: debug_btrfs_cmds.ct
+	$(MK_CMDS) debug_btrfs_cmds.ct
+
+debug-btrfs: $(TOPDIR)/lib/libbtrfs.a  debug_btrfs.o cmds.o debug_btrfs_cmds.o
+	$(CC) $(CFLAGS) -o debug-btrfs $^ $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
+
+clean:
+	rm -f *.o debug_btrfs_cmds.c
+	rm -f .*.d
+	rm -f debug-btrfs
+
+-include .*.d
diff --git a/debugbtrfs/cmds.c b/debugbtrfs/cmds.c
new file mode 100644
index 0000000..f5ed877
--- /dev/null
+++ b/debugbtrfs/cmds.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
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
+#include "debug_btrfs.h"
+
+void do_show_debugfs_params(int argc, char *argv[])
+{
+        FILE *out = stdout;
+        fprintf(out, "Filesystem in use: %s\n", current_device);
+}
diff --git a/debugbtrfs/debug_btrfs.c b/debugbtrfs/debug_btrfs.c
new file mode 100644
index 0000000..44d6f64
--- /dev/null
+++ b/debugbtrfs/debug_btrfs.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
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
+#include <ss/ss.h>
+#include "debug_btrfs.h"
+
+extern ss_request_table btrfs_debug_cmds;
+const char *current_device;
+
+void usage(char *prg)
+{
+	fprintf(stderr, "Usage: %s device\n", prg);
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	int sci_idx;
+	int retval;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	current_device = argv[1];
+	sci_idx = ss_create_invocation("debug-btrfs", "0.0", NULL,
+				&btrfs_debug_cmds, &retval);
+	if (retval) {
+		ss_perror(sci_idx, retval, "create invocation");
+		exit(1);
+	}
+	ss_get_readline(sci_idx);
+	(void) ss_add_request_table (sci_idx, &ss_std_requests, 1, &retval);
+        if (retval) {
+                ss_perror(sci_idx, retval, "adding standard requests");
+                exit (1);
+        }
+	ss_listen(sci_idx);
+	ss_delete_invocation(sci_idx);
+
+	return 0;
+}
diff --git a/debugbtrfs/debug_btrfs.h b/debugbtrfs/debug_btrfs.h
new file mode 100644
index 0000000..55d7b17
--- /dev/null
+++ b/debugbtrfs/debug_btrfs.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
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
+#ifndef DEBUG_BTRFS_H
+#define DEBUG_BTRFS_H
+#include <getopt.h>
+
+extern const char *current_device;
+static inline void reset_getopt(void)
+{
+	optind = 0;
+}
+#endif
diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
new file mode 100644
index 0000000..29095d3
--- /dev/null
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -0,0 +1,24 @@
+# Copyright IBM Corporation, 2010
+# Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public
+# License v2 as published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public
+# License along with this program; if not, write to the
+# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+# Boston, MA 021110-1307, USA.
+
+command_table btrfs_debug_cmds;
+
+request do_show_debugfs_params, "Show btrfs_debug parameters",
+	show_debugfs_params, params;
+
+end;
+
-- 
1.7.0.rc0.48.gdace5

