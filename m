Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35939 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755358AbcJQEiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 00:38:20 -0400
Received: by mail-pa0-f66.google.com with SMTP id os4so4688864pac.3
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Oct 2016 21:38:14 -0700 (PDT)
From: Prasanth K S R <kosigiprasanth@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.com
Cc: Prasanth K S R <prasanth.ksr@dell.com>
Subject: [PATCH V2] Btrfs-progs: subvol_uuid_search: Return error code on memory allocation failure
Date: Mon, 17 Oct 2016 10:07:17 +0530
Message-Id: <1476679037-2485-1-git-send-email-kosigiprasanth@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Prasanth K S R <prasanth.ksr@dell.com>

This commit fixes coverity defect CID 1328695.

Signed-off-by: Prasanth K S R <prasanth.ksr@dell.com>
---
 cmds-receive.c | 10 +++++-----
 cmds-send.c    | 18 +++++++++---------
 send-utils.c   | 22 ++++++++++++++++++----
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index d0525bf..40f64de 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -283,12 +283,12 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
 
 	parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
 			parent_ctransid, NULL, subvol_search_by_received_uuid);
-	if (!parent_subvol) {
+	if (IS_ERR(parent_subvol)) {
 		parent_subvol = subvol_uuid_search(&r->sus, 0, parent_uuid,
 				parent_ctransid, NULL, subvol_search_by_uuid);
 	}
-	if (!parent_subvol) {
-		ret = -ENOENT;
+	if (IS_ERR(parent_subvol)) {
+		ret = PTR_ERR(parent_subvol);
 		error("cannot find parent subvolume");
 		goto out;
 	}
@@ -744,13 +744,13 @@ static int process_clone(const char *path, u64 offset, u64 len,
 
 	si = subvol_uuid_search(&r->sus, 0, clone_uuid, clone_ctransid, NULL,
 			subvol_search_by_received_uuid);
-	if (!si) {
+	if (IS_ERR(si)) {
 		if (memcmp(clone_uuid, r->cur_subvol.received_uuid,
 				BTRFS_UUID_SIZE) == 0) {
 			/* TODO check generation of extent */
 			subvol_path = strdup(r->cur_subvol_path);
 		} else {
-			ret = -ENOENT;
+			ret = PTR_ERR(si);
 			error("clone: did not find source subvol");
 			goto out;
 		}
diff --git a/cmds-send.c b/cmds-send.c
index 74d0128..b773b40 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -68,8 +68,8 @@ static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)
 
 	si = subvol_uuid_search(&s->sus, 0, NULL, 0, path,
 			subvol_search_by_path);
-	if (!si)
-		return -ENOENT;
+	if (IS_ERR(si))
+		return PTR_ERR(si);
 	*root_id = si->root_id;
 	free(si->path);
 	free(si);
@@ -83,8 +83,8 @@ static struct subvol_info *get_parent(struct btrfs_send *s, u64 root_id)
 
 	si_tmp = subvol_uuid_search(&s->sus, root_id, NULL, 0, NULL,
 			subvol_search_by_root_id);
-	if (!si_tmp)
-		return NULL;
+	if (IS_ERR(si_tmp))
+		return si_tmp;
 
 	si = subvol_uuid_search(&s->sus, 0, si_tmp->parent_uuid, 0, NULL,
 			subvol_search_by_uuid);
@@ -104,8 +104,8 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 	int i;
 
 	parent = get_parent(s, root_id);
-	if (!parent) {
-		ret = -ENOENT;
+	if (IS_ERR(parent)) {
+		ret = PTR_ERR(parent);
 		goto out;
 	}
 
@@ -119,7 +119,7 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 
 	for (i = 0; i < s->clone_sources_count; i++) {
 		parent2 = get_parent(s, s->clone_sources[i]);
-		if (!parent2)
+		if (IS_ERR(parent2))
 			continue;
 		if (parent2->root_id != parent->root_id) {
 			free(parent2->path);
@@ -133,8 +133,8 @@ static int find_good_parent(struct btrfs_send *s, u64 root_id, u64 *found)
 		parent2 = subvol_uuid_search(&s->sus, s->clone_sources[i], NULL,
 				0, NULL, subvol_search_by_root_id);
 
-		if (!parent2) {
-			ret = -ENOENT;
+		if (IS_ERR(parent2)) {
+			ret = PTR_ERR(parent2);
 			goto out;
 		}
 		tmp = parent2->ctransid - parent->ctransid;
diff --git a/send-utils.c b/send-utils.c
index a85fa08..87b8559 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -27,6 +27,7 @@
 #include "send-utils.h"
 #include "ioctl.h"
 #include "btrfs-list.h"
+#include "utils.h"
 
 static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
 				      u64 subvol_id);
@@ -474,6 +475,11 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 		goto out;
 
 	info = calloc(1, sizeof(*info));
+	if (!info) {
+		error("Not enough memory");
+		ret = -ENOMEM;
+		goto out;
+	}
 	info->root_id = root_id;
 	memcpy(info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
 	memcpy(info->received_uuid, root_item.received_uuid, BTRFS_UUID_SIZE);
@@ -486,15 +492,23 @@ struct subvol_info *subvol_uuid_search(struct subvol_uuid_search *s,
 		info->path = strdup(path);
 	} else {
 		info->path = malloc(PATH_MAX);
+		if (!info->path) {
+			error("Not enough memory");
+			ret = -ENOMEM;
+			goto out;
+		}
 		ret = btrfs_subvolid_resolve(s->mnt_fd, info->path,
 					     PATH_MAX, root_id);
 	}
 
 out:
-	if (ret && info) {
-		free(info->path);
-		free(info);
-		info = NULL;
+	if (ret) {
+		if (info) {
+			free(info->path);
+			free(info);
+			info = NULL;
+		}
+		return ERR_PTR(ret);
 	}
 
 	return info;
-- 
2.6.6

