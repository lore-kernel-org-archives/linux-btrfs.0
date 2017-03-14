Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46667 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750871AbdCNIFU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 04:05:20 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v3 5/7] btrfs-progs: convert: Introduce function to read out btrfs reserved range
Date: Tue, 14 Mar 2017 16:05:07 +0800
Message-ID: <20170314080509.31163-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, read_reserved_ranges(), to allow later
rollback to use these data to do rollback.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index e834c6f9..505b4a70 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -1506,6 +1506,37 @@ fail:
 	return -1;
 }
 
+/*
+ * Read out data of convert image which is in btrfs reserved range.
+ *
+ * So rollback can just use these data to overwrite these ranges of btrfs
+ */
+static int read_reserved_ranges(struct btrfs_root *root, u64 ino,
+				u64 total_bytes, char *reserved_ranges[])
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(btrfs_reserved_ranges); i++) {
+		const struct simple_range *range = &btrfs_reserved_ranges[i];
+
+		if (range->start + range->len >= total_bytes)
+			break;
+		ret = btrfs_read_file(root, ino, range->start, range->len,
+				      reserved_ranges[i]);
+		if (ret < range->len) {
+			error(
+	"failed to read out data of convert image, offset=%llu len=%llu ret=%d",
+			      range->start, range->len, ret);
+			if (ret >= 0)
+				ret = -EIO;
+			break;
+		}
+		ret = 0;
+	}
+	return ret;
+}
+
 static int do_rollback(const char *devname)
 {
 	int fd = -1;
-- 
2.12.0



