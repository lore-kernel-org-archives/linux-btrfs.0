Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68391C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 07:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0F5520657
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 07:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0F5520657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbeJaQLO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 12:11:14 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:50106 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725931AbeJaQLO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 12:11:14 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47043344"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Oct 2018 15:14:13 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F13104B7117F;
        Wed, 31 Oct 2018 15:14:11 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 31 Oct 2018 15:14:17 +0800
Date:   Wed, 31 Oct 2018 15:14:09 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Omar Sandoval <osandov@osandov.com>
CC:     <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181031071409.GA2656@fnst.localdomain>
References: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <9b8c7d1ce662d216cf29ffcb756d177b0bf60b64.1540944854.git.osandov@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: F13104B7117F.AB991
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Oct 30, 2018 at 05:14:42PM -0700, Omar Sandoval wrote:
>From: Omar Sandoval <osandov@fb.com>
>
>There's a race between close_ctree() and cleaner_kthread().
>close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
>sees it set, but this is racy; the cleaner might have already checked
>the bit and could be cleaning stuff. In particular, if it deletes unused
>block groups, it will create delayed iputs for the free space cache
>inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
>longer running delayed iputs after a commit. Therefore, if the cleaner
>creates more delayed iputs after delayed iputs are run in
>btrfs_commit_super(), we will leak inodes on unmount and get a busy
>inode crash from the VFS.
>
>Fix it by parking the cleaner before we actually close anything. Then,
>any remaining delayed iputs will always be handled in
>btrfs_commit_super(). This also ensures that the commit in close_ctree()
>is really the last commit, so we can get rid of the commit in
>cleaner_kthread().
>
>Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
>Signed-off-by: Omar Sandoval <osandov@fb.com>
>---
>We found this with a stress test that our containers team runs. I'm
>wondering if this same race could have caused any other issues other
>than this new iput thing, but I couldn't identify any.

I noticed an inode leak issue in generic/475, but whether dropping commit
30928e9baac2 ("btrfs: don't run delayed_iputs in commit") or applying
this patch, the issue still exists.

I have attached the dmesg.

>
> fs/btrfs/disk-io.c | 40 +++++++---------------------------------
> 1 file changed, 7 insertions(+), 33 deletions(-)
>
>diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>index b0ab41da91d1..7c17284ae3c2 100644
>--- a/fs/btrfs/disk-io.c
>+++ b/fs/btrfs/disk-io.c
>@@ -1664,9 +1664,8 @@ static int cleaner_kthread(void *arg)
> 	struct btrfs_root *root = arg;
> 	struct btrfs_fs_info *fs_info = root->fs_info;
> 	int again;
>-	struct btrfs_trans_handle *trans;
> 
>-	do {
>+	while (1) {
> 		again = 0;
> 
> 		/* Make the cleaner go to sleep early. */
>@@ -1715,42 +1714,16 @@ static int cleaner_kthread(void *arg)
> 		 */
> 		btrfs_delete_unused_bgs(fs_info);
> sleep:
>+		if (kthread_should_park())
>+			kthread_parkme();
>+		if (kthread_should_stop())
>+			return 0;
> 		if (!again) {
> 			set_current_state(TASK_INTERRUPTIBLE);
>-			if (!kthread_should_stop())
>-				schedule();
>+			schedule();
> 			__set_current_state(TASK_RUNNING);
> 		}
>-	} while (!kthread_should_stop());
>-
>-	/*
>-	 * Transaction kthread is stopped before us and wakes us up.
>-	 * However we might have started a new transaction and COWed some
>-	 * tree blocks when deleting unused block groups for example. So
>-	 * make sure we commit the transaction we started to have a clean
>-	 * shutdown when evicting the btree inode - if it has dirty pages
>-	 * when we do the final iput() on it, eviction will trigger a
>-	 * writeback for it which will fail with null pointer dereferences
>-	 * since work queues and other resources were already released and
>-	 * destroyed by the time the iput/eviction/writeback is made.
>-	 */
>-	trans = btrfs_attach_transaction(root);
>-	if (IS_ERR(trans)) {
>-		if (PTR_ERR(trans) != -ENOENT)
>-			btrfs_err(fs_info,
>-				  "cleaner transaction attach returned %ld",
>-				  PTR_ERR(trans));
>-	} else {
>-		int ret;
>-
>-		ret = btrfs_commit_transaction(trans);
>-		if (ret)
>-			btrfs_err(fs_info,
>-				  "cleaner open transaction commit returned %d",
>-				  ret);
> 	}
>-
>-	return 0;
> }
> 
> static int transaction_kthread(void *arg)
>@@ -3931,6 +3904,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
> 	int ret;
> 
> 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
>+	kthread_park(fs_info->cleaner_kthread);

