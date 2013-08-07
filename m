Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36356 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195Ab3HGVrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 17:47:06 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 2/7] btrfs: cleanup: mark 'set_state_private' as static
Date: Thu,  8 Aug 2013 00:43:18 +0300
Message-Id: <1375911803-17318-3-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-1-git-send-email-slyich@gmail.com>
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Found by uselex.rb:
> set_state_private: [R]: exported from: fs/btrfs/disk-io.o fs/btrfs/built-in.o fs/btrfs/btrfs.o

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/extent_io.c | 2 +-
 fs/btrfs/extent_io.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 583d98b..3912396 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1810,7 +1810,7 @@ out:
  * set the private field for a given byte offset in the tree.  If there isn't
  * an extent_state there already, this does nothing.
  */
-int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
+static int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 {
 	struct rb_node *node;
 	struct extent_state *state;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3b8c4e2..bb1f75d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -261,7 +261,6 @@ int extent_readpages(struct extent_io_tree *tree,
 		     get_extent_t get_extent);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
-int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
 void extent_cache_csums_dio(struct extent_io_tree *tree, u64 start, u32 csums[],
 			    int count);
 void extent_cache_csums(struct extent_io_tree *tree, struct bio *bio,
-- 
1.8.3.2

