Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41813 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaAaQm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 11:42:27 -0500
Received: by mail-pa0-f41.google.com with SMTP id fa1so4631176pad.14
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 08:42:26 -0800 (PST)
Received: from linux-b0ol.localdomain ([36.59.228.44])
        by mx.google.com with ESMTPSA id om6sm29181142pbc.43.2014.01.31.08.42.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jan 2014 08:42:26 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: only add roots if necessary in find_parent_nodes()
Date: Sat,  1 Feb 2014 00:42:05 +0800
Message-Id: <1391186525-2965-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com>
References: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

find_all_leafs() dosen't need add all roots actually, add roots only
if we need, this can avoid unnecessary ulist dance.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 4f59f07..2888f7a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -965,7 +965,7 @@ again:
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
 		WARN_ON(ref->count < 0);
-		if (ref->count && ref->root_id && ref->parent == 0) {
+		if (roots && ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
 			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
 			if (ret < 0)
@@ -1061,22 +1061,14 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
 				u64 time_seq, struct ulist **leafs,
 				const u64 *extent_item_pos)
 {
-	struct ulist *tmp;
 	int ret;
 
-	tmp = ulist_alloc(GFP_NOFS);
-	if (!tmp)
-		return -ENOMEM;
 	*leafs = ulist_alloc(GFP_NOFS);
-	if (!*leafs) {
-		ulist_free(tmp);
+	if (!*leafs)
 		return -ENOMEM;
-	}
 
 	ret = find_parent_nodes(trans, fs_info, bytenr,
-				time_seq, *leafs, tmp, extent_item_pos);
-	ulist_free(tmp);
-
+				time_seq, *leafs, NULL, extent_item_pos);
 	if (ret < 0 && ret != -ENOENT) {
 		free_leaf_list(*leafs);
 		return ret;
-- 
1.8.4

