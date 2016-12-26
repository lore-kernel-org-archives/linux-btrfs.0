Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26380 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754858AbcLZGaY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:24 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 86DAC41B4BE0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:44 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 09/19] btrfs-progs: scrub: Introduce structures to support fsck scrub for RAID56
Date: Mon, 26 Dec 2016 14:29:29 +0800
Message-Id: <20161226062939.5841-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introuduce new local structures, scrub_full_stripe and scrub_stripe, for
incoming offline RAID56 scrub support.

For pure stripe/mirror based profiles, like raid0/1/10/dup/single, we
will follow the original bytenr and mirror number based iteration, so
they don't need any extra structures for these profiles.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile.in |   2 +-
 scrub.c     | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 scrub.c

diff --git a/Makefile.in b/Makefile.in
index bb619bfe..41da7ab5 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -99,7 +99,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  kernel-lib/tables.o kernel-lib/raid56.o csum.o
+	  kernel-lib/tables.o kernel-lib/raid56.o csum.o scrub.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/scrub.c b/scrub.c
new file mode 100644
index 00000000..c9ca817e
--- /dev/null
+++ b/scrub.c
@@ -0,0 +1,120 @@
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
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+/*
+ * Main part to implement offline(unmounted) btrfs scrub
+ */
+
+#include <unistd.h>
+#include "ctree.h"
+#include "volumes.h"
+#include "disk-io.h"
+#include "utils.h"
+
+/*
+ * For parity based profile(RAID56)
+ * Mirror/stripe based on won't need this. They are iterated by bytenr and
+ * mirror number.
+ */
+struct scrub_stripe {
+	/* For P/Q logical start will be BTRFS_RAID5/6_P/Q_STRIPE */
+	u64 logical;
+
+	/* Device is missing */
+	unsigned int dev_missing:1;
+
+	/* Any tree/data csum mismatches */
+	unsigned int csum_mismatch:1;
+
+	/* Some data doesn't have csum(nodatasum) */
+	unsigned int csum_missing:1;
+
+	char *data;
+};
+
+/*
+ * RAID56 full stripe(data stripes + P/Q)
+ */
+struct scrub_full_stripe {
+	u64 logical_start;
+	u64 logical_len;
+	u64 bg_type;
+	u32 nr_stripes;
+	u32 stripe_len;
+
+	/* Read error stripes */
+	u32 err_read_stripes;
+
+	/* Missing devices */
+	u32 err_missing_devs;
+
+	/* Csum error data stripes */
+	u32 err_csum_dstripes;
+
+	/* Missing csum data stripes */
+	u32 missing_csum_dstripes;
+
+	/* currupted stripe index */
+	int corrupted_index[2];
+
+	int nr_corrupted_stripes;
+
+	/* Already recovered once? */
+	unsigned int recovered:1;
+
+	struct scrub_stripe stripes[];
+};
+
+static void free_full_stripe(struct scrub_full_stripe *fstripe)
+{
+	int i;
+
+	for (i = 0; i < fstripe->nr_stripes; i++)
+		free(fstripe->stripes[i].data);
+	free(fstripe);
+}
+
+static struct scrub_full_stripe *alloc_full_stripe(int nr_stripes,
+						    u32 stripe_len)
+{
+	struct scrub_full_stripe *ret;
+	int size = sizeof(*ret) + nr_stripes * sizeof(struct scrub_stripe);
+	int i;
+
+	ret = malloc(size);
+	if (!ret)
+		return NULL;
+
+	memset(ret, 0, size);
+	ret->nr_stripes = nr_stripes;
+	ret->stripe_len = stripe_len;
+	ret->corrupted_index[0] = -1;
+	ret->corrupted_index[1] = -1;
+
+	/* Alloc data memory for each stripe */
+	for (i = 0; i < nr_stripes; i++) {
+		struct scrub_stripe *stripe = &ret->stripes[i];
+
+		stripe->data = malloc(stripe_len);
+		if (!stripe->data) {
+			free_full_stripe(ret);
+			return NULL;
+		}
+	}
+	return ret;
+}
-- 
2.11.0



