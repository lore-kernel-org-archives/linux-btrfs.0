Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14657 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751074AbeAELR0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 06:17:26 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [v6 04/16] btrfs-progs: scrub: Introduce structures to support offline scrub for RAID56
Date: Fri, 5 Jan 2018 19:01:12 +0800
Message-ID: <1515150084-17231-5-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
References: <1515150084-17231-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Introuduce new local structures, scrub_full_stripe and scrub_stripe, for
incoming offline RAID56 scrub support.

For pure stripe/mirror based profiles, like raid0/1/10/dup/single, we
will follow the original bytenr and mirror number based iteration, so
they don't need any extra structures for these profiles.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile |   3 +-
 scrub.c  | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 scrub.c

diff --git a/Makefile b/Makefile
index ab45ab7f..fa3ebc86 100644
--- a/Makefile
+++ b/Makefile
@@ -106,7 +106,8 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o csum.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o csum.o \
+	  scrub.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/scrub.c b/scrub.c
new file mode 100644
index 00000000..41c40108
--- /dev/null
+++ b/scrub.c
@@ -0,0 +1,119 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
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
+ * For parity based profile (RAID56)
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
+	/* Some data doesn't have csum (nodatasum) */
+	unsigned int csum_missing:1;
+
+	/* Device fd, to write correct data back to disc */
+	int fd;
+
+	char *data;
+};
+
+/*
+ * RAID56 full stripe (data stripes + P/Q)
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
2.14.3



