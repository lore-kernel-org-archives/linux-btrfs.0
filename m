Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24437 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754768AbaHFJeY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 05:34:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s769YLtf029825
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Aug 2014 17:34:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: cancel scrub/replace if the user space process receive SIGKILL.
Date: Wed, 6 Aug 2014 17:34:22 +0800
Message-ID: <1407317662-9364-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When impatient sysadmin is tired of waiting background running btrfs
scrub/replace and send SIGKILL to btrfs process, unlike
SIGINT/SIGTERM which can be caught by user space program and cancel the
scrub work, user space program will continue running until ioctl exits.

To keep it consistent with the behavior of btrfs-progs, which cancels
the work when SIGINT is received, this patch will make scrub routine to
check SIGKILL pending of current task and cancel the work if SIGKILL is
already pending.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b6d198f..0c8047f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2277,6 +2277,29 @@ static int get_raid56_logic_offset(u64 physical, int num,
 	return 1;
 }
 
+/*
+ * check whether the scrub is canceled
+ * if canceled, return -ECANCELED, else return 0
+ *
+ * scrub/replace will be canceled when
+ * 1) cancel is called manually
+ * 2) caller user space process(btrfs-progs) receive SIGKILL
+ * other signals can be caught in btrfs-progs using multi-thread
+ * and cancel the work.
+ * but SIGKILL can't be caught and btrfs-progs already fallen into ioctl
+ * so cancel current scrub to return asap if SIGKILL is received.
+ */
+static inline int is_scrub_canceled(struct btrfs_fs_info *fs_info,
+				    struct scrub_ctx *sctx)
+{
+	int ret = 0;
+
+	if (unlikely(atomic_read(&fs_info->scrub_cancel_req) ||
+		     atomic_read(&sctx->cancel_req) ||
+		     __fatal_signal_pending(current)))
+		ret = -ECANCELED;
+	return ret;
+}
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
@@ -2420,11 +2443,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 		/*
 		 * canceled?
 		 */
-		if (atomic_read(&fs_info->scrub_cancel_req) ||
-		    atomic_read(&sctx->cancel_req)) {
-			ret = -ECANCELED;
+		ret = is_scrub_canceled(fs_info, sctx);
+		if (ret)
 			goto out;
-		}
 		/*
 		 * check to see if we have to pause
 		 */
-- 
2.0.4

