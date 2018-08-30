Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33380 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeH3VqA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:00 -0400
Received: by mail-qk1-f194.google.com with SMTP id z78-v6so22638qka.0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:45 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y142-v6sm4207288qka.5.2018.08.30.10.42.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:43 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/35] btrfs: protect space cache inode alloc with nofs
Date: Thu, 30 Aug 2018 13:41:59 -0400
Message-Id: <20180830174225.2200-10-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're allocating a new space cache inode it's likely going to be
under a transaction handle, so we need to use memalloc_nofs_save() in
order to avoid deadlocks, and more importantly lockdep messages that
make xfstests fail.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/free-space-cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c3888c113d81..db93a5f035a0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -10,6 +10,7 @@
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
 #include <linux/error-injection.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
@@ -47,6 +48,7 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct inode *inode = NULL;
+	unsigned nofs_flag;
 	int ret;
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
@@ -68,7 +70,9 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	btrfs_disk_key_to_cpu(&location, &disk_key);
 	btrfs_release_path(path);
 
+	nofs_flag = memalloc_nofs_save();
 	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
+	memalloc_nofs_restore(nofs_flag);
 	if (IS_ERR(inode))
 		return inode;
 
-- 
2.14.3
