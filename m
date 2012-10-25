Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:51503 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab2JYQNK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 12:13:10 -0400
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com [209.85.212.172])
	by m53-178.qiye.163.com (HMail) with ESMTPA id DF58312281FB
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 00:13:06 +0800 (CST)
Received: by mail-wi0-f172.google.com with SMTP id hq12so6161352wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 09:13:04 -0700 (PDT)
MIME-Version: 1.0
From: Rock Lee <zimilo@code-trick.com>
Date: Fri, 26 Oct 2012 00:12:24 +0800
Message-ID: <CAMRmmpLUsC=L=4sUf09Gx97W1hvc2FoOMmqOydiZQ6XwumUoYQ@mail.gmail.com>
Subject: [PATCH V2][BTRFS-PROGS] [BUG] Fix Bug to corrupt the img file
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix Bug to corrupt the img file

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
@@ -557,6 +557,12 @@ int btrfs_prepare_device(int fd, char *file, int
zero_end, u64 *block_count_ret,
        }
        if (max_block_count)
                block_count = min(block_count, max_block_count);
+
+       if (block_count < 2 * 1024 * 1024) {
+               fprintf(stderr, "size of %s is too small(less than
2Mb)\n", file);
+               exit(1);
+       }
+
        zero_end = 1;

        if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
-- 
1.7.9.5
