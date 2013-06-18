Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:59245 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab3FRWHr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 18:07:47 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Chris Mason <chris.mason@fusionio.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH] Btrfs: do not ignore errors when truncating the free space cache inode
Date: Tue, 18 Jun 2013 22:57:41 +0100
Message-Id: <1371592661-11167-1-git-send-email-tixxdz@opendz.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_check_trunc_cache_free_space() tries to check if there is enough
space for cache inode truncation but it fails.

Currently this function always returns success even if there is no
enough space. Fix this by returning the -ENOSPC error code.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
Totally untested code.

 fs/btrfs/free-space-cache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2750b50..9629830 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -201,7 +201,7 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
 				       struct btrfs_block_rsv *rsv)
 {
 	u64 needed_bytes;
-	int ret;
+	int ret = 0;
 
 	/* 1 for slack space, 1 for updating the inode */
 	needed_bytes = btrfs_calc_trunc_metadata_size(root, 1) +
@@ -210,10 +210,10 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
 	spin_lock(&rsv->lock);
 	if (rsv->reserved < needed_bytes)
 		ret = -ENOSPC;
-	else
-		ret = 0;
+
 	spin_unlock(&rsv->lock);
-	return 0;
+
+	return ret;
 }
 
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,
-- 
1.7.11.7

