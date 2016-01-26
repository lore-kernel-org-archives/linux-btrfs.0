Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54594 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934219AbcAZLGO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 06:06:14 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id A8DDF41824FD
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 19:05:33 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 2/2] btrfs: reada: avoid undone reada extents in btrfs_reada_wait
Date: Tue, 26 Jan 2016 19:04:07 +0800
Message-ID: <a590be094d533be2ccd32a462a7c9f37bd82bd15.1453806157.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <84455a12ceda75ad15a97cdbf01f99787eda0b89.1453806157.git.zhaolei@cn.fujitsu.com>
References: <84455a12ceda75ad15a97cdbf01f99787eda0b89.1453806157.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reada background works is not designed to finish all jobs
completely, it will break in following case:
1: When a device reachs workload limit(MAX_IN_FLIGHT)
2: Total reads reachs max limit(10000)
3: All devices haven't queue more jobs, often happened in DUP case

And if all background works exit with remain jobs,
btrfs_reada_wait() will enter into infinite wait.

Above problem is rarely happened in old code, because:
1: Every works queues 2x new works
   So many works reduced odds of undone jobs.
2: One work will continue 10000 times loop in case of no-jobs
   It reduced no-thread window time.

But after we fixed above case, the "undone reada extents" frequently
happened.

Fix:
 Check to ensure we have at least one thread if there are undone jobs
 in btrfs_reada_wait().

Changelog v1->v2:
 1: RFC->PATCH
 2: Some cleanup and wait_time adjust.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 245a961..12a9c9c 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -953,8 +953,11 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 int btrfs_reada_wait(void *handle)
 {
 	struct reada_control *rc = handle;
+	struct btrfs_fs_info *fs_info = rc->root->fs_info;
 
 	while (atomic_read(&rc->elems)) {
+		if (!atomic_read(&fs_info->reada_works_cnt))
+			reada_start_machine(fs_info);
 		wait_event_timeout(rc->wait, atomic_read(&rc->elems) == 0,
 				   5 * HZ);
 		dump_devs(rc->root->fs_info,
@@ -971,9 +974,13 @@ int btrfs_reada_wait(void *handle)
 int btrfs_reada_wait(void *handle)
 {
 	struct reada_control *rc = handle;
+	struct btrfs_fs_info *fs_info = rc->root->fs_info;
 
 	while (atomic_read(&rc->elems)) {
-		wait_event(rc->wait, atomic_read(&rc->elems) == 0);
+		if (!atomic_read(&fs_info->reada_works_cnt))
+			reada_start_machine(fs_info);
+		wait_event_timeout(rc->wait, atomic_read(&rc->elems) == 0,
+				   (HZ + 9) / 10);
 	}
 
 	kref_put(&rc->refcnt, reada_control_release);
-- 
1.8.5.1



