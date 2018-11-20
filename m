Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A71C04EBC
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7946C20831
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7946C20831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbeKTXUV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:20:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:44664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728130AbeKTXUU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 18:20:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0AAFAF53
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 12:51:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 27AF7DA78B; Tue, 20 Nov 2018 13:51:01 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: dev-replace: swich locking to rw semaphore
Date:   Tue, 20 Nov 2018 13:51:01 +0100
Message-Id: <b476e68fc2d6aef281a35a7b067ec1c608b02ddd.1542717531.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542717531.git.dsterba@suse.com>
References: <cover.1542717531.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The this is first part of removing the custom locking and waiting scheme
used for device replace. It was probably copied from extent buffer
locking, but there's nothing that would require more than is provided by
the common locking primitives.

The rw spinlock protects waiting tasks counter in case of incompatible
locks and the waitqueue. Same as rw semaphore.

This patch only switches the locking primitive, for better
bisectability.  There should be no functional change other than the
overhead of the locking and potential sleeping instead of spinning when
the lock is contended.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/dev-replace.c | 12 ++++++------
 fs/btrfs/disk-io.c     |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b58c5e73e458..01efe3849968 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -360,7 +360,7 @@ struct btrfs_dev_replace {
 	struct btrfs_device *tgtdev;
 
 	struct mutex lock_finishing_cancel_unmount;
-	rwlock_t lock;
+	struct rw_semaphore rwsem;
 	atomic_t blocking_readers;
 	wait_queue_head_t read_lock_wq;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 85d93bd3b27a..387f85fcc26e 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1001,12 +1001,12 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 
 void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace)
 {
-	read_lock(&dev_replace->lock);
+	down_read(&dev_replace->rwsem);
 }
 
 void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	read_unlock(&dev_replace->lock);
+	up_read(&dev_replace->rwsem);
 }
 
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
@@ -1014,16 +1014,16 @@ void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
 again:
 	wait_event(dev_replace->read_lock_wq,
 		   atomic_read(&dev_replace->blocking_readers) == 0);
-	write_lock(&dev_replace->lock);
+	down_write(&dev_replace->rwsem);
 	if (atomic_read(&dev_replace->blocking_readers)) {
-		write_unlock(&dev_replace->lock);
+		up_write(&dev_replace->rwsem);
 		goto again;
 	}
 }
 
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	write_unlock(&dev_replace->lock);
+	up_write(&dev_replace->rwsem);
 }
 
 /* inc blocking cnt and release read lock */
@@ -1032,7 +1032,7 @@ void btrfs_dev_replace_set_lock_blocking(
 {
 	/* only set blocking for read lock */
 	atomic_inc(&dev_replace->blocking_readers);
-	read_unlock(&dev_replace->lock);
+	up_read(&dev_replace->rwsem);
 }
 
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c1d127decc8d..38717aa9c47d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2119,7 +2119,7 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info)
 static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 {
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
-	rwlock_init(&fs_info->dev_replace.lock);
+	init_rwsem(&fs_info->dev_replace.rwsem);
 	atomic_set(&fs_info->dev_replace.blocking_readers, 0);
 	init_waitqueue_head(&fs_info->dev_replace.replace_wait);
 	init_waitqueue_head(&fs_info->dev_replace.read_lock_wq);
-- 
2.19.1

