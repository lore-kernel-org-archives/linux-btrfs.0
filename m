Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:46595 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753118AbeGCABD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 20:01:03 -0400
Received: by mail-qk0-f194.google.com with SMTP id o2-v6so78264qkc.13
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 17:01:02 -0700 (PDT)
From: Zhihui Zhang <zzhsuny@gmail.com>
To: jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make sure there is always room for generation number
Date: Mon,  2 Jul 2018 20:00:54 -0400
Message-Id: <1530576054-12837-1-git-send-email-zzhsuny@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

io_ctl_set_generation() assumes that the generation number shares
the same page with inline CRCs. Let's make sure this is always true.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 fs/btrfs/free-space-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d5f80cb300be..9aa0fbf16515 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -300,9 +300,9 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FREE_INO_OBJECTID)
 		check_crcs = 1;
 
-	/* Make sure we can fit our crcs into the first page */
+	/* Make sure we can fit our crcs and generation # into the first page */
 	if (write && check_crcs &&
-	    (num_pages * sizeof(u32)) >= PAGE_SIZE)
+	    (num_pages * sizeof(u32) + sizeof(u64)) > PAGE_SIZE)
 		return -ENOSPC;
 
 	memset(io_ctl, 0, sizeof(struct btrfs_io_ctl));
-- 
2.17.1

