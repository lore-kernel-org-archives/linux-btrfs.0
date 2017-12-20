Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44024 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbdLTFTY (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 20 Dec 2017 00:19:24 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com
Subject: [PATCH v2] btrfs-progs: qgroup: Remove support for specifying inherit type
Date: Wed, 20 Dec 2017 13:19:12 +0800
Message-Id: <20171220051912.18147-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since kernel is deprecating the support for specifying inherit type,
remove the support in btrfs-progs too.

Thankfully, the options for qgroup inheritance is hidden and not
documented, so user shouldn't be affected at all.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Remove the "c:" option in getopt(), spotted by Misono.
---
 cmds-subvolume.c | 25 ++-----------------------
 qgroup.c         | 42 ------------------------------------------
 qgroup.h         |  3 ---
 3 files changed, 2 insertions(+), 68 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index dc626a6495e5..f8e34bc842b3 100644
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
@@ -665,18 +658,11 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 
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
@@ -687,13 +673,6 @@ static int cmd_subvol_snapshot(int argc, char **argv)
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
index 156825fd431d..e9158a260251 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1310,45 +1310,3 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
 
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
index 875fbdf37f5f..3fc57123dc2d 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -92,7 +92,4 @@ int btrfs_qgroup_setup_comparer(struct btrfs_qgroup_comparer_set **comp_set,
 				int is_descending);
 int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
 int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
-int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
-			    int type);
-
 #endif
-- 
2.15.1

