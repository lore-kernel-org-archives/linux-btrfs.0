Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934420AbeBMJs2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:48:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l5Fv013434
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:27 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2g3wh282re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:27 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9mQA0008303
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:26 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1D9mQIF005003
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:48:26 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: verify max_inline mount parameter
Date: Tue, 13 Feb 2018 17:49:50 +0800
Message-Id: <20180213094950.9412-2-anand.jain@oracle.com>
In-Reply-To: <20180213094950.9412-1-anand.jain@oracle.com>
References: <20180213094950.9412-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't verifying the parameter passed to the max_inline mount option,
so we won't report and fail the mount if a junk value is specified for
example, -o max_inline=abc.
This patch converts the max_inline option to %d and checks if it's a
number >= 0.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: use match_int ret value if error
        use %u instead of %d for parser

 fs/btrfs/super.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b13d68506f15..02c7766e6849 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -344,7 +344,7 @@ static const match_table_t tokens = {
 	{Opt_datacow, "datacow"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_barrier, "barrier"},
-	{Opt_max_inline, "max_inline=%s"},
+	{Opt_max_inline, "max_inline=%u"},
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
@@ -604,22 +604,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			}
 			break;
 		case Opt_max_inline:
-			num = match_strdup(&args[0]);
-			if (num) {
-				info->max_inline = memparse(num, NULL);
-				kfree(num);
-
-				if (info->max_inline) {
-					info->max_inline = min_t(u32,
-						info->max_inline,
-						info->sectorsize);
-				}
-				btrfs_info(info, "max_inline at %u",
-					   info->max_inline);
-			} else {
-				ret = -ENOMEM;
+			ret = match_int(&args[0], &intarg);
+			if (ret)
 				goto out;
-			}
+			info->max_inline = min_t(u32, intarg, info->sectorsize);
+			btrfs_info(info, "max_inline at %u", info->max_inline);
 			break;
 		case Opt_alloc_start:
 			btrfs_info(info,
-- 
2.7.0

