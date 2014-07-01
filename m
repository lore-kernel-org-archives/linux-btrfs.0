Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46373 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaGAGex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 02:34:53 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 1 Jul 2014 16:34:50 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 6F55F2BB0040
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Jul 2014 16:34:49 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s616IJTp60424336
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Jul 2014 16:18:20 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s616YmTa027486
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Jul 2014 16:34:48 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH] Btrfs: fill_holes: Fix slot number passed to hole_mergeable() call.
Date: Tue,  1 Jul 2014 12:04:28 +0530
Message-Id: <1404196468-2007-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For a non-existent key, btrfs_search_slot() sets path->slots[0] to the slot
where the key could have been present, which in this case would be the slot
containing the extent item which would be the next neighbor of the file range
being punched. The current code passes an incremented path->slots[0] and we
skip to the wrong file extent item. This would mean that we would fail to
merge the "yet to be created" hole with the next neighboring hole (if one
exists). Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ad7c059..3cd7997 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2126,10 +2126,9 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 		goto out;
 	}
 
-	if (hole_mergeable(inode, leaf, path->slots[0]+1, offset, end)) {
+	if (hole_mergeable(inode, leaf, path->slots[0], offset, end)) {
 		u64 num_bytes;
 
-		path->slots[0]++;
 		key.offset = offset;
 		btrfs_set_item_key_safe(root, path, &key);
 		fi = btrfs_item_ptr(leaf, path->slots[0],
-- 
1.8.3.1

