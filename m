Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbbJKRvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 13:51:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A8BA0AC66
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 17:51:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/6] btrfs: remove extra barrier before waitqueue_active
Date: Sun, 11 Oct 2015 19:50:33 +0200
Message-Id: <779adf0f647651f5a45eeee3442c881300ce989e.1444579885.git.dsterba@suse.com>
In-Reply-To: <cover.1444579885.git.dsterba@suse.com>
References: <cover.1444579885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Removing barriers is scary, but a call to atomic_dec_and_test implies
a barrier, so we don't need to issue another one.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index d0deb4643502..63275594debd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -229,7 +229,9 @@ int btrfs_pin_log_trans(struct btrfs_root *root)
 void btrfs_end_log_trans(struct btrfs_root *root)
 {
 	if (atomic_dec_and_test(&root->log_writers)) {
-		smp_mb();
+		/*
+		 * Implicit memory barrier after atomic_dec_and_test
+		 */
 		if (waitqueue_active(&root->log_writer_wait))
 			wake_up(&root->log_writer_wait);
 	}
@@ -2820,7 +2822,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&log_root_tree->log_mutex);
 	if (atomic_dec_and_test(&log_root_tree->log_writers)) {
-		smp_mb();
+		/*
+		 * Implicit memory barrier after atomic_dec_and_test
+		 */
 		if (waitqueue_active(&log_root_tree->log_writer_wait))
 			wake_up(&log_root_tree->log_writer_wait);
 	}
-- 
2.1.3

