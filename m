Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60017 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbbASGrW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:22 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6khGm022572
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 05/10] btrfs-progs: Switch btrfs-find-root to use the new open_ctree flags.
Date: Mon, 19 Jan 2015 14:45:07 +0800
Message-ID: <1421649912-14539-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since in previous patches, we introduced the new open_ctree flag
OPEN_CTREE_CHUNK_ONLY, switch btrfs-find-root to use it instead of the
open_ctree_broken().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 6fa61cc..bc2b344 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -281,7 +281,6 @@ static int find_root(struct btrfs_root *root)
 int main(int argc, char **argv)
 {
 	struct btrfs_root *root;
-	int dev_fd;
 	int opt;
 	int ret;
 
@@ -309,14 +308,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	dev_fd = open(argv[optind], O_RDONLY);
-	if (dev_fd < 0) {
-		fprintf(stderr, "Failed to open device %s\n", argv[optind]);
-		exit(1);
-	}
-
-	root = open_ctree_broken(dev_fd, argv[optind]);
-	close(dev_fd);
+	root = open_ctree(argv[optind], 0, OPEN_CTREE_CHUNK_ONLY);
 
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
-- 
2.2.2

