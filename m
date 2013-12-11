Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3LKLab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 06:30:31 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBBBUL68008777
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 19:30:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make sure we cleanup all reloc roots if error happens
Date: Wed, 11 Dec 2013 19:29:52 +0800
Message-Id: <1386761392-5002-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1386761392-5002-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1386761392-5002-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit an oops when merging reloc roots fails, the reason is that
new reloc roots may be added and we should make sure we cleanup
all reloc roots.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 55bffcf..93d01b7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2409,6 +2409,13 @@ out:
 		btrfs_std_error(root->fs_info, ret);
 		if (!list_empty(&reloc_roots))
 			free_reloc_roots(&reloc_roots);
+
+		/* new reloc root may be added */
+		mutex_lock(&root->fs_info->reloc_mutex);
+		list_splice_init(&rc->reloc_roots, &reloc_roots);
+		mutex_unlock(&root->fs_info->reloc_mutex);
+		if (!list_empty(&reloc_roots))
+			free_reloc_roots(&reloc_roots);
 	}
 
 	BUG_ON(!RB_EMPTY_ROOT(&rc->reloc_root_tree.rb_root));
-- 
1.8.3.1

