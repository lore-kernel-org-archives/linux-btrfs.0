Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33399 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3FQVT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 17:19:28 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B011B7C0696
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 15:19:27 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 4CQKFh21q35bYOeH (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 15:19:27 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: move btrfs_truncate_page to btrfs_cont_expand instead of btrfs_truncate
Date: Mon, 17 Jun 2013 17:19:24 -0400
Message-ID: <1371503964-5067-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has plagued us forever and I'm so over working around it.  When we truncate
down to a non-page aligned offset we will call btrfs_truncate_page to zero out
the end of the page and write it back to disk, this will keep us from exposing
stale data if we truncate back up from that point.  The problem with this is it
requires data space to do this, and people don't really expect to get ENOSPC
from truncate() for these sort of things.  This also tends to bite the orphan
cleanup stuff too which keeps people from mounting.  To get around this we can
just move this into btrfs_cont_expand() to make sure if we are truncating up
from a non-page size aligned i_size we will zero out the rest of this page so
that we don't expose stale data.  This will give ENOSPC if you try to truncate()
up or if you try to write past the end of isize, which is much more reasonable.
This fixes xfstests generic/083 failing to mount because of the orphan cleanup
failing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3dbfee9..ecf8b5b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4253,6 +4253,15 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	u64 hole_size;
 	int err = 0;
 
+	/*
+	 * If our size started in the middle of a page we need to zero out the
+	 * rest of the page before we expand the i_size, otherwise we could
+	 * expose stale data.
+	 */
+	err = btrfs_truncate_page(inode, oldsize, 0, 0);
+	if (err)
+		return err;
+
 	if (size <= hole_start)
 		return 0;
 
@@ -7590,16 +7599,12 @@ static int btrfs_truncate(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv;
-	int ret;
+	int ret = 0;
 	int err = 0;
 	struct btrfs_trans_handle *trans;
 	u64 mask = root->sectorsize - 1;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 
-	ret = btrfs_truncate_page(inode, inode->i_size, 0, 0);
-	if (ret)
-		return ret;
-
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 
-- 
1.7.7.6

