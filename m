Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58636 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbbG0KC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 06:02:58 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 27 Jul 2015 19:59:11 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 153F0357805D
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 19:58:40 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t6R9wV1B53149910
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 19:58:39 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t6R9vAV3007588
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 19:57:10 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, chandan@mykolab.com
Subject: [PATCH] Btrfs: btrfs_submit_bio_hook: Use btrfs_wq_endio_type values instead of integer constants
Date: Mon, 27 Jul 2015 15:26:43 +0530
Message-Id: <1437991003-5901-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_submit_bio_hook() uses integer constants instead of values from "enum
btrfs_wq_endio_type". Fix this.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e33dff3..0695a62 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1859,15 +1859,15 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 			  u64 bio_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	enum btrfs_wq_endio_type metadata = BTRFS_WQ_ENDIO_DATA;
 	int ret = 0;
 	int skip_sum;
-	int metadata = 0;
 	int async = !atomic_read(&BTRFS_I(inode)->sync_writers);
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	if (btrfs_is_free_space_inode(inode))
-		metadata = 2;
+		metadata = BTRFS_WQ_ENDIO_FREE_SPACE;
 
 	if (!(rw & REQ_WRITE)) {
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
-- 
2.1.0

