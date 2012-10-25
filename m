Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m59-178.qiye.163.com ([123.58.178.59]:33638 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2JYXjc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 19:39:32 -0400
From: zimilo@code-trick.com
To: linux-btrfs@vger.kernel.org
Cc: Rock <zimilo@code-trick.com>
Subject: [RESEND PATCH V2][BTRFS-PROGS] [BUG] Fix Bug to corrupt the img file
Date: Fri, 26 Oct 2012 07:38:57 +0800
Message-Id: <1351208337-3455-1-git-send-email-zimilo@code-trick.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Rock <zimilo@code-trick.com>

Reproduce steps:
  > dd if=/dev/zero of=btrfs-small.img bs=1M count=1
  > ls -lh btrfs-small.img
  -rw-rw-r--. 1 rock rock 1.0M Oct 24 09:51 btrfs-small.img
                          ^^^
  > mkfs.btrfs btrfs-small.img
  -rw-rw-r--. 1 rock rock 2.0M Oct 24 09:53 btrfs-small.img
                          ^^^

Here you can see the original img file's size goes larger to 2Mb.

Signed-off-by: Rock Lee <zimilo@code-trick.com>
---
 utils.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utils.c b/utils.c
index 205e667..7ba746e 100644
--- a/utils.c
+++ b/utils.c
@@ -557,6 +557,12 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
+
+	if (block_count < 2 * 1024 * 1024) {
+		fprintf(stderr, "size of %s is too small(less than 2Mb)\n", file);
+		exit(1);
+	}
+
 	zero_end = 1;
 
 	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
-- 
1.7.9.5

