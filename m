Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:35230 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858Ab2IFUqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 16:46:34 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id yD1JRE8HXxfbexzx (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2012 14:46:33 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: wait on async pages when shrinking delalloc
Date: Thu, 6 Sep 2012 16:51:56 -0400
Message-ID: <1346964716-12070-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mitch reported a problem where you could get an ENOSPC error when untarring
a kernel git tree onto a 16gb file system with compress-force=zlib.  This is
because compression is a huge pain, it will return from ->writepages()
without having actually created any ordered extents.  To get around this we
check to see if the async submit counter is up, and if it is wait until it
drops to 0 before doing our normal ordered wait dance.  With this patch I
can now untar a kernel git tree onto a 16gb file system without getting
ENOSPC errors.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b6b33e4..4bb546da 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3697,6 +3697,14 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
 					       WB_REASON_FS_FREE_SPACE);
 
+		/*
+		 * We need to wait for the async pages to actually start before
+		 * we do anything.
+		 */
+		if (atomic_read(&root->fs_info->async_delalloc_pages))
+			wait_event(root->fs_info->async_submit_wait,
+			  !atomic_read(&root->fs_info->async_delalloc_pages));
+
 		spin_lock(&space_info->lock);
 		if (space_info->bytes_used + space_info->bytes_reserved +
 		    space_info->bytes_pinned + space_info->bytes_readonly +
-- 
1.7.7.6

