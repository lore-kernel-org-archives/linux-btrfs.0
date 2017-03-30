Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13217 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754625AbdC3GVY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:21:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id BED6747EE21E
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 14:21:20 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 04/19] btrfs-progs: raid56: Allow raid6 to recover data and p
Date: Thu, 30 Mar 2017 14:21:00 +0800
Message-ID: <20170330062116.14379-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copied from kernel lib/raid6/recov.c.

Minor modifications includes:
- Rename from raid6_datap_recov_intx() to raid5_recov_datap()
- Rename parameter from faila to dest1

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 kernel-lib/raid56.c | 41 +++++++++++++++++++++++++++++++++++++++++
 kernel-lib/raid56.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/kernel-lib/raid56.c b/kernel-lib/raid56.c
index dca8f8d4..e078972b 100644
--- a/kernel-lib/raid56.c
+++ b/kernel-lib/raid56.c
@@ -239,3 +239,44 @@ int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
 	free(zero_mem2);
 	return ret;
 }
+
+/*
+ * Raid 6 recover code copied from kernel lib/raid6/recov.c
+ * - rename from raid6_datap_recov_intx1()
+ * - parameter changed from faila to dest1
+ */
+int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data)
+{
+	u8 *p, *q, *dq;
+	const u8 *qmul;		/* Q multiplier table */
+	char *zero_mem;
+
+	p = (u8 *)data[nr_devs - 2];
+	q = (u8 *)data[nr_devs - 1];
+
+	zero_mem = calloc(1, stripe_len);
+	if (!zero_mem)
+		return -ENOMEM;
+
+	/* Compute syndrome with zero for the missing data page
+	   Use the dead data page as temporary storage for delta q */
+	dq = (u8 *)data[dest1];
+	data[dest1] = (void *)zero_mem;
+	data[nr_devs - 1] = dq;
+
+	raid6_gen_syndrome(nr_devs, stripe_len, data);
+
+	/* Restore pointer table */
+	data[dest1]   = dq;
+	data[nr_devs - 1] = q;
+
+	/* Now, pick the proper data tables */
+	qmul  = raid6_gfmul[raid6_gfinv[raid6_gfexp[dest1]]];
+
+	/* Now do it... */
+	while ( stripe_len-- ) {
+		*p++ ^= *dq = qmul[*q ^ *dq];
+		q++; dq++;
+	}
+	return 0;
+}
diff --git a/kernel-lib/raid56.h b/kernel-lib/raid56.h
index 8d64256f..83ac39a1 100644
--- a/kernel-lib/raid56.h
+++ b/kernel-lib/raid56.h
@@ -42,4 +42,6 @@ extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
 /* Recover raid6 with 2 data corrupted */
 int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
 		      void **data);
+/* Recover data and P */
+int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data);
 #endif
-- 
2.12.1