Since we are not going to call kthread_unpark, I am not sure why
kthread_park is used instead of kthread_stop here. It looks like there
is no significant difference between stopping instantly and delayed stop.

-- 
Thanks,
Lu

> 
> 	/* wait for the qgroup rescan worker to stop */
> 	btrfs_qgroup_wait_for_completion(fs_info, false);
>-- 
>2.19.1
>
>
>
>



--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="generic_475.dmesg"

[  366.955193] run fstests generic/475 at 2018-10-31 15:06:43
[  367.495791] BTRFS: device fsid 812f883c-40b2-4456-9769-b94ddf1cb07e devid 1 transid 5 /dev/nvme0n1p2
[  367.624469] BTRFS info (device dm-3): disk space caching is enabled
[  367.627305] BTRFS info (device dm-3): has skinny extents
[  367.628771] BTRFS info (device dm-3): flagging fs with big metadata feature
[  367.637585] BTRFS info (device dm-3): enabling ssd optimizations
[  367.640079] BTRFS info (device dm-3): checking UUID tree
[  367.666290] btrfs_dev_stat_print_on_error: 86 callbacks suppressed
[  367.666293] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
[  367.670665] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
[  367.673332] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
[  367.674024] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
[  367.676072] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
[  367.677316] Buffer I/O error on dev dm-3, logical block 4718576, async page read
[  367.682713] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
[  367.685150] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
[  367.690053] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
[  367.690298] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
[  367.694166] BTRFS error (device dm-3): bdev /dev/mapper/error-test errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
[  367.700484] BTRFS: error (device dm-3) in btrfs_commit_transaction:2239: errno=-5 IO failure (Error while writing out transaction)
[  367.707185] BTRFS info (device dm-3): forced readonly
[  367.708627] BTRFS warning (device dm-3): Skipping commit of aborted transaction.
[  367.710526] BTRFS: error (device dm-3) in cleanup_transaction:1849: errno=-5 IO failure
[  367.712330] BTRFS info (device dm-3): delayed_refs has NO entry
[  367.975623] BTRFS error (device dm-3): cleaner transaction attach returned -30
[  367.977998] BTRFS info (device dm-3): at unmount delalloc count 8192
[  367.980424] WARNING: CPU: 2 PID: 14918 at fs/btrfs/disk-io.c:3846 btrfs_free_fs_root+0x94/0xa0 [btrfs]
[  367.983228] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core
[  367.986171] CPU: 2 PID: 14918 Comm: umount Kdump: loaded Not tainted 4.19.0-rc8+ #18
[  367.988154] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  367.990175] RIP: 0010:btrfs_free_fs_root+0x94/0xa0 [btrfs]
[  367.997036] RSP: 0018:ffffc9000744bd60 EFLAGS: 00010282
[  367.998595] RAX: ffff880354eb6270 RBX: ffff8803661c4548 RCX: 0000000000000000
[  368.000665] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000000
[  368.002527] RBP: ffff88033cd70000 R08: 0000000000000000 R09: 0000000000000001
[  368.004426] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc9000744bd88
[  368.006248] R13: ffff88033cd700c0 R14: ffffc9000744bd80 R15: 0000000000000000
[  368.008082] FS:  00007f206293e780(0000) GS:ffff880373800000(0000) knlGS:0000000000000000
[  368.010068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  368.011654] CR2: 000055d225976b70 CR3: 000000033f992004 CR4: 00000000003606e0
[  368.013440] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  368.015232] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  368.016979] Call Trace:
[  368.017947]  btrfs_free_fs_roots+0xcf/0x160 [btrfs]
[  368.019317]  ? wait_for_completion+0x126/0x150
[  368.020617]  close_ctree+0x149/0x330 [btrfs]
[  368.021822]  generic_shutdown_super+0x6c/0x100
[  368.023043]  kill_anon_super+0x14/0x30
[  368.024203]  btrfs_kill_super+0x13/0x100 [btrfs]
[  368.025471]  deactivate_locked_super+0x2f/0x70
[  368.027647]  cleanup_mnt+0x3b/0x70
[  368.028712]  task_work_run+0x9e/0xd0
[  368.029875]  do_syscall_64+0x470/0x600
[  368.031009]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  368.032350]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  368.033620] RIP: 0033:0x7f2062ec1b5b
[  368.039127] RSP: 002b:00007ffd75ebd748 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  368.040906] RAX: 0000000000000000 RBX: 000055b8b9bdb2b0 RCX: 00007f2062ec1b5b
[  368.042564] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055b8b9bdb490
[  368.044250] RBP: 0000000000000000 R08: 000055b8b9bdb4b0 R09: 00007ffd75ebbfa0
[  368.045862] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b8b9bdb490
[  368.047503] R13: 00007f20631e11a4 R14: 0000000000000000 R15: 00007ffd75ebd9b8
[  368.049089] irq event stamp: 0
[  368.049979] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[  368.051674] hardirqs last disabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.053587] softirqs last  enabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.055550] softirqs last disabled at (0): [<0000000000000000>]           (null)
[  368.058098] ---[ end trace 08fc3163d80dad81 ]---
[  368.061134] WARNING: CPU: 2 PID: 14918 at fs/btrfs/extent-tree.c:123 btrfs_put_block_group+0x51/0x60 [btrfs]
[  368.063637] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core
[  368.066230] CPU: 2 PID: 14918 Comm: umount Kdump: loaded Tainted: G        W         4.19.0-rc8+ #18
[  368.068615] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  368.070406] RIP: 0010:btrfs_put_block_group+0x51/0x60 [btrfs]
[  368.076431] RSP: 0018:ffffc9000744bda0 EFLAGS: 00010206
[  368.077765] RAX: 0000000000000001 RBX: ffff88033cd70000 RCX: ffff8803414f76c0
[  368.079477] RDX: ffff8803414f76c0 RSI: 0000000000000001 RDI: ffff8803414f74e8
[  368.081141] RBP: ffff8803414f74e8 R08: 0000000000000000 R09: 0000000000000000
[  368.082830] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88033cd70118
[  368.084565] R13: ffff88033cd70168 R14: ffff8803414f7680 R15: dead000000000100
[  368.087151] FS:  00007f206293e780(0000) GS:ffff880373800000(0000) knlGS:0000000000000000
[  368.089087] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  368.090616] CR2: 000055d225976b70 CR3: 000000033f992004 CR4: 00000000003606e0
[  368.092390] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  368.094103] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  368.095812] Call Trace:
[  368.096700]  btrfs_free_block_groups+0x1da/0x3b0 [btrfs]
[  368.098065]  close_ctree+0x171/0x330 [btrfs]
[  368.099254]  generic_shutdown_super+0x6c/0x100
[  368.100486]  kill_anon_super+0x14/0x30
[  368.101554]  btrfs_kill_super+0x13/0x100 [btrfs]
[  368.102758]  deactivate_locked_super+0x2f/0x70
[  368.103986]  cleanup_mnt+0x3b/0x70
[  368.105002]  task_work_run+0x9e/0xd0
[  368.106038]  do_syscall_64+0x470/0x600
[  368.107123]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  368.108397]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  368.109677] RIP: 0033:0x7f2062ec1b5b
[  368.115270] RSP: 002b:00007ffd75ebd748 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  368.117866] RAX: 0000000000000000 RBX: 000055b8b9bdb2b0 RCX: 00007f2062ec1b5b
[  368.119595] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055b8b9bdb490
[  368.121368] RBP: 0000000000000000 R08: 000055b8b9bdb4b0 R09: 00007ffd75ebbfa0
[  368.122983] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b8b9bdb490
[  368.124680] R13: 00007f20631e11a4 R14: 0000000000000000 R15: 00007ffd75ebd9b8
[  368.126330] irq event stamp: 0
[  368.127242] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[  368.128874] hardirqs last disabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.130836] softirqs last  enabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.132742] softirqs last disabled at (0): [<0000000000000000>]           (null)
[  368.134443] ---[ end trace 08fc3163d80dad82 ]---
[  368.140638] WARNING: CPU: 2 PID: 14918 at fs/btrfs/extent-tree.c:9789 btrfs_free_block_groups+0x2af/0x3b0 [btrfs]
[  368.143175] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core
[  368.145923] CPU: 2 PID: 14918 Comm: umount Kdump: loaded Tainted: G        W         4.19.0-rc8+ #18
[  368.148908] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  368.150766] RIP: 0010:btrfs_free_block_groups+0x2af/0x3b0 [btrfs]
[  368.156851] RSP: 0018:ffffc9000744bdb0 EFLAGS: 00010206
[  368.158212] RAX: ffff8803414f4620 RBX: ffff88033cd70000 RCX: 0000000000000000
[  368.159883] RDX: 0000000000000002 RSI: ffff88033cd71750 RDI: ffff8803414f7a38
[  368.161614] RBP: ffff8803414f0558 R08: 0000000000000000 R09: ffff8803414f7b70
[  368.163340] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88033cd70118
[  368.165029] R13: ffff8803414f4620 R14: 0000000000000000 R15: dead000000000100
[  368.166730] FS:  00007f206293e780(0000) GS:ffff880373800000(0000) knlGS:0000000000000000
[  368.168613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  368.170055] CR2: 000055d225976b70 CR3: 000000033f992004 CR4: 00000000003606e0
[  368.171794] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  368.173501] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  368.175273] Call Trace:
[  368.176969]  close_ctree+0x171/0x330 [btrfs]
[  368.178203]  generic_shutdown_super+0x6c/0x100
[  368.179443]  kill_anon_super+0x14/0x30
[  368.180560]  btrfs_kill_super+0x13/0x100 [btrfs]
[  368.181794]  deactivate_locked_super+0x2f/0x70
[  368.182975]  cleanup_mnt+0x3b/0x70
[  368.184024]  task_work_run+0x9e/0xd0
[  368.185051]  do_syscall_64+0x470/0x600
[  368.186098]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  368.187392]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  368.188675] RIP: 0033:0x7f2062ec1b5b
[  368.194299] RSP: 002b:00007ffd75ebd748 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  368.195990] RAX: 0000000000000000 RBX: 000055b8b9bdb2b0 RCX: 00007f2062ec1b5b
[  368.197690] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055b8b9bdb490
[  368.199348] RBP: 0000000000000000 R08: 000055b8b9bdb4b0 R09: 00007ffd75ebbfa0
[  368.200998] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b8b9bdb490
[  368.202651] R13: 00007f20631e11a4 R14: 0000000000000000 R15: 00007ffd75ebd9b8
[  368.204354] irq event stamp: 0
[  368.205236] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[  368.207825] hardirqs last disabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.209804] softirqs last  enabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.211807] softirqs last disabled at (0): [<0000000000000000>]           (null)
[  368.213501] ---[ end trace 08fc3163d80dad83 ]---
[  368.214836] BTRFS info (device dm-3): space_info 1 has 7708672 free, is not full
[  368.216595] BTRFS info (device dm-3): space_info total=8388608, used=585728, pinned=0, reserved=86016, may_use=8192, readonly=0
[  368.219751] WARNING: CPU: 2 PID: 14918 at fs/btrfs/extent-tree.c:9789 btrfs_free_block_groups+0x2af/0x3b0 [btrfs]
[  368.222497] Modules linked in: btrfs xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs nvme nvme_core
[  368.225120] CPU: 2 PID: 14918 Comm: umount Kdump: loaded Tainted: G        W         4.19.0-rc8+ #18
[  368.227581] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  368.229402] RIP: 0010:btrfs_free_block_groups+0x2af/0x3b0 [btrfs]
[  368.235564] RSP: 0018:ffffc9000744bdb0 EFLAGS: 00010206
[  368.237770] RAX: ffff8803414f7b40 RBX: ffff88033cd70000 RCX: 000000000017000c
[  368.239647] RDX: 0000000000000002 RSI: 000000000017000c RDI: ffffffff8125fb74
[  368.241447] RBP: ffff8803414f47d0 R08: 0000000000000000 R09: 0000000000000000
[  368.243206] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8803414f4848
[  368.245071] R13: ffff8803414f7b40 R14: 0000000000000000 R15: dead000000000100
[  368.246825] FS:  00007f206293e780(0000) GS:ffff880373800000(0000) knlGS:0000000000000000
[  368.248758] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  368.250245] CR2: 000055d225976b70 CR3: 000000033f992004 CR4: 00000000003606e0
[  368.251982] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  368.253714] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  368.255491] Call Trace:
[  368.256375]  close_ctree+0x171/0x330 [btrfs]
[  368.257584]  generic_shutdown_super+0x6c/0x100
[  368.258786]  kill_anon_super+0x14/0x30
[  368.259900]  btrfs_kill_super+0x13/0x100 [btrfs]
[  368.261180]  deactivate_locked_super+0x2f/0x70
[  368.262433]  cleanup_mnt+0x3b/0x70
[  368.263452]  task_work_run+0x9e/0xd0
[  368.264531]  do_syscall_64+0x470/0x600
[  368.265621]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  368.267805]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  368.269288] RIP: 0033:0x7f2062ec1b5b
[  368.275103] RSP: 002b:00007ffd75ebd748 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  368.276887] RAX: 0000000000000000 RBX: 000055b8b9bdb2b0 RCX: 00007f2062ec1b5b
[  368.278598] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 000055b8b9bdb490
[  368.280268] RBP: 0000000000000000 R08: 000055b8b9bdb4b0 R09: 00007ffd75ebbfa0
[  368.281917] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b8b9bdb490
[  368.283580] R13: 00007f20631e11a4 R14: 0000000000000000 R15: 00007ffd75ebd9b8
[  368.285271] irq event stamp: 0
[  368.286151] hardirqs last  enabled at (0): [<0000000000000000>]           (null)
[  368.287851] hardirqs last disabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.289798] softirqs last  enabled at (0): [<ffffffff810cd810>] copy_process.part.55+0x3b0/0x1f00
[  368.291756] softirqs last disabled at (0): [<0000000000000000>]           (null)
[  368.293419] ---[ end trace 08fc3163d80dad84 ]---
[  368.294684] BTRFS info (device dm-3): space_info 4 has 275857408 free, is not full
[  368.297278] BTRFS info (device dm-3): space_info total=276824064, used=114688, pinned=0, reserved=0, may_use=786432, readonly=65536
[  368.300677] VFS: Busy inodes after unmount of dm-3. Self-destruct in 5 seconds.  Have a nice day...

--GvXjxJ+pjyke8COw--
