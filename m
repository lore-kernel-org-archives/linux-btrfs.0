Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B742C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 06:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA0DB2064A
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 06:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfCFGTS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 01:19:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:48170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCFGTS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Mar 2019 01:19:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 91614ADD3
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2019 06:19:16 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/3] btrfs: locking: Add hooks for btrfs perf
Date:   Wed,  6 Mar 2019 14:19:06 +0800
Message-Id: <20190306061907.29685-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190306061907.29685-1-wqu@suse.com>
References: <20190306061907.29685-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For btrfs tree locking, there are only 2 functions can sleep:
- btrfs_tree_read_lock()
  It will wait for any blocking writers
- btrfs_tree_lock()
  It will wait for any blocking readers or writers

Other functions only depends on rwlock which won't sleep.
We doesn't really care about the spinning lock version.

The overheads introduced are:
- two ktime_get() calls
- several if branches
- percpu_counter_add()

Which should be smaller than to ftrace function_graph.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/locking.c | 11 +++++++++++
 fs/btrfs/perf.c    | 20 ++++++++++++++++++++
 fs/btrfs/perf.h    |  8 ++++++++
 3 files changed, 39 insertions(+)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 1da768e5ef75..c23c8f7450e8 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -11,6 +11,7 @@
 #include "ctree.h"
 #include "extent_io.h"
 #include "locking.h"
+#include "perf.h"
 
 static void btrfs_assert_tree_read_locked(struct extent_buffer *eb);
 
@@ -85,10 +86,14 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
  */
 void btrfs_tree_read_lock(struct extent_buffer *eb)
 {
+	u64 start_ns;
+
+	start_ns = btrfs_perf_start();
 again:
 	BUG_ON(!atomic_read(&eb->blocking_writers) &&
 	       current->pid == eb->lock_owner);
 
+
 	read_lock(&eb->lock);
 	if (atomic_read(&eb->blocking_writers) &&
 	    current->pid == eb->lock_owner) {
@@ -101,16 +106,19 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 		BUG_ON(eb->lock_nested);
 		eb->lock_nested = 1;
 		read_unlock(&eb->lock);
+		btrfs_perf_end(eb->fs_info, btrfs_header_owner(eb), start_ns);
 		return;
 	}
 	if (atomic_read(&eb->blocking_writers)) {
 		read_unlock(&eb->lock);
+
 		wait_event(eb->write_lock_wq,
 			   atomic_read(&eb->blocking_writers) == 0);
 		goto again;
 	}
 	atomic_inc(&eb->read_locks);
 	atomic_inc(&eb->spinning_readers);
+	btrfs_perf_end(eb->fs_info, btrfs_header_owner(eb), start_ns);
 }
 
 /*
@@ -227,7 +235,9 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
  */
 void btrfs_tree_lock(struct extent_buffer *eb)
 {
+	u64 start_ns;
 	WARN_ON(eb->lock_owner == current->pid);
+	start_ns = btrfs_perf_start();
 again:
 	wait_event(eb->read_lock_wq, atomic_read(&eb->blocking_readers) == 0);
 	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
@@ -248,6 +258,7 @@ void btrfs_tree_lock(struct extent_buffer *eb)
 	atomic_inc(&eb->spinning_writers);
 	atomic_inc(&eb->write_locks);
 	eb->lock_owner = current->pid;
+	btrfs_perf_end(eb->fs_info, btrfs_header_owner(eb), start_ns);
 }
 
 /*
diff --git a/fs/btrfs/perf.c b/fs/btrfs/perf.c
index 2880111f3b0c..893bfad8e6d3 100644
--- a/fs/btrfs/perf.c
+++ b/fs/btrfs/perf.c
@@ -50,3 +50,23 @@ void btrfs_perf_free_profiler(struct btrfs_fs_info *fs_info)
 	kfree(profiler);
 }
 
+void btrfs_perf_end(struct btrfs_fs_info *fs_info, u64 eb_owner, u64 start_ns)
+{
+	struct btrfs_perf_profiler *profiler = fs_info->profiler;
+	u64 end_ns;
+	int i;
+
+	if (!profiler)
+		return;
+
+	end_ns = ktime_get_ns();
+	if (eb_owner == BTRFS_ROOT_TREE_OBJECTID)
+		i = BTRFS_PERF_TREE_LOCK_ROOT;
+	else if (is_fstree(eb_owner))
+		i = BTRFS_PERF_TREE_LOCK_FS;
+	else if (eb_owner == BTRFS_EXTENT_TREE_OBJECTID)
+		i = BTRFS_PERF_TREE_LOCK_EXTENT;
+	else
+		i = BTRFS_PERF_TREE_LOCK_OTHER;
+	percpu_counter_add(&profiler->perf_counters[i], end_ns - start_ns);
+}
diff --git a/fs/btrfs/perf.h b/fs/btrfs/perf.h
index 9dbea6458d86..7cf4b8c9a0ad 100644
--- a/fs/btrfs/perf.h
+++ b/fs/btrfs/perf.h
@@ -24,4 +24,12 @@ struct btrfs_perf_profiler {
 
 struct btrfs_perf_profiler *btrfs_perf_alloc_profiler(void);
 void btrfs_perf_free_profiler(struct btrfs_fs_info *fs_info);
+void btrfs_perf_update_lock(struct btrfs_fs_info *fs_info,
+			    u64 eb_owner, u64 ns_diff);
+static inline u64 btrfs_perf_start(void)
+{
+	return ktime_get_ns();
+}
+
+void btrfs_perf_end(struct btrfs_fs_info *fs_info, u64 eb_owner, u64 start_ns);
 #endif
-- 
2.21.0

