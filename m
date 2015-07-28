Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47013 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbbG1KDq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 06:03:46 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com
Subject: [PATCH v2] Btrfs: fix warning in backref walking
Date: Tue, 28 Jul 2015 18:03:30 +0800
Message-Id: <1438077810-5618-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1437984953-453-1-git-send-email-bo.li.liu@oracle.com>
References: <1437984953-453-1-git-send-email-bo.li.liu@oracle.com>
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
v2: Fix typo of not deleting key.type and key.offset, credit goes to Filipe.

 fs/btrfs/backref.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 802fabb..c306414 100644
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
@@ -664,11 +664,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			struct btrfs_delayed_data_ref *ref;
 
 			ref = btrfs_delayed_node_to_data_ref(node);
-
-			key.objectid = ref->objectid;
-			key.type = BTRFS_EXTENT_DATA_KEY;
-			key.offset = ref->offset;
-			ret = __add_prelim_ref(prefs, ref->root, &key, 0,
+			ret = __add_prelim_ref(prefs, 0, NULL, 0,
 					       ref->parent, node->bytenr,
 					       node->ref_mod * sgn, GFP_ATOMIC);
 			break;
-- 
2.1.0

