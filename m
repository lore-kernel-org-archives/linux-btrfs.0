Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35387 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3CKJWj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 05:22:39 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2B9MdHt001655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 09:22:39 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2B9McIq020063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 09:22:38 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2B9Mc7M003657
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 04:22:38 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: get better concurrency for snapshot-aware defrag work
Date: Mon, 11 Mar 2013 17:20:58 +0800
Message-Id: <1362993658-30147-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using spinning case instead of blocking will result in better concurrency
overall.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13ab4de..1f268888 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2312,6 +2312,7 @@ again:
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = start;
 
+	path->leave_spinning = 1;
 	if (merge) {
 		struct btrfs_file_extent_item *fi;
 		u64 extent_len;
@@ -2368,6 +2369,7 @@ again:
 
 	btrfs_mark_buffer_dirty(leaf);
 	inode_add_bytes(inode, len);
+	btrfs_release_path(path);
 
 	ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
 			new->disk_len, 0,
@@ -2381,6 +2383,7 @@ again:
 	ret = 1;
 out_free_path:
 	btrfs_release_path(path);
+	path->leave_spinning = 0;
 	btrfs_end_transaction(trans, root);
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
-- 
1.7.7.6

