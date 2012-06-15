Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab2FOSTu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 14:19:50 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: [PATCH] Btrfs: delay iput with async extents V2
Date: Fri, 15 Jun 2012 14:19:48 -0400
Message-Id: <1339784388-10908-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is some concern that these iput()'s could be the final iputs and could
induce lockups on people waiting on writeback.  This would happen in the
rare case that we don't create ordered extents because of an error, but it
is theoretically possible and we already have a mechanism to deal with this
so just make them delayed iputs to negate any worry.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: Drop the iput in async_cow_free, I'm an idiot.
 fs/btrfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fe3073e..a95ef03 100644
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
@@ -1023,7 +1023,7 @@ static noinline void async_cow_free(struct btrfs_work *work)
 	struct async_cow *async_cow;
 	async_cow = container_of(work, struct async_cow, work);
 	if (async_cow->inode)
-		iput(async_cow->inode);
+		btrfs_add_delayed_iput(async_cow->inode);
 	kfree(async_cow);
 }
 
-- 
1.7.7.6

