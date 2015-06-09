Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7372 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868AbbFIJBw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 05:01:52 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t597wBdd015717
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Jun 2015 15:58:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: convert: Print different error message if convert partly failed.
Date: Tue, 9 Jun 2015 15:57:40 +0800
Message-ID: <1433836660-1163-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When testing under libguestfs, btrfs-convert will never succeed to fix
chunk map, and always fails.

But in that case, it's already a mountable btrfs.
So better to info user with different error message for that case.

The root cause of it is still under investigation.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 9a9d619..5606156 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2286,6 +2286,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 {
 	int i, ret, blocks_per_node;
 	int fd = -1;
+	int is_btrfs = 0;
 	u32 blocksize;
 	u64 blocks[7];
 	u64 total_bytes;
@@ -2435,6 +2436,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "unable to migrate super block\n");
 		goto fail;
 	}
+	is_btrfs = 1;
 
 	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
 	if (!root) {
@@ -2455,7 +2457,11 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 fail:
 	if (fd != -1)
 		close(fd);
-	fprintf(stderr, "conversion aborted.\n");
+	if (is_btrfs)
+		fprintf(stderr,
+			"some error happened, but still converted to btrfs\n");
+	else
+		fprintf(stderr, "conversion aborted\n");
 	return -1;
 }
 
-- 
2.4.2

