Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBE7C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900832171F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710708;
	bh=eooWO2ugB+gtOMNSUdMy9UmW/A3EXIwwqG36q8GHvjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FEnxSe6GVrXgvNLCdIy1Bh4IQf0Gqme/WVOEtKG00sBqqhCa2R5aXwxAjiVbavywf
	 vYOI5x99Be77LungSlms8+70gQxbL/VAOyyDfulKV1p0f/WOEU8WJxfgXA5EJoCNJc
	 HXXYXsvJR4JkB1nQWaMOLeicFLDJhZT3vP5wFteY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbfA1VZC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:25:02 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38288 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbfA1VZB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:25:01 -0500
Received: by mail-yb1-f196.google.com with SMTP id x9so7322193ybj.5;
        Mon, 28 Jan 2019 13:25:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q6V2t4AO/NQ51NpDSK0iwO1J92PFaU8+yoOOQaviHM4=;
        b=fp1HrYOEkdaeyIPdOKfVNiIhSvlqd4DunGTvWyL12yh4LNTIPW0THH58EfZahrOgLg
         569WirSynzKzpxlkOJmkos4iffWIzmXvvguVeNWL3CT3hywUNWjAaWMSqttCEzv0EmbZ
         aPEYmFQPviJnEHIelDPI8sLFke/uauPa09KOx/YLEaOVLlaF7k4SwLZy4pVnAugtq5v2
         bhITrWoB/bAqm2KJdW2nJ1h9YhLy+nOvQU5od1ypaE9PvDoYq3Z66ISkAtJ/B0OmJ27Y
         OhgPhI1+O+4PtVsnl+v51ZXXZ9z+u16I4lhIxOnNaSdIA19JyTkWcBK7rfoOQ/YMNVu2
         /RwQ==
X-Gm-Message-State: AJcUukfu4AZEwGIjeJd4BiShMMsOyZxN1oxiqYXcgs7fcxuvpvMEA9MO
        XrTZSlwjX2erdqvNzMPETtA=
X-Google-Smtp-Source: ALg8bN6QT/dtSJDFmyckWDZyA4N68JITtWiBg7ui6u7SCP7r7+FifrxbCWEuW7QcI+ytqhO0akRtwQ==
X-Received: by 2002:a25:a001:: with SMTP id x1mr21495015ybh.169.1548710700195;
        Mon, 28 Jan 2019 13:25:00 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:59 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        Omar Sandoval <osandov@fb.com>
Subject: [PATCH 11/11] btrfs: add zstd compression level support
Date:   Mon, 28 Jan 2019 16:24:37 -0500
Message-Id: <20190128212437.11597-12-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Zstd compression requires different amounts of memory for each level of
compression. The prior patches implemented indirection to allow for each
compression type to manage their workspaces independently. This patch
uses this indirection to implement compression level support for zstd.

As mentioned above, a requirement that differs zstd from zlib is that
higher levels of compression require more memory. To manage this, each
compression level has its own queue of workspaces. A global LRU is used
to help with reclaim. To guarantee forward progress, a max level
workspace is preallocated and hidden from the LRU.

When getting a workspace, it uses a bitmap to identify the levels that
are populated and scans up. If it finds a workspace that is greater than
it, it uses it, but does not update the last_used time and the
corresponding place in the LRU. This provides a mechanism to decrease
memory utilization as we only keep around workspaces that are sized
appropriately for the in use compression levels.

By knowing which compression levels have available workspaces, we can
recycle rather than always create new workspaces as well as take
advantage of the preallocated max level for forward progress. If we hit
memory pressure, we sleep on the max level workspace. We continue to
rescan in case we can use a smaller workspace, but eventually should be
able to obtain the max level workspace or allocate one again should
memory pressure subside. The memory requirement for decompression is the
same as level 1, and therefore can use any of available workspace.

The number of workspaces is bound by an upper limit of the workqueue's
limit which currently is 2 (percpu limit). Second, a reclaim timer is
used to free inactive/improperly sized workspaces. The reclaim timer is
set to 67s to avoid colliding with transaction commit (every 30s) and
attempts to reclaim any unused workspace older than 45s.

