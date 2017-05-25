Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25075 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1165155AbdEYGWn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
Subject: [PATCH v4 09/20] btrfs-progs: scrub: Introduce structures to support offline scrub for RAID56
Date: Thu, 25 May 2017 14:21:54 +0800
Message-ID: <20170525062205.11660-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introuduce new local structures, scrub_full_stripe and scrub_stripe, for
incoming offline RAID56 scrub support.

For pure stripe/mirror based profiles, like raid0/1/10/dup/single, we
will follow the original bytenr and mirror number based iteration, so
they don't need any extra structures for these profiles.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile |   2 +-
 scrub.c  | 126 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 scrub.c

diff --git a/Makefile b/Makefile
index e6d7c187..b3c70e04 100644
--- a/Makefile
+++ b/Makefile
@@ -95,7 +95,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o csum.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o csum.o scrub.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/scrub.c b/scrub.c
new file mode 100644
index 00000000..a757dff6
--- /dev/null
+++ b/scrub.c
@@ -0,0 +1,126 @@
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
+	u64 physical;
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
+	/* Device fd, to write correct data back to disc */
+	int fd;
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
+	int size = sizeof(*ret) + sizeof(unsigned long *) +
+		nr_stripes * sizeof(struct scrub_stripe);
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
2.13.0



