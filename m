Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36363 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206Ab3HGVrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 17:47:12 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 3/7] btrfs: cleanup: mark 'btrfs_write_and_wait_marked_extents' as static
Date: Thu,  8 Aug 2013 00:43:19 +0300
Message-Id: <1375911803-17318-4-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Found by uselex.rb:
> btrfs_write_and_wait_marked_extents: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/transaction.o fs/btrfs/built-in.o

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/transaction.c | 4 ++--
 fs/btrfs/transaction.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d58cce7..ff891d2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -837,8 +837,8 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
  * them in one of two extent_io trees.  This is used to make sure all of
  * those extents are on disk for transaction or log commit
  */
-int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
-				struct extent_io_tree *dirty_pages, int mark)
+static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
+					       struct extent_io_tree *dirty_pages, int mark)
 {
 	int ret;
 	int ret2;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 005b037..af8293f 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -160,8 +160,6 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 void btrfs_throttle(struct btrfs_root *root);
 int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
-int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
-				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_write_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_wait_marked_extents(struct btrfs_root *root,
-- 
1.8.3.2

