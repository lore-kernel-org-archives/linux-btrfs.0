Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21484 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754945AbbKRHYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:49 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoS8007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:59 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 13/22] btrfs-progs: Introduce function to initialize csum tree
Date: Wed, 18 Nov 2015 15:22:13 +0800
Message-Id: <1447831342-15056-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_csum_tree(), to setup temporary
csum tree for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/utils.c b/utils.c
index edd8ac1..ee2a538 100644
--- a/utils.c
+++ b/utils.c
@@ -862,6 +862,28 @@ out:
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
@@ -959,6 +981,9 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 	if (ret < 0)
 		goto out;
 	ret = setup_temp_fs_tree(fd, cfg, fs_bytenr);
+	if (ret < 0)
+		goto out;
+	ret = setup_temp_csum_tree(fd, cfg, csum_bytenr);
 
 out:
 	free(free_tree);
-- 
2.6.2

