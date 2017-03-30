Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13217 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932361AbdC3GVa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:21:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CFF9749F9A76
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Mar 2017 14:21:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 11/19] btrfs-progs: scrub: Introduce function to scrub mirror based data blocks
Date: Thu, 30 Mar 2017 14:21:07 +0800
Message-ID: <20170330062116.14379-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
References: <20170330062116.14379-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_data_mirror(), to check mirror based
data blocks.

It can also accept @data parameter to use in-memory data instead of
reading them out of disk.
This is a handy feature for RAID5/6 recovery verification code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 scrub.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/scrub.c b/scrub.c
index 1ea2645b..d59be25d 100644
--- a/scrub.c
+++ b/scrub.c
@@ -191,3 +191,100 @@ out:
 	free_extent_buffer(eb);
 	return ret;
 }
+
+/*
+ * Scrub one data mirror given by @start @len and @mirror, or @data
+ * If @data is not given, try to read it from disk.
+ * This function will try to read out all the data then check sum.
+ *
+ * If @data is given, just use the data.
+ * This behavior is useful for RAID5/6 recovery code to verify recovered data.
+ *
+ * Return 0 if everything is OK.
+ * Return <0 if something goes wrong, and @scrub_ctx accounting will be updated
+ * if it's a data corruption.
+ */
+static int scrub_data_mirror(struct btrfs_fs_info *fs_info,
+			     struct btrfs_scrub_progress *scrub_ctx,
+			     char *data, u64 start, u64 len, int mirror)
+{
+	u64 cur = 0;
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	u32 data_csum;
+	u32 *csums = NULL;
+	char *buf = NULL;
+	int ret = 0;
+	int err = 0;
+	unsigned long *csum_bitmap = NULL;
+
+	if (!data) {
+		buf = malloc(len);
+		if (!buf)
+			return -ENOMEM;
+		/* Read out as much data as possible to speed up read */
+		while (cur < len) {
+			u64 read_len = len - cur;
+
+			ret = read_extent_data(fs_info->tree_root, buf + cur,
+								   start + cur, &read_len, mirror);
+			if (ret < 0) {
+				error("failed to read out data at logical bytenr %llu mirror %d",
+				      start + cur, mirror);
+				scrub_ctx->read_errors++;
+				goto out;
+			}
+			scrub_ctx->data_bytes_scrubbed += read_len;
+			cur += read_len;
+		}
+	} else {
+		buf = data;
+	}
+
+	/* Alloc and Check csums */
+	csums = malloc(len / sectorsize * sizeof(data_csum));
+	if (!csums) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	csum_bitmap = malloc(round_up(len / sectorsize, BITS_PER_BYTE));
+	if (!csum_bitmap) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = btrfs_read_data_csums(fs_info, start, len, csums, csum_bitmap);
+	if (ret < 0)
+		goto out;
+
+	for (u32 i = 0; i < len / sectorsize; i++) {
+		if (!test_bit(i, csum_bitmap)) {
+			scrub_ctx->csum_discards++;
+			continue;
+		}
+
+		data_csum = ~(u32)0;
+		data_csum = btrfs_csum_data(buf + i * sectorsize, data_csum,
+					    sectorsize);
+		btrfs_csum_final(data_csum, (u8 *)&data_csum);
+
+		if (memcmp(&data_csum, (char *)csums + i * sizeof(data_csum),
+				   sizeof(data_csum))) {
+			error("data at bytenr %llu mirror %d csum mismatch, have 0x%08x expect 0x%08x",
+			      start + cur, mirror, data_csum,
+			      *(u32 *)((char *)csums + i * sizeof(data_csum)));
+			err = 1;
+			scrub_ctx->csum_errors++;
+			continue;
+		}
+		scrub_ctx->data_bytes_scrubbed += sectorsize;
+	}
+out:
+	if (!data)
+		free(buf);
+	free(csums);
+	free(csum_bitmap);
+
+	if (!ret && err)
+		return -EIO;
+	return ret;
+}
-- 
2.12.1



