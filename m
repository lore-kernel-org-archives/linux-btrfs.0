Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDD9C04EBC
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA6F2087E
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EA6F2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbeKTXUW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:20:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:44676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728242AbeKTXUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 18:20:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DCB1AAF95
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 12:51:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6DE3EDA78B; Tue, 20 Nov 2018 13:51:04 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: dev-replace: remove custom read/write blocking scheme
Date:   Tue, 20 Nov 2018 13:51:04 +0100
Message-Id: <9ab466e862cbcbb6cf87e27a8e7e53bf3d457a5a.1542717531.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542717531.git.dsterba@suse.com>
References: <cover.1542717531.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

After the rw semaphore has been added, the custom blocking using
::blocking_readers and ::read_lock_wq is redundant.

The blocking logic in __btrfs_map_block is replaced by extending the
time the semaphore is held, that has the same blocking effect on writes
as the previous custom scheme that waited until ::blocking_readers was
zero.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  2 --
 fs/btrfs/dev-replace.c | 16 ----------------
 fs/btrfs/dev-replace.h |  1 -
 fs/btrfs/disk-io.c     |  2 --
 fs/btrfs/volumes.c     | 13 ++++++-------
 5 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 01efe3849968..b711d4ee4c83 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -361,8 +361,6 @@ struct btrfs_dev_replace {
 
 	struct mutex lock_finishing_cancel_unmount;
 	struct rw_semaphore rwsem;
-	atomic_t blocking_readers;
-	wait_queue_head_t read_lock_wq;
 
 	struct btrfs_scrub_progress scrub_progress;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 387f85fcc26e..a37af7aaca86 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1011,14 +1011,7 @@ void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
 
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
 {
-again:
-	wait_event(dev_replace->read_lock_wq,
-		   atomic_read(&dev_replace->blocking_readers) == 0);
 	down_write(&dev_replace->rwsem);
-	if (atomic_read(&dev_replace->blocking_readers)) {
-		up_write(&dev_replace->rwsem);
-		goto again;
-	}
 }
 
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
@@ -1026,15 +1019,6 @@ void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
 	up_write(&dev_replace->rwsem);
 }
 
-/* inc blocking cnt and release read lock */
-void btrfs_dev_replace_set_lock_blocking(
-					struct btrfs_dev_replace *dev_replace)
-{
-	/* only set blocking for read lock */
-	atomic_inc(&dev_replace->blocking_readers);
-	up_read(&dev_replace->rwsem);
-}
-
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 {
 	percpu_counter_inc(&fs_info->dev_replace.bio_counter);
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 27e3bb0cca11..dd1dcb22c1e3 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -23,6 +23,5 @@ void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_set_lock_blocking(struct btrfs_dev_replace *dev_replace);
 
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 38717aa9c47d..39fd33ef8f80 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2120,9 +2120,7 @@ static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 {
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	init_rwsem(&fs_info->dev_replace.rwsem);
-	atomic_set(&fs_info->dev_replace.blocking_readers, 0);
 	init_waitqueue_head(&fs_info->dev_replace.replace_wait);
-	init_waitqueue_head(&fs_info->dev_replace.read_lock_wq);
 }
 
 static void btrfs_init_qgroup(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1f476669479b..dc09c6abaf6d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5759,10 +5759,12 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	btrfs_dev_replace_read_lock(dev_replace);
 	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
+	/*
+	 * Hold the semaphore for read during the whole operation, write is
+	 * requested at commit time but must wait.
+	 */
 	if (!dev_replace_is_ongoing)
 		btrfs_dev_replace_read_unlock(dev_replace);
-	else
-		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
 	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
@@ -5957,11 +5959,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (dev_replace_is_ongoing) {
-		ASSERT(atomic_read(&dev_replace->blocking_readers) > 0);
-		btrfs_dev_replace_read_lock(dev_replace);
-		/* Barrier implied by atomic_dec_and_test */
-		if (atomic_dec_and_test(&dev_replace->blocking_readers))
-			cond_wake_up_nomb(&dev_replace->read_lock_wq);
+		lockdep_assert_held(&dev_replace->rwsem);
+		/* Unlock and let waiting writers proceed */
 		btrfs_dev_replace_read_unlock(dev_replace);
 	}
 	free_extent_map(em);
-- 
2.19.1

