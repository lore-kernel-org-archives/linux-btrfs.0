Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50756 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab3LIQOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Dec 2013 11:14:38 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so5719269pbc.20
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Dec 2013 08:14:37 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com
Subject: [PATCH 1/2] Btrfs: fix an oops when doing balance relocation
Date: Tue, 10 Dec 2013 00:14:33 +0800
Message-Id: <1386605674-3320-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

I hit a BUG_ON() when inserting reloc root into rc->reloc_root_tree.rb_root,
the fact is block bytenr has been inserted before, this is really a redicious
bug, the reason is that we freed root node after we have allocated root
node block,and this block bytenr will be reused and then oops happens.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ce459a7..4dc7f26 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1361,7 +1361,6 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_tree_unlock(eb);
-	free_extent_buffer(eb);
 
 	ret = btrfs_insert_root(trans, root->fs_info->tree_root,
 				&root_key, root_item);
-- 
1.8.4

