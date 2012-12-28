Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37549 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2L1DG4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:56 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36tBa010128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:55 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36sjK017764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:55 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36s2q007479
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:54 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] Btrfs-progs: move struct root_info to btrfs-list.h
Date: Fri, 28 Dec 2012 11:12:58 +0800
Message-Id: <1356664382-24423-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   47 -----------------------------------------------
 btrfs-list.h |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index cc065e9..1851f3e 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -46,53 +46,6 @@ struct root_lookup {
 	struct rb_root root;
 };
 
-/*
- * one of these for each root we find.
- */
-struct root_info {
-	struct rb_node rb_node;
-	struct rb_node sort_node;
-
-	/* this root's id */
-	u64 root_id;
-
-	/* equal the offset of the root's key */
-	u64 root_offset;
-
-	/* flags of the root */
-	u64 flags;
-
-	/* the id of the root that references this one */
-	u64 ref_tree;
-
-	/* the dir id we're in from ref_tree */
-	u64 dir_id;
-
-	u64 top_id;
-
-	/* generation when the root is created or last updated */
-	u64 gen;
-
-	/* creation generation of this root in sec*/
-	u64 ogen;
-
-	/* creation time of this root in sec*/
-	time_t otime;
-
-	u8 uuid[BTRFS_UUID_SIZE];
-	u8 puuid[BTRFS_UUID_SIZE];
-
-	/* path from the subvol we live in to this root, including the
-	 * root's name.  This is null until we do the extra lookup ioctl.
-	 */
-	char *path;
-
-	/* the name of this root in the directory it lives in */
-	char *name;
-
-	char *full_path;
-};
-
 struct {
 	char	*name;
 	char	*column_name;
diff --git a/btrfs-list.h b/btrfs-list.h
index 855e73d..3b7b680 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -18,7 +18,52 @@
 
 #include "kerncompat.h"
 
-struct root_info;
+/*
+ * one of these for each root we find.
+ */
+struct root_info {
+	struct rb_node rb_node;
+	struct rb_node sort_node;
+
+	/* this root's id */
+	u64 root_id;
+
+	/* equal the offset of the root's key */
+	u64 root_offset;
+
+	/* flags of the root */
+	u64 flags;
+
+	/* the id of the root that references this one */
+	u64 ref_tree;
+
+	/* the dir id we're in from ref_tree */
+	u64 dir_id;
+
+	u64 top_id;
+
+	/* generation when the root is created or last updated */
+	u64 gen;
+
+	/* creation generation of this root in sec*/
+	u64 ogen;
+
+	/* creation time of this root in sec*/
+	time_t otime;
+
+	u8 uuid[BTRFS_UUID_SIZE];
+	u8 puuid[BTRFS_UUID_SIZE];
+
+	/* path from the subvol we live in to this root, including the
+	 * root's name.  This is null until we do the extra lookup ioctl.
+	 */
+	char *path;
+
+	/* the name of this root in the directory it lives in */
+	char *name;
+
+	char *full_path;
+};
 
 typedef int (*btrfs_list_filter_func)(struct root_info *, u64);
 typedef int (*btrfs_list_comp_func)(struct root_info *, struct root_info *,
-- 
1.7.1

