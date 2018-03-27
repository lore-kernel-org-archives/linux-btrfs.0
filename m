Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbeC0Sut (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:50:49 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5D22AC98
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:50:48 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: use lockdep_assert_held for spinlocks
Date: Tue, 27 Mar 2018 20:48:22 +0200
Message-Id: <7475488a897dce6833b3948de056f49da79e965b.1522176187.git.dsterba@suse.com>
In-Reply-To: <cover.1522176187.git.dsterba@suse.com>
References: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using lockdep_assert_held is preferred, replace assert_spin_locked.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/delayed-ref.c | 6 +++---
 fs/btrfs/qgroup.c      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 7ab5e0128f0c..6dcb0128ea7f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -216,7 +216,7 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	assert_spin_locked(&delayed_refs->lock);
+	lockdep_assert_held(&delayed_refs->lock);
 	if (mutex_trylock(&head->mutex))
 		return 0;
 
@@ -239,7 +239,7 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 				    struct btrfs_delayed_ref_head *head,
 				    struct btrfs_delayed_ref_node *ref)
 {
-	assert_spin_locked(&head->lock);
+	lockdep_assert_held(&head->lock);
 	rb_erase(&ref->ref_node, &head->ref_tree);
 	RB_CLEAR_NODE(&ref->ref_node);
 	if (!list_empty(&ref->add_list))
@@ -307,7 +307,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 	struct rb_node *node;
 	u64 seq = 0;
 
-	assert_spin_locked(&head->lock);
+	lockdep_assert_held(&head->lock);
 
 	if (RB_EMPTY_ROOT(&head->ref_tree))
 		return;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index aa259d6986e1..ad09845b618c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1414,7 +1414,7 @@ int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
 	struct btrfs_qgroup_extent_record *entry;
 	u64 bytenr = record->bytenr;
 
-	assert_spin_locked(&delayed_refs->lock);
+	lockdep_assert_held(&delayed_refs->lock);
 	trace_btrfs_qgroup_trace_extent(fs_info, record);
 
 	while (*p) {
-- 
2.16.2

