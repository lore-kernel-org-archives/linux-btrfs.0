Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47077 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3EHRbV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 May 2013 13:31:21 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1EA9F9A069F
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 11:31:20 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 08DblkqtIo3jCAzF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 08 May 2013 11:31:19 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't null pointer deref on abort
Date: Wed, 8 May 2013 13:31:17 -0400
Message-ID: <1368034277-5016-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm sorry, theres no excuse for this sort of work.  We need to use
root->leafsize since eb may be NULL.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e8b5027..19d7e63 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3752,7 +3752,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 		while (start <= end) {
 			eb = btrfs_find_tree_block(root, start,
 						   root->leafsize);
-			start += eb->len;
+			start += root->leafsize;
 			if (!eb)
 				continue;
 			wait_on_extent_buffer_writeback(eb);
-- 
1.7.7.6

