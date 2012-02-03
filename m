From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 2/3] Btrfs-progs: add 'balance' command group infrastructure
Date: Fri,  3 Feb 2012 23:49:11 +0200
Message-ID: <1328305752-32160-3-git-send-email-idryomov@gmail.com>
References: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328305752-32160-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add balance command group under both 'btrfs' and 'btrfs filesystem'.
Preserve the old 'btrfs filesystem balance <path>' behaviour.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 Makefile          |    2 +-
 btrfs.c           |    1 +
 cmds-balance.c    |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-filesystem.c |   38 +--------------------
 commands.h        |    2 +
 5 files changed, 101 insertions(+), 38 deletions(-)
 create mode 100644 cmds-balance.c

diff --git a/Makefile b/Makefile
index deafda6..cd5f7f1 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o
+	       cmds-inspect.o cmds-balance.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/btrfs.c b/btrfs.c
index 599a3e7..76f725a 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -240,6 +240,7 @@ const struct cmd_group btrfs_cmd_group = {
 	btrfs_cmd_group_usage, btrfs_cmd_group_info, {
 		{ "subvolume", cmd_subvolume, NULL, &subvolume_cmd_group, 0 },
 		{ "filesystem", cmd_filesystem, NULL, &filesystem_cmd_group, 0 },
+		{ "balance", cmd_balance, NULL, &balance_cmd_group, 0 },
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
diff --git a/cmds-balance.c b/cmds-balance.c
new file mode 100644
index 0000000..d141b46
--- /dev/null
+++ b/cmds-balance.c
@@ -0,0 +1,96 @@
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
+#include <sys/ioctl.h>
+#include <errno.h>
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "ioctl.h"
+#include "volumes.h"
+
+#include "commands.h"
+
+static const char balance_cmd_group_usage[] =
+	"btrfs [filesystem] balance [<command>] [options] <path>";
+
+static const char balance_cmd_group_info[] =
+	"'btrfs filesystem balance' command is deprecated, please use\n"
+	"'btrfs balance start' command instead.";
+
+static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args)
+{
+	int fd;
+	int ret;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, args);
+	e = errno;
+	close(fd);
+
+	if (ret < 0) {
+		if (e == ECANCELED) {
+			if (args->state & BTRFS_BALANCE_STATE_PAUSE_REQ)
+				fprintf(stderr, "balance paused by user\n");
+			if (args->state & BTRFS_BALANCE_STATE_CANCEL_REQ)
+				fprintf(stderr, "balance canceled by user\n");
+		} else {
+			fprintf(stderr, "ERROR: error during balancing '%s' "
+				"- %s\n", path, strerror(e));
+			if (e != EINPROGRESS)
+				fprintf(stderr, "There may be more info in "
+					"syslog - try dmesg | tail\n");
+			return 19;
+		}
+	} else {
+		printf("Done, had to relocate %llu out of %llu chunks\n",
+		       (unsigned long long)args->stat.completed,
+		       (unsigned long long)args->stat.considered);
+	}
+
+	return 0;
+}
+
+const struct cmd_group balance_cmd_group = {
+	balance_cmd_group_usage, balance_cmd_group_info, {
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_balance(int argc, char **argv)
+{
+	if (argc == 2) {
+		/* old 'btrfs filesystem balance <path>' syntax */
+		struct btrfs_ioctl_balance_args args;
+
+		memset(&args, 0, sizeof(args));
+		args.flags |= BTRFS_BALANCE_TYPE_MASK;
+
+		return do_balance(argv[1], &args);
+	}
+
+	return handle_command_group(&balance_cmd_group, argc, argv);
+}
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 828ca0c..a2efb93 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -453,42 +453,6 @@ static int cmd_defrag(int argc, char **argv)
 	return errors + 20;
 }
 
-static const char * const cmd_balance_usage[] = {
-	"btrfs filesystem balance <path>",
-	"Balance the chunks across the device",
-	NULL
-};
-
-static int cmd_balance(int argc, char **argv)
-{
-	int	fdmnt, ret=0, e;
-	struct btrfs_ioctl_vol_args args;
-	char	*path;
-
-	if (check_argc_exact(argc, 2))
-		usage(cmd_balance_usage);
-
-	path = argv[1];
-
-	fdmnt = open_file_or_dir(path);
-	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-		return 12;
-	}
-
-	memset(&args, 0, sizeof(args));
-	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
-	e = errno;
-	close(fdmnt);
-	if(ret<0){
-		fprintf(stderr, "ERROR: error during balancing '%s' - %s\n", 
-			path, strerror(e));
-
-		return 19;
-	}
-	return 0;
-}
-
 static const char * const cmd_resize_usage[] = {
 	"btrfs filesystem resize [+/-]<newsize>[gkm]|max <path>",
 	"Resize a filesystem",
@@ -559,7 +523,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
-		{ "balance", cmd_balance, cmd_balance_usage, NULL, 0 },
+		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
diff --git a/commands.h b/commands.h
index 5d024c2..de2c75c 100644
--- a/commands.h
+++ b/commands.h
@@ -84,12 +84,14 @@ int open_file_or_dir(const char *fname);
 
 extern const struct cmd_group subvolume_cmd_group;
 extern const struct cmd_group filesystem_cmd_group;
+extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
+int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
-- 
1.7.6.3

