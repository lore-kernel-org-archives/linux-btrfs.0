Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43255 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933102AbdKORoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 20440AD07
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: reoder btrfs_transaction members for better packing
Date: Wed, 15 Nov 2017 18:42:06 +0100
Message-Id: <968af0bfaca921b5879c297e3f5b8037377bc672.1510767175.git.dsterba@suse.com>
In-Reply-To: <cover.1510767175.git.dsterba@suse.com>
References: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are now 20 bytes of holes, we can reduce that to 4 by minor
changes. Moving 'aborted' to the status and flags is also more logical,
similar for num_dirty_bgs. The size goes from 432 to 416.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 1805fd101767..6beee072b1bd 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -58,6 +58,7 @@ struct btrfs_transaction {
 
 	/* Be protected by fs_info->trans_lock when we want to change it. */
 	enum btrfs_trans_state state;
+	int aborted;
 	struct list_head list;
 	struct extent_io_tree dirty_pages;
 	unsigned long start_time;
@@ -70,7 +71,6 @@ struct btrfs_transaction {
 	struct list_head dirty_bgs;
 	struct list_head io_bgs;
 	struct list_head dropped_roots;
-	unsigned int num_dirty_bgs;
 
 	/*
 	 * we need to make sure block group deletion doesn't race with
@@ -79,11 +79,11 @@ struct btrfs_transaction {
 	 */
 	struct mutex cache_write_mutex;
 	spinlock_t dirty_bgs_lock;
+	unsigned int num_dirty_bgs;
 	/* Protected by spin lock fs_info->unused_bgs_lock. */
 	struct list_head deleted_bgs;
 	spinlock_t dropped_roots_lock;
 	struct btrfs_delayed_ref_root delayed_refs;
-	int aborted;
 	struct btrfs_fs_info *fs_info;
 };
 
-- 
2.14.3

