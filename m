Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FDCC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 572BE206BA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 15:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfCMPqD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:46:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:60790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726579AbfCMPqC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 11:46:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2A8BB119
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2019 15:46:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8E5D0DA875; Wed, 13 Mar 2019 16:47:17 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 8/9] btrfs: use assertion helpers for extent buffer write lock counters
Date:   Wed, 13 Mar 2019 16:47:17 +0100
Message-Id: <e2cc50f333e666c34e87b9d62959d4c141ee5fed.1552489554.git.dsterba@suse.com>
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
not trigger and extent_buffer::write_locks become unused and can be
moved to the appropriate section, saving a few bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 2 +-
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/locking.c   | 6 +++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a74495bdb552..a9ae476c7502 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4668,7 +4668,6 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	eb->fs_info = fs_info;
 	eb->bflags = 0;
 	rwlock_init(&eb->lock);
-	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->blocking_readers, 0);
 	atomic_set(&eb->blocking_writers, 0);
 	eb->lock_nested = 0;
@@ -4692,6 +4691,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	atomic_set(&eb->spinning_writers, 0);
 	atomic_set(&eb->spinning_readers, 0);
 	atomic_set(&eb->read_locks, 0);
+	atomic_set(&eb->write_locks, 0);
 #endif
 
 	return eb;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index fee8c8c463b8..b2640db8821e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -146,8 +146,6 @@ struct extent_buffer {
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
 
-	/* count of read lock holders on the extent buffer */
-	atomic_t write_locks;
 	atomic_t blocking_writers;
 	atomic_t blocking_readers;
 	short lock_nested;
@@ -171,6 +169,7 @@ struct extent_buffer {
 	atomic_t spinning_writers;
 	atomic_t spinning_readers;
 	atomic_t read_locks;
+	atomic_t write_locks;
 	struct list_head leak_list;
 #endif
 };
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index ebde1d943e55..e595e6541770 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -243,7 +243,7 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 		write_unlock(&eb->lock);
 		return 0;
 	}
-	atomic_inc(&eb->write_locks);
+	btrfs_assert_tree_write_locks_get(eb);
 	btrfs_assert_spinning_writers_get(eb);
 	eb->lock_owner = current->pid;
 	return 1;
@@ -310,7 +310,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
 		goto again;
 	}
 	btrfs_assert_spinning_writers_get(eb);
-	atomic_inc(&eb->write_locks);
+	btrfs_assert_tree_write_locks_get(eb);
 	eb->lock_owner = current->pid;
 }
 
@@ -325,7 +325,7 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 
 	btrfs_assert_tree_locked(eb);
 	eb->lock_owner = 0;
-	atomic_dec(&eb->write_locks);
+	btrfs_assert_tree_write_locks_put(eb);
 
 	if (blockers) {
 		btrfs_assert_no_spinning_writers(eb);
-- 
2.20.1

