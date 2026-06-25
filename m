Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CFC28C5CB
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415222; cv=none; b=WLCIu63Zt4mKCEwP5UsZfcpwDPzzxn/1Pb99RH64xO/bN39cRiAFiTfgG9JWCV/14dJDdCYyIP2XKvUJNJB0Lzf5zvXeHXUhd1d64KfZJ57MhzRgCi6I1USfHALsS6+8iCHCZ85ZkLUzfNjNBqk7WZzf5DB3FJMbo4J974eJxjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415222; c=relaxed/simple;
	bh=4X9TxWZnlb86+MYEx+1ynPkScUTmBN+EEktPqQ08ZxM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQmyvi2NGR59ZFHxpgxd/lxczpUqS8fzsyPfOsdjo6tndRnX91/j7Zgm/UL95t2OjOzAAs9Skn735x/UAKGpHJlyySQjA+S8Yi2vYK0mamfDnAKDfldND72foMeohsKrZNA+wN3rKSbNKXLOBJShNenfA5tpxUMC4Gq7lEatKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kqe3KR6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kqe3KR6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B9D1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415221;
	bh=y+Ouy7E6Y42FcMlSG1Vlg6N/EG3LkGT47mtKXt/2S7Y=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Kqe3KR6jBDkQ8+7Jjc+a09NfyixaPUQ7xJMtCdwBudhR3zErcRSN46HqhqUQc6wdd
	 M9sQv/0ltxoueIXNH7gEjN7yz+rwTQZACDUw+4qL8s+3H6Uc/IpItD+MCf+4APvPYT
	 S2wMiFuRCIX57t7O1pNl5FH1F/VrtL1tlELdqgF22S/QXuEEiJ9fyfJgO+6/OZakph
	 iYzMsX0W77mmDnU4uehKowbvcZ8PkNMBtJUXOwgcdLES9OQyMjY4P/bNT6Y4IdnOeI
	 CrrLFBoy21/Lrexne7WYpBNJDYmAuI1GroXHYpEwpp5WR0YJMZEJapp6jVbvZyrM/w
	 i3f7HjUdLgpZg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: defrag: fix deadlock between defrag and delalloc space reservation
Date: Thu, 25 Jun 2026 20:20:11 +0100
Message-ID: <9ad3db9fd98c7bbbdb74d06270ddce24b22e475c.1782321584.git.fdmanana@suse.com>
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

