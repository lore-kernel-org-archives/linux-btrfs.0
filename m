Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33942 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755575AbcLOIkM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 03:40:12 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: t-itoh@jp.fujitsu.com
Subject: [PATCH v2] btrfs-progs: Fix NULL pointer when receive clone operation
Date: Thu, 15 Dec 2016 16:37:02 +0800
Message-Id: <20161215083702.25732-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regression introduced by:
commit a2f7af94abe4a3491ca1280a2ae1d63edc0d62ab
Author: Prasanth K S R <prasanth.ksr@dell.com>
Date:   Sat Dec 10 19:17:43 2016 +0530

    btrfs-progs: subvol_uuid_search: return error encoded pointer

IS_ERR() will only check if it's an error code, won't check if it's
NULL.
And for all the caller the commit modifies, it can return NULL and makes
cause segfault.

Fix it by introducing new IS_ERR_OR_NULL() macro, and for NULL pointer
and needs to return int case, convert NULL pointer to -ENOENT.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-receive.c | 16 +++++++++++-----
 cmds-send.c    | 26 ++++++++++++++++++--------
 kerncompat.h   |  7 ++++++-
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index cb42aa2..166d37d 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -287,13 +287,16 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	parent_subvol = subvol_uuid_search(&rctx->sus, 0, parent_uuid,
 					   parent_ctransid, NULL,
 					   subvol_search_by_received_uuid);
-	if (IS_ERR(parent_subvol)) {
+	if (IS_ERR_OR_NULL(parent_subvol)) {
 		parent_subvol = subvol_uuid_search(&rctx->sus, 0, parent_uuid,
 						   parent_ctransid, NULL,
 						   subvol_search_by_uuid);
 	}
-	if (IS_ERR(parent_subvol)) {
-		ret = PTR_ERR(parent_subvol);
+	if (IS_ERR_OR_NULL(parent_subvol)) {
+		if (!parent_subvol)
+			ret = -ENOENT;
+		else
+			ret = PTR_ERR(parent_subvol);
 		error("cannot find parent subvolume");
 		goto out;
 	}
@@ -750,13 +753,16 @@ static int process_clone(const char *path, u64 offset, u64 len,
 	si = subvol_uuid_search(&rctx->sus, 0, clone_uuid, clone_ctransid,
 				NULL,
 				subvol_search_by_received_uuid);
-	if (IS_ERR(si)) {
+	if (IS_ERR_OR_NULL(si)) {
 		if (memcmp(clone_uuid, rctx->cur_subvol.received_uuid,
 				BTRFS_UUID_SIZE) == 0) {
 			/* TODO check generation of extent */
 			subvol_path = strdup(rctx->cur_subvol_path);
 		} else {
-			ret = PTR_ERR(si);
+			if (!si)
+				ret = -ENOENT;
+			else
+				ret = PTR_ERR(si);
 			error("clone: did not find source subvol");
 			goto out;
 		}
diff --git a/cmds-send.c b/cmds-send.c
index 5da64d8..cec11e6 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -70,8 +70,12 @@ static int get_root_id(struct btrfs_send *sctx, const char *path, u64 *root_id)
 
 	si = subvol_uuid_search(&sctx->sus, 0, NULL, 0, path,
 			subvol_search_by_path);
-	if (IS_ERR(si))
-		return PTR_ERR(si);
+	if (IS_ERR_OR_NULL(si)) {
+		if (!si)
+			return -ENOENT;
+		else
+			return PTR_ERR(si);
+	}
 	*root_id = si->root_id;
 	free(si->path);
 	free(si);
@@ -85,7 +89,7 @@ static struct subvol_info *get_parent(struct btrfs_send *sctx, u64 root_id)
 
 	si_tmp = subvol_uuid_search(&sctx->sus, root_id, NULL, 0, NULL,
 			subvol_search_by_root_id);
-	if (IS_ERR(si_tmp))
+	if (IS_ERR_OR_NULL(si_tmp))
 		return si_tmp;
 
 	si = subvol_uuid_search(&sctx->sus, 0, si_tmp->parent_uuid, 0, NULL,
@@ -105,8 +109,11 @@ static int find_good_parent(struct btrfs_send *sctx, u64 root_id, u64 *found)
 	int i;
 
 	parent = get_parent(sctx, root_id);
-	if (IS_ERR(parent)) {
-		ret = PTR_ERR(parent);
+	if (IS_ERR_OR_NULL(parent)) {
+		if (!parent)
+			ret = -ENOENT;
+		else
+			ret = PTR_ERR(parent);
 		goto out;
 	}
 
@@ -122,7 +129,7 @@ static int find_good_parent(struct btrfs_send *sctx, u64 root_id, u64 *found)
 		s64 tmp;
 
 		parent2 = get_parent(sctx, sctx->clone_sources[i]);
-		if (IS_ERR(parent2))
+		if (IS_ERR_OR_NULL(parent2))
 			continue;
 		if (parent2->root_id != parent->root_id) {
 			free(parent2->path);
@@ -136,8 +143,11 @@ static int find_good_parent(struct btrfs_send *sctx, u64 root_id, u64 *found)
 		parent2 = subvol_uuid_search(&sctx->sus,
 				sctx->clone_sources[i], NULL, 0, NULL,
 				subvol_search_by_root_id);
-		if (IS_ERR(parent2)) {
-			ret = PTR_ERR(parent2);
+		if (IS_ERR_OR_NULL(parent2)) {
+			if (!parent2)
+				ret = -ENOENT;
+			else
+				ret = PTR_ERR(parent2);
 			goto out;
 		}
 		tmp = parent2->ctransid - parent->ctransid;
diff --git a/kerncompat.h b/kerncompat.h
index e374614..19ed3fc 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -244,11 +244,16 @@ static inline long PTR_ERR(const void *ptr)
 	return (long) ptr;
 }
 
-static inline long IS_ERR(const void *ptr)
+static inline int IS_ERR(const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+static inline int IS_ERR_OR_NULL(const void *ptr)
+{
+	return !ptr || IS_ERR(ptr);
+}
+
 /*
  * This looks more complex than it should be. But we need to
  * get the type for the ~ right in round_down (it needs to be
-- 
2.10.2



