Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36533 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3JSERf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Oct 2013 00:17:35 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so4386702pab.8
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 21:17:35 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([223.65.142.116])
        by mx.google.com with ESMTPSA id py4sm5837737pbb.33.2013.10.18.21.17.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 18 Oct 2013 21:17:34 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix race condition between writting and scrubing supers
Date: Sat, 19 Oct 2013 12:17:30 +0800
Message-Id: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Scrubing supers is not in a transaction context, when trying to
write supers to disk, we should check if we are trying to
scrub supers.Fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c     | 2 ++
 fs/btrfs/transaction.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 419968e..0debb19 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3582,7 +3582,9 @@ int btrfs_commit_super(struct btrfs_root *root)
 		return ret;
 	}
 
+	btrfs_scrub_pause_super(root);
 	ret = write_ctree_super(NULL, root, 0);
+	btrfs_scrub_continue_super(root);
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 277fe81..3ebcbbd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1892,7 +1892,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto cleanup_transaction;
 	}
 
+	btrfs_scrub_pause_super(root);
 	ret = write_ctree_super(trans, root, 0);
+	btrfs_scrub_continue_super(root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		goto cleanup_transaction;
-- 
1.7.11.7

