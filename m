Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbaDXDny (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 23:43:54 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3O3hpMW006973
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 11:43:51 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: prevent close_root if the root to close is potentially NULL
Date: Thu, 24 Apr 2014 11:39:28 +0800
Message-ID: <1398310768-32438-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally only if 'block_only' is specified, the 'fs_root == NULL'
will be checked. But if 'block_only' is not specified and close_root
will be called blindly without checking 'fs_root == NULL', which is
unsafe.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-debug-tree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 8ae7270..cb6c106 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -177,13 +177,14 @@ int main(int ac, char **av)
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
 	}
+
 	root = info->fs_root;
+	if (!root) {
+		fprintf(stderr, "unable to open %s\n", av[optind]);
+		exit(1);
+	}
 
 	if (block_only) {
-		if (!root) {
-			fprintf(stderr, "unable to open %s\n", av[optind]);
-			exit(1);
-		}
 		leaf = read_tree_block(root,
 				      block_only,
 				      root->leafsize, 0);
-- 
1.8.1.4

