Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46370 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaCNUzU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 16:55:20 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so203995wib.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 13:55:18 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: fix race when updating existing ref head
Date: Fri, 14 Mar 2014 20:55:01 +0000
Message-Id: <1394830501-24550-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While we update an existing ref head's extent_op, we're not holding
its spinlock, so while we're updating its extent_op contents (key,
flags) we can have a task running __btrfs_run_delayed_refs() that
holds the ref head's lock and sets its extent_op to NULL right after
the task updating the ref head just checked its extent_op was not NULL.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/delayed-ref.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 2502ba5..3129964 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -495,6 +495,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 	ref = btrfs_delayed_node_to_head(update);
 	BUG_ON(existing_ref->is_data != ref->is_data);
 
+	spin_lock(&existing_ref->lock);
 	if (ref->must_insert_reserved) {
 		/* if the extent was freed and then
 		 * reallocated before the delayed ref
@@ -536,7 +537,6 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 	 * only need the lock for this case cause we could be processing it
 	 * currently, for refs we just added we know we're a-ok.
 	 */
-	spin_lock(&existing_ref->lock);
 	existing->ref_mod += update->ref_mod;
 	spin_unlock(&existing_ref->lock);
 }
-- 
1.7.9.5

