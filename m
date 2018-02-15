Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:33726 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161226AbeBOTF2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:28 -0500
Received: by mail-pl0-f67.google.com with SMTP id t4so359080plo.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:28 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 01/27] btrfs-progs: get rid of undocumented qgroup inheritance options
Date: Thu, 15 Feb 2018 11:04:46 -0800
Message-Id: <6085761e0047c1c57c69f2fdd5201a66483df204.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The -c option to subvol create and the -c and -x options to subvol
snapshot have never been documented (and -x doesn't actually work
because it's not in the getopt option string). The functionality is
dubious and the kernel interface is being removed, so get rid of these.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 25 ++-----------------------
 qgroup.c         | 42 ------------------------------------------
 qgroup.h         |  2 --
 3 files changed, 2 insertions(+), 67 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8a473f7a..edcb4f11 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -129,18 +129,11 @@ static int cmd_subvol_create(int argc, char **argv)
 	DIR	*dirstream = NULL;
 
 	while (1) {
-		int c = getopt(argc, argv, "c:i:");
+		int c = getopt(argc, argv, "i:");
 		if (c < 0)
 			break;
 
 		switch (c) {
-		case 'c':
-			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
-			if (res) {
-				retval = res;
-				goto out;
-			}
-			break;
 		case 'i':
 			res = qgroup_inherit_add_group(&inherit, optarg);
 			if (res) {
@@ -662,18 +655,11 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 
 	memset(&args, 0, sizeof(args));
 	while (1) {
-		int c = getopt(argc, argv, "c:i:r");
+		int c = getopt(argc, argv, "i:r");
 		if (c < 0)
 			break;
 
 		switch (c) {
-		case 'c':
-			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
-			if (res) {
-				retval = res;
-				goto out;
-			}
-			break;
 		case 'i':
 			res = qgroup_inherit_add_group(&inherit, optarg);
 			if (res) {
@@ -684,13 +670,6 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 		case 'r':
 			readonly = 1;
 			break;
-		case 'x':
-			res = qgroup_inherit_add_copy(&inherit, optarg, 1);
-			if (res) {
-				retval = res;
-				goto out;
-			}
-			break;
 		default:
 			usage(cmd_subvol_snapshot_usage);
 		}
diff --git a/qgroup.c b/qgroup.c
index b5b893f4..b107a683 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1324,45 +1324,3 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
 
 	return 0;
 }
-
-int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
-			    int type)
-{
-	int ret;
-	u64 qgroup_src;
-	u64 qgroup_dst;
-	char *p;
-	int pos = 0;
-
-	p = strchr(arg, ':');
-	if (!p) {
-bad:
-		error("invalid copy specification, missing separator :");
-		return -EINVAL;
-	}
-	*p = 0;
-	qgroup_src = parse_qgroupid(arg);
-	qgroup_dst = parse_qgroupid(p + 1);
-	*p = ':';
-
-	if (!qgroup_src || !qgroup_dst)
-		goto bad;
-
-	if (*inherit)
-		pos = (*inherit)->num_qgroups +
-		      (*inherit)->num_ref_copies * 2 * type;
-
-	ret = qgroup_inherit_realloc(inherit, 2, pos);
-	if (ret)
-		return ret;
-
-	(*inherit)->qgroups[pos++] = qgroup_src;
-	(*inherit)->qgroups[pos++] = qgroup_dst;
-
-	if (!type)
-		++(*inherit)->num_ref_copies;
-	else
-		++(*inherit)->num_excl_copies;
-
-	return 0;
-}
diff --git a/qgroup.h b/qgroup.h
index 875fbdf3..bb6610d7 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -92,7 +92,5 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
 				int is_descending);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
-int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
-			    int type);
 
 #endif
-- 
2.16.1

