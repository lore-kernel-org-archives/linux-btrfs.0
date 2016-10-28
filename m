Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1034417AbcJ1Cd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:33:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 03/19] btrfs-progs: raid56: Allow raid6 to recover 2 data stripes
Date: Fri, 28 Oct 2016 10:31:39 +0800
Message-Id: <20161028023155.27336-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mainly copied from kernel code, with minor modification to follow the
new naming schema.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 raid56.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 raid56.h |  4 ++++
 2 files changed, 67 insertions(+)

diff --git a/raid56.c b/raid56.c
index 8c79c45..599533e 100644
--- a/raid56.c
+++ b/raid56.c
@@ -28,6 +28,7 @@
 #include "disk-io.h"
 #include "volumes.h"
 #include "utils.h"
+#include "raid56.h"
 
 /*
  * This is the C data type to use
@@ -170,3 +171,65 @@ int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data)
 	}
 	return 0;
 }
+
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
diff --git a/raid56.h b/raid56.h
index a05c14b..46fd3a9 100644
--- a/raid56.h
+++ b/raid56.h
@@ -19,6 +19,10 @@
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
 
+/* Recover 2 data */
+int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
+		      void **data);
+
 /* Galois field tables */
 extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
 extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
-- 
2.10.1



