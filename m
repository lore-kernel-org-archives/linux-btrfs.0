Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0B5C10F03
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D6A206DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfCMPpv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:45:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:60730 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfCMPpt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:45:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1895B117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87DE1DA875; Wed, 13 Mar 2019 16:47:03 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/9] btrfs: use assertion helpers for spinning writers
Date:   Wed, 13 Mar 2019 16:47:03 +0100
Message-Id: <b90617344a13e6168bbda03178bf44887cfe9ce1.1552489554.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552489554.git.dsterba@suse.com>
References: <cover.1552489554.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Use the helpers where open coded. On non-debug builds, the warnings will
not trigger and extent_buffer::spining_writers become unused and can be
moved to the appropriate section, saving a few bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c |  5 ++++-
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/locking.c   | 16 ++++++----------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca259c75bbcd..11a95919bb3e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4673,7 +4673,6 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	atomic_set(&eb->blocking_readers, 0);
 	atomic_set(&eb->blocking_writers, 0);
 	atomic_set(&eb->spinning_readers, 0);
-	atomic_set(&eb->spinning_writers, 0);
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
@@ -4691,6 +4690,10 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 		> MAX_INLINE_EXTENT_BUFFER_SIZE);
 	BUG_ON(len > MAX_INLINE_EXTENT_BUFFER_SIZE);
 
+#ifdef CONFIG_BTRFS_DEBUG
+	atomic_set(&eb->spinning_writers, 0);
+#endif
+
 	return eb;
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 08749e0b9c32..c5eb261c1ea9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -152,7 +152,6 @@ struct extent_buffer {
 	atomic_t blocking_writers;
 	atomic_t blocking_readers;
 	atomic_t spinning_readers;
-	atomic_t spinning_writers;
 	short lock_nested;
 	/* >= 0 if eb belongs to a log tree, -1 otherwise */
 	short log_index;
@@ -171,6 +170,7 @@ struct extent_buffer {
 	wait_queue_head_t read_lock_wq;
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
 #ifdef CONFIG_BTRFS_DEBUG
+	atomic_t spinning_writers;
 	struct list_head leak_list;
 #endif
 };
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 13ef1decdea6..a5a3c5118f61 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -64,8 +64,7 @@ void btrfs_set_lock_blocking_write(struct extent_buffer *eb)
 	if (eb->lock_nested && current->pid == eb->lock_owner)
 		return;
 	if (atomic_read(&eb->blocking_writers) == 0) {
-		WARN_ON(atomic_read(&eb->spinning_writers) != 1);
-		atomic_dec(&eb->spinning_writers);
+		btrfs_assert_spinning_writers_put(eb);
 		btrfs_assert_tree_locked(eb);
 		atomic_inc(&eb->blocking_writers);
 		write_unlock(&eb->lock);
@@ -101,8 +100,7 @@ void btrfs_clear_lock_blocking_write(struct extent_buffer *eb)
 		return;
 	BUG_ON(atomic_read(&eb->blocking_writers) != 1);
 	write_lock(&eb->lock);
-	WARN_ON(atomic_read(&eb->spinning_writers));
-	atomic_inc(&eb->spinning_writers);
+	btrfs_assert_spinning_writers_get(eb);
 	/* atomic_dec_and_test implies a barrier */
 	if (atomic_dec_and_test(&eb->blocking_writers))
 		cond_wake_up_nomb(&eb->write_lock_wq);
@@ -200,7 +198,7 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 		return 0;
 	}
 	atomic_inc(&eb->write_locks);
-	atomic_inc(&eb->spinning_writers);
+	btrfs_assert_spinning_writers_get(eb);
 	eb->lock_owner = current->pid;
 	return 1;
 }
@@ -266,8 +264,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
 		write_unlock(&eb->lock);
 		goto again;
 	}
-	WARN_ON(atomic_read(&eb->spinning_writers));
-	atomic_inc(&eb->spinning_writers);
+	btrfs_assert_spinning_writers_get(eb);
 	atomic_inc(&eb->write_locks);
 	eb->lock_owner = current->pid;
 }
@@ -286,14 +283,13 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 	atomic_dec(&eb->write_locks);
 
 	if (blockers) {
-		WARN_ON(atomic_read(&eb->spinning_writers));
+		btrfs_assert_no_spinning_writers(eb);
 		atomic_dec(&eb->blocking_writers);
 		/* Use the lighter barrier after atomic */
 		smp_mb__after_atomic();
 		cond_wake_up_nomb(&eb->write_lock_wq);
 	} else {
-		WARN_ON(atomic_read(&eb->spinning_writers) != 1);
-		atomic_dec(&eb->spinning_writers);
+		btrfs_assert_spinning_writers_put(eb);
 		write_unlock(&eb->lock);
 	}
 }
-- 
2.20.1

