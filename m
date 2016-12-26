Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26380 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754893AbcLZGaX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 01:30:23 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id EC84941B4BE2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Dec 2016 14:29:44 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 11/19] btrfs-progs: scrub: Introduce function to scrub mirror based data blocks
Date: Mon, 26 Dec 2016 14:29:31 +0800
Message-Id: <20161226062939.5841-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
References: <20161226062939.5841-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_data_mirror(), to check mirror based
data blocks.

It can also accept @data parameter to use in-memory data instead of
reading them out of disk.
This is a handy feature for RAID5/6 recovery verification code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 scrub.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/scrub.c b/scrub.c
index 4cf678fb..2563f407 100644
--- a/scrub.c
+++ b/scrub.c
@@ -190,3 +190,85 @@ out:
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
+	u32 csum;
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	char *buf = NULL;
+	int ret = 0;
+	int err = 0;
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
+					start + cur, &read_len, mirror);
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
+	/* Check csum per-sectorsize */
+	cur = 0;
+	while (cur < len) {
+		u32 data_csum = ~(u32)0;
+
+		ret = btrfs_read_one_data_csum(fs_info, start + cur, &csum);
+		if (ret > 0) {
+			scrub_ctx->csum_discards++;
+			ret = 0;
+
+			/* In case only some csum are missing */
+			goto next;
+		}
+		data_csum = btrfs_csum_data(NULL, buf + cur, data_csum,
+					    sectorsize);
+		btrfs_csum_final(data_csum, (u8 *)&data_csum);
+		if (data_csum != csum) {
+			error("data at bytenr %llu mirror %d csum mismatch, have %u expect %u",
+			      start + cur, mirror, data_csum, csum);
+			err = 1;
+			scrub_ctx->csum_errors++;
+			cur += sectorsize;
+			continue;
+		}
+		scrub_ctx->data_bytes_scrubbed += sectorsize;
+next:
+		cur += sectorsize;
+	}
+out:
+	if (!data)
+		free(buf);
+	if (!ret && err)
+		return -EIO;
+	return ret;
+}
-- 
2.11.0



