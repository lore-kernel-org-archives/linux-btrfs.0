Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:44478 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbeAJQzg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:55:36 -0500
Received: by mail-qk0-f193.google.com with SMTP id u76so4913609qku.11
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 08:55:36 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs: return 0 for success in btrfs_alloc_data_chunk_ondemand
Date: Wed, 10 Jan 2018 11:55:34 -0500
Message-Id: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

My delayed refs rsv patches uncovered a problem in
btrfs_alloc_data_chunk_ondemand where we don't clear ret before
returning, so we could have whatever left over value we had from trying
to do a chunk allocation or whatever that may have failed.  Since we
know we've succeeded at this point just unconditionally return 0.  This
fixed the xfstests failures I was seeing with my delayed refs rsv
patches.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dbae25d882de..33c9efbfc9a7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4387,8 +4387,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
-
-	return ret;
+	return 0;
 }
 
 int btrfs_check_data_free_space(struct inode *inode,
-- 
2.7.5

