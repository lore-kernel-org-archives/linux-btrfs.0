Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14911 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932469AbcI3FFU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 01:05:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/4] btrfs-progs: raid56: Introduce new function to calculate raid5 parity or data stripe
Date: Fri, 30 Sep 2016 13:04:56 +0800
Message-Id: <20160930050457.22584-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
References: <20160930050457.22584-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function raid5_gen_result() to calculate parity or data
stripe.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Patch split
  Change parameter type from void* to char* for xor_range()
  Change parameter order for xxor_range()
  Handle unaligned memory address for xor_range()
---
 disk-io.h |  1 +
 raid56.c  | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/disk-io.h b/disk-io.h
index 440baa9..9fc7e92 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -192,5 +192,6 @@ int write_and_map_eb(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 /* raid56.c */
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data);
 
 #endif
diff --git a/raid56.c b/raid56.c
index 833df5f..8c79c45 100644
--- a/raid56.c
+++ b/raid56.c
@@ -26,6 +26,8 @@
 #include "kerncompat.h"
 #include "ctree.h"
 #include "disk-io.h"
+#include "volumes.h"
+#include "utils.h"
 
 /*
  * This is the C data type to use
@@ -107,3 +109,64 @@ void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 }
 
+static void xor_range(char *dst, const char*src, size_t size)
+{
+	/* Move to DWORD aligned */
+	while (size && ((unsigned long)dst & sizeof(unsigned long))) {
+		*dst++ ^= *src++;
+		size--;
+	}
+
+	/* DWORD aligned part */
+	while (size >= sizeof(unsigned long)) {
+		*(unsigned long *)dst ^= *(unsigned long *)src;
+		src += sizeof(unsigned long);
+		dst += sizeof(unsigned long);
+		size -= sizeof(unsigned long);
+	}
+	/* Remaining */
+	while (size) {
+		*dst++ ^= *src++;
+		size--;
+	}
+}
+
+/*
+ * Generate desired data/parity stripe for RAID5
+ *
+ * @nr_devs:	Total number of devices, including parity
+ * @stripe_len:	Stripe length
+ * @data:	Data, with special layout:
+ * 		data[0]:	 Data stripe 0
+ * 		data[nr_devs-2]: Last data stripe
+ * 		data[nr_devs-1]: RAID5 parity
+ * @dest:	To generate which data. should follow above data layout
+ */
+int raid5_gen_result(int nr_devs, size_t stripe_len, int dest, void **data)
+{
+	int i;
+	char *buf = data[dest];
+
+	/* Validation check */
+	if (stripe_len <= 0 || stripe_len != BTRFS_STRIPE_LEN) {
+		error("invalid parameter for %s", __func__);
+		return -EINVAL;
+	}
+
+	if (dest >= nr_devs || nr_devs < 2) {
+		error("invalid parameter for %s", __func__);
+		return -EINVAL;
+	}
+	/* Shortcut for 2 devs RAID5, which is just RAID1 */
+	if (nr_devs == 2) {
+		memcpy(data[dest], data[1 - dest], stripe_len);
+		return 0;
+	}
+	memset(buf, 0, stripe_len);
+	for (i = 0; i < nr_devs; i++) {
+		if (i == dest)
+			continue;
+		xor_range(buf, data[i], stripe_len);
+	}
+	return 0;
+}
-- 
2.10.0



