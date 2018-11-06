Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9196C46465
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E582081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2E582081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbeKFQF4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:56 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44359 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387491AbeKFQFz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:55 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417742"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:42:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 290AC4B71EA6;
        Tue,  6 Nov 2018 14:42:06 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:42:09 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v10.6 1/5] btrfs-progs: Basic framework for dedupe-inband command group
Date:   Tue, 6 Nov 2018 14:41:54 +0800
Message-ID: <20181106064158.6356-2-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064158.6356-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064158.6356-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 290AC4B71EA6.AA22E
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Add basic ioctl header and command group framework for later use.
Alone with basic man page doc.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 Documentation/Makefile.in                  |  1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 40 ++++++++++++++++++++++
 Documentation/btrfs.asciidoc               |  4 +++
 Makefile                                   |  3 +-
 btrfs.c                                    |  2 ++
 cmds-dedupe-ib.c                           | 35 +++++++++++++++++++
 commands.h                                 |  2 ++
 dedupe-ib.h                                | 28 +++++++++++++++
 ioctl.h                                    | 36 +++++++++++++++++++
 9 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index afc16980c6d9..c0d797324c25 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -28,6 +28,7 @@ MAN8_TXT += btrfs-qgroup.asciidoc
 MAN8_TXT += btrfs-replace.asciidoc
 MAN8_TXT += btrfs-restore.asciidoc
 MAN8_TXT += btrfs-property.asciidoc
+MAN8_TXT += btrfs-dedupe-inband.asciidoc
 
 # Category 5 manual page
 MAN5_TXT += btrfs-man5.asciidoc
diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
new file mode 100644
index 000000000000..83113f5487e2
--- /dev/null
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -0,0 +1,40 @@
+btrfs-dedupe-inband(8)
+======================
+
+NAME
+----
+btrfs-dedupe-inband - manage in-band (write time) de-duplication of a btrfs
+filesystem
+
+SYNOPSIS
+--------
+*btrfs dedupe-inband* <subcommand> <args>
+
+DESCRIPTION
+-----------
+*btrfs dedupe-inband* is used to enable/disable or show current in-band de-duplication
+status of a btrfs filesystem.
+
+Kernel support for in-band de-duplication starts from 4.19.
+
+WARNING: In-band de-duplication is still an experimental feautre of btrfs,
+use with caution.
+
+SUBCOMMAND
+----------
+Nothing yet
+
+EXIT STATUS
+-----------
+*btrfs dedupe-inband* returns a zero exit status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+*btrfs* is part of btrfs-progs.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index 7316ac094413..1cf5bddec335 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -50,6 +50,10 @@ COMMANDS
 	Do off-line check on a btrfs filesystem. +
 	See `btrfs-check`(8) for details.
 
+*dedupe-inband*::
+	Control btrfs in-band(write time) de-duplication. +
+	See `btrfs-dedupe-inband`(8) for details.
+
 *device*::
 	Manage devices managed by btrfs, including add/delete/scan and so
 	on. +
