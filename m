Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49320 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2I1Mxn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 08:53:43 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8SCrfiS022484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 12:53:41 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8SCreXt010868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 12:53:41 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8SCreJO000501
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 07:53:40 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: end user may like full path for the subvol list display
Date: Fri, 28 Sep 2012 20:56:33 +0800
Message-Id: <1348836993-19573-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c     |   10 +++++-----
 cmds-subvolume.c |   12 +++++++++---
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index c53d016..9191b7c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -719,7 +719,7 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent, int get_default)
+int list_subvols(int fd, int print_parent, int get_default, char *mntp)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
@@ -779,14 +779,14 @@ int list_subvols(int fd, int print_parent, int get_default)
 
 		resolve_root(&root_lookup, entry, &parent_id, &level, &path);
 		if (print_parent) {
-			printf("ID %llu parent %llu top level %llu path %s\n",
+			printf("ID %llu parent %llu top level %llu path %s/%s\n",
 				(unsigned long long)entry->root_id,
 				(unsigned long long)parent_id,
-				(unsigned long long)level, path);
+				(unsigned long long)level, mntp, path);
 		} else {
-			printf("ID %llu top level %llu path %s\n",
+			printf("ID %llu top level %llu path %s/%s\n",
 				(unsigned long long)entry->root_id,
-				(unsigned long long)level, path);
+				(unsigned long long)level, mntp, path);
 		}
 
 		free(path);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f4aa80f..0725d2d 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -31,7 +31,7 @@
 #include "commands.h"
 
 /* btrfs-list.c */
-int list_subvols(int fd, int print_parent, int get_default);
+int list_subvols(int fd, int print_parent, int get_default, char *mntp);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 
 static const char * const subvolume_cmd_group_usage[] = {
@@ -274,6 +274,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	int ret;
 	int print_parent = 0;
 	char *subvol;
+	char *mntp = NULL;
 
 	optind = 1;
 	while(1) {
@@ -310,7 +311,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, print_parent, 0);
+	find_mount_root(subvol, &mntp);
+	ret = list_subvols(fd, print_parent, 0, mntp);
+	free(mntp);
 	if (ret)
 		return 19;
 	return 0;
@@ -470,6 +473,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 	int fd;
 	int ret;
 	char *subvol;
+	char *mntp = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_subvol_get_default_usage);
@@ -491,7 +495,9 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, 0, 1);
+	find_mount_root(subvol, &mntp);
+	ret = list_subvols(fd, 0, 1, mntp);
+	free(mntp);
 	if (ret)
 		return 19;
 	return 0;
-- 
1.7.1

