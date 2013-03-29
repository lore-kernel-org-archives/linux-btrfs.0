Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65041 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3C2NFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:05:36 -0400
Received: by mail-pb0-f52.google.com with SMTP id ma3so254498pbc.25
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 06:05:35 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs: fix double free in the iterate_extent_inodes()
Date: Fri, 29 Mar 2013 21:05:30 +0800
Message-Id: <1364562330-1606-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

If btrfs_find_all_roots() fails, 'roots' has been freed or 'roots'
fails to allocate. we don't need to free it outside btrfs_find_all_roots()
again.Fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 5ff46ee..3ca413bb 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1514,7 +1514,6 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	}
 
 	free_leaf_list(refs);
-	ulist_free(roots);
 out:
 	if (!search_commit_root) {
 		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
-- 
1.7.11.7

