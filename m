Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38306 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3C2Nml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:42:41 -0400
Received: by mail-pd0-f179.google.com with SMTP id x11so264152pdj.10
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 06:42:41 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs: cleanup to remove reduplicate code in iterate_extent_inode()
Date: Fri, 29 Mar 2013 21:42:34 +0800
Message-Id: <1364564554-1848-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Just remove the unnecessary check and assignment.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3ca413bb..e102b48 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1499,7 +1499,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 		if (ret)
 			break;
 		ULIST_ITER_INIT(&root_uiter);
-		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
+		while ((root_node = ulist_next(roots, &root_uiter))) {
 			pr_debug("root %llu references leaf %llu, data list "
 				 "%#llx\n", root_node->val, ref_node->val,
 				 (long long)ref_node->aux);
@@ -1510,7 +1510,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 						iterate, ctx);
 		}
 		ulist_free(roots);
-		roots = NULL;
 	}
 
 	free_leaf_list(refs);
-- 
1.7.11.7