Repeating the experiment from v2 [1], the Silesia corpus was copied to a
btrfs filesystem 10 times and then read back after dropping the caches.
The btrfs filesystem was on an SSD.

Level   Ratio   Compression (MB/s)  Decompression (MB/s)
1       2.658        438.47                910.51
2       2.744        364.86                886.55
3       2.801        336.33                828.41
4       2.858        286.71                886.55
5       2.916        212.77                556.84
6       2.363        119.82                990.85
7       3.000        154.06                849.30
8       3.011        159.54                875.03
9       3.025        100.51                940.15
10      3.033        118.97                616.26
11      3.036         94.19                802.11
12      3.037         73.45                931.49
13      3.041         55.17                835.26
14      3.087         44.70                716.78
15      3.126         37.30                878.84

[1] https://lore.kernel.org/linux-btrfs/20181031181108.289340-1-terrelln@fb.com/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/super.c |   6 +-
 fs/btrfs/zstd.c  | 229 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 226 insertions(+), 9 deletions(-)

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
index a951d4fe77f7..ce9b466c197f 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -6,20 +6,27 @@
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
+#define ZSTD_BTRFS_MAX_LEVEL 15
+#define ZSTD_BTRFS_RECLAIM_NS (45 * NSEC_PER_SEC)
+/* 67s to avoid clashing with transaction commit (every 30s) */
+#define ZSTD_BTRFS_RECLAIM_JIFFIES (67 * HZ)
 
 static ZSTD_parameters zstd_get_btrfs_parameters(unsigned int level,
 						 size_t src_len)
@@ -36,37 +43,234 @@ struct workspace {
 	void *mem;
 	size_t size;
 	char *buf;
+	unsigned int level;
 	unsigned int req_level;
+	u64 last_used;
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
+
+static inline struct workspace *list_to_workspace(struct list_head *list)
+{
+	return container_of(list, struct workspace, list);
+}
+
+/*
+ * zstd_reclaim_timer_fn - reclaim timer
+ * @t: timer
+ *
+ * This is scheduled every ZSTD_BTRFS_RECLAIM_JIFFIES and checks if a workspace
+ * has not been used by the corresponding level for ZSTD_BTRFS_RECLAIM_NS.
+ */
+static void zstd_reclaim_timer_fn(struct timer_list *t)
+{
+	u64 now = ktime_get_ns();
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
+		if (now < victim->last_used + ZSTD_BTRFS_RECLAIM_NS)
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
 
 static void zstd_init_workspace_manager(void)
 {
-	btrfs_init_workspace_manager(&wsm, &btrfs_zstd_compress);
+	struct list_head *ws;
+	int i;
+
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
+	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
+		while (!list_empty(&wsm.idle_ws[i])) {
+			workspace = container_of(wsm.idle_ws[i].next,
+						 struct workspace, list);
+			list_del(&workspace->list);
+			list_del(&workspace->lru_list);
+			wsm.ops->free_workspace(&workspace->list);
+		}
+	}
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
+	unsigned long nofs_flag;
 
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
+			workspace->last_used = ktime_get_ns();
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
@@ -93,10 +297,14 @@ static struct list_head *zstd_alloc_workspace(unsigned int level)
 			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
 	workspace->mem = kvmalloc(workspace->size, GFP_KERNEL);
 	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	workspace->level = level;
+	workspace->req_level = level;
+	workspace->last_used = ktime_get_ns();
 	if (!workspace->mem || !workspace->buf)
 		goto fail;
 
 	INIT_LIST_HEAD(&workspace->list);
+	INIT_LIST_HEAD(&workspace->lru_list);
 
 	return &workspace->list;
 fail:
@@ -450,7 +658,12 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 
 static unsigned int zstd_set_level(unsigned int level)
 {
-	return ZSTD_BTRFS_DEFAULT_LEVEL;
+	if (!level)
+		level = ZSTD_BTRFS_DEFAULT_LEVEL;
+	else if (level > ZSTD_BTRFS_MAX_LEVEL)
+		level = ZSTD_BTRFS_MAX_LEVEL;
+
+	return level;
 }
 
 const struct btrfs_compress_op btrfs_zstd_compress = {
-- 
2.17.1

