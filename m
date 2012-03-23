From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 1/3] Btrfs: introduce common define for max number of mirrors
Date: Fri, 23 Mar 2012 15:59:08 +0100
Message-ID: <e5806ee1e3375093bf77b6b77eab65b44aedfd0a.1332513438.git.sbehrens@giantdisaster.de>
References: <cover.1332513438.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1332513438.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1332513438.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Readahead already has a define for the max number of mirrors. Scrub
needs such a define now, the rest of the code will need something
like this soon. Therefore the define was added to ctree.h and removed
from the readahead code.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h |    2 ++
 fs/btrfs/reada.c |   10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5e37fd5..cf545b8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -48,6 +48,8 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_MAGIC "_BHRfS_M"
 
+#define BTRFS_MAX_MIRRORS 2
+
 #define BTRFS_MAX_LEVEL 8
 
 #define BTRFS_COMPAT_EXTENT_TREE_V0
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 2373b39..c3c30f1 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -54,7 +54,6 @@
  * than the 2 started one after another.
  */
 
-#define MAX_MIRRORS 2
 #define MAX_IN_FLIGHT 6
 
 struct reada_extctl {
@@ -71,7 +70,7 @@ struct reada_extent {
 	struct list_head	extctl;
 	struct kref		refcnt;
 	spinlock_t		lock;
-	struct reada_zone	*zones[MAX_MIRRORS];
+	struct reada_zone	*zones[BTRFS_MAX_MIRRORS];
 	int			nzones;
 	struct btrfs_device	*scheduled_for;
 };
@@ -84,7 +83,8 @@ struct reada_zone {
 	spinlock_t		lock;
 	int			locked;
 	struct btrfs_device	*device;
-	struct btrfs_device	*devs[MAX_MIRRORS]; /* full list, incl self */
+	struct btrfs_device	*devs[BTRFS_MAX_MIRRORS]; /* full list, incl
+							   * self */
 	int			ndevs;
 	struct kref		refcnt;
 };
@@ -365,9 +365,9 @@ again:
 	if (ret || !bbio || length < blocksize)
 		goto error;
 
-	if (bbio->num_stripes > MAX_MIRRORS) {
+	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
 		printk(KERN_ERR "btrfs readahead: more than %d copies not "
-				"supported", MAX_MIRRORS);
+				"supported", BTRFS_MAX_MIRRORS);
 		goto error;
 	}
 
-- 
1.7.3.4

