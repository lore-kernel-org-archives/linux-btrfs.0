Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbcA2FR7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:17:59 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 10/22] btrfs-progs: Introduce function to initialize csum tree
Date: Fri, 29 Jan 2016 13:03:20 +0800
Message-Id: <1454043812-7893-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, setup_temp_csum_tree(), to setup temporary
csum tree for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 utils.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/utils.c b/utils.c
index 54085b0..51daad9 100644
--- a/utils.c
+++ b/utils.c
@@ -676,6 +676,28 @@ out:
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
@@ -775,6 +797,9 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
 	if (ret < 0)
 		goto out;
 	ret = setup_temp_fs_tree(fd, cfg, fs_bytenr);
+	if (ret < 0)
+		goto out;
+	ret = setup_temp_csum_tree(fd, cfg, csum_bytenr);
 
 out:
 	return ret;
-- 
2.7.0



