Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:19337 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2JLFRj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 01:17:39 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9C5HaHG002053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:37 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9C5HZMx014577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:36 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9C5HZF1024732
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 00:17:35 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/4] Btrfs-progs: need struct root_info to be accesible
Date: Fri, 12 Oct 2012 13:20:52 +0800
Message-Id: <1350019254-22036-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |   47 -----------------------------------------------
 btrfs-list.h |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 657e4db..c0407c9 100644
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
index a32545f..bd5e23a 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -17,8 +17,54 @@
  */
 
 #include "kerncompat.h"
+#include "rbtree.h"
 
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

