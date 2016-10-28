Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48358 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965899AbcJ1CcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 22:32:17 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 11/19] btrfs-progs: check/scrub: Introduce function to scrub mirror based data blocks
Date: Fri, 28 Oct 2016 10:31:47 +0800
Message-Id: <20161028023155.27336-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
References: <20161028023155.27336-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, scrub_data_mirror(), to check mirror based
data blocks.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 check/scrub.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/check/scrub.c b/check/scrub.c
index ef94193..b4bb081 100644
--- a/check/scrub.c
+++ b/check/scrub.c
@@ -167,3 +167,72 @@ out:
 	return ret;
 }
 
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
2.10.1



