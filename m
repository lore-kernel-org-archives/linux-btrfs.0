Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:57023 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756658AbcG0Rnb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 13:43:31 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/5] Add some helper functions
Date: Wed, 27 Jul 2016 19:43:14 +0200
Message-Id: <1469641398-3879-2-git-send-email-kreijack@libero.it>
In-Reply-To: <1469641398-3879-1-git-send-email-kreijack@libero.it>
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Add the following functions:
- int is_btrfs_fs(const char *path) -> returns 0 if path is a btrfs filesystem
- void check_root_or_exit() -> checks if the user has the root capability or
                               it exits writing an error message
- void check_btrfs_or_exit(const char *path)
				checks if path is a valid btrfs filesystem,
				otherwise it exits

Signed-off-by: Goffredo baroncelli <kreijack@inwind.it>
---
 utils.c | 41 +++++++++++++++++++++++++++++++++++++++++
 utils.h | 14 ++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/utils.c b/utils.c
index 578fdb0..b99706c 100644
--- a/utils.c
+++ b/utils.c
@@ -4131,3 +4131,44 @@ unsigned int rand_range(unsigned int upper)
 	 */
 	return (unsigned int)(jrand48(rand_seed) % upper);
 }
+
+/*
+ * check if path is a btrfs filesystem
+ */
+int is_btrfs_fs(const char *path)
+{
+	struct statfs stfs;
+
+	if (statfs(path, &stfs) != 0) {
+		/* cannot access */
+		return -1;
+	}
+
+	if (stfs.f_type != BTRFS_SUPER_MAGIC) {
+		/* not a btrfs filesystem */
+		return -2;
+	}
+
+	return 0;
+}
+
+/*
+ * check if the user is root
+ */
+void check_root_or_exit()
+{
+    if (geteuid() == 0)
+        return;
+
+    error("You need to be root to execute this command");
+    exit(100);
+}
+
+void check_btrfs_or_exit(const char *path)
+{
+    if (!is_btrfs_fs(path))
+        return;
+
+    error("'%s' must be a valid btrfs filesystem", path);
+    exit(100);
+}
diff --git a/utils.h b/utils.h
index 98bfb34..0bd6ecb 100644
--- a/utils.h
+++ b/utils.h
@@ -399,4 +399,18 @@ unsigned int rand_range(unsigned int upper);
 /* Also allow setting the seed manually */
 void init_rand_seed(u64 seed);
 
+/* return 0 if path is a valid btrfs filesystem */
+int is_btrfs_fs(const char *path);
+
+/*
+ * check if the user has the root capability, otherwise it exits printing an
+ * error message
+ */
+void check_root_or_exit();
+/*
+ * check if path is a valid btrfs filesystem, otherwise it exits printing an
+ * error message
+ */
+void check_btrfs_or_exit(const char *path);
+
 #endif
-- 
2.8.1

