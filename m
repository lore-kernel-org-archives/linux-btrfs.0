Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24418 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3JNFBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:18 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E51HsD006551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:17 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51GKo016608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:17 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51G3e016600
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:16 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 10/13] Btrfs: skip dedup reference during backref walking
Date: Mon, 14 Oct 2013 12:59:52 +0800
Message-Id: <1381726796-27191-11-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dedup ref is quite a special one, it is just used to store the hash value
of the extent and cannot be used to find data, so we skip it during backref
walking.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c    |    9 +++++++++
 fs/btrfs/relocation.c |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0552a59..6ff57d2 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -588,6 +588,9 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.objectid = ref->objectid;
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = ref->offset;
+			if (ref->root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
 					       node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
@@ -706,6 +709,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count, GFP_NOFS);
 			break;
@@ -789,6 +795,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
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
index a5a2632..d9bb01f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3486,6 +3486,9 @@ static int find_data_references(struct reloc_control *rc,
 	ref_offset = btrfs_extent_data_ref_offset(leaf, ref);
 	ref_count = btrfs_extent_data_ref_count(leaf, ref);
 
+	if (ref_root == BTRFS_DEDUP_TREE_OBJECTID)
+		return 0;
+
 	/*
 	 * This is an extent belonging to the free space cache, lets just delete
 	 * it and redo the search.
-- 
1.7.7

