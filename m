Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2FORkh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 13:40:37 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: [PATCH] Btrfs: delay iput with async extents
Date: Fri, 15 Jun 2012 13:40:35 -0400
Message-Id: <1339782035-10210-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is some concern that these iput()'s could be the final iputs and could
induce lockups on people waiting on writeback.  This would happen in the
rare case that we don't create ordered extents because of an error, but it
is theoretically possible and we already have a mechanism to deal with this
so just make them delayed iputs to negate any worry.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fe3073e..a78f5c7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -987,7 +987,7 @@ static noinline void async_cow_start(struct btrfs_work *work)
 			    async_cow->start, async_cow->end, async_cow,
 			    &num_added);
 	if (num_added == 0) {
-		iput(async_cow->inode);
+		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
 	}
 }
@@ -1022,8 +1022,10 @@ static noinline void async_cow_free(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	async_cow = container_of(work, struct async_cow, work);
-	if (async_cow->inode)
+	if (async_cow->inode) {
+		btrfs_add_delayed_iput(async_cow->inode);
 		iput(async_cow->inode);
+	}
 	kfree(async_cow);
 }
 
-- 
1.7.7.6

