Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032907AbeBNRKS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 12:10:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1EH76dJ081139
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:10:18 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2g4pseh183-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:10:18 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1EHAHio014853
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:10:17 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1EHAHIZ023942
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 17:10:17 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: verify subvolid mount parameter
Date: Thu, 15 Feb 2018 01:11:37 +0800
Message-Id: <20180214171137.5589-1-anand.jain@oracle.com>
In-Reply-To: <20180213161042.GV3003@twin.jikos.cz>
References: <20180213161042.GV3003@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't verifying the parameter passed to the subvolid mount option,
so we won't report and fail the mount if a junk value is specified for
example, -o subvolid=abc.
This patch verifies the subvolid option with match_u64.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
 Title changed. Old:
   btrfs: manage subvolid mount option with match_u64
 Change log updated.
 keep the %s as token verification.

 fs/btrfs/super.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 10f7d0fbd50f..0333b8802a02 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -976,8 +976,8 @@ static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *opts, *orig, *p;
-	char *num = NULL;
 	int error = 0;
+	u64 subvolid;
 
 	if (!options)
 		return 0;
@@ -1007,18 +1007,15 @@ static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
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
2.15.0

