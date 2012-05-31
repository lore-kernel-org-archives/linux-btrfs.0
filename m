Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791Ab2EaUET (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 16:04:19 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VK4Jnr032506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 16:04:19 -0400
Received: from localhost.localdomain.com (vpn-8-248.rdu.redhat.com [10.11.8.248])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4VK4HAA029039
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 16:04:18 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs: unlock everything properly in the error case for nocow
Date: Thu, 31 May 2012 16:04:16 -0400
Message-Id: <1338494656-12232-4-git-send-email-josef@redhat.com>
In-Reply-To: <1338494656-12232-1-git-send-email-josef@redhat.com>
References: <1338494656-12232-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was getting hung on umount when a transaction was aborted because a range
of one of the free space inodes was still locked.  This is because the nocow
stuff doesn't unlock anything on error.  This fixed the problem and I
verified that is what was happening.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e91f985..96b841d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1136,8 +1136,18 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		extent_clear_unlock_delalloc(inode,
+			     &BTRFS_I(inode)->io_tree,
+			     start, end, locked_page,
+			     EXTENT_CLEAR_UNLOCK_PAGE |
+			     EXTENT_CLEAR_UNLOCK |
+			     EXTENT_CLEAR_DELALLOC |
+			     EXTENT_CLEAR_DIRTY |
+			     EXTENT_SET_WRITEBACK |
+			     EXTENT_END_WRITEBACK);
 		return -ENOMEM;
+	}
 
 	nolock = btrfs_is_free_space_inode(root, inode);
 
@@ -1147,6 +1157,15 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		trans = btrfs_join_transaction(root);
 
 	if (IS_ERR(trans)) {
+		extent_clear_unlock_delalloc(inode,
+			     &BTRFS_I(inode)->io_tree,
+			     start, end, locked_page,
+			     EXTENT_CLEAR_UNLOCK_PAGE |
+			     EXTENT_CLEAR_UNLOCK |
+			     EXTENT_CLEAR_DELALLOC |
+			     EXTENT_CLEAR_DIRTY |
+			     EXTENT_SET_WRITEBACK |
+			     EXTENT_END_WRITEBACK);
 		btrfs_free_path(path);
 		return PTR_ERR(trans);
 	}
@@ -1327,8 +1346,11 @@ out_check:
 	}
 	btrfs_release_path(path);
 
-	if (cur_offset <= end && cow_start == (u64)-1)
+	if (cur_offset <= end && cow_start == (u64)-1) {
 		cow_start = cur_offset;
+		cur_offset = end;
+	}
+
 	if (cow_start != (u64)-1) {
 		ret = cow_file_range(inode, locked_page, cow_start, end,
 				     page_started, nr_written, 1);
@@ -1347,6 +1369,17 @@ error:
 	if (!ret)
 		ret = err;
 
+	if (ret && cur_offset < end)
+		extent_clear_unlock_delalloc(inode,
+			     &BTRFS_I(inode)->io_tree,
+			     cur_offset, end, locked_page,
+			     EXTENT_CLEAR_UNLOCK_PAGE |
+			     EXTENT_CLEAR_UNLOCK |
+			     EXTENT_CLEAR_DELALLOC |
+			     EXTENT_CLEAR_DIRTY |
+			     EXTENT_SET_WRITEBACK |
+			     EXTENT_END_WRITEBACK);
+
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.7.6

