Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25075 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1034485AbdEYGWg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 02:22:36 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
Subject: [PATCH v4 05/20] btrfs-progs: Introduce wrapper to recover raid56 data
Date: Thu, 25 May 2017 14:21:50 +0800
Message-ID: <20170525062205.11660-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
References: <20170525062205.11660-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a wrapper to recover raid56 data.

The logical is the same with kernel one, but with different interfaces,
since kernel ones cares the performance while in btrfs we don't care
that much.

And the interface is more caller friendly inside btrfs-progs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 kernel-lib/raid56.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel-lib/raid56.h | 11 ++++++++
 2 files changed, 88 insertions(+)

diff --git a/kernel-lib/raid56.c b/kernel-lib/raid56.c
index e078972b..e3a9339e 100644
--- a/kernel-lib/raid56.c
+++ b/kernel-lib/raid56.c
@@ -280,3 +280,80 @@ int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data)
 	}
 	return 0;
 }
+
+/* Original raid56 recovery wrapper */
+int raid56_recov(int nr_devs, size_t stripe_len, u64 profile, int dest1,
+		 int dest2, void **data)
+{
+	int min_devs;
+	int ret;
+
+	if (profile & BTRFS_BLOCK_GROUP_RAID5)
+		min_devs = 2;
+	else if (profile & BTRFS_BLOCK_GROUP_RAID6)
+		min_devs = 3;
+	else
+		return -EINVAL;
+	if (nr_devs < min_devs)
+		return -EINVAL;
+
+	/* Nothing to recover */
+	if (dest1 == -1 && dest2 == -1)
+		return 0;
+
+	/* Reorder dest1/2, so only dest2 can be -1  */
+	if (dest1 == -1) {
+		dest1 = dest2;
+		dest2 = -1;
+	} else if (dest2 != -1 && dest1 != -1) {
+		/* Reorder dest1/2, ensure dest2 > dest1 */
+		if (dest1 > dest2) {
+			int tmp;
+
+			tmp = dest2;
+			dest2 = dest1;
+			dest1 = tmp;
+		}
+	}
+
+	if (profile & BTRFS_BLOCK_GROUP_RAID5) {
+		if (dest2 != -1)
+			return 1;
+		return raid5_gen_result(nr_devs, stripe_len, dest1, data);
+	}
+
+	/* RAID6 one dev corrupted case*/
+	if (dest2 == -1) {
+		/* Regenerate P/Q */
+		if (dest1 == nr_devs - 1 || dest1 == nr_devs - 2) {
+			raid6_gen_syndrome(nr_devs, stripe_len, data);
+			return 0;
+		}
+
+		/* Regerneate data from P */
+		return raid5_gen_result(nr_devs - 1, stripe_len, dest1, data);
+	}
+
+	/* P/Q bot corrupted */
+	if (dest1 == nr_devs - 2 && dest2 == nr_devs - 1) {
+		raid6_gen_syndrome(nr_devs, stripe_len, data);
+		return 0;
+	}
+
+	/* 2 Data corrupted */
+	if (dest2 < nr_devs - 2)
+		return raid6_recov_data2(nr_devs, stripe_len, dest1, dest2,
+					 data);
+	/* Data and P*/
+	if (dest2 == nr_devs - 1)
+		return raid6_recov_datap(nr_devs, stripe_len, dest1, data);
+
+	/*
+	 * Final case, Data and Q, recover data first then regenerate Q
+	 */
+	ret = raid5_gen_result(nr_devs - 1, stripe_len, dest1, data);
+	if (ret < 0)
+		return ret;
+	raid6_gen_syndrome(nr_devs, stripe_len, data);
+	return 0;
+}
diff --git a/kernel-lib/raid56.h b/kernel-lib/raid56.h
index 83ac39a1..e06c3ffb 100644
--- a/kernel-lib/raid56.h
+++ b/kernel-lib/raid56.h
@@ -44,4 +44,15 @@ int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
 		      void **data);
 /* Recover data and P */
 int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data);
+
+/*
+ * Recover raid56 data
+ * @dest1/2 can be -1 to indicate correct data
+ *
+ * Return >0 for unrecoverable case.
+ * Return 0 for recoverable case, And recovered data will be stored into @data
+ * Return <0 for fatal error
+ */
+int raid56_recov(int nr_devs, size_t stripe_len, u64 profile, int dest1,
+		 int dest2, void **data);
 #endif
-- 
2.13.0



