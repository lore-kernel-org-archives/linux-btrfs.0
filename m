From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: avoid redundant block group free-space checks
Date: Mon, 12 Dec 2011 05:58:55 -0200
Message-ID: <ory5uite4g.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

It was pointed out to me that the test for enough free space in a block
group was wrong in that it would skip a block group that had most of its
free space reserved by a cluster.

I offer two mutually exclusive, (so far) very lightly tested patches to
address this problem.

One moves the test to the middle of the clustered allocation logic,
between the release of the cluster and the attempt to create a new
cluster, with some ugliness due to more indentation, locking operations
and testing.

The other, that I like better but haven't given any significant amount
of testing yet, only performs the test when we fall back to unclustered
allocation, relying on btrfs_find_space_cluster to test for enough free
space early (it does); it also arranges for the cluster in the current
block group to be released before we try unclustered allocation.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Btrfs-delay-block-group-s-free-space-test-within-all.patch

>From f1d4d6212a4cfb2fde6a15780d9b337319d3d1e1 Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Mon, 12 Dec 2011 04:33:33 -0200
Subject: [PATCH] Btrfs: delay block group's free space test within allocator

If a block group has a cluster, we don't want to test its free space
when the cluster has taken an unknown amount of free space.  Delay the
free space test after failing to allocate from the cluster and releasing
it.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 05e1386..1de4c47 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5277,15 +5277,6 @@ alloc:
 		if (unlikely(block_group->ro))
 			goto loop;
 
-		spin_lock(&block_group->free_space_ctl->tree_lock);
-		if (cached &&
-		    block_group->free_space_ctl->free_space <
-		    num_bytes + empty_cluster + empty_size) {
-			spin_unlock(&block_group->free_space_ctl->tree_lock);
-			goto loop;
-		}
-		spin_unlock(&block_group->free_space_ctl->tree_lock);
-
 		/*
 		 * Ok we want to try and use the cluster allocator, so
 		 * lets look there
@@ -5323,6 +5314,7 @@ alloc:
 			}
 refill_cluster:
 			BUG_ON(used_block_group != block_group);
+
 			/* If we are on LOOP_NO_EMPTY_SIZE, we can't
 			 * set up a new clusters, so lets just skip it
 			 * and let the allocator find whatever block
@@ -5332,17 +5324,29 @@ refill_cluster:
 			 * anything, so we are likely way too
 			 * fragmented for the clustering stuff to find
 			 * anything.  */
-			if (loop >= LOOP_NO_EMPTY_SIZE) {
+			if (loop >= LOOP_NO_EMPTY_SIZE)
 				spin_unlock(&last_ptr->refill_lock);
-				goto unclustered_alloc;
+			else {
+				/*
+				 * this cluster didn't work out, free
+				 * it and start over
+				 */
+				btrfs_return_cluster_to_free_space(NULL, last_ptr);
 			}
+		}
 
-			/*
-			 * this cluster didn't work out, free it and
-			 * start over
-			 */
-			btrfs_return_cluster_to_free_space(NULL, last_ptr);
+		spin_lock(&block_group->free_space_ctl->tree_lock);
+		if (cached &&
+		    block_group->free_space_ctl->free_space <
+		    num_bytes + empty_cluster + empty_size) {
+			spin_unlock(&block_group->free_space_ctl->tree_lock);
+			if (last_ptr && loop < LOOP_NO_EMPTY_SIZE)
+				spin_unlock(&last_ptr->refill_lock);
+			goto loop;
+		}
+		spin_unlock(&block_group->free_space_ctl->tree_lock);
 
+		if (last_ptr && loop < LOOP_NO_EMPTY_SIZE) {
 			/* allocate a cluster in this block group */
 			ret = btrfs_find_space_cluster(trans, root,
 					       block_group, last_ptr,
@@ -5382,7 +5386,6 @@ refill_cluster:
 			goto loop;
 		}
 
-unclustered_alloc:
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
 		/*
-- 
1.7.4.4


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-Btrfs-test-free-space-only-for-unclustered-allocatio.patch

>From 72c9239effd15c7c921c5265e860a14084e1f13e Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Mon, 12 Dec 2011 04:48:19 -0200
Subject: [PATCH 1/9] Btrfs: test free space only for unclustered allocation

Since the clustered allocation may be taking extents from a different
block group, there's no point in spin-locking and testing the current
block group free space before attempting to allocate space from a
cluster, even more so when we might refrain from even trying the
cluster in the current block group because, after the cluster was set
up, not enough free space remained.  Furthermore, cluster creation
attempts fail fast when the block group doesn't have enough free
space, so the test was completely superfluous.

I've move the free space test past the cluster allocation attempt,
where it is more useful, and arranged for a cluster in the current
block group to be released before trying an unclustered allocation,
when we reach the LOOP_NO_EMPTY_SIZE stage, so that the free space in
the cluster stands a chance of being combined with additional free
space in the block group so as to succeed in the allocation attempt.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 05e1386..26bb9f8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5277,15 +5277,6 @@ alloc:
 		if (unlikely(block_group->ro))
 			goto loop;
 
-		spin_lock(&block_group->free_space_ctl->tree_lock);
-		if (cached &&
-		    block_group->free_space_ctl->free_space <
-		    num_bytes + empty_cluster + empty_size) {
-			spin_unlock(&block_group->free_space_ctl->tree_lock);
-			goto loop;
-		}
-		spin_unlock(&block_group->free_space_ctl->tree_lock);
-
 		/*
 		 * Ok we want to try and use the cluster allocator, so
 		 * lets look there
@@ -5331,8 +5322,15 @@ refill_cluster:
 			 * plenty of times and not have found
 			 * anything, so we are likely way too
 			 * fragmented for the clustering stuff to find
-			 * anything.  */
-			if (loop >= LOOP_NO_EMPTY_SIZE) {
+			 * anything.
+			 *
+			 * However, if the cluster is taken from the
+			 * current block group, release the cluster
+			 * first, so that we stand a better chance of
+			 * succeeding in the unclustered
+			 * allocation.  */
+			if (loop >= LOOP_NO_EMPTY_SIZE &&
+			    last_ptr->block_group != block_group) {
 				spin_unlock(&last_ptr->refill_lock);
 				goto unclustered_alloc;
 			}
@@ -5343,6 +5341,11 @@ refill_cluster:
 			 */
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
 
+			if (loop >= LOOP_NO_EMPTY_SIZE) {
+				spin_unlock(&last_ptr->refill_lock);
+				goto unclustered_alloc;
+			}
+
 			/* allocate a cluster in this block group */
 			ret = btrfs_find_space_cluster(trans, root,
 					       block_group, last_ptr,
@@ -5383,6 +5386,15 @@ refill_cluster:
 		}
 
 unclustered_alloc:
+		spin_lock(&block_group->free_space_ctl->tree_lock);
+		if (cached &&
+		    block_group->free_space_ctl->free_space <
+		    num_bytes + empty_cluster + empty_size) {
+			spin_unlock(&block_group->free_space_ctl->tree_lock);
+			goto loop;
+		}
+		spin_unlock(&block_group->free_space_ctl->tree_lock);
+
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
 		/*
-- 
1.7.4.4


--=-=-=


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
