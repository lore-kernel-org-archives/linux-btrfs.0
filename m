Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62053 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932601AbdDQD0y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:54 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 6/9] btrfs-progs: Introduce btrfs-modify tool to modify btrfs internal structures
Date: Mon, 17 Apr 2017 11:26:39 +0800
Message-ID: <20170417032642.30770-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce the basic framework of a new prog, btrfs-modify,
which is designed to modify variant internal btrfs structures and
provide the basis for btrfs recovery test cases.

Btrfs-modify prog uses the command group facility to make it extendable,
the final objective is to replace the less maintained and poorly
documented btrfs-corrupt prog.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 .gitignore                          |   1 +
 Documentation/Makefile.in           |   1 +
 Documentation/btrfs-modify.asciidoc |  35 ++++++++++++
 Makefile                            |  10 +++-
 modify/main.c                       | 108 ++++++++++++++++++++++++++++++++++++
 5 files changed, 154 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-modify.asciidoc
 create mode 100644 modify/main.c

diff --git a/.gitignore b/.gitignore
index 43c0ed88..69bb2f7a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -41,6 +41,7 @@ libbtrfs.so.0
 libbtrfs.so.0.1
 library-test
 library-test-static
+btrfs-modify
 /fssum
 
 /tests/*-tests-results.txt
diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index 539c6b55..272432f5 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -11,6 +11,7 @@ MAN8_TXT += btrfs-select-super.asciidoc
 MAN8_TXT += btrfstune.asciidoc
 MAN8_TXT += fsck.btrfs.asciidoc
 MAN8_TXT += mkfs.btrfs.asciidoc
+MAN8_TXT += btrfs-modify.asciidoc
 
 # Sub commands for btrfs
 MAN8_TXT += btrfs-subvolume.asciidoc
diff --git a/Documentation/btrfs-modify.asciidoc b/Documentation/btrfs-modify.asciidoc
new file mode 100644
index 00000000..7d6e8e73
--- /dev/null
+++ b/Documentation/btrfs-modify.asciidoc
@@ -0,0 +1,35 @@
+btrfs-modify(8)
+===============
+
+NAME
+----
+btrfs-modify - modify variant internal structure of a unmounted btrfs
+
+SYNOPSIS
+--------
+*btrfs-modify* <command> <options> <device>
+
+DESCRIPTION
+-----------
+*btrfs-modify* is used to modify variant btrfs internal structures, either for
+experienced user to fix filesystem, or corrupt fs for test purpose.
+
+COMMANDS
+--------
+Nothing yet
+
+OPTIONS
+-------
+Nothing yet
+
+AVAILABILITY
+------------
+*btrfs-modify* is part of btrfs-progs.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`btrfs`(5),
+`btrfs`(8),
+`btrfs-inspect-internal`(8)
diff --git a/Makefile b/Makefile
index f405c1ec..633c4447 100644
--- a/Makefile
+++ b/Makefile
@@ -168,7 +168,7 @@ endif
 MAKEOPTS = --no-print-directory Q=$(Q)
 
 # build all by default
-progs = $(progs_install) btrfsck btrfs-corrupt-block
+progs = $(progs_install) btrfsck btrfs-corrupt-block btrfs-modify
 
 # install only selected
 progs_install = btrfs mkfs.btrfs btrfs-debug-tree \
@@ -394,6 +394,14 @@ btrfs-image.static: image/main.static.o $(static_objects) $(static_libbtrfs_obje
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
 
+btrfs-modify: modify/main.o $(objects) $(libs_static)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
+
+btrfs-modify.static: modify/main.static.o $(static_objects) $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
+
 btrfs-convert: $(convert_objects) $(objects) $(libs_static)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(btrfs_convert_libs) $(LIBS)
diff --git a/modify/main.c b/modify/main.c
new file mode 100644
index 00000000..107e2e7e
--- /dev/null
+++ b/modify/main.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
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
+#include <fcntl.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <limits.h>
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "volumes.h"
+#include "disk-io.h"
+#include "transaction.h"
+#include "list.h"
+#include "utils.h"
+#include "help.h"
+#include "commands.h"
+#include "crc32c.h"
+
+const char * const modify_group_usage[] = {
+	"btrfs-modify <command> <dest_options> <device>",
+	NULL
+};
+
+static const char * const modify_short_desc[] = {
+	"For an overview of a given command use 'btrfs-modify command --help'",
+	"or 'btrfs-modify [command...] --help --full' to print all available options.",
+	"Any command name can be shortened as far as it stays unambiguous,",
+	"however it is recommended to use full command names in scripts.",
+	"All command groups share the same man page named 'btrfs-modify'.",
+	NULL
+};
+
+static const char modify_group_info[] =
+	"Use --help as an argument for information on a specific group or command.";
+
+static const struct cmd_group modify_cmd_group = {
+	modify_group_usage, modify_group_info, {
+		NULL_CMD_STRUCT
+	},
+};
+
+static void check_options(int argc, char **argv)
+{
+	const char *arg;
+
+	if (argc == 0)
+		return;
+
+	arg = argv[0];
+
+	if (arg[0] != '-' ||
+	    !strncmp(arg, "--help", strlen("--help")))
+		return;
+	fprintf(stderr, "Unknown option: %s\n", arg);
+	fprintf(stderr, "usage: %s\n",
+		modify_cmd_group.usagestr[0]);
+	exit(129);
+}
+
+int main(int argc, char **argv)
+{
+	const struct cmd_struct *command;
+	int ret;
+
+	btrfs_config_init();
+
+	set_argv0(argv);
+	argc--;
+	argv++;
+
+	check_options(argc, argv);
+	if (argc == 0) {
+		usage_command_group_short(&modify_cmd_group, modify_short_desc);
+		exit(1);
+	}
+
+	command = parse_command_token(argv[0], &modify_cmd_group);
+
+	handle_help_options_next_level(command, argc, argv);
+
+	crc32c_optimization_init();
+
+	fixup_argv0(argv, command->token);
+
+	ret = command->fn(argc, argv);
+
+	btrfs_close_all_devices();
+
+	exit(!!ret);
+}
-- 
2.12.2



