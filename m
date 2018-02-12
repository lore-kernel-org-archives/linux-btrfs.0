Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753055AbeBLPeg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:34:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFWHMO018204
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:34:35 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2g3daw85dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:34:35 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFYYU5012089
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:34:34 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1CFYYfI024027
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:34:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: verify max_inline mount parameter
Date: Mon, 12 Feb 2018 23:35:46 +0800
Message-Id: <20180212153546.19443-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't verifying the parameter passed to the max_inline mount option,
so we won't report and fail the mount if a junk value is specified for
example, -o max_inline=abc.
This patch converts the max_inline option to %d and checks if it's a
number >= 0.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 383be3609cc9..485e12657bc4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -344,7 +344,7 @@ static const match_table_t tokens = {
 	{Opt_datacow, "datacow"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_barrier, "barrier"},
-	{Opt_max_inline, "max_inline=%s"},
+	{Opt_max_inline, "max_inline=%d"},
 	{Opt_alloc_start, "alloc_start=%s"},
 	{Opt_thread_pool, "thread_pool=%d"},
 	{Opt_compress, "compress"},
@@ -407,7 +407,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags)
 {
 	substring_t args[MAX_OPT_ARGS];
-	char *p, *num;
+	char *p;
 	u64 cache_gen;
 	int intarg;
 	int ret = 0;
@@ -604,22 +604,18 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			}
 			break;
 		case Opt_max_inline:
-			num = match_strdup(&args[0]);
-			if (num) {
-				info->max_inline = memparse(num, NULL);
-				kfree(num);
-
-				if (info->max_inline) {
-					info->max_inline = min_t(u64,
-						info->max_inline,
-						info->sectorsize);
-				}
-				btrfs_info(info, "max_inline at %llu",
-					   info->max_inline);
-			} else {
-				ret = -ENOMEM;
+			ret = match_int(&args[0], &intarg);
+			if (ret) {
+				ret = -EINVAL;
+				goto out;
+			} else if (intarg < 0) {
+				btrfs_err(info, "invalid max_inline=%d\n", intarg);
+				ret = -EINVAL;
 				goto out;
 			}
+			info->max_inline = min_t(u64, intarg, info->sectorsize);
+			btrfs_info(info, "max_inline at %llu",
+				   info->max_inline);
 			break;
 		case Opt_alloc_start:
 			btrfs_info(info,
-- 
2.15.0

