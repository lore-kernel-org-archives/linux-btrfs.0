Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbaBSMOr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 07:14:47 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBQ2uP026055
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:26:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs: wake up @scrub_pause_wait as much as we can
Date: Wed, 19 Feb 2014 19:24:19 +0800
Message-Id: <1392809059-22319-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check if @scrubs_running=@scrubs_paused condition inside wait_event()
is not an atomic operation which means we may inc/dec @scrub_running/
paused at any time. Let's wake up @scrub_pause_wait as much as we can
to let commit transaction blocked less.

An example below:

Thread1				Thread2
|->scrub_blocked_if_needed()	|->scrub_pending_trans_workers_inc
  |->increase @scrub_paused
                                       |->increase @scrub_running
  |->wake up scrub_pause_wait list
                                       |->scrub blocked
                                       |->increase @scrub_paused

Thread3 is commiting transaction which is blocked at btrfs_scrub_pause().
So after Thread2 increase @scrub_paused, we meet the condition
@scrub_paused=@scrub_running, but transaction will be still blocked until
another calling to wake up @scrub_pause_wait.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2f8803..682ec3fc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -315,6 +315,16 @@ static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx)
 	atomic_inc(&fs_info->scrubs_running);
 	atomic_inc(&fs_info->scrubs_paused);
 	mutex_unlock(&fs_info->scrub_lock);
+
+	/*
+	 * check if @scrubs_running=@scrubs_paused condition
+	 * inside wait_event() is not an atomic operation.
+	 * which means we may inc/dec @scrub_running/paused
+	 * at any time. Let's wake up @scrub_pause_wait as
+	 * much as we can to let commit transaction blocked less.
+	 */
+	wake_up(&fs_info->scrub_pause_wait);
+
 	atomic_inc(&sctx->workers_pending);
 }
 
-- 
1.8.3.1

