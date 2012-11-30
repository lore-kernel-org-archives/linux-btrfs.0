Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58027 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2K3GD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 01:03:27 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so97671iay.19
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 22:03:26 -0800 (PST)
From: shhuiw@gmail.com
To: chris.mason@fusionio.com, jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check crc area early in io_ctl_init
Date: Fri, 30 Nov 2012 14:02:27 +0800
Message-Id: <50b84c2d.c44d320a.520e.ffffbea6@mx.google.com>
In-Reply-To: <1354255348-5011-1-git-send-email-y>
References: <n>
 <1354255348-5011-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Sheng-Hui <shhuiw@gmail.com>

When use crc area, we should check if it can host the desired num of
crcs. Add the check in init stage.

And the check should be more strict: the first page has sizeof(u64)*2
cannot used for crc.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/free-space-cache.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4ea66d4..058fc9b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -286,8 +286,14 @@ static int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
 	if (!io_ctl->pages)
 		return -ENOMEM;
 	io_ctl->root = root;
-	if (btrfs_ino(inode) != BTRFS_FREE_INO_OBJECTID)
+	if (btrfs_ino(inode) != BTRFS_FREE_INO_OBJECTID) {
 		io_ctl->check_crcs = 1;
+		if ((io_ctl.num_pages * sizeof(u32)) >
+		    (PAGE_CACHE_SIZE - sizeof(u64) * 2)) {
+			WARN_ON(1);
+			return -1;
+		}
+	}
 	return 0;
 }
 
@@ -917,7 +923,8 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/* Make sure we can fit our crcs into the first page */
 	if (io_ctl.check_crcs &&
-	    (io_ctl.num_pages * sizeof(u32)) >= PAGE_CACHE_SIZE) {
+	    (io_ctl.num_pages * sizeof(u32)) >
+	    (PAGE_CACHE_SIZE - sizeof(u64) * 2)) {
 		WARN_ON(1);
 		goto out_nospc;
 	}
-- 
1.6.0.2

