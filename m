Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20420 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2HaFin (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:38:43 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5cfuO025962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:42 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5cffu018312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:41 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5cfEk027899
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:38:41 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: fix a bug in parsing return value in logical resolve
Date: Fri, 31 Aug 2012 13:36:57 +0800
Message-Id: <1346391419-4278-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
References: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liub.liubo@gmail.com>

In logical resolve, we parse extent_from_logical()'s 'ret' as a kind of flag.

It is possible to lose our errors because
(-EXXXX & BTRFS_EXTENT_FLAG_TREE_BLOCK) is true.

I'm not sure if it is on purpose, it just looks too hacky if it is.
I'd rather use a real flag and a 'ret' to catch errors.

Acked-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Liu Bo <liub.liubo@gmail.com>
---
 fs/btrfs/backref.c |   24 ++++++++++++++++--------
 fs/btrfs/backref.h |    3 ++-
 fs/btrfs/ioctl.c   |    6 ++++--
 fs/btrfs/scrub.c   |   14 ++++++++------
 fs/btrfs/send.c    |    7 ++++---
 5 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index ff6475f..4e80ba3 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1193,7 +1193,8 @@ char *btrfs_iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
  * tree blocks and <0 on error.
  */
 int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
-			struct btrfs_path *path, struct btrfs_key *found_key)
+			struct btrfs_path *path, struct btrfs_key *found_key,
+			u64 *flags_ret)
 {
 	int ret;
 	u64 flags;
@@ -1237,10 +1238,17 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 		 (unsigned long long)found_key->objectid,
 		 (unsigned long long)found_key->offset,
 		 (unsigned long long)flags, item_size);
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
-		return BTRFS_EXTENT_FLAG_TREE_BLOCK;
-	if (flags & BTRFS_EXTENT_FLAG_DATA)
-		return BTRFS_EXTENT_FLAG_DATA;
+
+	WARN_ON(!flags_ret);
+	if (flags_ret) {
+		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+			*flags_ret = BTRFS_EXTENT_FLAG_TREE_BLOCK;
+		else if (flags & BTRFS_EXTENT_FLAG_DATA)
+			*flags_ret = BTRFS_EXTENT_FLAG_DATA;
+		else
+			BUG_ON(1);
+		return 0;
+	}
 
 	return -EIO;
 }
@@ -1432,15 +1440,15 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 {
 	int ret;
 	u64 extent_item_pos;
+	u64 flags = 0;
 	struct btrfs_key found_key;
 	int search_commit_root = path->search_commit_root;
 
-	ret = extent_from_logical(fs_info, logical, path,
-					&found_key);
+	ret = extent_from_logical(fs_info, logical, path, &found_key, &flags);
 	btrfs_release_path(path);
 	if (ret < 0)
 		return ret;
-	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		return -EINVAL;
 
 	extent_item_pos = logical - found_key.objectid;
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 032f4dc..4fda5d8 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -40,7 +40,8 @@ int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
 			struct btrfs_path *path);
 
 int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
-			struct btrfs_path *path, struct btrfs_key *found_key);
+			struct btrfs_path *path, struct btrfs_key *found_key,
+			u64 *flags);
 
 int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
 				struct btrfs_extent_item *ei, u32 item_size,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7390b25..123ffee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3217,6 +3217,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 	int ret = 0;
 	int size;
 	u64 extent_item_pos;
+	u64 flags = 0;
 	struct btrfs_ioctl_logical_ino_args *loi;
 	struct btrfs_data_container *inodes = NULL;
 	struct btrfs_path *path = NULL;
@@ -3246,10 +3247,11 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 		goto out;
 	}
 
-	ret = extent_from_logical(root->fs_info, loi->logical, path, &key);
+	ret = extent_from_logical(root->fs_info, loi->logical, path, &key,
+				  &flags);
 	btrfs_release_path(path);
 
-	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		ret = -ENOENT;
 	if (ret < 0)
 		goto out;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b223620..5def223 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -352,13 +352,14 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	struct extent_buffer *eb;
 	struct btrfs_extent_item *ei;
 	struct scrub_warning swarn;
-	u32 item_size;
-	int ret;
+	unsigned long ptr = 0;
+	u64 extent_item_pos;
+	u64 flags = 0;
 	u64 ref_root;
+	u32 item_size;
 	u8 ref_level;
-	unsigned long ptr = 0;
 	const int bufsize = 4096;
-	u64 extent_item_pos;
+	int ret;
 
 	path = btrfs_alloc_path();
 
@@ -375,7 +376,8 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	if (!path || !swarn.scratch_buf || !swarn.msg_buf)
 		goto out;
 
-	ret = extent_from_logical(fs_info, swarn.logical, path, &found_key);
+	ret = extent_from_logical(fs_info, swarn.logical, path, &found_key,
+				  &flags);
 	if (ret < 0)
 		goto out;
 
@@ -387,7 +389,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	item_size = btrfs_item_size_nr(eb, path->slots[0]);
 	btrfs_release_path(path);
 
-	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		do {
 			ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
 							&ref_root, &ref_level);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fb5ffe9..7186ae8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1143,6 +1143,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	u64 logical;
 	u64 num_bytes;
 	u64 extent_item_pos;
+	u64 flags = 0;
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *eb = path->nodes[0];
 	struct backref_ctx backref_ctx;
@@ -1181,13 +1182,13 @@ static int find_extent_clone(struct send_ctx *sctx,
 	}
 	logical += btrfs_file_extent_offset(eb, fi);
 
-	ret = extent_from_logical(sctx->send_root->fs_info,
-			logical, tmp_path, &found_key);
+	ret = extent_from_logical(sctx->send_root->fs_info, logical, tmp_path,
+				  &found_key, &flags);
 	btrfs_release_path(tmp_path);
 
 	if (ret < 0)
 		goto out;
-	if (ret & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		ret = -EIO;
 		goto out;
 	}
-- 
1.7.7.6

