Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36371 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190Ab3HGVrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 17:47:16 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 4/7] btrfs: cleanup: removed unused 'btrfs_start_transaction_lflush'
Date: Thu,  8 Aug 2013 00:43:20 +0300
Message-Id: <1375911803-17318-5-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Found by uselex.rb:
> btrfs_start_transaction_lflush: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/transaction.o fs/btrfs/built-in.o

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/transaction.c | 7 -------
 fs/btrfs/transaction.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ff891d2..57c3239 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -497,13 +497,6 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 				 BTRFS_RESERVE_FLUSH_ALL);
 }
 
-struct btrfs_trans_handle *btrfs_start_transaction_lflush(
-					struct btrfs_root *root, int num_items)
-{
-	return start_transaction(root, num_items, TRANS_START,
-				 BTRFS_RESERVE_FLUSH_LIMIT);
-}
-
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN, 0);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index af8293f..05d4be1 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -131,8 +131,6 @@ int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
-struct btrfs_trans_handle *btrfs_start_transaction_lflush(
-					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
-- 
1.8.3.2

