Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33326 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab3GXCbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 22:31:04 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6O2UZNM018054
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2013 10:30:35 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 2/3] Btrfs: use u64 for subvolid when parsing mount options
Date: Wed, 24 Jul 2013 10:29:20 +0800
Message-Id: <1374632960-3379-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although for most time, int is enough for subvolid, we should
ensure safety in theory.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index cc00295..d82391d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -327,7 +327,7 @@ enum {
 static match_table_t tokens = {
 	{Opt_degraded, "degraded"},
 	{Opt_subvol, "subvol=%s"},
-	{Opt_subvolid, "subvolid=%d"},
+	{Opt_subvolid, "subvolid=%s"},
 	{Opt_device, "device=%s"},
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_nodatacow, "nodatacow"},
@@ -673,8 +673,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
+	char *num = NULL;
 	int error = 0;
-	int intarg;
 
 	if (!options)
 		return 0;
@@ -704,16 +704,14 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 			}
 			break;
 		case Opt_subvolid:
-			error = match_int(&args[0], &intarg);
-			if (!error) {
-				goto out;
-			} else if (intarg >= 0) {
+			num = match_strdup(&args[0]);
+			if (num) {
+				*subvol_objectid = memparse(num, NULL);
+				kfree(num);
 				/* we want the original fs_tree */
-				if (!intarg)
+				if (!*subvol_objectid)
 					*subvol_objectid =
 						BTRFS_FS_TREE_OBJECTID;
-				else
-					*subvol_objectid = intarg;
 			} else {
 				error = -EINVAL;
 				goto out;
-- 
1.8.0.1

