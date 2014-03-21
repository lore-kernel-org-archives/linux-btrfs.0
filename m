Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:50403 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760292AbaCUBG0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 21:06:26 -0400
Date: Fri, 21 Mar 2014 03:06:23 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs-progs: btrfs-image: don't call pthread_join on IDs
 not present
Message-ID: <20140321010621.GA7219@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If pthread_create fails in mdrestore_init, then number of threads
created could be less then num of threads option. Hence pass number of
successful pthread_create calls to mdrestore_destroy, so that we don't
call pthread_join on IDs not present when pthread_create fails.

metadump_init already had this fixed, but repeats code from
metadump_destroy. Reuse metadump_destroy by passing number of threads
created (successful pthread_create calls) and save repeated cleaup
code. Had to move metadump_destroy before metadump_init for obvious
reasons.

v1->v2 : Fix number of threads being passed to *_destroy from *_init

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 btrfs-image.c | 84 +++++++++++++++++++++++++----------------------------------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 7bcfc06..c0195f1 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -635,6 +635,35 @@ static void meta_cluster_init(struct metadump_struct *md, u64 start)
 			   COMPRESS_ZLIB : COMPRESS_NONE;
 }
 
+static void metadump_destroy(struct metadump_struct *md, int num_threads)
+{
+	int i;
+	struct rb_node *n;
+
+	pthread_mutex_lock(&md->mutex);
+	md->done = 1;
+	pthread_cond_broadcast(&md->cond);
+	pthread_mutex_unlock(&md->mutex);
+
+	for (i = 0; i < num_threads; i++)
+		pthread_join(md->threads[i], NULL);
+
+	pthread_cond_destroy(&md->cond);
+	pthread_mutex_destroy(&md->mutex);
+
+	while ((n = rb_first(&md->name_tree))) {
+		struct name *name;
+
+		name = rb_entry(n, struct name, n);
+		rb_erase(n, &md->name_tree);
+		free(name->val);
+		free(name->sub);
+		free(name);
+	}
+	free(md->threads);
+	free(md->cluster);
+}
+
 static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 			 FILE *out, int num_threads, int compress_level,
 			 int sanitize_names)
@@ -681,53 +710,12 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 			break;
 	}
 
-	if (ret) {
-		pthread_mutex_lock(&md->mutex);
-		md->done = 1;
-		pthread_cond_broadcast(&md->cond);
-		pthread_mutex_unlock(&md->mutex);
-
-		for (i--; i >= 0; i--)
-			pthread_join(md->threads[i], NULL);
-
-		pthread_cond_destroy(&md->cond);
-		pthread_mutex_destroy(&md->mutex);
-		free(md->cluster);
-		free(md->threads);
-	}
+	if (ret)
+		metadump_destroy(md, i + 1);
 
 	return ret;
 }
 
-static void metadump_destroy(struct metadump_struct *md)
-{
-	int i;
-	struct rb_node *n;
-
-	pthread_mutex_lock(&md->mutex);
-	md->done = 1;
-	pthread_cond_broadcast(&md->cond);
-	pthread_mutex_unlock(&md->mutex);
-
-	for (i = 0; i < md->num_threads; i++)
-		pthread_join(md->threads[i], NULL);
-
-	pthread_cond_destroy(&md->cond);
-	pthread_mutex_destroy(&md->mutex);
-
-	while ((n = rb_first(&md->name_tree))) {
-		struct name *name;
-
-		name = rb_entry(n, struct name, n);
-		rb_erase(n, &md->name_tree);
-		free(name->val);
-		free(name->sub);
-		free(name);
-	}
-	free(md->threads);
-	free(md->cluster);
-}
-
 static int write_zero(FILE *out, size_t size)
 {
 	static char zero[BLOCK_SIZE];
@@ -1322,7 +1310,7 @@ out:
 		fprintf(stderr, "Error flushing pending %d\n", ret);
 	}
 
-	metadump_destroy(&metadump);
+	metadump_destroy(&metadump, num_threads);
 
 	btrfs_free_path(path);
 	ret = close_ctree(root);
@@ -1731,7 +1719,7 @@ out:
 	pthread_exit(NULL);
 }
 
-static void mdrestore_destroy(struct mdrestore_struct *mdres)
+static void mdrestore_destroy(struct mdrestore_struct *mdres, int num_threads)
 {
 	struct rb_node *n;
 	int i;
@@ -1748,7 +1736,7 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres)
 	pthread_cond_broadcast(&mdres->cond);
 	pthread_mutex_unlock(&mdres->mutex);
 
-	for (i = 0; i < mdres->num_threads; i++)
+	for (i = 0; i < num_threads; i++)
 		pthread_join(mdres->threads[i], NULL);
 
 	pthread_cond_destroy(&mdres->cond);
@@ -1789,7 +1777,7 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 			break;
 	}
 	if (ret)
-		mdrestore_destroy(mdres);
+		mdrestore_destroy(mdres, i + 1);
 	return ret;
 }
 
@@ -2329,7 +2317,7 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 		}
 	}
 out:
-	mdrestore_destroy(&mdrestore);
+	mdrestore_destroy(&mdrestore, num_threads);
 failed_cluster:
 	free(cluster);
 failed_info:
-- 
1.8.5.3

