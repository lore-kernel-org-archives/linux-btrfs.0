Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489EC33A6E2
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415223; cv=none; b=bZMP0zx68C637tRutF2SN2fgcfOKFx3AMgUm+gK7jQ5TGbgZurGpDaKpU4QGHH5XxO4xBIUfMAsSwKG9QDPl6ZbXVniQtWCQjD2SE5hNcIWETr/Iqs1eBcR4Udtl7Qop+OLUvaiHTHgXZhS2nLacKKSBAPeRvavbpHQMfPRJHHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415223; c=relaxed/simple;
	bh=gWCOO2Gmf0PcbyrjXFLe7JBkEkaZX1ljbLSeR9FuJcU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/RXgFcmqByjGIlhDbOH5d4/G23e5jqBOzlb3yGrUYmsGuWr4yFDRpRtCQEqYgXgZ5A8IAM5wBjnOIKdfdf38COU8t/5ZL8cKCe0WZ3XcT3DEMvoOHZ8BNKpRXDh92IcuXETOwLILIZNfXLUytx9ZtqNTfsA52CBjKdgJdCpWF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OugOJl0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OugOJl0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F881F000E9
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415222;
	bh=gYuHFpCJ1aeAA4FbqBIZYXKAE+J+s+/cKVkIwZlF9l4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=OugOJl0Miv4T8dQ2BbTQKLZJSmWLogVUIwuL1euXWGTNyRI4pJ22AvvG9wNHhRvkp
	 t2yzXwTCu0QC6yWuttlNW+GEtLbqNpdbLReW7ivlFxQmNJNF4+yiNMfEDpGvXFxelT
	 M4R6H/93hxaCmGTvS6/8SGpDfg6xlTQB7dAnzp3/Z1YUOgO0buye6CZcWpV6lWsu4Q
	 Djbn00mpajKPzf8OcYivcWMqGGY3c0/W+pXuOBFqWhjomEOFybXegbYwSP+Cr3B0SG
	 3/AjDTZXOuZcRHM4+FWxpgATKQX78rQGjMl4QfCr979EVtIytF61+QqZhQRI2eOYSo
	 HUENaU/gzaaVw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: fix pending delayed iputs when using autodefrag
Date: Thu, 25 Jun 2026 20:20:12 +0100
Message-ID: <028ec86d8b83cebedf3b1f5090aaf34d39c55306.1782321584.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1782321584.git.fdmanana@suse.com>
References: <cover.1782321584.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Syzbot reported the following warning recently:

   [  157.672472][ T6611] BTRFS info (device loop0): turning on flush-on-commit
   [  157.672488][ T6611] BTRFS info (device loop0): enabling free space tree
   [  157.672504][ T6611] BTRFS info (device loop0): enabling auto defrag
   [  157.672555][ T6611] BTRFS info (device loop0): use lzo compression, level 1
   [  157.672574][ T6611] BTRFS info (device loop0): max_inline set to 4096
   [  158.094512][ T5608] BTRFS info (device loop2): last unmount of filesystem c9fe44da-de57-406a-8241-57ec7d4412cf
   [  160.073968][ T6656] BTRFS info (device loop0 state M): max_inline set to 4096
   [  160.418911][ T5611] BTRFS info (device loop0): last unmount of filesystem ab8108e1-bea5-4a9f-94c9-a3ff208d732a
   [  160.432287][ T6662] loop2: detected capacity change from 0 to 32768
   [  160.438859][ T6662] BTRFS: device fsid c9fe44da-de57-406a-8241-57ec7d4412cf devid 1 transid 8 /dev/loop2 (7:2) scanned by syz.2.74 (6662)
   [  160.459589][ T6662] BTRFS info (device loop2): first mount of filesystem c9fe44da-de57-406a-8241-57ec7d4412cf
   [  160.459616][ T6662] BTRFS info (device loop2): using crc32c checksum algorithm
   [  160.634366][ T1187] ------------[ cut here ]------------
   [  160.634376][ T1187] test_bit(BTRFS_FS_STATE_NO_DELAYED_IPUT, &fs_info->fs_state)
   [  160.634387][ T1187] WARNING: fs/btrfs/inode.c:3596 at btrfs_add_delayed_iput+0x2e3/0x340, CPU#0: kworker/u8:10/1187
   [  160.634412][ T1187] Modules linked in:
   [  160.634423][ T1187] CPU: 0 UID: 0 PID: 1187 Comm: kworker/u8:10 Not tainted syzkaller #0 PREEMPT_{RT,(full)}
   [  160.634435][ T1187] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
   [  160.634442][ T1187] Workqueue: btrfs-endio-write btrfs_work_helper
   [  160.634456][ T1187] RIP: 0010:btrfs_add_delayed_iput+0x2e3/0x340
   [  160.634468][ T1187] Code: 53 a3 45 (...)
   [  160.634482][ T1187] RSP: 0018:ffffc900065d77c8 EFLAGS: 00010293
   [  160.634490][ T1187] RAX: ffffffff83e5f502 RBX: ffff88805aba0000 RCX: ffff888029768000
   [  160.634497][ T1187] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
   [  160.634503][ T1187] RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
   [  160.634509][ T1187] R10: dffffc0000000000 R11: ffffed100b574497 R12: 0000000000000001
   [  160.634516][ T1187] R13: dffffc0000000000 R14: ffff888061194788 R15: 0000000000000200
   [  160.634523][ T1187] FS:  0000000000000000(0000) GS:ffff888126186000(0000) knlGS:0000000000000000
   [  160.634531][ T1187] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   [  160.634537][ T1187] CR2: 00007fe553a3f000 CR3: 00000000596c2000 CR4: 00000000003526f0
   [  160.634547][ T1187] Call Trace:
   [  160.634551][ T1187]  <TASK>
   [  160.634560][ T1187]  btrfs_put_ordered_extent+0x18f/0x430
   [  160.634577][ T1187]  btrfs_finish_one_ordered+0xf63/0x2680
   [  160.634598][ T1187]  ? __pfx_btrfs_finish_one_ordered+0x10/0x10
   [  160.634611][ T1187]  ? do_raw_spin_lock+0x12b/0x2f0
   [  160.634622][ T1187]  ? lock_acquire+0x106/0x350
   [  160.634636][ T1187]  ? __pfx_do_raw_spin_lock+0x10/0x10
   [  160.634650][ T1187]  btrfs_work_helper+0x38b/0xc20
   [  160.634666][ T1187]  ? process_scheduled_works+0xa70/0x1860
   [  160.634679][ T1187]  process_scheduled_works+0xb5d/0x1860
   [  160.634703][ T1187]  ? __pfx_process_scheduled_works+0x10/0x10
   [  160.634716][ T1187]  ? assign_work+0x3d5/0x5e0
   [  160.634729][ T1187]  worker_thread+0xa53/0xfc0
   [  160.634752][ T1187]  kthread+0x388/0x470
   [  160.634765][ T1187]  ? __pfx_worker_thread+0x10/0x10
   [  160.635870][ T1187]  ? __pfx_kthread+0x10/0x10
   [  160.635891][ T1187]  ret_from_fork+0x514/0xb70
   [  160.635907][ T1187]  ? __pfx_ret_from_fork+0x10/0x10
   [  160.635917][ T1187]  ? __switch_to+0xc79/0x1410
   [  160.635934][ T1187]  ? __pfx_kthread+0x10/0x10
   [  160.635948][ T1187]  ret_from_fork_asm+0x1a/0x30
   [  160.635969][ T1187]  </TASK>
   [  160.635975][ T1187] Kernel panic - not syncing: kernel: panic_on_warn set ...

