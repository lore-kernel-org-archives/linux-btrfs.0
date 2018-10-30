Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA069C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 10:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C37520823
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 10:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Pnijko3v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C37520823
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbeJ3S47 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 14:56:59 -0400
Received: from synology.com ([59.124.61.242]:42652 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbeJ3S47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 14:56:59 -0400
Received: from localhost.localdomain (unknown [10.13.20.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 036BF24F6A6F;
        Tue, 30 Oct 2018 18:04:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1540893851; bh=8zA7/BwF5sc2DLauegiQ9dTMAea1LwEB+9OhX8PuwgE=;
        h=From:To:Cc:Subject:Date;
        b=Pnijko3vcVJXmY2yOVGL+WhZRlAaWi8RkKLmEWyVZAtleh8G82tZ43Illf4IPVmy3
         wACW7IELd0+hksZpJ+KpbXuti55sv5WXTCcSAe9R6+AI4hDz1h2Wmll7qvj2NqhiGi
         mtdtIbqA0DuWEyeciOwYCVIrEeRw/IPVJyFAyKvI=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix cur_offset in the error case for nocow
Date:   Tue, 30 Oct 2018 18:04:04 +0800
Message-Id: <1540893844-3480-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

When the cow_file_range fail, the related resources are
unlocked according to the range (start-end), so the unlock
cannot be repeated in run_delalloc_nocow.

In some cases (e.g. cur_offset <= end && cow_start!= -1),
cur_offset is not updated correctly, so move the cur_offset
update before cow_file_range.

------------[ cut here ]------------
kernel BUG at mm/page-writeback.c:2663!
Internal error: Oops - BUG: 0 [#1] SMP
CPU: 3 PID: 31525 Comm: kworker/u8:7 Tainted: P O
Hardware name: Realtek_RTD1296 (DT)
Workqueue: writeback wb_workfn (flush-btrfs-1)
task: ffffffc076db3380 ti: ffffffc02e9ac000 task.ti: ffffffc02e9ac000
PC is at clear_page_dirty_for_io+0x1bc/0x1e8
LR is at clear_page_dirty_for_io+0x14/0x1e8
pc : [<ffffffc00033c91c>] lr : [<ffffffc00033c774>] pstate: 40000145
sp : ffffffc02e9af4f0
Process kworker/u8:7 (pid: 31525, stack limit = 0xffffffc02e9ac020)
Call trace:
[<ffffffc00033c91c>] clear_page_dirty_for_io+0x1bc/0x1e8
[<ffffffbffc514674>] extent_clear_unlock_delalloc+0x1e4/0x210 [btrfs]
[<ffffffbffc4fb168>] run_delalloc_nocow+0x3b8/0x948 [btrfs]
[<ffffffbffc4fb948>] run_delalloc_range+0x250/0x3a8 [btrfs]
[<ffffffbffc514c0c>] writepage_delalloc.isra.21+0xbc/0x1d8 [btrfs]
[<ffffffbffc516048>] __extent_writepage+0xe8/0x248 [btrfs]
[<ffffffbffc51630c>] extent_write_cache_pages.isra.17+0x164/0x378 [btrfs]
[<ffffffbffc5185a8>] extent_writepages+0x48/0x68 [btrfs]
[<ffffffbffc4f5828>] btrfs_writepages+0x20/0x30 [btrfs]
[<ffffffc00033d758>] do_writepages+0x30/0x88
[<ffffffc0003ba0f4>] __writeback_single_inode+0x34/0x198
[<ffffffc0003ba6c4>] writeback_sb_inodes+0x184/0x3c0
[<ffffffc0003ba96c>] __writeback_inodes_wb+0x6c/0xc0
[<ffffffc0003bac20>] wb_writeback+0x1b8/0x1c0
[<ffffffc0003bb0f0>] wb_workfn+0x150/0x250
[<ffffffc0002b0014>] process_one_work+0x1dc/0x388
[<ffffffc0002b02f0>] worker_thread+0x130/0x500
[<ffffffc0002b6344>] kthread+0x10c/0x110
[<ffffffc000284590>] ret_from_fork+0x10/0x40
Code: d503201f a9025bb5 a90363b7 f90023b9 (d4210000)
---[ end trace 65fecee7c2296f25 ]---

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 181c58b..b62299b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1532,10 +1532,10 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 
 	if (cur_offset <= end && cow_start == (u64)-1) {
 		cow_start = cur_offset;
-		cur_offset = end;
 	}
 
 	if (cow_start != (u64)-1) {
+		cur_offset = end;
 		ret = cow_file_range(inode, locked_page, cow_start, end, end,
 				     page_started, nr_written, 1, NULL);
 		if (ret)
-- 
1.9.1

