Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1031086AbdEYGWc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
Subject: [PATCH v4 03/20] btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
Date: Thu, 25 May 2017 14:21:48 +0800
Message-ID: <20170525062205.11660-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copied from kernel lib/raid6/recov.c raid6_2data_recov_intx1() function.
With the following modification:
- Rename to raid6_recov_data2() for shorter name
- s/kfree/free/g modification

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile                        |  4 +--
 raid56.c => kernel-lib/raid56.c | 69 +++++++++++++++++++++++++++++++++++++++++
 kernel-lib/raid56.h             |  5 +++
 3 files changed, 76 insertions(+), 2 deletions(-)
 rename raid56.c => kernel-lib/raid56.c (71%)

diff --git a/Makefile b/Makefile
index ba73357b..df584672 100644
--- a/Makefile
+++ b/Makefile
@@ -92,10 +92,10 @@ CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
 objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
+	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o kernel-lib/tables.o
+	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o
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
index 030b0afb..8d64256f 100644
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
2.13.0



