Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbcA2FQm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:16:42 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 09/22] btrfs-progs: Introduce function to initialize fs tree
Date: Fri, 29 Jan 2016 13:03:19 +0800
Message-Id: <1454043812-7893-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introudce new function, setup_temp_fs_tree(), to setup temporary fs tree
for make_btrfs_v2().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 utils.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/utils.c b/utils.c
index 4d29b1e..54085b0 100644
--- a/utils.c
+++ b/utils.c
@@ -654,6 +654,28 @@ out:
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
@@ -750,6 +772,10 @@ static int make_convert_btrfs(int fd, struct btrfs_mkfs_config *cfg,
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
2.7.0



