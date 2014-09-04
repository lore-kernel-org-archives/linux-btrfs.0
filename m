Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8488 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756133AbaIDDJ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 23:09:59 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8439sFa005332
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Sep 2014 11:09:55 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: remove btrfs_release_path before btrfs_free_path
Date: Thu, 4 Sep 2014 11:09:23 +0800
Message-ID: <1409800164-14491-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_free_path calls btrfs_release_path internally.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 disk-io.c   | 1 -
 file-item.c | 1 -
 inode-map.c | 2 --
 3 files changed, 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 9e44f10..0f9f374 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -628,7 +628,6 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 	memcpy(&root->root_key, location, sizeof(*location));
 	ret = 0;
 out:
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	if (ret) {
 		free(root);
diff --git a/file-item.c b/file-item.c
index 6f3708b..b46d7f1 100644
--- a/file-item.c
+++ b/file-item.c
@@ -306,7 +306,6 @@ found:
 			    csum_size);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 fail:
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/inode-map.c b/inode-map.c
index 3e138b5..1321bfb 100644
--- a/inode-map.c
+++ b/inode-map.c
@@ -90,12 +90,10 @@ int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 	// FIXME -ENOSPC
 found:
 	root->last_inode_alloc = *objectid;
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	BUG_ON(*objectid < search_start);
 	return 0;
 error:
-	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.8.1.4