While running fsstress with autodefrag and flushoncommit, hit a deadlock
due to the fact that defrag reserves delalloc space while it's holding
dirty and locked folios, besides the extent range lock. The stack traces
are the following:

   [430958.624136] task:kworker/u50:3   state:D stack:0     pid:20365 tgid:20365 ppid:2      task_flags:0x4208060 flags:0x00080000
   [430958.626267] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
   [430958.627821] Call Trace:
   [430958.628351]  <TASK>
   [430958.628990]  __schedule+0x4be/0x10f0
   [430958.629791]  ? preempt_count_add+0x69/0xa0
   [430958.630605]  schedule+0x26/0xd0
   [430958.631327]  wait_current_trans+0x102/0x160 [btrfs]
   [430958.632414]  ? __pfx_autoremove_wake_function+0x10/0x10
   [430958.633515]  start_transaction+0x374/0x900 [btrfs]
   [430958.634601]  btrfs_commit_current_transaction+0x1d/0x70 [btrfs]
   [430958.635982]  flush_space+0xca/0x5e0 [btrfs]
   [430958.636996]  ? _raw_spin_unlock+0x15/0x30
   [430958.637894]  ? btrfs_reduce_alloc_profile+0x8c/0x190 [btrfs]
   [430958.639217]  ? _raw_spin_unlock+0x15/0x30
   [430958.640030]  ? calc_available_free_space.isra.0+0x6f/0x110 [btrfs]
   [430958.641462]  do_async_reclaim_metadata_space+0x84/0x190 [btrfs]
   [430958.642711]  btrfs_async_reclaim_metadata_space+0x64/0x80 [btrfs]
   [430958.644015]  process_one_work+0x19d/0x3a0
   [430958.644873]  worker_thread+0x1c4/0x330
   [430958.645668]  ? __pfx_worker_thread+0x10/0x10
   [430958.646535]  kthread+0xfc/0x130
   [430958.647285]  ? __pfx_kthread+0x10/0x10
   [430958.648068]  ret_from_fork+0x1f7/0x2c0
   [430958.648894]  ? __pfx_kthread+0x10/0x10
   [430958.649713]  ret_from_fork_asm+0x1a/0x30
   [430958.650536]  </TASK>
   [430958.651036] task:kworker/u49:7   state:D stack:0     pid:52990 tgid:52990 ppid:2      task_flags:0x4208060 flags:0x00080000
   [430958.653709] Workqueue: writeback wb_workfn (flush-btrfs-334)
   [430958.655110] Call Trace:
   [430958.655737]  <TASK>
   [430958.656284]  __schedule+0x4be/0x10f0
   [430958.657178]  ? __blk_flush_plug+0xe9/0x140
   [430958.658188]  schedule+0x26/0xd0
   [430958.658982]  io_schedule+0x42/0x70
   [430958.659850]  folio_wait_bit_common+0x12b/0x330
   [430958.660954]  ? folio_wait_bit_common+0x100/0x330
   [430958.662157]  ? __pfx_wake_page_function+0x10/0x10
   [430958.663328]  extent_write_cache_pages+0x599/0x830 [btrfs]
   [430958.664496]  ? acpi_fwnode_get_reference_args+0x1fa/0x270
   [430958.665579]  btrfs_writepages+0x77/0x130 [btrfs]
   [430958.666614]  ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs]
   [430958.667846]  do_writepages+0xc6/0x160
   [430958.668596]  __writeback_single_inode+0x42/0x310
   [430958.669535]  writeback_sb_inodes+0x231/0x570
   [430958.670583]  wb_writeback+0x8a/0x340
   [430958.671383]  wb_workfn+0xbf/0x450
   [430958.672058]  ? finish_task_switch.isra.0+0xc1/0x350
   [430958.673026]  process_one_work+0x19d/0x3a0
   [430958.673814]  worker_thread+0x1c4/0x330
   [430958.674565]  ? __pfx_worker_thread+0x10/0x10
   [430958.675440]  kthread+0xfc/0x130
   [430958.676084]  ? __pfx_kthread+0x10/0x10
   [430958.676832]  ret_from_fork+0x1f7/0x2c0
   [430958.677582]  ? __pfx_kthread+0x10/0x10
   [430958.678369]  ret_from_fork_asm+0x1a/0x30
   [430958.679171]  </TASK>
   [430958.679644] task:btrfs-cleaner   state:D stack:0     pid:296750 tgid:296750 ppid:2      task_flags:0x208040 flags:0x00080000
   [430958.681812] Call Trace:
   [430958.682318]  <TASK>
   [430958.682762]  __schedule+0x4be/0x10f0
   [430958.683542]  schedule+0x26/0xd0
   [430958.684264]  handle_reserve_ticket+0x1b9/0x2c0 [btrfs]
   [430958.685366]  ? __pfx_autoremove_wake_function+0x10/0x10
   [430958.686520]  reserve_bytes+0x283/0x4c0 [btrfs]
   [430958.687610]  btrfs_reserve_metadata_bytes+0x18/0xb0 [btrfs]
   [430958.688860]  btrfs_delalloc_reserve_metadata+0x121/0x320 [btrfs]
   [430958.690263]  btrfs_delalloc_reserve_space+0x46/0xb0 [btrfs]
   [430958.691675]  btrfs_defrag_file+0x903/0x1110 [btrfs]
   [430958.692879]  btrfs_run_defrag_inodes+0x334/0x430 [btrfs]
   [430958.694005]  cleaner_kthread+0x97/0x1c0 [btrfs]
   [430958.694969]  ? __pfx_cleaner_kthread+0x10/0x10 [btrfs]
   [430958.696232]  kthread+0xfc/0x130
   [430958.696954]  ? __pfx_kthread+0x10/0x10
   [430958.697763]  ret_from_fork+0x1f7/0x2c0
   [430958.698521]  ? __pfx_kthread+0x10/0x10
   [430958.699348]  ret_from_fork_asm+0x1a/0x30
   [430958.700217]  </TASK>
   [430958.716533] task:fsstress        state:D stack:0     pid:296769 tgid:296769 ppid:296768 task_flags:0x400140 flags:0x00080000
   [430958.718780] Call Trace:
   [430958.719366]  <TASK>
   [430958.719817]  __schedule+0x4be/0x10f0
   [430958.720611]  ? preempt_count_add+0x69/0xa0
   [430958.721465]  schedule+0x26/0xd0
   [430958.722150]  wb_wait_for_completion+0x79/0xc0
   [430958.723109]  ? __pfx_autoremove_wake_function+0x10/0x10
   [430958.724173]  __writeback_inodes_sb_nr+0xc5/0xf0
   [430958.725081]  try_to_writeback_inodes_sb+0x55/0x70
   [430958.726075]  btrfs_commit_transaction+0x19d/0xeb0 [btrfs]
   [430958.727337]  ? start_transaction+0x343/0x900 [btrfs]
   [430958.728422]  btrfs_mksubvol+0x28b/0x4e0 [btrfs]
   [430958.729445]  btrfs_mksnapshot+0x74/0xa0 [btrfs]
   [430958.730511]  __btrfs_ioctl_snap_create+0x194/0x210 [btrfs]
   [430958.732245]  btrfs_ioctl_snap_create_v2+0xef/0x150 [btrfs]
   [430958.733636]  btrfs_ioctl+0x7ec/0x2a70 [btrfs]
   [430958.734665]  ? __virt_addr_valid+0xe4/0x180
   [430958.735534]  ? __check_object_size+0x1cd/0x1f0
   [430958.736613]  ? kmem_cache_free+0x146/0x380
   [430958.737645]  ? _raw_spin_unlock+0x15/0x30
   [430958.738660]  ? do_sys_openat2+0x83/0xd0
   [430958.739637]  __x64_sys_ioctl+0x92/0xe0
   [430958.740576]  do_syscall_64+0x60/0x590
   [430958.741512]  ? clear_bhb_loop+0x60/0xb0
   [430958.742485]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
   [430958.743772] RIP: 0033:0x7f4431e108db
   [430958.744668] RSP: 002b:00007ffcd147db20 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
   [430958.746327] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f4431e108db
   [430958.747816] RDX: 00007ffcd147eb90 RSI: 0000000050009417 RDI: 0000000000000005
   [430958.749479] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
   [430958.751216] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcd147fbf0
   [430958.752929] R13: 00007ffcd147eb90 R14: 0000000000000005 R15: 0000000000000003
   [430958.754684]  </TASK>

