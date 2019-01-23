Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093D5C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC03D21872
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfAWRig (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:38:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:37948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbfAWRig (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:38:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B09CBB080
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:38:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 40E73DA6F5; Wed, 23 Jan 2019 18:38:02 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/6] btrfs: split btrfs_set_lock_blocking_rw to read and write helpers
Date:   Wed, 23 Jan 2019 18:38:02 +0100
Message-Id: <559c0f46dae93f2aea0d457087f9987c210ffe94.1548264220.git.dsterba@suse.com>
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
two but leave a helper that still takes the variable lock type to make
current code compile.  The call sites will be converted in followup
patches.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/locking.c | 50 ++++++++++++++++++++++++----------------------
 fs/btrfs/locking.h | 15 +++++++++++++-
 2 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 1da768e5ef75..7201d000f61d 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -14,35 +14,37 @@
 
 static void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
 
-/*
- * if we currently have a spinning reader or writer lock
- * (indicated by the rw flag) this will bump the count
- * of blocking holders and drop the spinlock.
- */
-void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
+void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
 {
 	/*
-	 * no lock is required.  The lock owner may change if
-	 * we have a read lock, but it won't change to or away
-	 * from us.  If we have the write lock, we are the owner
-	 * and it'll never change.
+	 * No lock is required.  The lock owner may change if we have a read
+	 * lock, but it won't change to or away from us.  If we have the write
+	 * lock, we are the owner and it'll never change.
 	 */
 	if (eb->lock_nested && current->pid == eb->lock_owner)
 		return;
-	if (rw == BTRFS_WRITE_LOCK) {
-		if (atomic_read(&eb->blocking_writers) == 0) {
-			WARN_ON(atomic_read(&eb->spinning_writers) != 1);
-			atomic_dec(&eb->spinning_writers);
-			btrfs_assert_tree_locked(eb);
-			atomic_inc(&eb->blocking_writers);
-			write_unlock(&eb->lock);
-		}
-	} else if (rw == BTRFS_READ_LOCK) {
-		btrfs_assert_tree_read_locked(eb);
-		atomic_inc(&eb->blocking_readers);
-		WARN_ON(atomic_read(&eb->spinning_readers) == 0);
-		atomic_dec(&eb->spinning_readers);
-		read_unlock(&eb->lock);
+	btrfs_assert_tree_read_locked(eb);
+	atomic_inc(&eb->blocking_readers);
+	WARN_ON(atomic_read(&eb->spinning_readers) == 0);
+	atomic_dec(&eb->spinning_readers);
+	read_unlock(&eb->lock);
+}
+
+void btrfs_set_lock_blocking_write(struct extent_buffer *eb)
+{
+	/*
+	 * No lock is required.  The lock owner may change if we have a read
+	 * lock, but it won't change to or away from us.  If we have the write
+	 * lock, we are the owner and it'll never change.
+	 */
+	if (eb->lock_nested && current->pid == eb->lock_owner)
+		return;
+	if (atomic_read(&eb->blocking_writers) == 0) {
+		WARN_ON(atomic_read(&eb->spinning_writers) != 1);
+		atomic_dec(&eb->spinning_writers);
+		btrfs_assert_tree_locked(eb);
+		atomic_inc(&eb->blocking_writers);
+		write_unlock(&eb->lock);
 	}
 }
 
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index 29135def468e..0453a4797693 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -17,7 +17,8 @@ void btrfs_tree_unlock(struct extent_buffer *eb);
 void btrfs_tree_read_lock(struct extent_buffer *eb);
 void btrfs_tree_read_unlock(struct extent_buffer *eb);
 void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb);
-void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw);
+void btrfs_set_lock_blocking_read(struct extent_buffer *eb);
+void btrfs_set_lock_blocking_write(struct extent_buffer *eb);
 void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw);
 void btrfs_assert_tree_locked(struct extent_buffer *eb);
 int btrfs_try_tree_read_lock(struct extent_buffer *eb);
@@ -37,6 +38,18 @@ static inline void btrfs_tree_unlock_rw(struct extent_buffer *eb, int rw)
 		BUG();
 }
 
+/*
+ * If we currently have a spinning reader or writer lock (indicated by the rw
+ * flag) this will bump the count of blocking holders and drop the spinlock.
+ */
+static inline void btrfs_set_lock_blocking_rw(struct extent_buffer *eb, int rw)
+{
+	if (rw == BTRFS_WRITE_LOCK)
+		btrfs_set_lock_blocking_write(eb);
+	else if (rw == BTRFS_READ_LOCK)
+		btrfs_set_lock_blocking_read(eb);
+}
+
 static inline void btrfs_set_lock_blocking(struct extent_buffer *eb)
 {
 	btrfs_set_lock_blocking_rw(eb, BTRFS_WRITE_LOCK);
-- 
2.20.1

