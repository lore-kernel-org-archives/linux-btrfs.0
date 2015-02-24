Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbbBXQvk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 11:51:40 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BEF79ADBA
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 16:51:39 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs: remove extra barrier before waitqueue_active
Date: Tue, 24 Feb 2015 17:51:39 +0100
Message-Id: <72ec4dccea7db12b160220d1adbb08e3b7ce1fa3.1424795734.git.dsterba@suse.cz>
In-Reply-To: <cover.1424795734.git.dsterba@suse.cz>
References: <cover.1424795734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Removing barriers is scary, but a call to atomic_dec_and_test implies
a barrier, so we don't need to issue another one.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/tree-log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 121df0fe5128..07ed248ef0e7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -238,7 +238,9 @@ int btrfs_pin_log_trans(struct btrfs_root *root)
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
@@ -2610,7 +2612,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 
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
1.8.4.5

