Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2344 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754994AbcLZGaY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:24 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 0708441B4BD3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:42 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/19] btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
Date: Mon, 26 Dec 2016 14:29:23 +0800
Message-Id: <20161226062939.5841-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copied from kernel lib/raid6/recov.c raid6_2data_recov_intx1() function.
With the following modification:
- Rename to raid6_recov_data2() for shorter name
- s/kfree/free/g modification

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile.in                     |  4 +--
 raid56.c => kernel-lib/raid56.c | 69 +++++++++++++++++++++++++++++++++++++++++
 kernel-lib/raid56.h             |  5 +++
 3 files changed, 76 insertions(+), 2 deletions(-)
 rename raid56.c => kernel-lib/raid56.c (71%)

diff --git a/Makefile.in b/Makefile.in
index fecaaa6a..c3f0eeda 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -96,10 +96,10 @@ CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
 objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
+	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  kernel-lib/tables.o
+	  kernel-lib/tables.o kernel-lib/raid56.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/raid56.c b/kernel-lib/raid56.c
similarity index 71%
rename from raid56.c
rename to kernel-lib/raid56.c
index 8c79c456..dca8f8d4 100644
--- a/raid56.c
+++ b/kernel-lib/raid56.c
@@ -28,6 +28,7 @@
 #include "disk-io.h"
 #include "volumes.h"
 #include "utils.h"
+#include "kernel-lib/raid56.h"
 
 /*
  * This is the C data type to use
@@ -170,3 +171,71 @@ int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data)
 	}
 	return 0;
 }
+
+/*
+ * Raid 6 recovery code copied from kernel lib/raid6/recov.c.
+ * With modifications:
+ * - rename from raid6_2data_recov_intx1
+ * - kfree/free modification for btrfs-progs
+ */
+int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
+		      void **data)
+{
+	u8 *p, *q, *dp, *dq;
+	u8 px, qx, db;
+	const u8 *pbmul;	/* P multiplier table for B data */
+	const u8 *qmul;		/* Q multiplier table (for both) */
+	char *zero_mem1, *zero_mem2;
+	int ret = 0;
+
+	/* Early check */
+	if (dest1 < 0 || dest1 >= nr_devs - 2 ||
+	    dest2 < 0 || dest2 >= nr_devs - 2 || dest1 >= dest2)
+		return -EINVAL;
+
+	zero_mem1 = calloc(1, stripe_len);
+	zero_mem2 = calloc(1, stripe_len);
+	if (!zero_mem1 || !zero_mem2) {
+		free(zero_mem1);
+		free(zero_mem2);
+		return -ENOMEM;
+	}
+
+	p = (u8 *)data[nr_devs - 2];
+	q = (u8 *)data[nr_devs - 1];
+
+	/* Compute syndrome with zero for the missing data pages
+	   Use the dead data pages as temporary storage for
+	   delta p and delta q */
+	dp = (u8 *)data[dest1];
+	data[dest1] = (void *)zero_mem1;
+	data[nr_devs - 2] = dp;
+	dq = (u8 *)data[dest2];
+	data[dest2] = (void *)zero_mem2;
+	data[nr_devs - 1] = dq;
+
+	raid6_gen_syndrome(nr_devs, stripe_len, data);
+
+	/* Restore pointer table */
+	data[dest1]   = dp;
+	data[dest2]   = dq;
+	data[nr_devs - 2] = p;
+	data[nr_devs - 1] = q;
+
+	/* Now, pick the proper data tables */
+	pbmul = raid6_gfmul[raid6_gfexi[dest2 - dest1]];
+	qmul  = raid6_gfmul[raid6_gfinv[raid6_gfexp[dest1]^raid6_gfexp[dest2]]];
+
+	/* Now do it... */
+	while ( stripe_len-- ) {
+		px    = *p ^ *dp;
+		qx    = qmul[*q ^ *dq];
+		*dq++ = db = pbmul[px] ^ qx; /* Reconstructed B */
+		*dp++ = db ^ px; /* Reconstructed A */
+		p++; q++;
+	}
+
+	free(zero_mem1);
+	free(zero_mem2);
+	return ret;
+}
diff --git a/kernel-lib/raid56.h b/kernel-lib/raid56.h
index 1bf2e01a..d397a23e 100644
--- a/kernel-lib/raid56.h
+++ b/kernel-lib/raid56.h
@@ -37,4 +37,9 @@ extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
 extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
+
+
+/* Recover raid6 with 2 data corrupted */
+int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
+		      void **data);
 #endif
-- 
2.11.0



