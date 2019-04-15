Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A65C10F12
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C6B20693
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfDONPj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:15:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:40846 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfDONPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 09:15:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB123AEE2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 13:15:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: trace: Introduce trace events for all btrfs tree locking events
Date:   Mon, 15 Apr 2019 21:15:25 +0800
Message-Id: <20190415131525.20274-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190415131525.20274-1-wqu@suse.com>
References: <20190415131525.20274-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Unlike btrfs_tree_lock() and btrfs_tree_read_lock(), the remaining
functions in locking.c will not sleep, thus doesn't make much sense to
record their execution time.

Those events are introduced mainly for user space tool to audit and
detect lock leakage or dead lock.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/locking.c           | 10 +++++++++
 include/trace/events/btrfs.h | 42 ++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index b414d64172b2..a09823474d9c 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -16,6 +16,7 @@ static void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
 
 void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
 {
+	trace_btrfs_set_lock_blocking_read(eb);
 	/*
 	 * No lock is required.  The lock owner may change if we have a read
 	 * lock, but it won't change to or away from us.  If we have the write
@@ -32,6 +33,7 @@ void btrfs_set_lock_blocking_read(struct extent_buffer *eb)
 
 void btrfs_set_lock_blocking_write(struct extent_buffer *eb)
 {
+	trace_btrfs_set_lock_blocking_write(eb);
 	/*
 	 * No lock is required.  The lock owner may change if we have a read
 	 * lock, but it won't change to or away from us.  If we have the write
@@ -50,6 +52,7 @@ void btrfs_set_lock_blocking_write(struct extent_buffer *eb)
 
 void btrfs_clear_lock_blocking_read(struct extent_buffer *eb)
 {
+	trace_btrfs_clear_lock_blocking_read(eb);
 	/*
 	 * No lock is required.  The lock owner may change if we have a read
 	 * lock, but it won't change to or away from us.  If we have the write
@@ -67,6 +70,7 @@ void btrfs_clear_lock_blocking_read(struct extent_buffer *eb)
 
 void btrfs_clear_lock_blocking_write(struct extent_buffer *eb)
 {
+	trace_btrfs_clear_lock_blocking_write(eb);
 	/*
 	 * no lock is required.  The lock owner may change if
 	 * we have a read lock, but it won't change to or away
@@ -141,6 +145,7 @@ int btrfs_tree_read_lock_atomic(struct extent_buffer *eb)
 	}
 	atomic_inc(&eb->read_locks);
 	atomic_inc(&eb->spinning_readers);
+	trace_btrfs_tree_read_lock_atomic(eb);
 	return 1;
 }
 
@@ -162,6 +167,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 	}
 	atomic_inc(&eb->read_locks);
 	atomic_inc(&eb->spinning_readers);
+	trace_btrfs_try_tree_read_lock(eb);
 	return 1;
 }
 
@@ -184,6 +190,7 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 	atomic_inc(&eb->write_locks);
 	atomic_inc(&eb->spinning_writers);
 	eb->lock_owner = current->pid;
+	trace_btrfs_try_tree_write_lock(eb);
 	return 1;
 }
 
@@ -192,6 +199,7 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
  */
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
+	trace_btrfs_tree_read_unlock(eb);
 	/*
 	 * if we're nested, we have the write lock.  No new locking
 	 * is needed as long as we are the lock owner.
@@ -214,6 +222,7 @@ void btrfs_tree_read_unlock(struct extent_buffer *eb)
  */
 void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 {
+	trace_btrfs_tree_read_unlock_blocking(eb);
 	/*
 	 * if we're nested, we have the write lock.  No new locking
 	 * is needed as long as we are the lock owner.
@@ -270,6 +279,7 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 	BUG_ON(blockers > 1);
 
 	btrfs_assert_tree_locked(eb);
+	trace_btrfs_tree_unlock(eb);
 	eb->lock_owner = 0;
 	atomic_dec(&eb->write_locks);
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 389f4722ca02..052263bd071c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1894,6 +1894,48 @@ DEFINE_EVENT(btrfs_sleep_tree_lock, btrfs_tree_lock,
 	TP_ARGS(eb, start_ns)
 );
 
+DECLARE_EVENT_CLASS(btrfs_locking_events,
+	TP_PROTO(const struct extent_buffer *eb),
+
+	TP_ARGS(eb),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	block		)
+		__field(	u64,	generation	)
+		__field(	u64,	owner		)
+		__field(	int,	is_log_tree	)
+	),
+
+	TP_fast_assign_btrfs(eb->fs_info,
+		__entry->block		= eb->start;
+		__entry->generation	= btrfs_header_generation(eb);
+		__entry->owner		= btrfs_header_owner(eb);
+		__entry->is_log_tree	= (eb->log_index >= 0);
+	),
+
+	TP_printk_btrfs("block=%llu generation=%llu owner=%llu is_log_tree=%d",
+		__entry->block, __entry->generation,
+		__entry->owner, __entry->is_log_tree)
+);
+
+#define DEFINE_BTRFS_LOCK_EVENT(name)				\
+DEFINE_EVENT(btrfs_locking_events, name,			\
+		TP_PROTO(const struct extent_buffer *eb),	\
+								\
+		TP_ARGS(eb)					\
+)
+
+DEFINE_BTRFS_LOCK_EVENT(btrfs_tree_unlock);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_tree_read_unlock);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_tree_read_unlock_blocking);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_set_lock_blocking_read);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_set_lock_blocking_write);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_clear_lock_blocking_read);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_clear_lock_blocking_write);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_try_tree_read_lock);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_try_tree_write_lock);
+DEFINE_BTRFS_LOCK_EVENT(btrfs_tree_read_lock_atomic);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.21.0

