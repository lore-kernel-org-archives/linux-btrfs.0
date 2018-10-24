Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6954C7112C
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882E92082E
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 882E92082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbeJXUwN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:52:13 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30356 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726812AbeJXUwN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:52:13 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46658918"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Oct 2018 20:24:15 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id DA3074B714A9
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 20:24:12 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 24 Oct
 2018 20:24:18 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs: fix pinned underflow after transaction aborted
Date:   Wed, 24 Oct 2018 20:24:03 +0800
Message-ID: <20181024122403.17418-4-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
References: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: DA3074B714A9.A77E7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When running generic/475, we may get the following warning in the dmesg.

[ 6902.102154] WARNING: CPU: 3 PID: 18013 at fs/btrfs/extent-tree.c:9776 btrfs_free_block_groups+0x2af/0x3b0 [btrfs]
[ 6902.104886] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core [last unloaded: btrfs]
[ 6902.109160] CPU: 3 PID: 18013 Comm: umount Tainted: G        W  O      4.19.0-rc8+ #8
[ 6902.110971] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[ 6902.112857] RIP: 0010:btrfs_free_block_groups+0x2af/0x3b0 [btrfs]
[ 6902.114377] Code: c6 48 89 04 24 48 8b 83 50 17 00 00 48 39 c6 0f 84 ab 00 00 00 4c 8b ab 50 17 00 00 49 83 bd 50 ff ff ff 00 0f 84 b4 00 00 00 <0f> 0b 31 c9 49 8d b5 f8 fe ff ff 31 d2 48
89 df e8 fc 76 ff ff 49
[ 6902.118921] RSP: 0018:ffffc9000459bdb0 EFLAGS: 00010286
[ 6902.120315] RAX: ffff880175050bb0 RBX: ffff8801124a8000 RCX: 0000000000170007
[ 6902.121969] RDX: 0000000000000002 RSI: 0000000000170007 RDI: ffffffff8125fb74
[ 6902.123716] RBP: ffff880175055d10 R08: 0000000000000000 R09: 0000000000000000
[ 6902.125417] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880175055d88
[ 6902.127129] R13: ffff880175050bb0 R14: 0000000000000000 R15: dead000000000100
[ 6902.129060] FS:  00007f4507223780(0000) GS:ffff88017ba00000(0000) knlGS:0000000000000000
[ 6902.130996] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6902.132558] CR2: 00005623599cac78 CR3: 000000014b700001 CR4: 00000000003606e0
[ 6902.134270] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6902.135981] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 6902.137836] Call Trace:
[ 6902.138939]  close_ctree+0x171/0x330 [btrfs]
[ 6902.140181]  ? kthread_stop+0x146/0x1f0
[ 6902.141277]  generic_shutdown_super+0x6c/0x100
[ 6902.142517]  kill_anon_super+0x14/0x30
[ 6902.143554]  btrfs_kill_super+0x13/0x100 [btrfs]
[ 6902.144790]  deactivate_locked_super+0x2f/0x70
[ 6902.146014]  cleanup_mnt+0x3b/0x70
[ 6902.147020]  task_work_run+0x9e/0xd0
[ 6902.148036]  do_syscall_64+0x470/0x600
[ 6902.149142]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[ 6902.150375]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 6902.151640] RIP: 0033:0x7f45077a6a7b
[ 6902.152782] Code: 23 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e fa 31 f6 e9 05 00 00 00 90 0f 1f 40 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 23
0c 00 f7 d8 64 89 01 48
[ 6902.157324] RSP: 002b:00007ffd589f3e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 6902.159187] RAX: 0000000000000000 RBX: 000055e8eec732b0 RCX: 00007f45077a6a7b
[ 6902.160834] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055e8eec73490
[ 6902.162526] RBP: 0000000000000000 R08: 000055e8eec734b0 R09: 00007ffd589f26c0
[ 6902.164141] R10: 0000000000000000 R11: 0000000000000246 R12: 000055e8eec73490
[ 6902.165815] R13: 00007f4507ac61a4 R14: 0000000000000000 R15: 00007ffd589f40d8
[ 6902.167553] irq event stamp: 0
[ 6902.168998] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[ 6902.170731] hardirqs last disabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[ 6902.172773] softirqs last  enabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[ 6902.174671] softirqs last disabled at (0): [<0000000000000000>]           (null)
[ 6902.176407] ---[ end trace 463138c2986b275c ]---
[ 6902.177636] BTRFS info (device dm-3): space_info 4 has 273465344 free, is not full
[ 6902.179453] BTRFS info (device dm-3): space_info total=276824064, used=4685824, pinned=18446744073708158976, reserved=0, may_use=0, readonly=65536
												^^^
											obviously underflow

When transaction_kthread is running cleanup_transaction(), another
fsstress is running btrfs_commit_transaction(). The
btrfs_finish_extent_commit() may get the same range as
btrfs_destroy_pinned_extent() got, which causes the pinned underflow.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b0ab41da91d1..00ee5e37e989 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4359,13 +4359,23 @@ static int btrfs_destroy_pinned_extent(struct btrfs_fs_info *fs_info,
 	unpin = pinned_extents;
 again:
 	while (1) {
+		/*
+		 * The btrfs_finish_extent_commit() may get the same range as
+		 * ours between find_first_extent_bit and clear_extent_dirty.
+		 * Hence, hold the unused_bg_unpin_mutex to avoid double unpin
+		 * the same extent range.
+		 */
+		mutex_lock(&fs_info->unused_bg_unpin_mutex);
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY, NULL);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 			break;
+		}
 
 		clear_extent_dirty(unpin, start, end);
 		btrfs_error_unpin_extent_range(fs_info, start, end);
+		mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 		cond_resched();
 	}
 
-- 
2.19.1



