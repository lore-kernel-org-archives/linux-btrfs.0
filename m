Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51390 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3BVEe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 23:34:56 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1M4YtUk001324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 04:34:55 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1M4Yskn027917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 04:34:54 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1M4Yra1029634
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 22:34:53 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use reserved space for creating a snapshot
Date: Fri, 22 Feb 2013 12:33:36 +0800
Message-Id: <1361507616-12342-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While inserting dir index and updating inode for a snapshot, we'd
add delayed items which consume trans->block_rsv, if we don't have
any space reserved in this trans handle, we either just return or
reserve space again.

But before creating pending snapshots during committing transaction,
we've done a release on this trans handle, so we don't have space reserved
in it at this stage.

What we're using is block_rsv of pending snapshots which has already
reserved well enough space for both inserting dir index and updating
inode, so we need to set trans handle to indicate that we have space
now.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fc03aa6..5878bb4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1063,6 +1063,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	rsv = trans->block_rsv;
 	trans->block_rsv = &pending->block_rsv;
+	trans->bytes_reserved = trans->block_rsv->reserved;
 
 	dentry = pending->dentry;
 	parent = dget_parent(dentry);
@@ -1216,6 +1217,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 fail:
 	dput(parent);
 	trans->block_rsv = rsv;
+	trans->bytes_reserved = 0;
 no_free_objectid:
 	kfree(new_root_item);
 root_item_alloc_fail:
-- 
1.7.7.6

