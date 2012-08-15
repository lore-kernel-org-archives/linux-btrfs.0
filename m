Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48079 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2HOI2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 04:28:46 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7F8Si5T018900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 08:28:44 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7F8ShHG028789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 08:28:43 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7F8Shg6021073
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 03:28:43 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] Btrfs-progs: seg fault in get_label_unmounted
Date: Wed, 15 Aug 2012 16:29:53 +0800
Message-Id: <1345019393-6168-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

btrfs f l /
No valid Btrfs found on /
Segmentation fault (core dumped)

open_ctree can return NULL, we need to check that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfslabel.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/btrfslabel.c b/btrfslabel.c
index bf73802..cb142b0 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -67,7 +67,7 @@ static void change_label_unmounted(char *dev, char *nLabel)
        close_ctree(root);
 }
 
-static void get_label_unmounted(char *dev)
+int get_label_unmounted(char *dev)
 {
        struct btrfs_root *root;
 
@@ -76,10 +76,14 @@ static void get_label_unmounted(char *dev)
         */
        root = open_ctree(dev, 0, 0);
 
+       if(!root)
+         return -1;
+
        fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
 
        /* Now we close it since we are done. */
        close_ctree(root);
+       return 0;
 }
 
 int get_label(char *btrfs_dev)
@@ -98,8 +102,8 @@ int get_label(char *btrfs_dev)
 	       fprintf(stderr, "FATAL: the filesystem has to be unmounted\n");
 	       return -2;
 	}
-	get_label_unmounted(btrfs_dev);
-	return 0;
+	ret = get_label_unmounted(btrfs_dev);
+	return ret;
 }
 
 
-- 
1.7.1

