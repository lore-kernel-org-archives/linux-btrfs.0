Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36379 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207Ab3HGVrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 17:47:19 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 5/7] btrfs: cleanup: mark 'btrfs_read_root_item' as static
Date: Thu,  8 Aug 2013 00:43:21 +0300
Message-Id: <1375911803-17318-6-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Found by uselex.rb:
> btrfs_read_root_item: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/built-in.o fs/btrfs/root-tree.o

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/ctree.h     | 2 --
 fs/btrfs/root-tree.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..e91ab9e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3414,8 +3414,6 @@ int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct btrfs_key *key,
 				   struct btrfs_root_item *item);
-void btrfs_read_root_item(struct extent_buffer *eb, int slot,
-			  struct btrfs_root_item *item);
 int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ffb1036..65ecc15 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -29,8 +29,8 @@
  * generation numbers as then we know the root was once mounted with an older
  * kernel that was not aware of the root item structure change.
  */
-void btrfs_read_root_item(struct extent_buffer *eb, int slot,
-			  struct btrfs_root_item *item)
+static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
+				 struct btrfs_root_item *item)
 {
 	uuid_le uuid;
 	int len;
-- 
1.8.3.2

