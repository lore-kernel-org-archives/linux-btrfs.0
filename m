Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4726AC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2787920870
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfAWRik (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:37966 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbfAWRik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1ED09B080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C655ADA6F5; Wed, 23 Jan 2019 18:38:06 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/6] btrfs: split btrfs_clear_lock_blocking_rw to read and write helpers
Date:   Wed, 23 Jan 2019 18:38:06 +0100
Message-Id: <294ca5b399373f93d9c52cd58faf83c6b8cbecc5.1548264220.git.dsterba@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548264220.git.dsterba@suse.com>
References: <cover.1548264220.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are many callers that hardcode the desired lock type so we can
avoid the switch and call them directly. Split the current function to
two. There are no remaining users of btrfs_clear_lock_blocking_rw so
it's removed.  The call sites will be converted in followup patches.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 47 ++++++++++++++++++++++++----------------------
 fs/btrfs/locking.h |  7 ++-----
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 7201d000f61d..7f89ca6f1fbc 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -48,11 +48,24 @@ void btrfs_set_lock_blocking_write(struct extent_buffer *eb)
 	}
 }
 
-/*
- * if we currently have a blocking lock, take the spinlock
- * and drop our blocking count
- */
-void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
+void btrfs_clear_lock_blocking_read(struct extent_buffer *eb)
+{
+	/*
+	 * No lock is required.  The lock owner may change if we have a read
+	 * lock, but it won't change to or away from us.  If we have the write
+	 * lock, we are the owner and it'll never change.
+	 */
+	if (eb->lock_nested && current->pid == eb->lock_owner)
+		return;
+	BUG_ON(atomic_read(&eb->blocking_readers) == 0);
+	read_lock(&eb->lock);
+	atomic_inc(&eb->spinning_readers);
+	/* atomic_dec_and_test implies a barrier */
+	if (atomic_dec_and_test(&eb->blocking_readers))
+		cond_wake_up_nomb(&eb->read_lock_wq);
+}
+
+void btrfs_clear_lock_blocking_write(struct extent_buffer *eb)
 {
 	/*
 	 * no lock is required.  The lock owner may change if
@@ -62,23 +75,13 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 	 */
 	if (eb->lock_nested && current->pid == eb->lock_owner)
 		return;
-
-	if (rw == BTRFS_WRITE_LOCK_BLOCKING) {
-		BUG_ON(atomic_read(&eb->blocking_writers) != 1);
-		write_lock(&eb->lock);
-		WARN_ON(atomic_read(&eb->spinning_writers));
-		atomic_inc(&eb->spinning_writers);
-		/* atomic_dec_and_test implies a barrier */
-		if (atomic_dec_and_test(&eb->blocking_writers))
-			cond_wake_up_nomb(&eb->write_lock_wq);
-	} else if (rw == BTRFS_READ_LOCK_BLOCKING) {
-		BUG_ON(atomic_read(&eb->blocking_readers) == 0);
-		read_lock(&eb->lock);
-		atomic_inc(&eb->spinning_readers);
-		/* atomic_dec_and_test implies a barrier */
-		if (atomic_dec_and_test(&eb->blocking_readers))
-			cond_wake_up_nomb(&eb->read_lock_wq);
-	}
+	BUG_ON(atomic_read(&eb->blocking_writers) != 1);
+	write_lock(&eb->lock);
+	WARN_ON(atomic_read(&eb->spinning_writers));
+	atomic_inc(&eb->spinning_writers);
+	/* atomic_dec_and_test implies a barrier */
+	if (atomic_dec_and_test(&eb->blocking_writers))
+		cond_wake_up_nomb(&eb->write_lock_wq);
 }
 
 /*
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 0453a4797693..3f81d6900c71 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -19,7 +19,8 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb);
 void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb);
 void btrfs_set_lock_blocking_read(struct extent_buffer *eb);
 void btrfs_set_lock_blocking_write(struct extent_buffer *eb);
-void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw);
+void btrfs_clear_lock_blocking_read(struct extent_buffer *eb);
+void btrfs_clear_lock_blocking_write(struct extent_buffer *eb);
 void btrfs_assert_tree_locked(struct extent_buffer *eb);
 int btrfs_try_tree_read_lock(struct extent_buffer *eb);
 int btrfs_try_tree_write_lock(struct extent_buffer *eb);
@@ -55,8 +56,4 @@ static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)
 	btrfs_set_lock_blocking_rw(eb, BTRFS_WRITE_LOCK);
 }
 
-static inline void btrfs_clear_lock_blocking(struct extent_buffer *eb)
-{
-	btrfs_clear_lock_blocking_rw(eb, BTRFS_WRITE_LOCK_BLOCKING);
-}
 #endif
-- 
2.20.1

