Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44000 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbeGPOm1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 10:42:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GEENbO192550
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:14:48 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2k7a3jmmb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:14:48 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEEkfj006423
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:14:47 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEEkUf006097
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:14:46 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: rename btrfs_parse_early_options
Date: Mon, 16 Jul 2018 22:18:07 +0800
Message-Id: <20180716141807.18551-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename btrfs_parse_early_options() to btrfs_parse_device_options(). As
btrfs_parse_early_options() parses the -o device options and scan the
device provided. So this rename specifies its action. Also the function
name is inline with btrfs_parse_subvol_options().
No functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9d340f8d3457..9dc56d3eaa66 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -465,9 +465,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_subvolrootid:
 		case Opt_device:
 			/*
-			 * These are parsed by btrfs_parse_subvol_options
-			 * and btrfs_parse_early_options
-			 * and can be happily ignored here.
+			 * These are parsed by btrfs_parse_subvol_options and
+			 * btrfs_parse_device_options and can be happily
+			 * ignored here.
 			 */
 			break;
 		case Opt_nodatasum:
@@ -883,8 +883,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * All other options will be parsed on much later in the mount process and
  * only when we need to allocate a new super block.
  */
-static int btrfs_parse_early_options(const char *options, fmode_t flags,
-				     void *holder)
+static int btrfs_parse_device_options(const char *options, fmode_t flags,
+				      void *holder)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
@@ -951,7 +951,7 @@ static int btrfs_parse_subvol_options(const char *options, char **subvol_name,
 
 	/*
 	 * strsep changes the string, duplicate it because
-	 * btrfs_parse_early_options gets called later
+	 * btrfs_parse_device_options gets called later
 	 */
 	opts = kstrdup(options, GFP_KERNEL);
 	if (!opts)
@@ -1558,7 +1558,7 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	}
 
 	mutex_lock(&uuid_mutex);
-	error = btrfs_parse_early_options(data, mode, fs_type);
+	error = btrfs_parse_device_options(data, mode, fs_type);
 	if (error) {
 		mutex_unlock(&uuid_mutex);
 		goto error_fs_info;
-- 
2.15.0