What happens is the following:

1) The cleaner kthread is running autodefrag, and in defrag_one_range()
   it acquired all the folios for the range and locked them.

   Then it locked the extent range in the inode's iotree.

   It got two subranges from defrag_collect_targets(), the first one
   with folio A and the second one with folio B.

   After it defraged the first subrange, folio A remains locked and
   dirty - it's only unlocked when defrag_one_range() returns.

   When it attempts to defrag the second subrange (containing folio B),
   btrfs_delalloc_reserve_space() creates a space reservation ticket,
   due to lack of free metadata space and blocks waiting for the async
   metadata reclaim task to free space and wake it up;

2) The async reclaim metadata task attempts to commit the current
   transaction, but it blocks because there is another task that
   started the commit first;

3) A task creating a snapshot is committing the transaction and
   because the fs was mounted with flushoncommit, it calls
   try_to_writeback_inodes_sb(), which spawns a task to flush
   delalloc and waits for it to complete;

4) The task flushing delalloc (kworker/u49:7), finds that folio A for
   the inode being defragged is dirty, so it tries to lock it...

   But it blocks because folio A is locked by the defrag task (the
   cleaner kthread) which is blocked waiting for the reservation
   ticket to be served, but the async reclaim metadata task is
   blocked waiting for the transaction commit, which in turn is
   blocked waiting for the delalloc flush task, which is trying to
   lock folio A, resulting in a deadlock.

The same type of problem can happen if the async reclaim task starts to
flush delalloc, as that requires both locking the folio and the extent
rannge in the inode's io tree, and in this case we don't need the fs to
be mounted with flushoncommit. This type of problem has ocurred several
times in the past with reflinks for example, where we had a dirty folio
while holding the extent range locked and then starting a transaction
blocked waiting for the async reclaim task due to lack of free metadata
space.

