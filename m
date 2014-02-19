Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaBSMAI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 07:00:08 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBQ2ut026056
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:26:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] Btrfs: device_replace: fix deadlock for nocow case
Date: Wed, 19 Feb 2014 19:24:17 +0800
Message-Id: <1392809059-22319-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit cb7ab02156e4 cause a following deadlock found by
xfstests,btrfs/011:

Thread1 is commiting transaction which is blocked at
btrfs_scrub_pause().

Thread2 is calling btrfs_file_aio_write() which has held
inode's @i_mutex and commit transaction(blocked because
Thread1 is committing transaction).

Thread3 is copy_nocow_page worker which will also try to
hold inode @i_mutex, so thread3 will wait Thread1 finished.

Thread4 is waiting pending workers finished which will wait
Thread3 finished. So the problem is like this:

Thread1--->Thread4--->Thread3--->Thread2---->Thread1

Deadlock happens! we fix it by letting Thread1 go firstly,
which means we won't block transaction commit while we are
waiting pending workers finished.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 51c342b..f2f8803 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2686,10 +2686,23 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->bios_in_flight) == 0);
-		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
+		atomic_inc(&fs_info->scrubs_paused);
+		wake_up(&fs_info->scrub_pause_wait);
+
+		/*
+		 * must be called before we decrease @scrub_paused.
+		 * make sure we don't block transaction commit while
+		 * we are waiting pending workers finished.
+		 */
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->workers_pending) == 0);
-		scrub_blocked_if_needed(fs_info);
+		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
+
+		mutex_lock(&fs_info->scrub_lock);
+		__scrub_blocked_if_needed(fs_info);
+		atomic_dec(&fs_info->scrubs_paused);
+		mutex_unlock(&fs_info->scrub_lock);
+		wake_up(&fs_info->scrub_pause_wait);
 
 		btrfs_put_block_group(cache);
 		if (ret)
-- 
1.8.3.1

