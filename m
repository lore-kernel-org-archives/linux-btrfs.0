Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49269 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbbG0IQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 04:16:43 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t6R8GgOT019972
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 08:16:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t6R8Gg3D002790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 08:16:42 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t6R8GFqq005669
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 08:16:35 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix warning in backref walking
Date: Mon, 27 Jul 2015 16:15:53 +0800
Message-Id: <1437984953-453-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we do backref walking, we search firstly in queued delayed refs
and then the on-disk backrefs, but we parse differently for shared
references, for delayed refs we also add 'ref->root' while for on-disk
backrefs we don't, this can prevent us from merging refs indexed
by the same bytenr and cause find_parent_nodes() to throw a warning at
'WARN_ON(ref->count < 0)', for example, when we have a shared data extent
with 'ref_cnt=1' and a delayed shared data with a BTRFS_DROP_DELAYED_REF,
that happens.

For shared references, no matter if it's delayed or on-disk, ref->root is
not at all used, instead it's ref->parent that really matters, so this has
delayed refs handled as the same way as on-disk refs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 802fabb..2485b868 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -632,7 +632,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			struct btrfs_delayed_tree_ref *ref;
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
-			ret = __add_prelim_ref(prefs, ref->root, NULL,
+			ret = __add_prelim_ref(prefs, 0, NULL,
 					       ref->level + 1, ref->parent,
 					       node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
@@ -665,10 +665,9 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 
 			ref = btrfs_delayed_node_to_data_ref(node);
 
-			key.objectid = ref->objectid;
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = ref->offset;
-			ret = __add_prelim_ref(prefs, ref->root, &key, 0,
+			ret = __add_prelim_ref(prefs, 0, NULL, 0,
 					       ref->parent, node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
 			break;
-- 
2.1.0