It means we add a delayed iput created after we last ran delayed iputs in
close_ctree() and set the flag BTRFS_FS_STATE_NO_DELAYED_IPUT in fs_info.

This happens when using autodefrag and more likely to happen if we use
flushoncommit too. The steps are the following:

1) Unmount starts, all delalloc is flushed and we enter close_ctree();

2) In close_ctree() we park the cleaner kthread, but while we wait for it
   to park, it's in:

     btrfs_run_defrag_inodes()
        btrfs_run_defrag_inode()
           btrfs_defrag_file()
              defrag_one_cluster()
                 defrag_one_range()
                    defrag_one_locked_target()

   And dirties some folios from an inode;

3) The cleaner kthread parks and we proceed in close_ctree(), waiting
   for all ordered extents, running delayed iputs and setting the flag
   BTRFS_FS_STATE_NO_DELAYED_IPUT in fs_info;

4) Later in close_ctree() we call btrfs_commit_super(), which commits the
   current transaction. Because we are mounted with flushoncommit, the
   transaction commit flushes delalloc and waits for the resulting ordered
   extent to complete;

5) The ordered extents from the flushed dealloc created by autodefrag
   complete and create delayed iputs, triggering the warning:

     WARN_ON_ONCE(test_bit(BTRFS_FS_STATE_NO_DELAYED_IPUT, &fs_info->fs_state));

   in btrfs_add_delayed_iput()

6) Further below in close_ctree() we will hit the following assertion:

     ASSERT(list_empty(&fs_info->delayed_iputs));

   Since we don't expect any more delayed iputs.

Fix this by flushing delalloc and waiting for the ordered extents right
after we parked the cleaner kthread and waiting for autodefrag in
close_ctree().

Reported-by: syzbot+6a843bf8604711c8fab0@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6a1ee507.b4221f80.1326c5.0004.GAE@google.com/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa5922a21e51..93ca33ca24e7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4365,6 +4365,21 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	/*
+	 * After we entered close_ctree() autodefrag could be running and before
+	 * we parked the cleaner kthread, it dirtied folios of some inode.
+	 * We don't want to leave any delalloc here, it may be flushed any time
+	 * after this point and result in ordered extents that create delayed
+	 * iputs after flushed the ordered extent queues further below, run
+	 * delayed iputs and set BTRFS_FS_STATE_NO_DELAYED_IPUT. If we are
+	 * mounted with flushoncommit, then btrfs_commit_super() called below
+	 * will flush delalloc and wait for ordered extents but we end up
+	 * getting delayed iputs than are never run. So flush delalloc and wait
+	 * for ordered extents.
+	 */
+	writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
+	btrfs_wait_ordered_roots(fs_info, U64_MAX, NULL);
+
 	/*
 	 * Handle the error fs first, as it will flush and wait for all ordered
 	 * extents.  This will generate delayed iputs, thus we want to handle
-- 
2.47.2