So fix this by reserving delalloc space before locking folios and locking
the extent range in the inode's iotree. We can not simply unlock the
folios for each subrange given by defrag_collect_targets() after we defrag
it because the same folio may be present too in the next subrange (due to
large folios).

Fixes: 22b398eeeed4 ("btrfs: defrag: introduce helper to defrag a contiguous prepared range")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 50 +++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index f0c6758b7055..0697b285e05f 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1130,20 +1130,15 @@ static_assert(PAGE_ALIGNED(CLUSTER_SIZE));
  *
  * - Extent bits are locked
  */
-static int defrag_one_locked_target(struct btrfs_inode *inode,
-				    struct defrag_target_range *target,
-				    struct folio **folios, int nr_pages,
-				    struct extent_state **cached_state)
+static void defrag_one_locked_target(struct btrfs_inode *inode,
+				     struct defrag_target_range *target,
+				     struct folio **folios, int nr_pages,
+				     struct extent_state **cached_state)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct extent_changeset *data_reserved = NULL;
 	const u64 start = target->start;
 	const u64 len = target->len;
-	int ret = 0;
 
-	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start, len);
-	if (ret < 0)
-		return ret;
 	btrfs_clear_extent_bit(&inode->io_tree, start, start + len - 1,
 			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
 			       EXTENT_DEFRAG, cached_state);
@@ -1164,10 +1159,6 @@ static int defrag_one_locked_target(struct btrfs_inode *inode,
 			continue;
 		btrfs_folio_clamp_set_dirty(fs_info, folio, start, len);
 	}
-	btrfs_delalloc_release_extents(inode, len);
-	extent_changeset_free(data_reserved);
-
-	return ret;
 }
 
 static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
@@ -1183,6 +1174,8 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	u64 cur = start;
 	const unsigned int nr_pages = ((start + len - 1) >> PAGE_SHIFT) -
 				      (start >> PAGE_SHIFT) + 1;
+	struct extent_changeset *data_reserved = NULL;
+	u64 last_defrag_end = start;
 	int ret = 0;
 
 	ASSERT(nr_pages <= CLUSTER_SIZE / PAGE_SIZE);
@@ -1192,6 +1185,22 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	if (!folios)
 		return -ENOMEM;
 
+	/*
+	 * Reserve delalloc space before locking the range and before locking
+	 * and dirtying any folios - otherwise we could deadlock, for example
+	 * after defrag of one range we dirty folios and keep them locked when
+	 * we move to the next range, so reserving delalloc space right before
+	 * each range could trigger flushing of delalloc and deadlock on the
+	 * extent lock or trigger a transaction commit with flushoncommit, which
+	 * can either deadlock on the lock of a folio made dirty in the previous
+	 * range or the extent lock.
+	 */
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start, len);
+	if (ret < 0) {
+		kfree(folios);
+		return ret;
+	}
+
 	/* Prepare all pages */
 	for (int i = 0; cur < start + len && i < nr_pages; i++) {
 		folios[i] = defrag_prepare_one_folio(inode, cur >> PAGE_SHIFT);
@@ -1226,10 +1235,11 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 		goto unlock_extent;
 
 	list_for_each_entry(entry, &target_list, list) {
-		ret = defrag_one_locked_target(inode, entry, folios, nr_pages,
-					       &cached_state);
-		if (ret < 0)
-			break;
+		defrag_one_locked_target(inode, entry, folios, nr_pages, &cached_state);
+		if (entry->start > last_defrag_end)
+			btrfs_delalloc_release_space(inode, data_reserved, last_defrag_end,
+						     entry->start - last_defrag_end, true);
+		last_defrag_end = entry->start + entry->len;
 	}
 
 	list_for_each_entry_safe(entry, tmp, &target_list, list) {
@@ -1246,6 +1256,12 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 		folio_put(folios[i]);
 	}
 	kfree(folios);
+	btrfs_delalloc_release_extents(inode, len);
+	if (last_defrag_end < start + len)
+		btrfs_delalloc_release_space(inode, data_reserved, last_defrag_end,
+					     start + len - last_defrag_end, true);
+	extent_changeset_free(data_reserved);
+
 	return ret;
 }
 
-- 
2.47.2

