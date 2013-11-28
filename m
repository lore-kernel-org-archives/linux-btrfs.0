Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3K1Ffg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 00:35:36 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAS5ZNXk008146
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 13:35:33 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: skip chunk recover works when check chunks successfully
Date: Thu, 28 Nov 2013 13:32:50 +0800
Message-Id: <1385616772-13222-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If no chunks need to be recovered, skip the recover works,
meanwhile the user won't be annoyed by the "ask_user".

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/chunk-recover.c b/chunk-recover.c
index ae0d318..45d6eae 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1685,6 +1685,9 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 		 * droppped from the fs. Don't deal with them now, we will
 		 * check it after the fs is opened.
 		 */
+	} else {
+		fprintf(stderr, "Check chunks successfully with no orphans\n");
+		goto fail_rc;
 	}
 
 	root = open_ctree_with_broken_chunk(&rc);
-- 
1.8.0.1

