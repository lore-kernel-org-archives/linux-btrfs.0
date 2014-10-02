Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaJBQu3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7A07DAAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:28 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 10/14] btrfs: hide typecast to definition of BTRFS_SEND_TRANS_STUB
Date: Thu,  2 Oct 2014 18:50:27 +0200
Message-Id: <2755a0de64693501741fb3603cd8ca928b0b7e81.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c     | 3 +--
 fs/btrfs/send.c        | 2 +-
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/transaction.h | 2 +-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f075ef20050..0abf4b0a9010 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -347,8 +347,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 {
 	struct extent_state *cached_state = NULL;
 	int ret;
-	bool need_lock = (current->journal_info ==
-			  (void *)BTRFS_SEND_TRANS_STUB);
+	bool need_lock = (current->journal_info == BTRFS_SEND_TRANS_STUB);
 
 	if (!parent_transid || btrfs_header_generation(eb) == parent_transid)
 		return 0;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7edfc7cebda4..8b44630f4abf 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5728,7 +5728,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 			NULL);
 	sort_clone_roots = 1;
 
-	current->journal_info = (void *)BTRFS_SEND_TRANS_STUB;
+	current->journal_info = BTRFS_SEND_TRANS_STUB;
 	ret = send_subvol(sctx);
 	current->journal_info = NULL;
 	if (ret < 0)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 16d0c1b62b3e..f4c194b160b7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -386,7 +386,7 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
 	int ret;
 
 	/* Send isn't supposed to start transactions. */
-	ASSERT(current->journal_info != (void *)BTRFS_SEND_TRANS_STUB);
+	ASSERT(current->journal_info != BTRFS_SEND_TRANS_STUB);
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return ERR_PTR(-EROFS);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 579be51b27e5..d8f40e1a5d2d 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -79,7 +79,7 @@ struct btrfs_transaction {
 #define TRANS_EXTWRITERS	(__TRANS_USERSPACE | __TRANS_START |	\
 				 __TRANS_ATTACH)
 
-#define BTRFS_SEND_TRANS_STUB	1
+#define BTRFS_SEND_TRANS_STUB	((void *)1)
 
 struct btrfs_trans_handle {
 	u64 transid;
-- 
1.8.4.5

