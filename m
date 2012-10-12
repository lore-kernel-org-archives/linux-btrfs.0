Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32632 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab2JLFRg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 01:17:36 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9C5HZir031286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:35 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9C5HYcZ014549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:34 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9C5HYOc024723
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 00:17:34 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/4] Btrfs-progs: introduce btrfs_get_subvols function
Date: Fri, 12 Oct 2012 13:20:51 +0800
Message-Id: <1350019254-22036-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Having this not part of btrfs_list_subvols will help
code reuse.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 20da828..657e4db 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1323,6 +1323,26 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
+static int btrfs_get_subvols(int fd, struct root_lookup *root_lookup)
+{
+	int ret;
+
+	ret = __list_subvol_search(fd, root_lookup);
+	if (ret) {
+		fprintf(stderr, "ERROR: can't perform the search - %s\n",
+				strerror(errno));
+		return ret;
+	}
+
+	/*
+	 * now we have an rbtree full of root_info objects, but we need to fill
+	 * in their path names within the subvol that is referencing each one.
+	 */
+	ret = __list_subvol_fill_paths(fd, root_lookup);
+
+	return ret;
+}
+
 static void print_subvolume_column(struct root_info *subv,
 				   enum btrfs_list_column_enum column)
 {
@@ -1471,20 +1491,7 @@ int btrfs_list_subvols(int fd, struct btrfs_list_filter_set *filter_set,
 	struct root_lookup root_sort;
 	int ret;
 
-	ret = __list_subvol_search(fd, &root_lookup);
-	if (ret) {
-		fprintf(stderr, "ERROR: can't perform the search - %s\n",
-				strerror(errno));
-		return ret;
-	}
-
-	/*
-	 * now we have an rbtree full of root_info objects, but we need to fill
-	 * in their path names within the subvol that is referencing each one.
-	 */
-	ret = __list_subvol_fill_paths(fd, &root_lookup);
-	if (ret < 0)
-		return ret;
+	ret = btrfs_get_subvols(fd, &root_lookup);
 
 	__filter_and_sort_subvol(&root_lookup, &root_sort, filter_set,
 				 comp_set, fd);
-- 
1.7.1

