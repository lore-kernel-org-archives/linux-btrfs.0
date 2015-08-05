Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30607 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751294AbbHEIpK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:45:10 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t758hE1O017029
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Aug 2015 16:43:14 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v4 3/4] btrfs: use scrub_pause_on/off() to reduce code in scrub_enumerate_chunks()
Date: Wed, 5 Aug 2015 16:43:29 +0800
Message-ID: <778526af4a289eb6022f62a2c801e9a3e1134bf9.1438763783.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1438763783.git.zhaolei@cn.fujitsu.com>
References: <cover.1438763783.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use new intruduced scrub_pause_on/off() can make this code block
clean and more readable.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index cbfb8c7..a882a34 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3492,8 +3492,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		wait_event(sctx->list_wait,
 			   atomic_read(&sctx->bios_in_flight) == 0);
-		atomic_inc(&fs_info->scrubs_paused);
-		wake_up(&fs_info->scrub_pause_wait);
+
+		scrub_pause_on(fs_info);
 
 		/*
 		 * must be called before we decrease @scrub_paused.
@@ -3504,11 +3504,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 			   atomic_read(&sctx->workers_pending) == 0);
 		atomic_set(&sctx->wr_ctx.flush_all_writes, 0);
 
-		mutex_lock(&fs_info->scrub_lock);
-		__scrub_blocked_if_needed(fs_info);
-		atomic_dec(&fs_info->scrubs_paused);
-		mutex_unlock(&fs_info->scrub_lock);
-		wake_up(&fs_info->scrub_pause_wait);
+		scrub_pause_off(fs_info);
 
 		btrfs_put_block_group(cache);
 		if (ret)
-- 
1.8.5.1

