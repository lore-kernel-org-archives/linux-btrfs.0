Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbcCUHV0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 03:21:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 6/6] btrfs-progs: rename get_subvol_name() to subvol_minus_mnt()
Date: Mon, 21 Mar 2016 15:21:05 +0800
Message-Id: <1458544865-16467-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-send.c | 4 ++--
 utils.c     | 4 ++--
 utils.h     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 7605ed94cd64..339475927837 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -455,7 +455,7 @@ int cmd_send(int argc, char **argv)
 			if (ret < 0)
 				goto out;
 
-			ret = get_root_id(&send, get_subvol_name(send.root_path, subvol),
+			ret = get_root_id(&send, subvol_path_minus_mnt(send.root_path, subvol),
 					&root_id);
 			if (ret < 0) {
 				error("cannot resolve rootid for %s", subvol);
@@ -569,7 +569,7 @@ int cmd_send(int argc, char **argv)
 
 	if (snapshot_parent != NULL) {
 		ret = get_root_id(&send,
-				get_subvol_name(send.root_path, snapshot_parent),
+				subvol_path_minus_mnt(send.root_path, snapshot_parent),
 				&parent_root_id);
 		if (ret < 0) {
 			error("could not resolve rootid for %s", snapshot_parent);
diff --git a/utils.c b/utils.c
index e66314db21ed..965356df15c9 100644
--- a/utils.c
+++ b/utils.c
@@ -3157,7 +3157,7 @@ int test_issubvolume(const char *path)
 	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
 }
 
-char *get_subvol_name(char *mnt, char *full_path)
+char *subvol_path_minus_mnt(char *mnt, char *full_path)
 {
 	int len = strlen(mnt);
 	if (!len)
@@ -3203,7 +3203,7 @@ int get_subvol_info(char *fullpath, struct root_info *get_ri)
 		return 1;
 	}
 	ret = 1;
-	svpath = get_subvol_name(mnt, fullpath);
+	svpath = subvol_path_minus_mnt(mnt, fullpath);
 
 	fd = btrfs_open_dir(fullpath, &dirstream1, 1);
 	if (fd < 0)
diff --git a/utils.h b/utils.h
index 843a1f4faa52..abdd52095854 100644
--- a/utils.h
+++ b/utils.h
@@ -196,7 +196,7 @@ const char* group_profile_str(u64 flags);
 int test_minimum_size(const char *file, u32 leafsize);
 int test_issubvolname(const char *name);
 int test_issubvolume(const char *path);
-char *get_subvol_name(char *mnt, char *full_path);
+char *subvol_path_minus_mnt(char *mnt, char *full_path);
 int get_subvol_info(char *fullpath, struct root_info *get_ri);
 int test_isdir(const char *path);
 
-- 
2.7.0

