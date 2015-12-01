Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25708 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755111AbbLAHO1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:27 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 8B76440444D6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:07 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 12/25] btrfs-progs: Introduce function to initialize fs tree
Date: Tue,  1 Dec 2015 15:11:32 +0800
Message-Id: <1448953905-28673-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introudce new function, setup_temp_fs_tree(), to setup temporary fs tree
for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/utils.c b/utils.c
index 4861caa..3251e18 100644
--- a/utils.c
+++ b/utils.c
@@ -652,6 +652,28 @@ out:
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
@@ -748,6 +770,10 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 		goto out;
 	ret = setup_temp_dev_tree(fd, cfg, sys_chunk_start, meta_chunk_start,
 				  dev_bytenr);
+	if (ret < 0)
+		goto out;
+	ret = setup_temp_fs_tree(fd, cfg, fs_bytenr);
+
 out:
 	return ret;
 }
-- 
2.6.2



