Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3IQPVf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:21:35 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3E2F5A5511
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 17:21:34 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/3] btrfs-progs: introduce rescue command group
Date: Tue, 17 Sep 2013 17:21:20 +0200
Message-Id: <2f00f09d57c7bf8278a32d1bc1bfe56d53de4a5b.1379430631.git.dsterba@suse.cz>
In-Reply-To: <cover.1379430631.git.dsterba@suse.cz>
References: <cover.1379430631.git.dsterba@suse.cz>
In-Reply-To: <cover.1379430631.git.dsterba@suse.cz>
References: <cover.1379430631.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add an empty 1st level command namespace that will collect specialized
recovery tools like chunk-recover, zero-log, select-super and similar.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile       |  2 +-
 btrfs.c        |  1 +
 cmds-rescue.c  | 37 +++++++++++++++++++++++++++++++++++++
 commands.h     |  3 +++
 man/btrfs.8.in |  6 ++++++
 5 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 cmds-rescue.c

diff --git a/Makefile b/Makefile
index 3d715d8..9e58028 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-	       cmds-restore.o cmds-chunk.o cmds-dedup.o
+	       cmds-restore.o cmds-chunk.o cmds-dedup.o cmds-rescue.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index c85af14..14a27cb 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -247,6 +247,7 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
+		{ "rescue", cmd_rescue, NULL, &rescue_cmd_group, 0 },
 		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
diff --git a/cmds-rescue.c b/cmds-rescue.c
new file mode 100644
index 0000000..35a61f8
--- /dev/null
+++ b/cmds-rescue.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2013 SUSE.  All rights reserved.
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
+#include "kerncompat.h"
+
+#include "commands.h"
+
+static const char * const rescue_cmd_group_usage[] = {
+	"btrfs rescue <command> [options] <path>",
+	NULL
+};
+
+const struct cmd_group rescue_cmd_group = {
+	rescue_cmd_group_usage, NULL, {
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_rescue(int argc, char **argv)
+{
+	return handle_command_group(&rescue_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index fa7a8ce..d25b8c1 100644
--- a/commands.h
+++ b/commands.h
@@ -91,12 +91,14 @@ extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group dedup_cmd_group;
+extern const struct cmd_group rescue_cmd_group;
 
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
 extern const char * const cmd_check_usage[];
 extern const char * const cmd_chunk_recover_usage[];
 extern const char * const cmd_restore_usage[];
+extern const char * const cmd_rescue_usage[];
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -116,6 +118,7 @@ int cmd_select_super(int argc, char **argv);
 int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
 int cmd_dedup(int argc, char **argv);
+int cmd_rescue(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 61ffe8d..24777e6 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -69,6 +69,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBcheck\fP [\fIoptions\fP] \fI<device>\fP
 .PP
+\fBbtrfs\fP \fBrescue\fP [\fIoptions\fP] \fI<path>\fP
+.PP
 \fBbtrfs\fP \fBchunk-recover\fP [\fIoptions\fP] \fI<device>\fP
 .PP
 \fBbtrfs\fP \fBrestore\fP [\fIoptions\fP] \fI<device>\fP
@@ -500,6 +502,10 @@ create a new extent tree.
 .RE
 .TP
 
+\fBrescue\fR [\fIoptions\fP] <path>\fR
+Rescue toolbox.
+.TP
+
 \fBchunk-recover\fR [\fIoptions\fP] <device>\fR
 Recover the chunk tree by scanning the devices one by one.
 .RS
-- 
1.8.3.1

