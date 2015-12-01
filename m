Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27701 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755218AbbLAHOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:30 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 8800640444C7
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:08 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 13/25] btrfs-progs: Introduce function to initialize csum tree
Date: Tue,  1 Dec 2015 15:11:33 +0800
Message-Id: <1448953905-28673-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_csum_tree(), to setup temporary
csum tree for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/utils.c b/utils.c
index 3251e18..43bc6cf 100644
--- a/utils.c
+++ b/utils.c
@@ -674,6 +674,28 @@ out:
 	return ret;
 }
 
+static int setup_temp_csum_tree(int fd, struct btrfs_mkfs_config *cfg,
+				u64 csum_bytenr)
+{
+	struct extent_buffer *buf = NULL;
+	int ret;
+
+	buf = malloc(sizeof(*buf) + cfg->nodesize);
+	if (!buf)
+		return -ENOMEM;
+	ret = setup_temp_extent_buffer(buf, cfg, csum_bytenr,
+				       BTRFS_CSUM_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+	/*
+	 * Temporary csum tree is completely empty.
+	 */
+	ret = write_temp_extent_buffer(fd, buf, csum_bytenr);
+out:
+	free(buf);
+	return ret;
+}
+
 /*
  * Improved version of make_btrfs().
  *
@@ -773,6 +795,9 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 	if (ret < 0)
 		goto out;
 	ret = setup_temp_fs_tree(fd, cfg, fs_bytenr);
+	if (ret < 0)
+		goto out;
+	ret = setup_temp_csum_tree(fd, cfg, csum_bytenr);
 
 out:
 	return ret;
-- 
2.6.2



