Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF2AC43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 06:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 143272064A
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 06:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfCFGTV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 01:19:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:48190 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfCFGTU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Mar 2019 01:19:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF039ADD3
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2019 06:19:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 3/3] btrfs: perf: Add RO sysfs interface to collect perf result
Date:   Wed,  6 Mar 2019 14:19:07 +0800
Message-Id: <20190306061907.29685-4-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190306061907.29685-1-wqu@suse.com>
References: <20190306061907.29685-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch adds a new sys fs interface, 'profiler', for user to get
real time performance data.

The content of /sys/fs/btrfs/<FDID>/profiler is generated at the time of
read, so user could have full control of the duration resolution.

The output example would be:
timestamp = 16364075995092ns
duration = 1025342515ns
TREE_LOCK_FS = 417160165ns (40.68%)
TREE_LOCK_EXTENT = 45087670ns (4.39%)
TREE_LOCK_ROOT = 1555506ns (0.15%)
TREE_LOCK_OTHER = 20387436ns (1.98%)

The 'timestamp' content is directly from ktime_get_ns(), which starts from
kernel boot, and doesn't count hibernation/suspension.
The 'duration' content is the time difference between last sample, in
nanoseconds. Doesn't count hibernation or suspension either.

The 'TREE_LOCK_*' content is the time spent on sleepable tree lock.
The percentage in the round brackets is the sleep time compared to
duration, which can be larger than 100%.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/perf.c  | 20 ++++++++++++++++++++
 fs/btrfs/perf.h  |  9 +++++++++
 fs/btrfs/sysfs.c | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/fs/btrfs/perf.c b/fs/btrfs/perf.c
index 893bfad8e6d3..d1c11b91eeb8 100644
--- a/fs/btrfs/perf.c
+++ b/fs/btrfs/perf.c
@@ -70,3 +70,23 @@ void btrfs_perf_end(struct btrfs_fs_info *fs_info, u64 eb_owner, u64 start_ns)
 		i = BTRFS_PERF_TREE_LOCK_OTHER;
 	percpu_counter_add(&profiler->perf_counters[i], end_ns - start_ns);
 }
+
+void btrfs_perf_report(struct btrfs_fs_info *fs_info,
+		       struct btrfs_perf_result *result)
+{
+	struct btrfs_perf_profiler *profiler = fs_info->profiler;
+	u64 end_ns = ktime_get_ns();
+	int i;
+
+	if (!profiler || !result)
+		return;
+
+	for (i = 0; i < BTRFS_PERF_LAST; i++) {
+		result->results_ns[i] =
+			percpu_counter_sum(&profiler->perf_counters[i]);
+		percpu_counter_set(&profiler->perf_counters[i], 0);
+	}
+	result->current_ns = end_ns;
+	result->duration_ns = end_ns - profiler->last_sample;
+	profiler->last_sample = end_ns;
+}
diff --git a/fs/btrfs/perf.h b/fs/btrfs/perf.h
index 7cf4b8c9a0ad..0af12aa148b4 100644
--- a/fs/btrfs/perf.h
+++ b/fs/btrfs/perf.h
@@ -22,6 +22,12 @@ struct btrfs_perf_profiler {
 	struct percpu_counter perf_counters[BTRFS_PERF_LAST];
 };
 
+struct btrfs_perf_result {
+	u64 current_ns;
+	u64 duration_ns;
+	u64 results_ns[BTRFS_PERF_LAST];
+};
+
 struct btrfs_perf_profiler *btrfs_perf_alloc_profiler(void);
 void btrfs_perf_free_profiler(struct btrfs_fs_info *fs_info);
 void btrfs_perf_update_lock(struct btrfs_fs_info *fs_info,
@@ -32,4 +38,7 @@ static inline u64 btrfs_perf_start(void)
 }
 
 void btrfs_perf_end(struct btrfs_fs_info *fs_info, u64 eb_owner, u64 start_ns);
+
+void btrfs_perf_report(struct btrfs_fs_info *fs_info,
+		       struct btrfs_perf_result *result);
 #endif
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 5a5930e3d32b..2b5d72b699d8 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -16,6 +16,7 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "perf.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj);
@@ -456,6 +457,43 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 
 BTRFS_ATTR(, sectorsize, btrfs_sectorsize_show);
 
+#define print_one_result(name)					\
+({								\
+	tmp = result.results_ns[BTRFS_PERF_##name];		\
+	size += snprintf(buf + size, PAGE_SIZE - size,		\
+			 "%s = %lluns (%llu.%02llu%%)\n",	\
+			 #name, tmp, tmp * 100 / duration,	\
+			 (tmp * 10000 / duration) % 100);	\
+})
+
+static ssize_t btrfs_profiler_show(struct kobject *kobj,
+				struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	struct btrfs_perf_result result = { 0 };
+	u64 tmp;
+	u64 duration;
+	ssize_t size = 0;
+
+	btrfs_perf_report(fs_info, &result);
+	if (result.duration_ns == 0)
+		return snprintf(buf, PAGE_SIZE, "profiler not running\n");
+
+	duration = result.duration_ns;
+	size += snprintf(buf + size, PAGE_SIZE - size, "timestamp = %lluns\n",
+			 result.current_ns);
+	size += snprintf(buf + size, PAGE_SIZE - size, "duration = %lluns\n",
+			 duration);
+	print_one_result(TREE_LOCK_FS);
+	print_one_result(TREE_LOCK_EXTENT);
+	print_one_result(TREE_LOCK_ROOT);
+	print_one_result(TREE_LOCK_OTHER);
+	return size;
+}
+#undef print_one_result
+
+BTRFS_ATTR(, profiler, btrfs_profiler_show);
+
 static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
 {
@@ -525,6 +563,7 @@ static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(, clone_alignment),
 	BTRFS_ATTR_PTR(, quota_override),
 	BTRFS_ATTR_PTR(, metadata_uuid),
+	BTRFS_ATTR_PTR(, profiler),
 	NULL,
 };
 
-- 
2.21.0

