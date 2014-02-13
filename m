Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaBMDUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 22:20:18 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1D3K49f002790
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:20:13 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: fix fsck leaks on error returns
Date: Thu, 13 Feb 2014 11:16:38 +0800
Message-Id: <1392261398-6197-4-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add close_ctree()s before the "returns" on errors after open_ctree()

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-check.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2911af0..81f65a3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6460,6 +6460,7 @@ int cmd_check(int argc, char **argv)
 	    !extent_buffer_uptodate(info->dev_root->node) ||
 	    !extent_buffer_uptodate(info->chunk_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
+		close_ctree(info->fs_root);
 		return -EIO;
 	}
 
@@ -6467,11 +6468,14 @@ int cmd_check(int argc, char **argv)
 	if (init_extent_tree) {
 		printf("Creating a new extent tree\n");
 		ret = reinit_extent_tree(info);
-		if (ret)
+		if (ret) {
+			close_ctree(root);
 			return ret;
+		}
 	}
 	if (!extent_buffer_uptodate(info->extent_root->node)) {
 		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
+		close_ctree(root);
 		return -EIO;
 	}
 
@@ -6483,12 +6487,14 @@ int cmd_check(int argc, char **argv)
 		trans = btrfs_start_transaction(info->csum_root, 1);
 		if (IS_ERR(trans)) {
 			fprintf(stderr, "Error starting transaction\n");
+			close_ctree(root);
 			return PTR_ERR(trans);
 		}
 
 		ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
 		if (ret) {
 			fprintf(stderr, "crc root initialization failed\n");
+			close_ctree(root);
 			return -EIO;
 		}
 
-- 
1.8.1.4

