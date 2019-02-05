Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51C3C282CC
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 19:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B0222083B
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549394772;
	bh=UfT2vkhYQFKvB8mTZOCWx5MGN/eLNncFnZQ+08MoEWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=15wM+OLVGOrcl6tVuxR4HPHV32Vw60YkeNGvxMt/qjKQYi2sLHbxIKLwVwOSNQcdu
	 DfOvO9V9QaTipqmnpTGILgNus94iHajGgv0uUmXTBlpakvuTpXMSXUz3E+x///qXed
	 8II8JMU2f4Kvs1KoVzWerT+OmuG8L+B5xJqWk+rQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfBET0H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:26:07 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40535 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfBET0G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 14:26:06 -0500
Received: by mail-yw1-f68.google.com with SMTP id g194so2143196ywe.7;
        Tue, 05 Feb 2019 11:26:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uuNCrPpc9eBXMZzPRtVaItvTz5NbyCUmghU2feLsu88=;
        b=B/5QC0Af9ktUqlJ8pKmAbwbREQoA1jex1j/8KNay57BfF0/PDqPKTbNXpfnH6YwYnc
         b1CuDPeZhs4VrE2en0T0I174Q3dmJKK6s4/75rBpFKBjUOqJ/yO8m4YoxiCrhbBeSH8Q
         Dx23sR5BBGjAImDsIDRHYoy8iHm2CNxSbhydEKU/7truR0lrUs6lF2tKHC3yZVQRW30/
         AWvmAKwUfz+ffkkbNm2RfKvKR9kGmHw0VxEHsHosITdRocTibUEbF5ueVpjEAmCLrgPL
         vSoHHHiBpAcf9CWDeqrTtlVHX0Gen3ifZup9bF0t0MpOPn2moWryUbHC+htZZ0BUSp1P
         jabQ==
X-Gm-Message-State: AHQUAubzRRXT1ncT2gewC1JMzmfQNzyolUGX/6udxFTw3Y0DayWQewBe
        mzlRaTEbGkpFxTUfYArAFn0=
X-Google-Smtp-Source: AHgI3Ia3/c1JAzTSe72ftYeMYMZnUcldLp5uMnELVBDg+M24JdmGoPYjR6oggpKAIn3uLz0EkGOMYA==
X-Received: by 2002:a81:7785:: with SMTP id s127mr5472949ywc.375.1549394765227;
        Tue, 05 Feb 2019 11:26:05 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::6:6d9d])
        by smtp.gmail.com with ESMTPSA id z74sm2132628ywz.51.2019.02.05.11.26.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 11:26:04 -0800 (PST)
Date:   Tue, 5 Feb 2019 14:26:02 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/12] btrfs: add zstd compression level support
Message-ID: <20190205192602.GA24701@dennisz-mbp.dhcp.thefacebook.com>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190204202008.51652-13-dennis@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204202008.51652-13-dennis@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From 0d8684d1d7b18dfa9d5bc9c74033c6c3b6fecd92 Mon Sep 17 00:00:00 2001
From: Dennis Zhou <dennis@kernel.org>
Date: Sat, 19 Jan 2019 18:51:39 -0800

Zstd compression requires different amounts of memory for each level of
compression. The prior patches implemented indirection to allow for each
compression type to manage their workspaces independently. This patch
uses this indirection to implement compression level support for zstd.

To manage the additional memory require, each compression level has its
own queue of workspaces. A global LRU is used to help with reclaim.
Reclaim is done via a timer which provides a mechanism to decrease
memory utilization by keeping only workspaces around that are sized
appropriately. Forward progress is guaranteed by a preallocated max
workspace hidden from the LRU.

When getting a workspace, it uses a bitmap to identify the levels that
are populated and scans up. If it finds a workspace that is greater than
it, it uses it, but does not update the last_used time and the
corresponding place in the LRU. If we hit memory pressure, we sleep on
the max level workspace. We continue to rescan in case we can use a
smaller workspace, but eventually should be able to obtain the max level
workspace or allocate one again should memory pressure subside.

The memory requirement for decompression is the same as level 1, and
therefore can use any of available workspace.

The number of workspaces is bound by an upper limit of the workqueue's
limit which currently is 2 (percpu limit). The reclaim timer is used to
free inactive/improperly sized workspaces and is set to 307s to avoid
colliding with transaction commit (every 30s).

Repeating the experiment from v2 [1], the Silesia corpus was copied to a
btrfs filesystem 10 times and then read back after dropping the caches.
The btrfs filesystem was on an SSD.

