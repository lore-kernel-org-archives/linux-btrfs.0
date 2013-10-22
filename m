Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54984 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3JVQWp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 12:22:45 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id ACB219A06C9
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 10:22:44 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id iCqr8seZkqFbGfDX (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 10:22:43 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add support for the no holes incompat flag
Date: Tue, 22 Oct 2013 12:22:41 -0400
Message-ID: <1382458961-22202-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds the flag to ctree.h, adds the feature option to mkfs to turn it on and
fixes fsck so it doesn't complain about missing hole extents in files when this
flag is set.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c | 14 ++++++++++++--
 ctree.h      |  5 +++--
 mkfs.c       |  2 ++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 668af15..a6047ea 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -50,6 +50,7 @@ static u64 data_bytes_referenced = 0;
 static int found_old_backref = 0;
 static LIST_HEAD(duplicate_extents);
 static int repair = 0;
+static int no_holes = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -443,8 +444,9 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 			rec->errors |= I_ERR_FILE_NBYTES_WRONG;
 		if (rec->extent_start == (u64)-1 || rec->extent_start > 0)
 			rec->first_extent_gap = 0;
-		if (rec->nlink > 0 && (rec->extent_end < rec->isize ||
-		    rec->first_extent_gap < rec->isize))
+		if (rec->nlink > 0 && !no_holes &&
+		    (rec->extent_end < rec->isize ||
+		     rec->first_extent_gap < rec->isize))
 			rec->errors |= I_ERR_FILE_EXTENT_DISCOUNT;
 	}
 
@@ -6155,6 +6157,14 @@ int cmd_check(int argc, char **argv)
 	if (ret)
 		goto out;
 
+	/*
+	 * We used to have to have these hole extents in between our real
+	 * extents so if we don't have this flag set we need to make sure there
+	 * are no gaps in the file extents for inodes, otherwise we can just
+	 * ignore it when this happens.
+	 */
+	no_holes = btrfs_fs_incompat(root->fs_info,
+				     BTRFS_FEATURE_INCOMPAT_NO_HOLES);
 	fprintf(stderr, "checking fs roots\n");
 	ret = check_fs_roots(root, &root_cache);
 	if (ret)
diff --git a/ctree.h b/ctree.h
index 2117374..761987a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -470,7 +470,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
-
+#define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -482,7 +482,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
-	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
+	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
diff --git a/mkfs.c b/mkfs.c
index d576797..770a4c0 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1142,6 +1142,8 @@ static const struct btrfs_fs_feature {
 		"raid56 extended format" },
 	{ "skinny-metadata", BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA,
 		"reduced-size metadata extent refs" },
+	{ "no-holes", BTRFS_FEATURE_INCOMPAT_NO_HOLES,
+		"no explicit hole extents for files" },
 	/* Keep this one last */
 	{ "list-all", BTRFS_FEATURE_LIST_ALL, NULL }
 };
-- 
1.8.3.1

