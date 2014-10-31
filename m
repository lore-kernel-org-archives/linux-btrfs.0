Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:64900 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaJaVwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 17:52:53 -0400
Message-ID: <545404A6.2090807@users.sourceforge.net>
Date: Fri, 31 Oct 2014 22:52:38 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] btrfs: Deletion of unnecessary checks before six function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following functions test whether their argument is NULL and then
return immediately.
* btrfs_free_path()
* free_extent_buffer()
* free_extent_map()
* free_extent_state()
* iput()
* kfree()

Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/dev-replace.c       |  3 +--
 fs/btrfs/extent_io.c         | 12 ++++--------
 fs/btrfs/file.c              |  6 ++----
 fs/btrfs/free-space-cache.c  |  7 +++----
 fs/btrfs/inode.c             |  6 ++----
 fs/btrfs/reada.c             |  3 +--
 fs/btrfs/relocation.c        |  3 +--
 fs/btrfs/tests/btrfs-tests.c |  3 +--
 fs/btrfs/tree-defrag.c       |  3 +--
 fs/btrfs/tree-log.c          |  6 ++----
 10 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6f662b3..3465029 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -183,8 +183,7 @@ no_valid_dev_replace_entry_found:
 	}

 out:
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	return ret;
 }

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bf3f424..cfbf00a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -704,8 +704,7 @@ next:

 out:
 	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
+	free_extent_state(prealloc);

 	return 0;

@@ -1006,8 +1005,7 @@ hit_next:

 out:
 	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
+	free_extent_state(prealloc);

 	return err;

@@ -1223,8 +1221,7 @@ hit_next:

 out:
 	spin_unlock(&tree->lock);
-	if (prealloc)
-		free_extent_state(prealloc);
+	free_extent_state(prealloc);

 	return err;

@@ -4146,8 +4143,7 @@ int extent_readpages(struct extent_io_tree *tree,
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
 				   &bio, 0, &bio_flags, READ);

-	if (em_cached)
-		free_extent_map(em_cached);
+	free_extent_map(em_cached);

 	BUG_ON(!list_empty(pages));
 	if (bio)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a18ceab..add07ce8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -677,10 +677,8 @@ next:
 		/* once for the tree*/
 		free_extent_map(em);
 	}
-	if (split)
-		free_extent_map(split);
-	if (split2)
-		free_extent_map(split2);
+	free_extent_map(split);
+	free_extent_map(split2);
 }

 /*
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3384819..11883e2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1943,8 +1943,7 @@ new_bitmap:

 out:
 	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}

@@ -3322,8 +3321,8 @@ again:

 	if (info)
 		kmem_cache_free(btrfs_free_space_cachep, info);
-	if (map)
-		kfree(map);
+
+	kfree(map);
 	return 0;
 }

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d23362f..7301b99 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -857,8 +857,7 @@ static u64 get_extent_allocation_hint(struct inode *inode,
u64 start,
 			em = search_extent_mapping(em_tree, 0, 0);
 			if (em && em->block_start < EXTENT_MAP_LAST_BYTE)
 				alloc_hint = em->block_start;
-			if (em)
-				free_extent_map(em);
+			free_extent_map(em);
 		} else {
 			alloc_hint = em->block_start;
 			free_extent_map(em);
@@ -6573,8 +6572,7 @@ out:

 	trace_btrfs_get_extent(root, em);

-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	if (trans) {
 		ret = btrfs_end_transaction(trans, root);
 		if (!err)
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index b63ae20..ec8eb49 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -731,8 +731,7 @@ static int reada_start_machine_dev(struct btrfs_fs_info
*fs_info,
 	else if (eb)
 		__readahead_hook(fs_info->extent_root, eb, eb->start, ret);

-	if (eb)
-		free_extent_buffer(eb);
+	free_extent_buffer(eb);

 	return 1;

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 74257d6..f87a5ee 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4158,8 +4158,7 @@ out:
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root);
 	if (err) {
-		if (inode)
-			iput(inode);
+		iput(inode);
 		inode = ERR_PTR(err);
 	}
 	return inode;
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 9626252..7fb123f 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -162,8 +162,7 @@ void btrfs_free_dummy_root(struct btrfs_root *root)
 {
 	if (!root)
 		return;
-	if (root->node)
-		free_extent_buffer(root->node);
+	free_extent_buffer(root->node);
 	if (root->fs_info)
 		btrfs_free_dummy_fs_info(root->fs_info);
 	kfree(root);
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index a63719c..c74f106 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -118,8 +118,7 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		ret = -EAGAIN;
 	}
 out:
-	if (path)
-		btrfs_free_path(path);
+	btrfs_free_path(path);
 	if (ret == -EAGAIN) {
 		if (root->defrag_max.objectid > root->defrag_progress.objectid)
 			goto done;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1475979..70926a9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -736,8 +736,7 @@ static noinline int replay_one_extent(struct
btrfs_trans_handle *trans,
 	inode_add_bytes(inode, nbytes);
 	ret = btrfs_update_inode(trans, root, inode);
 out:
-	if (inode)
-		iput(inode);
+	iput(inode);
 	return ret;
 }

@@ -2210,8 +2209,7 @@ static noinline int walk_down_log_tree(struct
btrfs_trans_handle *trans,
 		}

 		WARN_ON(*level <= 0);
-		if (path->nodes[*level-1])
-			free_extent_buffer(path->nodes[*level-1]);
+		free_extent_buffer(path->nodes[*level-1]);
 		path->nodes[*level-1] = next;
 		*level = btrfs_header_level(next);
 		path->slots[*level] = 0;
-- 
2.1.3


