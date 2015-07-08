Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33647 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757861AbbGHDqm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jul 2015 23:46:42 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t683iuF0024543
	for <linux-btrfs@vger.kernel.org>; Wed, 8 Jul 2015 11:44:56 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v3 4/4] btrfs: Fix data checksum error cause by replace with io-load.
Date: Wed, 8 Jul 2015 11:44:09 +0800
Message-ID: <955d4a564a4f44b1a2d3485e21207530b66f75b9.1436326244.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1436326244.git.zhaolei@cn.fujitsu.com>
References: <cover.1436326244.git.zhaolei@cn.fujitsu.com>
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
  old data from source device by replace code in debug, to avoid
  above problem, we can set target block group to readonly in
  replace period, so new data requested by other operation will
  not write to same place with replace code.

  Before patch(4.1-rc3):
    30% failed in 100 xfstests.
  After patch:
    0% failed in 300 xfstests.

  It also happened in btrfs/071.

Changelog v2->v3:
1: Fix a typo(caused in rebase) which make xfstests failed in
   btrfs/073 and btrfs/066.
2: Rebase on top of integration-4.2
3: Do full xfstests(generic and btrfs group with 10 mount options)

Changelog v1->v2:
1: Update subject to reflect the problem being fixed.
2: Update description to say reason why set read-only can fix the
   problem.
3: Use a helper function to avoid duplicated code block for set
   chunk ro.
All of above are suggested by: David Sterba <dsterba@suse.cz>

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Suggested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a882a34..3a49a43 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3467,6 +3467,18 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
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
+		scrub_pause_on(fs_info);
+		btrfs_inc_block_group_ro(root, cache);
+		scrub_pause_off(fs_info);
+
 		dev_replace->cursor_right = found_key.offset + length;
 		dev_replace->cursor_left = found_key.offset;
 		dev_replace->item_needs_writeback = 1;
@@ -3506,6 +3518,8 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 
 		scrub_pause_off(fs_info);
 
+		btrfs_dec_block_group_ro(root, cache);
+
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
-- 
1.8.5.1

