Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46874 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753260AbbEVFsc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 01:48:32 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4M5l6V1014744
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 13:47:06 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Fix xfstests btrfs/070
Date: Fri, 22 May 2015 13:46:54 +0800
Message-ID: <24319912bdbd15dbb0a2a2d9299733edf606c552.1432273488.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <af458385e2759893000ccd9b5160350312de928c.1432273487.git.zhaolei@cn.fujitsu.com>
References: <af458385e2759893000ccd9b5160350312de928c.1432273487.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

xfstests btrfs/070 sometimes failed.
In my test machine, its fail rate is about 30%.
In another vm(vmware), its fail rate is about 50%.

Reason:
btrfs/070 do replace and defrag with fsstress simultaneously,
after above operation, checksum error is found by scrub.
Actually, it have no relationship with defrag operation, only
replace with fsstress can trigger this bug.
New data writen to target device have possibility rewrited by
old data from source device by replace code in debug, and can
be fixed by set chunk to ro in replace operation.

Before patch(4.1-rc3):
  30% failed in 100 xfstests.
After patch:
  0% failed in 300 xfstests.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ab58115..469c8a5 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3446,6 +3446,23 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		if (!cache)
 			goto skip;
 
+		/*
+		 * we need call btrfs_inc_block_group_ro() with scrubs_paused,
+		 * to avoid deadlock caused by:
+		 * btrfs_inc_block_group_ro()
+		 * -> btrfs_wait_for_commit()
+		 * -> btrfs_commit_transaction()
+		 * -> btrfs_scrub_pause()
+		 */
+		atomic_inc(&fs_info->scrubs_paused);
+		wake_up(&fs_info->scrub_pause_wait);
+		btrfs_inc_block_group_ro(root, cache);
+		mutex_lock(&fs_info->scrub_lock);
+		__scrub_blocked_if_needed(fs_info);
+		atomic_dec(&fs_info->scrubs_paused);
+		mutex_unlock(&fs_info->scrub_lock);
+		wake_up(&fs_info->scrub_pause_wait);
+
 		dev_replace->cursor_right = found_key.offset + length;
 		dev_replace->cursor_left = found_key.offset;
 		dev_replace->item_needs_writeback = 1;
@@ -3489,6 +3506,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		mutex_unlock(&fs_info->scrub_lock);
 		wake_up(&fs_info->scrub_pause_wait);
 
+		btrfs_dec_block_group_ro(root, cache);
+
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
-- 
1.8.5.1

