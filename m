Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33601 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbcLJNsU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Dec 2016 08:48:20 -0500
Received: by mail-pg0-f68.google.com with SMTP id 3so5387298pgd.0
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Dec 2016 05:48:20 -0800 (PST)
From: Prasanth K S R <kosigiprasanth@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Prasanth K S R <prasanth.ksr@dell.com>, dsterba@suse.com
Subject: [PATCH 2/3] Btrfs-progs: subvol_uuid_search: Return error encoded pointer
Date: Sat, 10 Dec 2016 19:17:43 +0530
Message-Id: <20161210134744.10825-2-kosigiprasanth@gmail.com>
In-Reply-To: <20161210134744.10825-1-kosigiprasanth@gmail.com>
References: <20161210134744.10825-1-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Prasanth K S R <prasanth.ksr@dell.com>

This commit changes subvol_uuid_search() to return an error encoded
pointer on failure.

Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>
---
 cmds-receive.c | 10 +++++-----
 cmds-send.c    | 19 +++++++++----------
 send-utils.c   |  2 +-
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 6f54c2e..cb42aa2 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -287,13 +287,13 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 	parent_subvol = subvol_uuid_search(&rctx->sus, 0, parent_uuid,
 					   parent_ctransid, NULL,
 					   subvol_search_by_received_uuid);
-	if (!parent_subvol) {
+	if (IS_ERR(parent_subvol)) {
 		parent_subvol = subvol_uuid_search(&rctx->sus, 0, parent_uuid,
 						   parent_ctransid, NULL,
 						   subvol_search_by_uuid);
 	}
-	if (!parent_subvol) {
-		ret = -ENOENT;
+	if (IS_ERR(parent_subvol)) {
+		ret = PTR_ERR(parent_subvol);
 		error("cannot find parent subvolume");
 		goto out;
 	}
@@ -750,13 +750,13 @@ static int process_clone(const char *path, u64 offset, u64 len,
 	si = subvol_uuid_search(&rctx->sus, 0, clone_uuid, clone_ctransid,
 				NULL,
 				subvol_search_by_received_uuid);
-	if (!si) {
+	if (IS_ERR(si)) {
 		if (memcmp(clone_uuid, rctx->cur_subvol.received_uuid,
 				BTRFS_UUID_SIZE) == 0) {
 			/* TODO check generation of extent */
 			subvol_path = strdup(rctx->cur_subvol_path);
 		} else {
-			ret = -ENOENT;
+			ret = PTR_ERR(si);
 			error("clone: did not find source subvol");
 			goto out;
 		}
diff --git a/cmds-send.c b/cmds-send.c
index a4fb126..5da64d8 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -70,8 +70,8 @@ static int get_root_id(struct btrfs_send *sctx, const char *path, u64 *root_id)
 
 	si = subvol_uuid_search(&sctx->sus, 0, NULL, 0, path,
 			subvol_search_by_path);
-	if (!si)
-		return -ENOENT;
+	if (IS_ERR(si))
+		return PTR_ERR(si);
 	*root_id = si->root_id;
 	free(si->path);
 	free(si);
@@ -85,8 +85,8 @@ static struct subvol_info *get_parent(struct btrfs_send *sctx, u64 root_id)
 
 	si_tmp = subvol_uuid_search(&sctx->sus, root_id, NULL, 0, NULL,
 			subvol_search_by_root_id);
-	if (!si_tmp)
-		return NULL;
+	if (IS_ERR(si_tmp))
+		return si_tmp;
 
 	si = subvol_uuid_search(&sctx->sus, 0, si_tmp->parent_uuid, 0, NULL,
 			subvol_search_by_uuid);
@@ -105,8 +105,8 @@ static int find_good_parent(struct btrfs_send *sctx, u64 root_id, u64 *found)
 	int i;
 
 	parent = get_parent(sctx, root_id);
-	if (!parent) {
-		ret = -ENOENT;
+	if (IS_ERR(parent)) {
+		ret = PTR_ERR(parent);
 		goto out;
 	}
 
@@ -122,7 +122,7 @@ static int find_good_parent(struct btrfs_send *sctx, u64 root_id, u64 *found)
 		s64 tmp;
 
 		parent2 = get_parent(sctx, sctx->clone_sources[i]);
-		if (!parent2)
+		if (IS_ERR(parent2))
 			continue;
 		if (parent2->root_id != parent->root_id) {
 			free(parent2->path);
@@ -136,9 +136,8 @@ static int find_good_parent(struct btrfs_send *sctx, u64 root_id, u64 *found)
 		parent2 = subvol_uuid_search(&sctx->sus,
 				sctx->clone_sources[i], NULL, 0, NULL,
 				subvol_search_by_root_id);
-
-		if (!parent2) {
-			ret = -ENOENT;
+		if (IS_ERR(parent2)) {
+			ret = PTR_ERR(parent2);
 			goto out;
 		}
 		tmp = parent2->ctransid - parent->ctransid;
diff --git a/send-utils.c b/send-utils.c
index 5026882..252ca6d 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -498,7 +498,7 @@ out:
 	if (ret && info) {
 		free(info->path);
 		free(info);
-		info = NULL;
+		return ERR_PTR(ret);
 	}
 
 	return info;
-- 
2.10.2

