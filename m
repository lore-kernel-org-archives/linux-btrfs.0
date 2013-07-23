Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3GWFWm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 01:22:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6N5MeQc004290
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 13:22:40 +0800
Message-ID: <51EE12E3.1010801@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 13:21:39 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] Btrfs: use u64 for subvolid when parsing mount options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although for most time, int is enough for subvolid, we should
ensure safety in theory.

Signed-off-by: Wang Shilong<wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie<miaox@cn.fujitsu.com>
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
-- 1.8.0.1

