Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454AFC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCE2206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfCMPp7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:45:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:60768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfCMPp6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:45:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12F81B117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DA436DA875; Wed, 13 Mar 2019 16:47:12 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 6/9] btrfs: use assertion helpers for extent buffer read lock counters
Date:   Wed, 13 Mar 2019 16:47:12 +0100
Message-Id: <d60df16318a7293ac9f76be1f82f22d15dda0624.1552489554.git.dsterba@suse.com>
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
not trigger and extent_buffer::read_locks become unused and can be
moved to the appropriate section, saving a few bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/locking.c   | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 30363cb97625..a74495bdb552 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4669,7 +4669,6 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	eb->bflags = 0;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
-	atomic_set(&eb->read_locks, 0);
 	atomic_set(&eb->blocking_readers, 0);
 	atomic_set(&eb->blocking_writers, 0);
 	eb->lock_nested = 0;
@@ -4692,6 +4691,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 #ifdef CONFIG_BTRFS_DEBUG
 	atomic_set(&eb->spinning_writers, 0);
 	atomic_set(&eb->spinning_readers, 0);
+	atomic_set(&eb->read_locks, 0);
 #endif
 
 	return eb;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e49310d2caf4..fee8c8c463b8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -148,7 +148,6 @@ struct extent_buffer {
 
 	/* count of read lock holders on the extent buffer */
 	atomic_t write_locks;
-	atomic_t read_locks;
 	atomic_t blocking_writers;
 	atomic_t blocking_readers;
 	short lock_nested;
@@ -171,6 +170,7 @@ struct extent_buffer {
 #ifdef CONFIG_BTRFS_DEBUG
 	atomic_t spinning_writers;
 	atomic_t spinning_readers;
+	atomic_t read_locks;
 	struct list_head leak_list;
 #endif
 };
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 947c66c01e34..e88a0a3d286f 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -164,7 +164,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 			   atomic_read(&eb->blocking_writers) == 0);
 		goto again;
 	}
-	atomic_inc(&eb->read_locks);
+	btrfs_assert_tree_read_locks_get(eb);
 	btrfs_assert_spinning_readers_get(eb);
 }
 
@@ -183,7 +183,7 @@ int btrfs_tree_read_lock_atomic(struct extent_buffer *eb)
 		read_unlock(&eb->lock);
 		return 0;
 	}
-	atomic_inc(&eb->read_locks);
+	btrfs_assert_tree_read_locks_get(eb);
 	btrfs_assert_spinning_readers_get(eb);
 	return 1;
 }
@@ -204,7 +204,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 		read_unlock(&eb->lock);
 		return 0;
 	}
-	atomic_inc(&eb->read_locks);
+	btrfs_assert_tree_read_locks_get(eb);
 	btrfs_assert_spinning_readers_get(eb);
 	return 1;
 }
@@ -248,7 +248,7 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
 	}
 	btrfs_assert_tree_read_locked(eb);
 	btrfs_assert_spinning_readers_put(eb);
-	atomic_dec(&eb->read_locks);
+	btrfs_assert_tree_read_locks_put(eb);
 	read_unlock(&eb->lock);
 }
 
@@ -272,7 +272,7 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 	/* atomic_dec_and_test implies a barrier */
 	if (atomic_dec_and_test(&eb->blocking_readers))
 		cond_wake_up_nomb(&eb->read_lock_wq);
-	atomic_dec(&eb->read_locks);
+	btrfs_assert_tree_read_locks_put(eb);
 }
 
 /*
-- 
2.20.1

