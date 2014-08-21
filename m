Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2135 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbaHUDf7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 23:35:59 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marvin24@gmx.de>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: init uninitialized output buf for btrfs-restore
Date: Thu, 21 Aug 2014 11:35:36 +0800
Message-ID: <1408592136-7606-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A memory problem reported by valgrind as follows:
	=== Syscall param pwrite64(buf) points to uninitialised byte(s)
When running:
	# valgrind --leak-check=yes btrfs restore /dev/sda9 /mnt/backup

Because the output buf size is alloced with malloc, but the length of
output data is shorter than the sizeof(buf), so valgrind report
uninitialised byte(s).
We could use calloc to repalce malloc and clear this WARNING away.

Reported-by: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index cbda6bb..bb72311 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -251,7 +251,7 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	}
 
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
-	outbuf = malloc(ram_size);
+	outbuf = calloc(1, ram_size);
 	if (!outbuf) {
 		fprintf(stderr, "No memory\n");
 		return -ENOMEM;
@@ -320,7 +320,7 @@ static int copy_one_extent(struct btrfs_root *root, int fd,
 	}
 
 	if (compress != BTRFS_COMPRESS_NONE) {
-		outbuf = malloc(ram_size);
+		outbuf = calloc(1, ram_size);
 		if (!outbuf) {
 			fprintf(stderr, "No memory\n");
 			free(inbuf);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
