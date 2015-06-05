Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:33005 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbFEXHg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jun 2015 19:07:36 -0400
Received: by qgfa66 with SMTP id a66so563463qgf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2015 16:07:35 -0700 (PDT)
From: jmaggard10@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] Btrfs: Fix inverted no_quota logic
Date: Fri,  5 Jun 2015 16:07:29 -0700
Message-Id: <1433545649-6134-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Justin Maggard <jmaggard10@gmail.com>

Both btrfs_add_delayed_tree_ref() and
btrfs_add_delayed_data_ref() have inverted logic when
setting the no_quota value for delayed refs.  This is
eventually double-checked in __btrfs_inc_extent_ref() and
__btrfs_free_extent(), but not alloc_reserved_tree_block(),
so it can throw off qgroup accounting.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
---
 fs/btrfs/delayed-ref.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8f8ed7d..b0ff795 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -792,7 +792,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
-		no_quota = 0;
+		no_quota = 1;
 
 	BUG_ON(extent_op && extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
@@ -841,7 +841,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
-		no_quota = 0;
+		no_quota = 1;
 
 	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
-- 
2.4.2

