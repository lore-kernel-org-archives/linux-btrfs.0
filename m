Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53120 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933908AbeBMJt3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:49:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D9l7Ip031060
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:28 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2g3w9s070g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1D9nRH6012112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:27 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1D9nRnU014564
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 09:49:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: manage subvolid mount option as %u
Date: Tue, 13 Feb 2018 17:50:43 +0800
Message-Id: <20180213095048.9550-2-anand.jain@oracle.com>
In-Reply-To: <20180213095048.9550-1-anand.jain@oracle.com>
References: <20180213095048.9550-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As -o subvolid mount option is an u64 manage it as %u for
token verifications, instead of %s.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8112619cac95..bf629c8a6a47 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -336,7 +336,7 @@ enum {
 static const match_table_t tokens = {
 	{Opt_degraded, "degraded"},
 	{Opt_subvol, "subvol=%s"},
-	{Opt_subvolid, "subvolid=%s"},
+	{Opt_subvolid, "subvolid=%u"},
 	{Opt_device, "device=%s"},
 	{Opt_nodatasum, "nodatasum"},
 	{Opt_datasum, "datasum"},
@@ -964,8 +964,8 @@ static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *opts, *orig, *p;
-	char *num = NULL;
 	int error = 0;
+	u64 subvolid;
 
 	if (!options)
 		return 0;
@@ -995,18 +995,15 @@ static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
 			}
 			break;
 		case Opt_subvolid:
-			num = match_strdup(&args[0]);
-			if (num) {
-				*subvol_objectid = memparse(num, NULL);
-				kfree(num);
-				/* we want the original fs_tree */
-				if (!*subvol_objectid)
-					*subvol_objectid =
-						BTRFS_FS_TREE_OBJECTID;
-			} else {
-				error = -EINVAL;
+			error = match_u64(&args[0], &subvolid);
+			if (error)
 				goto out;
-			}
+
+			/* we want the original fs_tree */
+			if (subvolid == 0)
+				subvolid = BTRFS_FS_TREE_OBJECTID;
+
+			*subvol_objectid = subvolid;
 			break;
 		case Opt_subvolrootid:
 			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
-- 
2.7.0

