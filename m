Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48882 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751542AbeCUIpS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 04:45:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6BA2FAE32
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:45:17 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/8] btrfs: Introduce init_delayed_ref_head
Date: Wed, 21 Mar 2018 10:45:10 +0200
Message-Id: <1521621912-25065-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1521621912-25065-1-git-send-email-nborisov@suse.com>
References: <1521621912-25065-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

add_delayed_ref_head implements the logic to both initialize a head_ref
structure as well as perform the necessary operations to add it to the
delayed ref machinery. This has resulted in a very cumebrsome interface
with loads of parameters and code, which at first glance, looks very
unwieldy. Begin untangling it by first extracting the initialization
only code in its own function. It's more or less verbatim copy of the
first part of add_delayed_ref_head.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8d8a86784fd1..47b1a534f95f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -542,6 +542,74 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 	spin_unlock(&existing->lock);
 }
 
+
+static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+				  struct btrfs_qgroup_extent_record *qrecord,
+				  u64 bytenr, u64 num_bytes, u64 ref_root,
+				  u64 reserved, int action, bool is_data)
+{
+
+	int count_mod = 1;
+	int must_insert_reserved = 0;
+
+	/* If reserved is provided, it must be a data extent. */
+	BUG_ON(!is_data && reserved);
+
+	/*
+	 * the head node stores the sum of all the mods, so dropping a ref
+	 * should drop the sum in the head node by one.
+	 */
+	if (action == BTRFS_UPDATE_DELAYED_HEAD)
+		count_mod = 0;
+	else if (action == BTRFS_DROP_DELAYED_REF)
+		count_mod = -1;
+
+	/*
+	 * BTRFS_ADD_DELAYED_EXTENT means that we need to update
+	 * the reserved accounting when the extent is finally added, or
+	 * if a later modification deletes the delayed ref without ever
+	 * inserting the extent into the extent allocation tree.
+	 * ref->must_insert_reserved is the flag used to record
+	 * that accounting mods are required.
+	 *
+	 * Once we record must_insert_reserved, switch the action to
+	 * BTRFS_ADD_DELAYED_REF because other special casing is not required.
+	 */
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
+		must_insert_reserved = 1;
+	else
+		must_insert_reserved = 0;
+
+
+	refcount_set(&head_ref->refs, 1);
+	head_ref->bytenr = bytenr;
+	head_ref->num_bytes = num_bytes;
+	head_ref->ref_mod = count_mod;
+	head_ref->must_insert_reserved = must_insert_reserved;
+	head_ref->is_data = is_data;
+	head_ref->ref_tree = RB_ROOT;
+	INIT_LIST_HEAD(&head_ref->ref_add_list);
+	RB_CLEAR_NODE(&head_ref->href_node);
+	head_ref->processing = 0;
+	head_ref->total_ref_mod = count_mod;
+	head_ref->qgroup_reserved = 0;
+	head_ref->qgroup_ref_root = 0;
+	spin_lock_init(&head_ref->lock);
+	mutex_init(&head_ref->mutex);
+
+
+	if (qrecord) {
+		if (ref_root && reserved) {
+			head_ref->qgroup_ref_root = ref_root;
+			head_ref->qgroup_reserved = reserved;
+		}
+
+		qrecord->bytenr = bytenr;
+		qrecord->num_bytes = num_bytes;
+		qrecord->old_roots = NULL;
+	}
+}
+
 /*
  * helper function to actually insert a head node into the rbtree.
  * this does all the dirty work in terms of maintaining the correct
-- 
2.7.4

