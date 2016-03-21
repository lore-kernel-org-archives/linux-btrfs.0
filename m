Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbcCUHVX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:23 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 4/6] btrfs-progs: move get_subvol_name() to utils.c
Date: Mon, 21 Mar 2016 15:21:03 +0800
Message-Id: <1458544865-16467-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c | 11 -----------
 utils.c     | 12 ++++++++++++
 utils.h     |  1 +
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 3e34d75bb834..7605ed94cd64 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -335,17 +335,6 @@ out:
 	return ret;
 }
 
-char *get_subvol_name(char *mnt, char *full_path)
-{
-	int len = strlen(mnt);
-	if (!len)
-		return full_path;
-	if (mnt[len - 1] != '/')
-		len += 1;
-
-	return full_path + len;
-}
-
 static int init_root_path(struct btrfs_send *s, const char *subvol)
 {
 	int ret = 0;
diff --git a/utils.c b/utils.c
index 110a4badb764..9aae7df04902 100644
--- a/utils.c
+++ b/utils.c
@@ -3156,3 +3156,15 @@ int test_issubvolume(const char *path)
 
 	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
 }
+
+char *get_subvol_name(char *mnt, char *full_path)
+{
+	int len = strlen(mnt);
+	if (!len)
+		return full_path;
+
+	if (mnt[len - 1] != '/')
+		len += 1;
+
+	return full_path + len;
+}
diff --git a/utils.h b/utils.h
index 32bb02005719..08543ff278ee 100644
--- a/utils.h
+++ b/utils.h
@@ -195,6 +195,7 @@ const char* group_profile_str(u64 flags);
 int test_minimum_size(const char *file, u32 leafsize);
 int test_issubvolname(const char *name);
 int test_issubvolume(const char *path);
+char *get_subvol_name(char *mnt, char *full_path);
 int test_isdir(const char *path);
 
 /*
-- 
2.7.0