Level   Ratio   Compression (MB/s)  Decompression (MB/s)  Memory (KB)
1       2.658        438.47                910.51            780
2       2.744        364.86                886.55           1004
3       2.801        336.33                828.41           1260
4       2.858        286.71                886.55           1260
5       2.916        212.77                556.84           1388
6       2.363        119.82                990.85           1516
7       3.000        154.06                849.30           1516
8       3.011        159.54                875.03           1772
9       3.025        100.51                940.15           1772
10      3.033        118.97                616.26           1772
11      3.036         94.19                802.11           1772
12      3.037         73.45                931.49           1772
13      3.041         55.17                835.26           2284
14      3.087         44.70                716.78           2547
15      3.126         37.30                878.84           2547

[1] https://lore.kernel.org/linux-btrfs/20181031181108.289340-1-terrelln@fb.com/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Omar Sandoval <osandov@osandov.com>
---
v2:
- increase reclaim timer to 307s from 67s
- move from keeping track of time in ns to jiffies
- remove timer in cleanup code (use del_timer_sync)
- use min_t() instead of if statements in .set_level()
- add header text to describe how workspaces are managed
- nofs_flag type -> unsigned long to unsigned int

 fs/btrfs/super.c |   6 +-
 fs/btrfs/zstd.c  | 245 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 242 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b28dff207383..0ecc513cb56c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -544,9 +544,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 				no_compress = 0;
