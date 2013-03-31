Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59263 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3CaKgm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 06:36:42 -0400
Received: by mail-pb0-f50.google.com with SMTP id jt11so789428pbb.9
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 03:36:42 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, wangsl-fnst@cn.fujitsu.com, list.btrfs@jan-o-sch.net
Subject: [PATCH V2] Btrfs: fix double free in the iterate_extent_inodes()
Date: Sun, 31 Mar 2013 18:36:37 +0800
Message-Id: <1364726197-1879-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

If btrfs_find_all_roots() fails, 'roots' has been freed or 'roots'
fails to allocate. We don't need to free it outside btrfs_find_all_roots()
again.Fix it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
Changelog:
	V1->v2: remove reduplicate code that set 'roots' to be NULL
---
 fs/btrfs/backref.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 5ff46ee..cbb7108 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1510,11 +1510,9 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 						iterate, ctx);
 		}
 		ulist_free(roots);
-		roots = NULL;
 	}
 
 	free_leaf_list(refs);
-	ulist_free(roots);
 out:
 	if (!search_commit_root) {
 		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
-- 
1.7.11.7

