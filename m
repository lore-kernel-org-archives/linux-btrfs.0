Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8399CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D956206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfCMPpy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:45:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:60746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbfCMPpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:45:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E0EDB117
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:45:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2FAE5DA875; Wed, 13 Mar 2019 16:47:08 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 4/9] btrfs: use assertion helpers for spinning readers
Date:   Wed, 13 Mar 2019 16:47:08 +0100
Message-Id: <a76a27b87096042c0ad2d5ab2e05b586dd2f0e58.1552489554.git.dsterba@suse.com>
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
not trigger and extent_buffer::spining_readers become unused and can be
moved to the appropriate section, saving a few bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/locking.c   | 12 +++++-------
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 11a95919bb3e..30363cb97625 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4672,7 +4672,6 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	atomic_set(&eb->read_locks, 0);
 	atomic_set(&eb->blocking_readers, 0);
 	atomic_set(&eb->blocking_writers, 0);
-	atomic_set(&eb->spinning_readers, 0);
 	eb->lock_nested = 0;
 	init_waitqueue_head(&eb->write_lock_wq);
 	init_waitqueue_head(&eb->read_lock_wq);
@@ -4692,6 +4691,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 
 #ifdef CONFIG_BTRFS_DEBUG
 	atomic_set(&eb->spinning_writers, 0);
+	atomic_set(&eb->spinning_readers, 0);
 #endif
 
 	return eb;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c5eb261c1ea9..e49310d2caf4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -151,7 +151,6 @@ struct extent_buffer {
 	atomic_t read_locks;
 	atomic_t blocking_writers;
 	atomic_t blocking_readers;
-	atomic_t spinning_readers;
 	short lock_nested;
 	/* >= 0 if eb belongs to a log tree, -1 otherwise */
 	short log_index;
@@ -171,6 +170,7 @@ struct extent_buffer {
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
 #ifdef CONFIG_BTRFS_DEBUG
 	atomic_t spinning_writers;
+	atomic_t spinning_readers;
 	struct list_head leak_list;
 #endif
 };
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 2dd3ae524aa3..ce9dc985ce05 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -62,8 +62,7 @@ void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
 		return;
 	btrfs_assert_tree_read_locked(eb);
 	atomic_inc(&eb->blocking_readers);
-	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
-	atomic_dec(&eb->spinning_readers);
+	btrfs_assert_spinning_readers_put(eb);
 	read_unlock(&eb->lock);
 }
 
@@ -150,7 +149,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 		goto again;
 	}
 	atomic_inc(&eb->read_locks);
-	atomic_inc(&eb->spinning_readers);
+	btrfs_assert_spinning_readers_get(eb);
 }
 
 /*
@@ -169,7 +168,7 @@ int btrfs_tree_read_lock_atomic(struct extent_buffer *eb)
 		return 0;
 	}
 	atomic_inc(&eb->read_locks);
-	atomic_inc(&eb->spinning_readers);
+	btrfs_assert_spinning_readers_get(eb);
 	return 1;
 }
 
@@ -190,7 +189,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 		return 0;
 	}
 	atomic_inc(&eb->read_locks);
-	atomic_inc(&eb->spinning_readers);
+	btrfs_assert_spinning_readers_get(eb);
 	return 1;
 }
 
@@ -232,8 +231,7 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
 		return;
 	}
 	btrfs_assert_tree_read_locked(eb);
-	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
-	atomic_dec(&eb->spinning_readers);
+	btrfs_assert_spinning_readers_put(eb);
 	atomic_dec(&eb->read_locks);
 	read_unlock(&eb->lock);
 }
-- 
2.20.1

