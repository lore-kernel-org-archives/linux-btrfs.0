Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1034324AbcJ1Cc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:58 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 04/19] btrfs-progs: raid56: Allow raid6 to recover data and p
Date: Fri, 28 Oct 2016 10:31:40 +0800
Message-Id: <20161028023155.27336-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copied from kernel raid6 lib, with some naming modification.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 raid56.c | 36 ++++++++++++++++++++++++++++++++++++
 raid56.h |  3 +++
 2 files changed, 39 insertions(+)

diff --git a/raid56.c b/raid56.c
index 599533e..3e471d6 100644
--- a/raid56.c
+++ b/raid56.c
@@ -233,3 +233,39 @@ int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
 	free(zero_mem2);
 	return ret;
 }
+
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
diff --git a/raid56.h b/raid56.h
index 46fd3a9..e30cc28 100644
--- a/raid56.h
+++ b/raid56.h
@@ -19,6 +19,9 @@
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
 
+/* Recover data and P */
+int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data);
+
 /* Recover 2 data */
 int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
 		      void **data);
-- 
2.10.1



