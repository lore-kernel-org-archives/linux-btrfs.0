Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933987AbeBMJtb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:49:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l58K046072
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:30 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2g3tgq8shg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:30 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nToe022767
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:29 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nS3n009868
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: manage metadata_ratio mount option as %u
Date: Tue, 13 Feb 2018 17:50:44 +0800
Message-Id: <20180213095048.9550-3-anand.jain@oracle.com>
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
References: <20180213095048.9550-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As -o metadata_ratio mount option is unsinged so manage it as %u for
token verifications, instead of %s.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bf629c8a6a47..b925a649a01a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -362,7 +362,7 @@ static const match_table_t tokens = {
 	{Opt_norecovery, "norecovery"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_noflushoncommit, "noflushoncommit"},
-	{Opt_ratio, "metadata_ratio=%d"},
+	{Opt_ratio, "metadata_ratio=%u"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
 	{Opt_space_cache, "space_cache"},
@@ -648,16 +648,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			break;
 		case Opt_ratio:
 			ret = match_int(&args[0], &intarg);
-			if (ret) {
-				goto out;
-			} else if (intarg >= 0) {
-				info->metadata_ratio = intarg;
-				btrfs_info(info, "metadata ratio %d",
-					   info->metadata_ratio);
-			} else {
-				ret = -EINVAL;
+			if (ret)
 				goto out;
-			}
+			info->metadata_ratio = intarg;
+			btrfs_info(info, "metadata ratio %u",
+				   info->metadata_ratio);
 			break;
 		case Opt_discard:
 			btrfs_set_and_info(info, DISCARD,
@@ -1369,7 +1364,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 				info->check_integrity_print_mask);
 #endif
 	if (info->metadata_ratio)
-		seq_printf(seq, ",metadata_ratio=%d",
+		seq_printf(seq, ",metadata_ratio=%u",
 				info->metadata_ratio);
 	if (btrfs_test_opt(info, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
-- 
2.7.0

