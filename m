Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63473 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751947AbcKCEIR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 00:08:17 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v4 2/4] btrfs-progs: introduce new send-dump object
Date: Thu,  3 Nov 2016 12:07:32 +0800
Message-Id: <20161103040734.8098-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce send-dump.[ch] which implements a new btrfs_send_ops to
exam and output all operations inside a send stream.

It has a better output format than the old and no longer compilable
send-test tool, but still tries to be script friendly.

Provides the basis for later "inspect-internal dump-send" command.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 Makefile.in |   2 +-
 send-dump.c | 298 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 send-dump.h |  29 ++++++
 3 files changed, 328 insertions(+), 1 deletion(-)
 create mode 100644 send-dump.c
 create mode 100644 send-dump.h

diff --git a/Makefile.in b/Makefile.in
index b53cf2c..c535c19 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -93,7 +93,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o free-space-tree.o help.o
+	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/send-dump.c b/send-dump.c
new file mode 100644
index 0000000..5de8cdd
--- /dev/null
+++ b/send-dump.c
@@ -0,0 +1,298 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
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
+ * License along with this program.
+ */
+
+#include <unistd.h>
+#include <stdint.h>
+#include <dirent.h>
+#include <pthread.h>
+#include <math.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <libgen.h>
+#include <mntent.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <time.h>
+#include <asm/types.h>
+#include <uuid/uuid.h>
+#include "utils.h"
+#include "commands.h"
+#include "send-utils.h"
+#include "send-stream.h"
+#include "send-dump.h"
+
+/*
+ * Disable format zero length warning since we use zero length format
+ * for unified function parameters.
+ */
+#pragma GCC diagnostic ignored "-Wformat-zero-length"
+
+#define PATH_CAT_OR_RET(function_name, outpath, path1, path2, ret)	\
+({									\
+	ret = path_cat_out(outpath, path1, path2);			\
+	if (ret < 0) {							\
+		error("%s: path invalid: %s\n", function_name, path2);	\
+		return ret;						\
+	}								\
+})
+
+/*
+ * Underlying PRINT_DUMP, the only difference is how we handle
+ * the full path.
+ */
+__attribute__ ((format (printf, 5, 6)))
+static int __print_dump(int subvol, void *user, const char *path,
+			const char *title, const char *fmt, ...)
+{
+	struct btrfs_dump_send_args *r = user;
+	char full_path[PATH_MAX] = {0};
+	char *out_path;
+	va_list args;
+	int ret;
+
+	if (subvol) {
+		PATH_CAT_OR_RET(title, r->full_subvol_path, r->root_path, path, ret);
+		out_path = r->full_subvol_path;
+	} else {
+		PATH_CAT_OR_RET(title, full_path, r->full_subvol_path, path, ret);
+		out_path = full_path;
+	}
+	string_escape_inplace(out_path, " \n\t\\");
+
+	/* Unified header, */
+	printf("%-16s%-32s", title, out_path);
+	va_start(args, fmt);
+	/* Operation specified ones */
+	vprintf(fmt, args);
+	va_end(args);
+	printf("\n");
+	return 0;
+}
+
+/* For subvolume/snapshot operation only */
+#define PRINT_DUMP_SUBVOL(user, path, title, fmt, ...) \
+	__print_dump(1, user, path, title, fmt, ##__VA_ARGS__)
+
+/* For other operations */
+#define PRINT_DUMP(user, path, title, fmt, ...) \
+	__print_dump(0, user, path, title, fmt, ##__VA_ARGS__)
+
+static int print_subvol(const char *path, const u8 *uuid, u64 ctransid,
+			void *user)
+{
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+
+	uuid_unparse(uuid, uuid_str);
+
+	return PRINT_DUMP_SUBVOL(user, path, "subvol", "uuid=%s transid=%llu",
+				 uuid_str, ctransid);
+}
+
+static int print_snapshot(const char *path, const u8 *uuid, u64 ctransid,
+			  const u8 *parent_uuid, u64 parent_ctransid,
+			  void *user)
+{
+	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+	char parent_uuid_str[BTRFS_UUID_UNPARSED_SIZE];
+	int ret;
+
+	uuid_unparse(uuid, uuid_str);
+	uuid_unparse(parent_uuid, parent_uuid_str);
+
+	ret = PRINT_DUMP_SUBVOL(user, path, "snapshot",
+		"uuid=%s transid=%llu parent_uuid=%s parent_transid=%llu",
+				uuid_str, ctransid, parent_uuid_str,
+				parent_ctransid);
+	return ret;
+}
+
+static int print_mkfile(const char *path, void *user)
+{
+	return PRINT_DUMP(user, path, "mkfile", "");
+}
+
+static int print_mkdir(const char *path, void *user)
+{
+	return PRINT_DUMP(user, path, "mkdir", "");
+}
+
+static int print_mknod(const char *path, u64 mode, u64 dev, void *user)
+{
+	return PRINT_DUMP(user, path, "mknod", "mode=%llo dev=0x%llx", mode,
+			  dev);
+}
+
+static int print_mkfifo(const char *path, void *user)
+{
+	return PRINT_DUMP(user, path, "mkfifo", "");
+}
+
+static int print_mksock(const char *path, void *user)
+{
+	return PRINT_DUMP(user, path, "mksock", "");
+}
+
+static int print_symlink(const char *path, const char *lnk, void *user)
+{
+	return PRINT_DUMP(user, path, "symlink", "dest=%s", lnk);
+}
+
+static int print_rename(const char *from, const char *to, void *user)
+{
+	struct btrfs_dump_send_args *r = user;
+	char full_to[PATH_MAX];
+	int ret;
+
+	PATH_CAT_OR_RET("rename", full_to, r->full_subvol_path, to, ret);
+	return PRINT_DUMP(user, from, "rename", "dest=%s", full_to);
+}
+
+static int print_link(const char *path, const char *lnk, void *user)
+{
+	return PRINT_DUMP(user, path, "link", "dest=%s", lnk);
+}
+
+static int print_unlink(const char *path, void *user)
+{
+	return PRINT_DUMP(user, path, "unlink", "");
+}
+
+static int print_rmdir(const char *path, void *user)
+{
+	return PRINT_DUMP(user, path, "rmdir", "");
+}
+
+static int print_write(const char *path, const void *data, u64 offset,
+		       u64 len, void *user)
+{
+	return PRINT_DUMP(user, path, "write", "offset=%llu len=%llu",
+			  offset, len);
+}
+
+static int print_clone(const char *path, u64 offset, u64 len,
+		       const u8 *clone_uuid, u64 clone_ctransid,
+		       const char *clone_path, u64 clone_offset,
+		       void *user)
+{
+	struct btrfs_dump_send_args *r = user;
+	char full_path[PATH_MAX];
+	int ret;
+
+	PATH_CAT_OR_RET("clone", full_path, r->full_subvol_path, clone_path,
+			ret);
+	return PRINT_DUMP(user, path, "clone",
+			  "offset=%llu len=%llu from=%s clone_offset=%llu",
+			  offset, len, full_path, clone_offset);
+}
+
+static int print_set_xattr(const char *path, const char *name,
+			   const void *data, int len, void *user)
+{
+	return PRINT_DUMP(user, path, "set_xattr", "name=%s data=%.*s len=%d",
+			  name, len, (char *)data, len);
+}
+
+static int print_remove_xattr(const char *path, const char *name, void *user)
+{
+
+	return PRINT_DUMP(user, path, "remove_xattr", "name=%s", name);
+}
+
+static int print_truncate(const char *path, u64 size, void *user)
+{
+	return PRINT_DUMP(user, path, "truncate", "size=%llu", size);
+}
+
+static int print_chmod(const char *path, u64 mode, void *user)
+{
+	return PRINT_DUMP(user, path, "chmod", "mode=%llo", mode);
+}
+
+static int print_chown(const char *path, u64 uid, u64 gid, void *user)
+{
+	return PRINT_DUMP(user, path, "chown", "gid=%llu uid=%llu", gid, uid);
+}
+
+static int sprint_timespec(struct timespec *ts, char *restrict dest, int max_size)
+{
+	struct tm *tm;
+	int ret;
+
+	tm = localtime(&ts->tv_sec);
+	if (!tm) {
+		error("failed to convert time %lld.%.9ld to local time",
+		      (long long)ts->tv_sec, ts->tv_nsec);
+		return -EINVAL;
+	}
+	ret = strftime(dest, max_size, "%FT%T%z", tm);
+	if (ret == 0) {
+		error(
+		"time %lld.%ld is too long to convert into readable string",
+		      (long long)ts->tv_sec, ts->tv_nsec);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+#define TIME_STRING_MAX	64
+static int print_utimes(const char *path, struct timespec *at,
+			struct timespec *mt, struct timespec *ct,
+			void *user)
+{
+	char at_str[TIME_STRING_MAX];
+	char mt_str[TIME_STRING_MAX];
+	char ct_str[TIME_STRING_MAX];
+
+	if (sprint_timespec(at, at_str, TIME_STRING_MAX - 1) < 0 ||
+	    sprint_timespec(mt, mt_str, TIME_STRING_MAX - 1) < 0 ||
+	    sprint_timespec(ct, ct_str, TIME_STRING_MAX - 1) < 0)
+		return -EINVAL;
+	return PRINT_DUMP(user, path, "utimes", "atime=%s mtime=%s ctime=%s",
+			  at_str, mt_str, ct_str);
+}
+
+static int print_update_extent(const char *path, u64 offset, u64 len,
+			       void *user)
+{
+	return PRINT_DUMP(user, path, "update_extent", "offset=%llu len=%llu",
+			  offset, len);
+}
+
+struct btrfs_send_ops btrfs_print_send_ops = {
+	.subvol = print_subvol,
+	.snapshot = print_snapshot,
+	.mkfile = print_mkfile,
+	.mkdir = print_mkdir,
+	.mknod = print_mknod,
+	.mkfifo = print_mkfifo,
+	.mksock = print_mksock,
+	.symlink = print_symlink,
+	.rename = print_rename,
+	.link = print_link,
+	.unlink = print_unlink,
+	.rmdir = print_rmdir,
+	.write = print_write,
+	.clone = print_clone,
+	.set_xattr = print_set_xattr,
+	.remove_xattr = print_remove_xattr,
+	.truncate = print_truncate,
+	.chmod = print_chmod,
+	.chown = print_chown,
+	.utimes = print_utimes,
+	.update_extent = print_update_extent
+};
diff --git a/send-dump.h b/send-dump.h
new file mode 100644
index 0000000..06a6108
--- /dev/null
+++ b/send-dump.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
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
+ * License along with this program.
+ */
+
+#ifndef __BTRFS_SEND_DUMP_H__
+#define __BTRFS_SEND_DUMP_H__
+
+#include <linux/limits.h>
+
+struct btrfs_dump_send_args {
+	char full_subvol_path[PATH_MAX];
+	char root_path[PATH_MAX];
+};
+
+extern struct btrfs_send_ops btrfs_print_send_ops;
+
+#endif
-- 
2.10.1



