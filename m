From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: add incompat flag for space cache inode
Date: Wed, 27 Oct 2010 14:29:39 -0400
Message-ID: <1288204179-1764-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the incompat flag for the space cache inode stuff.  Eventually
we'll want to turn this feature on at mkfs time, but for now lets let it settle
a bit first.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 ctree.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/ctree.h b/ctree.h
index b79e238..4d0e1e2 100644
--- a/ctree.h
+++ b/ctree.h
@@ -350,13 +350,15 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
-#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(2ULL << 0)
+#define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
+#define BTRFS_FEATURE_INCOMPAT_SPACE_CACHE	(1ULL << 2)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
-#define BTRFS_FEATURE_INCOMPAT_SUPP		\
-	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |	\
-	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)
+#define BTRFS_FEATURE_INCOMPAT_SUPP			\
+	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
+	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
+	 BTRFS_FEATURE_INCOMPAT_SPACE_CACHE)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
-- 
1.6.6.1

