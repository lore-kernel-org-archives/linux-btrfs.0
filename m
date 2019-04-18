Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C48C10F0B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC0A21479
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733049AbfDRG2O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:28:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:47442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbfDRG2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 02:28:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 52C63AF5B
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 06:28:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: volumes: Check memory allocation failure for alloc_btrfs_bio()
Date:   Thu, 18 Apr 2019 14:28:07 +0800
Message-Id: <20190418062807.32340-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
With kmalloc failure injection for submit_one_bio(), btrfs can crash like:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
  #PF error: [WRITE]
  PGD 0 P4D 0
  Oops: 0002 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 247 Comm: kworker/u8:4 Not tainted 5.1.0-rc5-custom+ #19
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Workqueue: writeback wb_workfn (flush-btrfs-6)
  RIP: 0010:alloc_btrfs_bio+0x1e/0x30 [btrfs]
  Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 48 63 f6 48 63 ff 48 8d 7c fe 18 be 40 8d 00 00 48 c1 e7 02 e8 a2 86 94 e0 <c7> 40 38 00 00 00 00 c7 00 01 00 00 00 c3 0f 1f 40 00 0f 1f 44 00
  Call Trace:
   __btrfs_map_block+0x5ce/0x1210 [btrfs]
   ? btrfs_bio_counter_inc_blocked+0x3a/0xc0 [btrfs]
   btrfs_map_bio+0x9a/0x430 [btrfs]
   btree_submit_bio_hook+0x82/0xb0 [btrfs]
   submit_one_bio+0x95/0xc0 [btrfs]
   copy_oldmem_page_encrypted+0x20/0x20
   ? write_one_eb+0x18f/0x2a0 [btrfs]
   ? end_extent_buffer_writeback+0x20/0x20 [btrfs]
   ? btree_write_cache_pages+0x12c/0x350 [btrfs]
   ? do_writepages+0x41/0xd0
   ? __writeback_single_inode+0x54/0x650
   ? writeback_sb_inodes+0x1f9/0x540
   ? __writeback_inodes_wb+0x5d/0xb0
   ? wb_writeback+0x340/0x4b0
   ? wb_workfn+0x410/0x5d0
   ? process_one_work+0x294/0x650
   ? worker_thread+0x2d/0x3d0
   ? process_one_work+0x650/0x650
   ? kthread+0x112/0x130
   ? kthread_park+0x80/0x80
   ? ret_from_fork+0x3a/0x50
  ---[ end trace b637169fb8b17c9c ]---

[CAUSE]
We just forgot to check the return value of kmalloc.
Surprisingly, all alloc_btrfs_bio() callers have handled memory
allocation pretty well.

[FIX]
Check and return if we failed memory allocation.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78bab7803bda..875d0eee1785 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5582,6 +5582,8 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
 		sizeof(u64) * (total_stripes),
 		GFP_NOFS|__GFP_NOFAIL);
 
+	if (!bbio)
+		return NULL;
 	atomic_set(&bbio->error, 0);
 	refcount_set(&bbio->refs, 1);
 
-- 
2.21.0

