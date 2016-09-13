Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24643 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757225AbcIMNiZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 09:38:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: make wait_for_commit non static
Date: Tue, 13 Sep 2016 21:39:48 +0800
Message-Id: <1473773990-3071-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

wait_for_commit() is needed by encrypt patch set so this patch makes
it non static.

Also as utils.h is included twice deletes one of it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     | 10 ++++++++++
 cmds-subvolume.c | 11 -----------
 utils.h          |  1 +
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 4cc2ed498536..4e67fe28b9b5 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1913,3 +1913,13 @@ int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 	*treeid = args.treeid;
 	return 0;
 }
+
+int wait_for_commit(int fd)
+{
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
+	if (ret < 0)
+		return ret;
+	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
+}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7ef67d3449b..5df7af56c7f8 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -36,7 +36,6 @@
 #include "commands.h"
 #include "utils.h"
 #include "btrfs-list.h"
-#include "utils.h"
 
 static int is_subvolume_cleaned(int fd, u64 subvolid)
 {
@@ -223,16 +222,6 @@ out:
 	return retval;
 }
 
-static int wait_for_commit(int fd)
-{
-	int ret;
-
-	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
-	if (ret < 0)
-		return ret;
-	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
-}
-
 static const char * const cmd_subvol_delete_usage[] = {
 	"btrfs subvolume delete [options] <subvolume> [<subvolume>...]",
 	"Delete subvolume(s)",
diff --git a/utils.h b/utils.h
index da23bfcc9166..729e50a113a2 100644
--- a/utils.h
+++ b/utils.h
@@ -225,6 +225,7 @@ int test_isdir(const char *path);
 
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
 int get_subvol_info(const char *fullpath, struct root_info *get_ri);
+int wait_for_commit(int fd);
 
 /*
  * Btrfs minimum size calculation is complicated, it should include at least:
-- 
2.7.0

