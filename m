Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20274 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbcCUHVW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:22 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/6] btrfs-progs: move test_issubvolume() to utils.c
Date: Mon, 21 Mar 2016 15:21:01 +0800
Message-Id: <1458544865-16467-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 27 ---------------------------
 utils.c          | 27 +++++++++++++++++++++++++++
 utils.h          |  1 +
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3953d7c060a2..f62ab9584ce7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -224,33 +224,6 @@ out:
 	return retval;
 }
 
-/*
- * Test if path is a subvolume
- * Returns:
- *   0 - path exists but it is not a subvolume
- *   1 - path exists and it is  a subvolume
- * < 0 - error
- */
-int test_issubvolume(const char *path)
-{
-	struct stat	st;
-	struct statfs stfs;
-	int		res;
-
-	res = stat(path, &st);
-	if (res < 0)
-		return -errno;
-
-	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode))
-		return 0;
-
-	res = statfs(path, &stfs);
-	if (res < 0)
-		return -errno;
-
-	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
-}
-
 static int wait_for_commit(int fd)
 {
 	int ret;
diff --git a/utils.c b/utils.c
index fb549ee923c7..046ddf8eef19 100644
--- a/utils.c
+++ b/utils.c
@@ -3148,3 +3148,30 @@ int test_issubvolname(const char *name)
 	return name[0] != '\0' && !strchr(name, '/') &&
 		strcmp(name, ".") && strcmp(name, "..");
 }
+
+/*
+ * Test if path is a subvolume
+ * Returns:
+ *   0 - path exists but it is not a subvolume
+ *   1 - path exists and it is  a subvolume
+ * < 0 - error
+ */
+int test_issubvolume(const char *path)
+{
+	struct stat	st;
+	struct statfs stfs;
+	int		res;
+
+	res = stat(path, &st);
+	if (res < 0)
+		return -errno;
+
+	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode))
+		return 0;
+
+	res = statfs(path, &stfs);
+	if (res < 0)
+		return -errno;
+
+	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
+}
diff --git a/utils.h b/utils.h
index a4e55bf58914..32bb02005719 100644
--- a/utils.h
+++ b/utils.h
@@ -194,6 +194,7 @@ const char* group_profile_str(u64 flags);
 
 int test_minimum_size(const char *file, u32 leafsize);
 int test_issubvolname(const char *name);
+int test_issubvolume(const char *path);
 int test_isdir(const char *path);
 
 /*
-- 
2.7.0

