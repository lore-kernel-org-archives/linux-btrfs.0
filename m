Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34310 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965235AbaDJDtl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:49:41 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 07/16] Btrfs: skip dedup reference during backref walking
Date: Thu, 10 Apr 2014 11:48:37 +0800
Message-Id: <1397101727-20806-8-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
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
index aad7201..5e57949 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -623,6 +623,9 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.objectid = ref->objectid;
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = ref->offset;
+			if (ref->root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
 					       node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
@@ -743,6 +746,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
 			break;
@@ -826,6 +832,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
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
index def428a..8431294 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3508,6 +3508,9 @@ static int find_data_references(struct reloc_control *rc,
 	ref_offset = btrfs_extent_data_ref_offset(leaf, ref);
 	ref_count = btrfs_extent_data_ref_count(leaf, ref);
 
+	if (ref_root == BTRFS_DEDUP_TREE_OBJECTID)
+		return 0;
+
 	/*
 	 * This is an extent belonging to the free space cache, lets just delete
 	 * it and redo the search.
-- 
1.8.1.4

