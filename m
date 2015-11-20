Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10660 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934932AbbKTD1D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:27:03 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdL022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/25] btrfs-progs: Introduce function to initialize fs tree
Date: Fri, 20 Nov 2015 11:24:16 +0800
Message-Id: <1447989869-24739-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introudce new function, setup_temp_fs_tree(), to setup temporary fs tree
for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/utils.c b/utils.c
index 3be484a..edd8ac1 100644
--- a/utils.c
+++ b/utils.c
@@ -840,6 +840,28 @@ out:
 	return ret;
 }
 
+static int setup_temp_fs_tree(int fd, struct btrfs_mkfs_config *cfg,
+			      u64 fs_bytenr)
+{
+	struct extent_buffer *buf = NULL;
+	int ret;
+
+	buf = malloc(sizeof(*buf) + cfg->nodesize);
+	if (!buf)
+		return -ENOMEM;
+	ret = setup_temp_extent_buffer(buf, cfg, fs_bytenr,
+				       BTRFS_FS_TREE_OBJECTID);
+	if (ret < 0)
+		goto out;
+	/*
+	 * Temporary fs tree is completely empty.
+	 */
+	ret = write_temp_extent_buffer(fd, buf, fs_bytenr);
+out:
+	free(buf);
+	return ret;
+}
+
 /*
  * Improved version of make_btrfs().
  *
@@ -934,6 +956,10 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 		goto out;
 	ret = setup_temp_dev_tree(fd, cfg, sys_chunk_start, meta_chunk_start,
 				  dev_bytenr);
+	if (ret < 0)
+		goto out;
+	ret = setup_temp_fs_tree(fd, cfg, fs_bytenr);
+
 out:
 	free(free_tree);
 	return ret;
-- 
2.6.2

