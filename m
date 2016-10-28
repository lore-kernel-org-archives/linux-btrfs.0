Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1034409AbcJ1CdG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:33:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 05/19] btrfs-progs: Introduce wrapper to recover raid56 data
Date: Fri, 28 Oct 2016 10:31:41 +0800
Message-Id: <20161028023155.27336-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 raid56.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 raid56.h | 13 +++++++++++
 2 files changed, 89 insertions(+)

diff --git a/raid56.c b/raid56.c
index 3e471d6..8d54e55 100644
--- a/raid56.c
+++ b/raid56.c
@@ -269,3 +269,79 @@ int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data)
 	}
 	return 0;
 }
+
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
diff --git a/raid56.h b/raid56.h
index e30cc28..91d50c5 100644
--- a/raid56.h
+++ b/raid56.h
@@ -16,6 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include "kerncompat.h"
+
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
 int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
 
@@ -26,6 +28,17 @@ int raid6_recov_datap(int nr_devs, size_t stripe_len, int dest1, void **data);
 int raid6_recov_data2(int nr_devs, size_t stripe_len, int dest1, int dest2,
 		      void **data);
 
+/*
+ * Recover raid56 data
+ * @dest1/2 can be -1 to indicate non-corrupted case
+ *
+ * Return >0 for unrecoverable case.
+ * Return 0 for recoverable case. And recovered data will be stored into @data
+ * Return <0 for fatal error
+ */
+int raid56_recov(int nr_devs, size_t stripe_len, u64 profile, int dest1,
+		 int dest2, void **data);
+
 /* Galois field tables */
 extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
 extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
-- 
2.10.1



