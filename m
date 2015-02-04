Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57071 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753197AbbBDHTw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:19:52 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IGHR020233
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs-progs: Introduce new function reset_tree_block_csum() for later tree block csum reset.
Date: Wed, 4 Feb 2015 15:16:49 +0800
Message-ID: <1423034213-14018-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New function reset_tree_block_csum() will do the black magic to reset
csum for a tree block in-place.

This provides the basis to the whole tree csum resetting function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 5817ecf..e4b4f4a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9137,6 +9137,62 @@ static u16 report_root_corrupted(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+/*
+ * Black magics to reset the csum of a tree block.
+ * The evil part is to modify block without transaction/cow.
+ *
+ * Return 0 if the csum is OK or reset the csum
+ * Return <0 if error happened
+ */
+static int reset_tree_block_csum(struct btrfs_fs_info *fs_info,
+				 u64 bytenr, u32 len)
+{
+	/*
+	 * read_tree_block just use root as ladder to reach fs_info,
+	 * so use chunk_root since it must be OK.
+	 */
+	struct btrfs_root *root = fs_info->chunk_root;
+	struct extent_buffer *eb;
+	char *buf = NULL;
+	u32 crc;
+	int ret = 0;
+
+	eb = read_tree_block(root, bytenr, len, 0);
+	/* No need to do anything since its csum is OK */
+	if (extent_buffer_uptodate(eb))
+		goto out;
+
+	buf = malloc(len);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = read_data_from_disk(fs_info, buf, bytenr, len, 0);
+	if (ret < 0)
+		goto out;
+	crc = ~(u32)0;
+	crc = btrfs_csum_data(NULL, buf + BTRFS_CSUM_SIZE, crc,
+			      len - BTRFS_CSUM_SIZE);
+	btrfs_csum_final(crc, buf);
+	ret = write_data_to_disk(fs_info, buf, bytenr, len, 0);
+	if (ret < 0)
+		goto out;
+
+	/* Make sure now we can read the tree block */
+	eb = read_tree_block(root, bytenr, len, 0);
+	if (!extent_buffer_uptodate(eb)) {
+		if (IS_ERR(eb))
+			ret = PTR_ERR(eb);
+		else
+			ret = -EINVAL;
+		goto out;
+	}
+out:
+	free(buf);
+	free_extent_buffer(eb);
+	return ret;
+}
+
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check an unmounted btrfs filesystem.",
-- 
2.2.2

