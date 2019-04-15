Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6E4C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 951FF20693
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfDONPf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:15:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:40834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfDONPf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 09:15:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5ED01AEE2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 13:15:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: trace: Introduce trace events for sleepable tree lock
Date:   Mon, 15 Apr 2019 21:15:24 +0800
Message-Id: <20190415131525.20274-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190415131525.20274-1-wqu@suse.com>
References: <20190415131525.20274-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are two tree lock events which can sleep:
- btrfs_tree_read_lock()
- btrfs_tree_lock()

Sometimes we may need to look into the concurrency picture of the fs.
For that case, we need the execution time of above two functions and the
owner of @eb.

Here we introduce a trace events for user space tools like bcc, to get
the execution time of above two functions, and get detailed owner info
where eBPF code can't.

All the overhead is hidden behind the trace events, so if events are not
enabled, there is no overhead.

These trace events also output bytenr and generation, allow them to be
pared with unlock events to pin down deadlock.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/locking.c           | 12 ++++++++++
 include/trace/events/btrfs.h | 44 ++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 82b84e4daad1..b414d64172b2 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -90,6 +90,10 @@ void btrfs_clear_lock_blocking_write(struct extent_buffer *eb)
  */
 void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
+	u64 start_ns = 0;
+
+	if (trace_btrfs_tree_read_lock_enabled())
+		start_ns = ktime_get_ns();
 again:
 	BUG_ON(!atomic_read(&eb->blocking_writers) &&
 	       current->pid == eb->lock_owner);
@@ -106,6 +110,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 		BUG_ON(eb->lock_nested);
 		eb->lock_nested = 1;
 		read_unlock(&eb->lock);
+		trace_btrfs_tree_read_lock(eb, start_ns);
 		return;
 	}
 	if (atomic_read(&eb->blocking_writers)) {
@@ -116,6 +121,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 	}
 	atomic_inc(&eb->read_locks);
 	atomic_inc(&eb->spinning_readers);
+	trace_btrfs_tree_read_lock(eb, start_ns);
 }
 
 /*
@@ -232,6 +238,11 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  */
 void btrfs_tree_lock(struct extent_buffer *eb)
 {
+	u64 start_ns = 0;
+
+	if (trace_btrfs_tree_lock_enabled())
+		start_ns = ktime_get_ns();
+
 	WARN_ON(eb->lock_owner == current->pid);
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
@@ -246,6 +257,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
 	atomic_inc(&eb->spinning_writers);
 	atomic_inc(&eb->write_locks);
 	eb->lock_owner = current->pid;
+	trace_btrfs_tree_lock(eb, start_ns);
 }
 
 /*
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index ab1cc33adbac..389f4722ca02 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1850,6 +1850,50 @@ DEFINE_EVENT(btrfs__block_group, btrfs_skip_unused_block_group,
 	TP_ARGS(bg_cache)
 );
 
+DECLARE_EVENT_CLASS(btrfs_sleep_tree_lock,
+	TP_PROTO(const struct extent_buffer *eb, u64 start_ns),
+
+	TP_ARGS(eb, start_ns),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	block		)
+		__field(	u64,	generation	)
+		__field(	u64,	start_ns	)
+		__field(	u64,	end_ns		)
+		__field(	u64,	diff_ns		)
+		__field(	u64,	owner		)
+		__field(	int,	is_log_tree	)
+	),
+
+	TP_fast_assign_btrfs(eb->fs_info,
+		__entry->block		= eb->start;
+		__entry->generation	= btrfs_header_generation(eb);
+		__entry->start_ns	= start_ns;
+		__entry->end_ns		= ktime_get_ns();
+		__entry->diff_ns	= __entry->end_ns - start_ns;
+		__entry->owner		= btrfs_header_owner(eb);
+		__entry->is_log_tree	= (eb->log_index >= 0);
+	),
+
+	TP_printk_btrfs(
+"block=%llu generation=%llu start_ns=%llu end_ns=%llu diff_ns=%llu owner=%llu is_log_tree=%d",
+		__entry->block, __entry->generation,
+		__entry->start_ns, __entry->end_ns, __entry->diff_ns,
+		__entry->owner, __entry->is_log_tree)
+);
+
+DEFINE_EVENT(btrfs_sleep_tree_lock, btrfs_tree_read_lock,
+	TP_PROTO(const struct extent_buffer *eb, u64 start_ns),
+
+	TP_ARGS(eb, start_ns)
+);
+
+DEFINE_EVENT(btrfs_sleep_tree_lock, btrfs_tree_lock,
+	TP_PROTO(const struct extent_buffer *eb, u64 start_ns),
+
+	TP_ARGS(eb, start_ns)
+);
+
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.21.0

