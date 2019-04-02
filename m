Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46C1C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 09:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EB862082C
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 09:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfDBJhF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:37:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:51714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729680AbfDBJhF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 05:37:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B4B1AF19
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2019 09:37:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: trace: Introduce trace events for sleepable tree lock
Date:   Tue,  2 Apr 2019 17:37:00 +0800
Message-Id: <20190402093700.7127-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
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

This patch introduce one overhead for those two functions, extra
ktime_get_ns() call, which should be pretty small.

The other ktime_get_ns() call needed won't be enabled until those events
are enabled, so they won't cause extra overhead.

Also, since this patch and later user space tool only cares about the
execution time and owner, other info like bytenr is ignored in this
events.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/locking.c           |  6 ++++++
 include/trace/events/btrfs.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 6df03ba36026..169c0a4ff090 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -158,6 +158,7 @@ void btrfs_clear_lock_blocking_write(struct extent_buffer *eb)
  */
 void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
+	u64 start_ns = ktime_get_ns();
 again:
 	BUG_ON(!atomic_read(&eb->blocking_writers) &&
 	       current->pid == eb->lock_owner);
@@ -174,6 +175,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 		BUG_ON(eb->lock_nested);
 		eb->lock_nested = true;
 		read_unlock(&eb->lock);
+		trace_btrfs_tree_read_lock(eb, start_ns);
 		return;
 	}
 	if (atomic_read(&eb->blocking_writers)) {
@@ -184,6 +186,7 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 	}
 	btrfs_assert_tree_read_locks_get(eb);
 	btrfs_assert_spinning_readers_get(eb);
+	trace_btrfs_tree_read_lock(eb, start_ns);
 }
 
 /*
@@ -299,6 +302,8 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  */
 void btrfs_tree_lock(struct extent_buffer *eb)
 {
+	u64 start_ns = ktime_get_ns();
+
 	WARN_ON(eb->lock_owner == current->pid);
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
@@ -312,6 +317,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
 	btrfs_assert_spinning_writers_get(eb);
 	btrfs_assert_tree_write_locks_get(eb);
 	eb->lock_owner = current->pid;
+	trace_btrfs_tree_lock(eb, start_ns);
 }
 
 /*
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8b12753fee78..406a71571254 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -2005,6 +2005,42 @@ TRACE_EVENT(btrfs_convert_extent_bit,
 		  __print_flags(__entry->clear_bits, "|", EXTENT_FLAGS))
 );
 
+DECLARE_EVENT_CLASS(btrfs_sleep_tree_lock,
+	TP_PROTO(const struct extent_buffer *eb, u64 start_ns),
+
+	TP_ARGS(eb, start_ns),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	start_ns	)
+		__field(	u64,	end_ns		)
+		__field(	u64,	owner		)
+		__field(	int,	is_log_tree	)
+	),
+
+	TP_fast_assign_btrfs(eb->fs_info,
+		__entry->start_ns	= start_ns;
+		__entry->end_ns		= ktime_get_ns();
+		__entry->owner		= btrfs_header_owner(eb);
+		__entry->is_log_tree	= (eb->log_index >= 0);
+	),
+
+	TP_printk_btrfs("start_ns=%llu end_ns=%llu owner=%llu is_log_tree=%d",
+		__entry->start_ns, __entry->end_ns, __entry->owner,
+		__entry->is_log_tree)
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

