Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:52267 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeCEIJZ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 5 Mar 2018 03:09:25 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: free-space-cache: Use DIV_ROUND_UP() to replace open code
Date: Mon,  5 Mar 2018 16:09:12 +0800
Message-Id: <20180305080912.5417-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 free-space-cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 50356d0462dd..f933f9f1cf3f 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -54,8 +54,7 @@ static int io_ctl_init(struct io_ctl *io_ctl, u64 size, u64 ino,
 		       struct btrfs_root *root)
 {
 	memset(io_ctl, 0, sizeof(struct io_ctl));
-	io_ctl->num_pages = (size + root->fs_info->sectorsize - 1) /
-				root->fs_info->sectorsize;
+	io_ctl->num_pages = DIV_ROUND_UP(size, root->fs_info->sectorsize);
 	io_ctl->buffer = kzalloc(size, GFP_NOFS);
 	if (!io_ctl->buffer)
 		return -ENOMEM;
-- 
2.16.2

