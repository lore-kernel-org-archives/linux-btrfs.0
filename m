Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35582 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3A2Gms (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:42:48 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: [PATCH 04/12] Btrfs-progs: move struct root_info to btrfs-list.h
Date: Tue, 29 Jan 2013 14:48:53 +0800
Message-Id: <1359442141-25498-5-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <1359442141-25498-1-git-send-email-anand.jain@oracle.com>

As we would add more ways to list and manage the subvols
and snapshots, its better if we have struct root_info
defined in the header file.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c | 47 -----------------------------------------------
 btrfs-list.h | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 13a365d..909d814 100644
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
1.8.1.227.g44fe835

