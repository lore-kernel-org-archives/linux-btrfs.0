Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55410 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933908AbeBMJtc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:49:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l5I2046060
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:31 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2g3tgq8shm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nUnU022783
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:30 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nTnK009881
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: manage check_int_print_mask mount option as %u
Date: Tue, 13 Feb 2018 17:50:45 +0800
Message-Id: <20180213095048.9550-4-anand.jain@oracle.com>
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
References: <20180213095048.9550-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As -o check_int_print_mask mount option is unsinged so manage it as %u
for token verifications, instead of %d.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b925a649a01a..83e11bbacc17 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -382,7 +382,7 @@ static const match_table_t tokens = {
 	{Opt_skip_balance, "skip_balance"},
 	{Opt_check_integrity, "check_int"},
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
-	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
+	{Opt_check_integrity_print_mask, "check_int_print_mask=%u"},
 	{Opt_rescan_uuid_tree, "rescan_uuid_tree"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
 	{Opt_commit_interval, "commit=%d"},
@@ -747,17 +747,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_check_integrity_print_mask:
 			ret = match_int(&args[0], &intarg);
-			if (ret) {
-				goto out;
-			} else if (intarg >= 0) {
-				info->check_integrity_print_mask = intarg;
-				btrfs_info(info,
-					   "check_integrity_print_mask 0x%x",
-					   info->check_integrity_print_mask);
-			} else {
-				ret = -EINVAL;
+			if (ret)
 				goto out;
-			}
+			info->check_integrity_print_mask = intarg;
+			btrfs_info(info, "check_integrity_print_mask 0x%x",
+				   info->check_integrity_print_mask);
 			break;
 #else
 		case Opt_check_integrity_including_extent_data:
-- 
2.7.0

