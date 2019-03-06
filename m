Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35E4C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 06:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE692064A
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 06:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfCFGTQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 01:19:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:48156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCFGTQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Mar 2019 01:19:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5A340ADD7
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2019 06:19:14 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 1/3] btrfs: Introduce performance profiler
Date:   Wed,  6 Mar 2019 14:19:05 +0800
Message-Id: <20190306061907.29685-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190306061907.29685-1-wqu@suse.com>
References: <20190306061907.29685-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch introduce the skeleton of btrfs performance profiler.

The objective of btrfs performance profiler is to provide various
indicator to locate possible performance bottleneck.

Initial btrfs profiler only supports sleepable tree lock anaylyse for
the following trees:
- fs/subvolume trees
- extent tree
- root tree
- all other trees

This patch is just the basic skeleton for alloc/free.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/Makefile  |  2 +-
 fs/btrfs/ctree.h   |  3 +++
 fs/btrfs/disk-io.c |  6 ++++++
 fs/btrfs/perf.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/perf.h    | 27 ++++++++++++++++++++++++
 5 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/perf.c
 create mode 100644 fs/btrfs/perf.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index ca693dd554e9..7b20d93e4988 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -10,7 +10,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o zstd.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
-	   uuid-tree.o props.o free-space-tree.o tree-checker.o
+	   uuid-tree.o props.o free-space-tree.o tree-checker.o perf.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7a2a2621f0d9..a64f81da0c5e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1163,6 +1163,9 @@ struct btrfs_fs_info {
 	spinlock_t swapfile_pins_lock;
 	struct rb_root swapfile_pins;
 
+	/* performance profiler */
+	struct btrfs_perf_profiler *profiler;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6a2a2a951705..a2a4ae344c38 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -38,6 +38,7 @@
 #include "compression.h"
 #include "tree-checker.h"
 #include "ref-verify.h"
+#include "perf.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
@@ -2608,6 +2609,9 @@ int open_ctree(struct super_block *sb,
 	int clear_free_space_tree = 0;
 	int level;
 
+	fs_info->profiler = btrfs_perf_alloc_profiler();
+	if (IS_ERR(fs_info->profiler))
+		return PTR_ERR(fs_info->profiler);
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	if (!tree_root || !chunk_root) {
@@ -3330,6 +3334,7 @@ int open_ctree(struct super_block *sb,
 fail:
 	btrfs_free_stripe_hash_table(fs_info);
 	btrfs_close_devices(fs_info->fs_devices);
+	btrfs_perf_free_profiler(fs_info);
 	return err;
 
 recovery_tree_root:
@@ -4043,6 +4048,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_free_stripe_hash_table(fs_info);
 	btrfs_free_ref_cache(fs_info);
 
+	btrfs_perf_free_profiler(fs_info);
 	while (!list_empty(&fs_info->pinned_chunks)) {
 		struct extent_map *em;
 
diff --git a/fs/btrfs/perf.c b/fs/btrfs/perf.c
new file mode 100644
index 000000000000..2880111f3b0c
--- /dev/null
+++ b/fs/btrfs/perf.c
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+ */
+
+#include "perf.h"
+
+/*
+ * Allocate and initialize the performance profiler
+ *
+ * Return valid pointer if everything worked.
+ * Return error pointer if something went wrong.
+ */
+struct btrfs_perf_profiler *btrfs_perf_alloc_profiler(void)
+{
+	struct btrfs_perf_profiler *profiler;
+	int ret;
+	int last_failed;
+	int i;
+
+	profiler = kmalloc(sizeof(*profiler), GFP_KERNEL);
+	if (!profiler)
+		return ERR_PTR(-ENOMEM);
+	for (i = 0; i < BTRFS_PERF_LAST; i++) {
+		ret = percpu_counter_init(&profiler->perf_counters[i], 0,
+					  GFP_KERNEL);
+		if (ret < 0) {
+			last_failed = i;
+			goto cleanup;
+		}
+	}
+	profiler->last_sample = ktime_get_ns();
+	return profiler;
+cleanup:
+	for (i = 0; i < last_failed; i++)
+		percpu_counter_destroy(&profiler->perf_counters[i]);
+	return ERR_PTR(ret);
+}
+
+void btrfs_perf_free_profiler(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_perf_profiler *profiler = fs_info->profiler;
+	int i;
+
+	if (!profiler)
+		return;
+	fs_info->profiler = NULL;
+	for (i = 0; i < BTRFS_PERF_LAST; i++)
+		percpu_counter_destroy(&profiler->perf_counters[i]);
+	kfree(profiler);
+}
+
diff --git a/fs/btrfs/perf.h b/fs/btrfs/perf.h
new file mode 100644
index 000000000000..9dbea6458d86
--- /dev/null
+++ b/fs/btrfs/perf.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 SUSE Linux Products GmbH. All Rights Reserved.
+ */
+
+#ifndef BTRFS_PERF_H
+#define BTRFS_PERF_H
+
+#include "ctree.h"
+
+enum {
+	BTRFS_PERF_TREE_LOCK_FS,
+	BTRFS_PERF_TREE_LOCK_EXTENT,
+	BTRFS_PERF_TREE_LOCK_ROOT,
+	BTRFS_PERF_TREE_LOCK_OTHER,
+	BTRFS_PERF_LAST,
+};
+
+struct btrfs_perf_profiler {
+	/* timestamp (ns) of last sample */
+	u64 last_sample;
+	struct percpu_counter perf_counters[BTRFS_PERF_LAST];
+};
+
+struct btrfs_perf_profiler *btrfs_perf_alloc_profiler(void);
+void btrfs_perf_free_profiler(struct btrfs_fs_info *fs_info);
+#endif
-- 
2.21.0