diff --git a/Makefile b/Makefile
index f4ab14ea74c8..f155252c91f1 100644
--- a/Makefile
+++ b/Makefile
@@ -124,7 +124,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
-	       mkfs/common.o check/mode-common.o check/mode-lowmem.o
+	       mkfs/common.o check/mode-common.o check/mode-lowmem.o \
+	       cmds-dedupe-ib.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
diff --git a/btrfs.c b/btrfs.c
index 2d39f2ced3e8..2168f5a8bc7f 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -255,6 +255,8 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
+		{ "dedupe-inband", cmd_dedupe_ib, NULL, &dedupe_ib_cmd_group,
+			0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		NULL_CMD_STRUCT
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
new file mode 100644
index 000000000000..73c923a797da
--- /dev/null
+++ b/cmds-dedupe-ib.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
+ */
+
+#include <getopt.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+
+#include "commands.h"
+#include "utils.h"
+#include "kerncompat.h"
+#include "dedupe-ib.h"
+
+static const char * const dedupe_ib_cmd_group_usage[] = {
+	"btrfs dedupe-inband <command> [options] <path>",
+	NULL
+};
+
+static const char dedupe_ib_cmd_group_info[] =
+"manage inband(write time) de-duplication";
+
+const struct cmd_group dedupe_ib_cmd_group = {
+	dedupe_ib_cmd_group_usage, dedupe_ib_cmd_group_info, {
+		NULL_CMD_STRUCT
+	}
+};
+
+int cmd_dedupe_ib(int argc, char **argv)
+{
+	return handle_command_group(&dedupe_ib_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 76991f2b28d5..28b8eec7cbfd 100644
--- a/commands.h
+++ b/commands.h
@@ -81,6 +81,7 @@ extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group rescue_cmd_group;
+extern const struct cmd_group dedupe_ib_cmd_group;
 
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
@@ -120,5 +121,6 @@ int cmd_select_super(int argc, char **argv);
 int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
 int cmd_rescue(int argc, char **argv);
+int cmd_dedupe_ib(int argc, char **argv);
 
 #endif
diff --git a/dedupe-ib.h b/dedupe-ib.h
new file mode 100644
index 000000000000..c5a35724e97b
--- /dev/null
+++ b/dedupe-ib.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
+ */
+
+#ifndef __BTRFS_DEDUPE__
+#define __BTRFS_DEDUPE__
+
+/*
+ * Dedup storage backend
+ * On disk is persist storage but overhead is large
+ * In memory is fast but will lose all its hash on umount
+ */
+#define BTRFS_DEDUPE_BACKEND_INMEMORY		0
+#define BTRFS_DEDUPE_BACKEND_LAST		1
+
+/* Dedup block size limit and default value */
+#define BTRFS_DEDUPE_BLOCKSIZE_MAX	SZ_8M
+#define BTRFS_DEDUPE_BLOCKSIZE_MIN	SZ_16K
+#define BTRFS_DEDUPE_BLOCKSIZE_DEFAULT	SZ_128K
+
+/* Default dedupe limit on number of hash */
+#define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	SZ_32K
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUPE_HASH_SHA256		0
+
+#endif
diff --git a/ioctl.h b/ioctl.h
index 4bf91ddbdb0c..d2655fe1d167 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -575,6 +575,42 @@ struct btrfs_ioctl_qgroup_create_args {
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_qgroup_create_args) == 16);
 
+/*
+ * de-duplication control modes
+ * For re-config, enable will handle it
+ */
+#define BTRFS_DEDUPE_CTL_ENABLE	1
+#define BTRFS_DEDUPE_CTL_DISABLE 2
+#define BTRFS_DEDUPE_CTL_STATUS	3
+#define BTRFS_DEDUPE_CTL_RECONF	4
+#define BTRFS_DEDUPE_CTL_LAST	5
+
+/*
+ * Allow enable command to be executed on dedupe enabled fs.
+ * Make dedupe_enable ioctl to be stateless.
+ *
+ * Or only dedup_reconf ioctl can be executed on dedupe enabled fs
+ */
+#define BTRFS_DEDUPE_FLAG_FORCE		(1 << 0)
+/*
+ * This structure is used for dedupe enable/disable/configure
+ * and status ioctl.
+ * Reserved range should be set to 0xff.
+ */
+struct btrfs_ioctl_dedupe_args {
+	__u16 cmd;		/* In: command */
+	__u64 blocksize;	/* In/Out: blocksize */
+	__u64 limit_nr;		/* In/Out: limit nr for inmem backend */
+	__u64 limit_mem;	/* In/Out: limit mem for inmem backend */
+	__u64 current_nr;	/* Out: current hash nr */
+	__u16 backend;		/* In/Out: current backend */
+	__u16 hash_algo;	/* In/Out: hash algorithm */
+	u8 status;		/* Out: enabled or disabled */
+	u8 flags;		/* In: special flags for ioctl */
+	u8 __unused[472];	/* Pad to 512 bytes */
+};
+BUILD_ASSERT(sizeof(btrfs_ioctl_dedupe_args) == 512);
+
 struct btrfs_ioctl_timespec {
 	__u64 sec;
 	__u32 nsec;
-- 
2.19.1