-			} else if (strcmp(args[0].from, "zstd") == 0) {
+			} else if (strncmp(args[0].from, "zstd", 4) == 0) {
 				compress_type = "zstd";
 				info->compress_type = BTRFS_COMPRESS_ZSTD;
+				info->compress_level =
+					btrfs_compress_str2level(
+							 BTRFS_COMPRESS_ZSTD,
+							 args[0].from + 4);
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 2231123fedbe..54219c84320c 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -3,24 +3,45 @@
  * Copyright (c) 2016-present, Facebook, Inc.
  * All rights reserved.
  *
+ * Zstd Workspace Management:
+ * Zstd workspaces have different memory requirements depending on the level.
+ * The zstd workspaces are managed by having individual lists for each level
+ * and a global lru.  Forward progress is maintained by protecting a max level
+ * workspace.
+ *
+ * Getting a workspace is done by using the bitmap to identify the levels that
+ * have available workspaces and scans up.  This lets us recycle higher level
+ * workspaces because of the monotonic memory guarantee.  A workspace's
+ * last_used is only updated if it is being used by the corresponding memory
+ * level.  Putting a workspace involves adding it back to the appropriate places
+ * and adding it back to the lru if necessary.
+ *
+ * A timer is used to reclaim workspaces if they have not been used for
+ * ZSTD_BTRFS_RECLAIM_JIFFIES.  This helps keep only active workspaces around.
+ * The upper bound is provided by the workqueue limit which is 2 (percpu limit).
  */
 
 #include <linux/bio.h>
+#include <linux/bitmap.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/sched/mm.h>
 #include <linux/pagemap.h>
 #include <linux/refcount.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/zstd.h>
 #include "compression.h"
+#include "ctree.h"
 
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
 #define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
 #define ZSTD_BTRFS_DEFAULT_LEVEL 3
 #define ZSTD_BTRFS_MAX_LEVEL 15
+/* 307s to avoid pathologically clashing with transaction commit */
+#define ZSTD_BTRFS_RECLAIM_JIFFIES (307 * HZ)
 
 static ZSTD_parameters zstd_get_btrfs_parameters(unsigned int level,
 						 size_t src_len)
@@ -37,16 +58,81 @@ struct workspace {
 	void *mem;
 	size_t size;
 	char *buf;
+	unsigned int level;
 	unsigned int req_level;
+	unsigned long last_used; /* jiffies */
 	struct list_head list;
+	struct list_head lru_list;
 	ZSTD_inBuffer in_buf;
 	ZSTD_outBuffer out_buf;
 };
 
-static struct workspace_manager wsm;
+struct zstd_workspace_manager {
+	const struct btrfs_compress_op *ops;
+	spinlock_t lock;
+	struct list_head lru_list;
+	struct list_head idle_ws[ZSTD_BTRFS_MAX_LEVEL];
+	unsigned long active_map;
+	wait_queue_head_t wait;
+	struct timer_list timer;
+};
+
+static struct zstd_workspace_manager wsm;
 
 static size_t zstd_ws_mem_sizes[ZSTD_BTRFS_MAX_LEVEL];
 
+static inline struct workspace *list_to_workspace(struct list_head *list)
+{
+	return container_of(list, struct workspace, list);
+}
+
+/*
+ * zstd_reclaim_timer_fn - reclaim timer
+ * @t: timer
+ *
+ * This scans the lru_list and attempts to reclaim any workspace that hasn't
+ * been used for ZSTD_BTRFS_RECLAIM_JIFFIES.
+ */
+static void zstd_reclaim_timer_fn(struct timer_list *t)
+{
+	unsigned long reclaim_threshold = jiffies - ZSTD_BTRFS_RECLAIM_JIFFIES;
+	struct list_head *pos, *next;
+
+	spin_lock(&wsm.lock);
+
+	if (list_empty(&wsm.lru_list)) {
+		spin_unlock(&wsm.lock);
+		return;
+	}
+
+	list_for_each_prev_safe(pos, next, &wsm.lru_list) {
+		struct workspace *victim = container_of(pos, struct workspace,
+							lru_list);
+		unsigned int level;
+
+		if (time_after(victim->last_used, reclaim_threshold))
+			break;
+
+		/* workspace is in use */
+		if (victim->req_level)
+			continue;
+
+		level = victim->level;
+		list_del(&victim->lru_list);
+		list_del(&victim->list);
+		wsm.ops->free_workspace(&victim->list);
+
+		if (list_empty(&wsm.idle_ws[level - 1]))
+			clear_bit(level - 1, &wsm.active_map);
+
+	}
+
+	if (!list_empty(&wsm.lru_list))
+		mod_timer(&wsm.timer, jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
+
+	spin_unlock(&wsm.lock);
+}
+
 /*
  * zstd_calc_ws_mem_sizes - calculate monotonic memory bounds
  *
@@ -76,29 +162,165 @@ static void zstd_calc_ws_mem_sizes(void)
 
 static void zstd_init_workspace_manager(void)
 {
+	struct list_head *ws;
+	int i;
+
 	zstd_calc_ws_mem_sizes();
 
-	btrfs_init_workspace_manager(&wsm, &btrfs_zstd_compress);
+	wsm.ops = &btrfs_zstd_compress;
+	spin_lock_init(&wsm.lock);
+	init_waitqueue_head(&wsm.wait);
+	timer_setup(&wsm.timer, zstd_reclaim_timer_fn, 0);
+
+	INIT_LIST_HEAD(&wsm.lru_list);
+	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++)
+		INIT_LIST_HEAD(&wsm.idle_ws[i]);
+
+	ws = wsm.ops->alloc_workspace(ZSTD_BTRFS_MAX_LEVEL);
+	if (IS_ERR(ws)) {
+		pr_warn("BTRFS: cannot preallocate zstd compression workspace\n");
+	} else {
+		set_bit(ZSTD_BTRFS_MAX_LEVEL - 1, &wsm.active_map);
+		list_add(ws, &wsm.idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1]);
+	}
 }
 
 static void zstd_cleanup_workspace_manager(void)
 {
-	btrfs_cleanup_workspace_manager(&wsm);
+	struct workspace *workspace;
+	int i;
+
+	del_timer_sync(&wsm.timer);
+
+	spin_lock(&wsm.lock);
+	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
+		while (!list_empty(&wsm.idle_ws[i])) {
+			workspace = container_of(wsm.idle_ws[i].next,
+						 struct workspace, list);
+			list_del(&workspace->list);
+			list_del(&workspace->lru_list);
+			wsm.ops->free_workspace(&workspace->list);
+		}
+	}
+	spin_unlock(&wsm.lock);
+}
+
+/*
+ * zstd_find_workspace - find workspace
+ * @level: compression level
+ *
+ * This iterates over the set bits in the active_map beginning at the requested
+ * compression level.  This lets us utilize already allocated workspaces before
+ * allocating a new one.  If the workspace is of a larger size, it is used, but
+ * the place in the lru_list and last_used times are not updated.  This is to
+ * offer the opportunity to reclaim the workspace in favor of allocating an
+ * appropriately sized one in the future.
+ */
+static struct list_head *zstd_find_workspace(unsigned int level)
+{
+	struct list_head *ws;
+	struct workspace *workspace;
+	int i = level - 1;
+
+	spin_lock(&wsm.lock);
+	for_each_set_bit_from(i, &wsm.active_map, ZSTD_BTRFS_MAX_LEVEL) {
+		if (!list_empty(&wsm.idle_ws[i])) {
+			ws = wsm.idle_ws[i].next;
+			workspace = list_to_workspace(ws);
+			list_del_init(ws);
+			/* keep its place if it's a lower level using this */
+			workspace->req_level = level;
+			if (level == workspace->level)
+				list_del(&workspace->lru_list);
+			if (list_empty(&wsm.idle_ws[i]))
+				clear_bit(i, &wsm.active_map);
+			spin_unlock(&wsm.lock);
+			return ws;
+		}
+	}
+	spin_unlock(&wsm.lock);
+
+	return NULL;
 }
 
+/*
+ * zstd_get_workspace - zstd's get_workspace
+ * @level: compression level
+ *
+ * If @level is 0, then any compression level can be used.  Therefore, we begin
+ * scanning from 1.  We first scan through possible workspaces and then after
+ * attempt to allocate a new workspace.  If we fail to allocate one due to
+ * memory pressure, go to sleep waiting for the max level workspace to free up.
+ */
 static struct list_head *zstd_get_workspace(unsigned int level)
 {
-	struct list_head *ws = btrfs_get_workspace(&wsm, level);
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct list_head *ws;
+	unsigned int nofs_flag;
 
-	workspace->req_level = level;
+	/* level == 0 means we can use any workspace */
+	if (!level)
+		level = 1;
+
+again:
+	ws = zstd_find_workspace(level);
+	if (ws)
+		return ws;
+
+	nofs_flag = memalloc_nofs_save();
+	ws = wsm.ops->alloc_workspace(level);
+	memalloc_nofs_restore(nofs_flag);
+
+	if (IS_ERR(ws)) {
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait(&wsm.wait, &wait, TASK_UNINTERRUPTIBLE);
+		schedule();
+		finish_wait(&wsm.wait, &wait);
+
+		goto again;
+	}
 
 	return ws;
 }
 
+/*
+ * zstd_put_workspace - zstd put_workspace
+ * @ws: list_head for the workspace
+ *
+ * When putting back a workspace, we only need to update the LRU if we are of
+ * the requested compression level.  Here is where we continue to protect the
+ * max level workspace or update last_used accordingly.  If the reclaim timer
+ * isn't set, it is also set here.  Only the max level workspace tries and wakes
+ * up waiting workspaces.
+ */
 static void zstd_put_workspace(struct list_head *ws)
 {
-	btrfs_put_workspace(&wsm, ws);
+	struct workspace *workspace = list_to_workspace(ws);
+
+	spin_lock(&wsm.lock);
+
+	/* a node is only taken off the lru if we are the corresponding level */
+	if (workspace->req_level == workspace->level) {
+		/* hide a max level workspace from reclaim */
+		if (list_empty(&wsm.idle_ws[ZSTD_BTRFS_MAX_LEVEL - 1])) {
+			INIT_LIST_HEAD(&workspace->lru_list);
+		} else {
+			workspace->last_used = jiffies;
+			list_add(&workspace->lru_list, &wsm.lru_list);
+			if (!timer_pending(&wsm.timer))
+				mod_timer(&wsm.timer,
+					  jiffies + ZSTD_BTRFS_RECLAIM_JIFFIES);
+		}
+	}
+
+	set_bit(workspace->level - 1, &wsm.active_map);
+	list_add(&workspace->list, &wsm.idle_ws[workspace->level - 1]);
+	workspace->req_level = 0;
+
+	spin_unlock(&wsm.lock);
+
+	if (workspace->level == ZSTD_BTRFS_MAX_LEVEL)
+		cond_wake_up(&wsm.wait);
 }
 
 static void zstd_free_workspace(struct list_head *ws)
@@ -121,10 +343,14 @@ static struct list_head *zstd_alloc_workspace(unsigned int level)
 	workspace->size = zstd_ws_mem_sizes[level - 1];
 	workspace->mem = kvmalloc(workspace->size, GFP_KERNEL);
 	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	workspace->level = level;
+	workspace->req_level = level;
+	workspace->last_used = jiffies;
 	if (!workspace->mem || !workspace->buf)
 		goto fail;
 
 	INIT_LIST_HEAD(&workspace->list);
+	INIT_LIST_HEAD(&workspace->lru_list);
 
 	return &workspace->list;
 fail:
@@ -478,7 +704,10 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 
 static unsigned int zstd_set_level(unsigned int level)
 {
-	return ZSTD_BTRFS_DEFAULT_LEVEL;
+	if (!level)
+		return ZSTD_BTRFS_DEFAULT_LEVEL;
+
+	return min_t(unsigned int, level, ZSTD_BTRFS_MAX_LEVEL);
 }
 
 const struct btrfs_compress_op btrfs_zstd_compress = {
-- 
2.17.1

