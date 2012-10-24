Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:45153 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2JXCM5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 22:12:57 -0400
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by m53-178.qiye.163.com (HMail) with ESMTPA id C249A1228C4E
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 10:05:29 +0800 (CST)
Received: by mail-la0-f46.google.com with SMTP id h6so12387lag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 19:05:27 -0700 (PDT)
MIME-Version: 1.0
From: Rock Lee <zimilo@code-trick.com>
Date: Wed, 24 Oct 2012 10:04:47 +0800
Message-ID: <CAMRmmpL01PqR1nZPGhyDv1ECdWaBDrhVbx-9FH83x-3ez+M_pQ@mail.gmail.com>
Subject: [BUG][BTRFS-PROGS] Fix Bug to corrupt the img file
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix Bug to corrupt the img file

Reproduce steps:
  > dd if=/dev/zero of=btrfs-small.img bs=1M count=1
  > ls -lh btrfs-small.img
  -rw-rw-r--. 1 rock rock 1.0M Oct 24 09:51 btrfs-small.img
  > mkfs.btrfs btrfs-small.img
  -rw-rw-r--. 1 rock rock 2.0M Oct 24 09:53 btrfs-small.img

Here you can see the original img file's size goes larger to 2Mbytes.

Signed-off-by: Rock Lee <zimilo@code-trick.com>
---
 utils.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 205e667..3c88d2e 100644
--- a/utils.c
+++ b/utils.c
@@ -441,7 +441,7 @@ static int zero_blocks(int fd, off_t start, size_t len)
        return ret;
 }

-static int zero_dev_start(int fd)
+static int zero_dev_start(int fd, u64 dev_size)
 {
        off_t start = 0;
        size_t len = 2 * 1024 * 1024;
@@ -451,6 +451,10 @@ static int zero_dev_start(int fd)
        start = 1024;
        len -= 1024;
 #endif
+
+       if (dev_size < len)
+               return -EIO;
+
        return zero_blocks(fd, start, len);
 }

@@ -572,7 +576,7 @@ int btrfs_prepare_device(int fd, char *file, int
zero_end, u64 *block_count_ret,
                discard_blocks(fd, 0, block_count);
        }

-       ret = zero_dev_start(fd);
+       ret = zero_dev_start(fd, block_count);
        if (ret) {
                fprintf(stderr, "failed to zero device start %d\n", ret);
                exit(1);
-- 
1.7.7.6
