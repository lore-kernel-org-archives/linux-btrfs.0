Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17616 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3L3INZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:25 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 10/14] Btrfs: skip dedup reference during backref walking
Date: Mon, 30 Dec 2013 16:12:50 +0800
Message-Id: <1388391175-29539-11-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dedup ref is quite a special one, it is just used to store the hash value
of the extent and cannot be used to find data, so we skip it during backref
walking.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c    | 9 +++++++++
 fs/btrfs/relocation.c | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3775947..1ec0046 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -590,6 +590,9 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.objectid = ref->objectid;
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = ref->offset;
+			if (ref->root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
 					       node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
@@ -708,6 +711,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
 			break;
@@ -791,6 +797,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
 			break;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 429c73c..a06e448 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3509,6 +3509,9 @@ static int find_data_references(struct reloc_control *rc,
 	ref_offset = btrfs_extent_data_ref_offset(leaf, ref);
 	ref_count = btrfs_extent_data_ref_count(leaf, ref);
 
+	if (ref_root == BTRFS_DEDUP_TREE_OBJECTID)
+		return 0;
+
 	/*
 	 * This is an extent belonging to the free space cache, lets just delete
 	 * it and redo the search.
-- 
1.8.2.1

