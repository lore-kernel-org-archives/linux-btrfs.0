Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7DFC282E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E20621738
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfDWLmL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 07:42:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:44366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727569AbfDWLmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 07:42:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68EB3ACA5
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 11:42:10 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Remove dead code
Date:   Tue, 23 Apr 2019 14:42:07 +0300
Message-Id: <20190423114207.7899-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190423114207.7899-1-nborisov@suse.com>
References: <20190423114207.7899-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

BTRFS no longer relies on btrfs_subvolume_writers for snapshot
exclusion. Just remove any code allocating/freeing it and the structure
definition itself.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h   |  6 ------
 fs/btrfs/disk-io.c | 10 ----------
 2 files changed, 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 05731e4ca358..9fdb7ab74102 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1169,11 +1169,6 @@ static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-struct btrfs_subvolume_writers {
-	struct percpu_counter	counter;
-	wait_queue_head_t	wait;
-};
-
 /*
  * The state of btrfs root
  */
@@ -1339,7 +1334,6 @@ struct btrfs_root {
 	 * manipulation with the read-only status via SUBVOL_SETFLAGS
 	 */
 	int send_in_progress;
-	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshotted;
 	atomic_t snapshot_force_cow;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 005c9f5c6f10..ad2fa12cc654 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1492,7 +1492,6 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 int btrfs_init_fs_root(struct btrfs_root *root)
 {
 	int ret;
-	struct btrfs_subvolume_writers *writers;
 
 	root->free_ino_ctl = kzalloc(sizeof(*root->free_ino_ctl), GFP_NOFS);
 	root->free_ino_pinned = kzalloc(sizeof(*root->free_ino_pinned),
@@ -1502,13 +1501,6 @@ int btrfs_init_fs_root(struct btrfs_root *root)
 		goto fail;
 	}
 
-	writers = btrfs_alloc_subvolume_writers();
-	if (IS_ERR(writers)) {
-		ret = PTR_ERR(writers);
-		goto fail;
-	}
-	root->subv_writers = writers;
-
 	btrfs_init_free_ino_ctl(root);
 	spin_lock_init(&root->ino_cache_lock);
 	init_waitqueue_head(&root->ino_cache_wait);
@@ -3870,8 +3862,6 @@ void btrfs_free_fs_root(struct btrfs_root *root)
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
 	if (root->anon_dev)
 		free_anon_bdev(root->anon_dev);
-	if (root->subv_writers)
-		btrfs_free_subvolume_writers(root->subv_writers);
 	free_extent_buffer(root->node);
 	free_extent_buffer(root->commit_root);
 	kfree(root->free_ino_ctl);
-- 
2.17.1

