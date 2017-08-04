Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33169 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752240AbdHDLlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 07:41:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4B70ABB1
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Aug 2017 11:41:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Fix -EOVERFLOW handling in btrfs_ioctl_tree_search_v2
Date: Fri,  4 Aug 2017 14:41:18 +0300
Message-Id: <1501846878-10627-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The buffer passed to btrfs_ioctl_tree_search* functions have to be at least
sizeof(struct btrfs_ioctl_search_header). If this is not the case then the
ioctl should return -EOVERFLOW and set the uarg->buf_size to the minimum
required size. Currently btrfs_ioctl_tree_search_v2 would return an -EOVERFLOW
error with ->buf_size being set to the value passed by user space. Fix this by
removing the size check and relying on search_ioctl, which already includes it
and correctly sets buf_size.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fa1b78cf25f6..e80950b3f340 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2201,9 +2201,6 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 
 	buf_size = args.buf_size;
 
-	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
-		return -EOVERFLOW;
-
 	/* limit result size to 16MB */
 	if (buf_size > buf_limit)
 		buf_size = buf_limit;
-- 
2.7.4

