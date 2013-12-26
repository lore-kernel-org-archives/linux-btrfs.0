Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31668 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3LZFLk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 00:11:40 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBQ5BZ70004287
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Dec 2013 13:11:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: fix an oops when we fail to merge reloc roots
Date: Thu, 26 Dec 2013 13:10:50 +0800
Message-Id: <1388034651-2778-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1388034651-2778-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1388034651-2778-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, we will free reloc root memory and then force filesystem
to be readonly. The problem is that there may be another thread commiting
transaction which will try to access freed reloc root during merging reloc
roots process.

To keep consistency snapshots shared space, we should allow snapshot
finished if possible, so here we don't free reloc root memory.

signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 277b8e3..9189f9e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2311,9 +2311,6 @@ void free_reloc_roots(struct list_head *list)
 		reloc_root = list_entry(list->next, struct btrfs_root,
 					root_list);
 		__del_reloc_root(reloc_root);
-		free_extent_buffer(reloc_root->node);
-		free_extent_buffer(reloc_root->commit_root);
-		kfree(reloc_root);
 	}
 }
 
@@ -2355,10 +2352,9 @@ again:
 
 			ret = merge_reloc_root(rc, root);
 			if (ret) {
-				__del_reloc_root(reloc_root);
-				free_extent_buffer(reloc_root->node);
-				free_extent_buffer(reloc_root->commit_root);
-				kfree(reloc_root);
+				if (list_empty(&reloc_root->root_list))
+					list_add_tail(&reloc_root->root_list,
+						      &reloc_roots);
 				goto out;
 			}
 		} else {
-- 
1.8.3.1

