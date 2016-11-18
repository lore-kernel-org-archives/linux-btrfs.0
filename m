Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbcKRJiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 04:38:50 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: remove rb_node field from the delayed ref node structure
Date: Fri, 18 Nov 2016 09:38:44 +0000
Message-Id: <1479461924-25986-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

After the last big change in the delayed references code that was needed
for the last qgroups rework, the red black tree node field of struct
btrfs_delayed_ref_node is no longer used, so just remove it, this helps
us save some memory (since struct rb_node is 24 bytes on x86_64) for
these structures.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/delayed-ref.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 43f3629..a72fbe7 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -34,12 +34,6 @@
  * ref_head. Must clean this mess up later.
  */
 struct btrfs_delayed_ref_node {
-	/*
-	 * ref_head use rb tree, stored in ref_root->href.
-	 * indexed by bytenr
-	 */
-	struct rb_node rb_node;
-
 	/*data/tree ref use list, stored in ref_head->ref_list. */
 	struct list_head list;
 
-- 
2.7.0.rc3

