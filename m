Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6A4F6483;
	Mon, 31 Aug 2026 13:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183674; cv=none; b=SUVjKGaHkIwARrfUXJ3MwN+w/WN59fInt35OMrIPabHnNSv95t/yZfb1jd0RCiznUdWKx8lT9wq2Wm4rac622r+cNgqRTZzGLOH9XQFvRJO/5fZaJMnyFAu7OCrdGBw86tZjJInJuLW8Ih/PALFgAa9hGV6kWaaz2F/zbibTvgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183674; c=relaxed/simple;
	bh=AcDjFaXhT1eZ0fIpAPVqSX9EHXJ501HzNQgg9xcCtQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJqZ/QXXKmZ5wi533QK9Cp7e7lQOf8Caf7SQpDqZIKCB/YJWDQdN7SSx6APUkZbKbWjEwmPiUJfITC9WO6ggKec6Ln7OQGSoc6A8sZ3afRgXQHwc4upBMrKf04Q+bH5IVoducHsLKbpu4SB0FMYILFrvGLPyI+voN0MZ9fQN5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wi9crCda; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wi9crCda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233771F000E9;
	Mon, 31 Aug 2026 13:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183670;
	bh=cHu2xE4GCKhZy+JlEXuuFjwZyk5VxJ1jd08ccEkw6rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wi9crCdatBAySLjaaf7atlAnlUoxZqx03oDrY4TDvatMjZb75cPDjmL1pbuzMobSk
	 kdeM+y+Og6EbRhbCZdUHrmoIABeXuJOO6hRhShBpTYJY9iKCZlViKnN7f5wkNxXXr/
	 T1HQW9KjLjkKQHOGy+fdS9f6rHBLHvK3+ipTOQu63q/j+XffMp322slx504op18Tix
	 4JL+R5YlIMbxBiszMXnIJCXcFmka3hfKQCTp+zqlQV7Luq2OWUoQu95Y4+WncBUXqt
	 wu3g1FFV0EOgg+lhHeTKX3AQgHONkTMGNm3w7E2WjO2nY6K+sKgsW9DsyNg1KDA6pM
	 UgXImImEKzK1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()
Date: Mon, 31 Aug 2026 09:24:22 -0400
Message-ID: <20260831133314.4125787-234-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 83201804efa4a5168be754e1dfc9b2faee760cac ]

If during relocation we fail in insert_dirty_subvol() because
btrfs_update_reloc_root() returned an error, we will leave a root's
reloc_root field pointing to a reloc root that was freed instead of NULL,
resulting later in a use-after-free, or double free attempt during
unmount.

The sequence of steps is this:

1) During relocation the call to btrfs_update_reloc_root() in
   insert_dirty_subvol() fails, so insert_dirty_subvol() returns the
   error to merge_reloc_root() without adding the root to the list
   rc->dirty_subvol_roots;

2) Then merge_reloc_root() aborts the current transaction because
   insert_dirty_subvol() returned an error;

3) Up the call chain, merge_reloc_roots() gets the error, adds the
   reloc root for root X to the local reloc_roots list and jumps to the
   'out' label, where it calls free_reloc_roots() to free all the reloc
   roots in the local reloc_roots list. This frees the reloc root for
   root X;

4) We go up the call chain to relocate_block_group() which calls
   clean_dirty_subvols() to go over dirty roots and set their
   ->reloc_root field to NULL, but root X is not in the dirty_subvol_roots
   list, so its ->reloc_root still points to a reloc root;

5) Relocation finishes, with an error and a transaction abort, but the
   ->reloc_root field for root X still points to the reloc root that was
   freed in step 3;

6) When unmounting the fs we end up calling:

     btrfs_free_fs_roots()
        btrfs_drop_and_free_fs_root()
           --> calls btrfs_put_root() against root X's ->reloc_root
               which is not NULL and points to the already freed
               reloc root in step 4 above

  Resulting in a use-after-free to a double free attempt.

Syzbot reported this with the following dmesg/syslog:

   [  106.004389][ T5339] BTRFS error (device loop0 state A): Transaction aborted (error -5)
   [  106.014266][ T5339] BTRFS: error (device loop0 state A) in merge_reloc_root:1655: errno=-5 IO failure
   [  106.021891][ T1061] BTRFS error (device loop0 state A): error while writing out transaction: -5
   [  106.026964][ T1061] BTRFS warning (device loop0 state A): Skipping commit of aborted transaction.
   [  106.033807][ T5340] BTRFS error (device loop0 state A): bdev /dev/loop0 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
   [  106.039265][ T1061] BTRFS: error (device loop0 state A) in cleanup_transaction:2067: errno=-5 IO failure
   [  106.044382][ T5339] BTRFS info (device loop0 state EA): forced readonly
   [  106.074329][ T5339] BTRFS: error (device loop0 state EA) in merge_reloc_roots:1887: errno=-5 IO failure
   [  106.081004][ T5356] BTRFS info (device loop0 state EA): scrub: started on devid 1
   [  106.085611][ T5339] BTRFS info (device loop0 state EA): balance: ended with status: -30
   [  106.089517][ T5356] BTRFS info (device loop0 state EA): scrub: not finished on devid 1 with status: -30
   [  106.662365][ T5338] BTRFS info (device loop0 state EA): last unmount of filesystem 3a375e4e-b156-4d76-a2ad-16e198ce1409
   [  106.682946][ T5338] ==================================================================
   [  106.686574][ T5338] BUG: KASAN: slab-use-after-free in btrfs_put_root+0x2f/0x250
   [  106.690090][ T5338] Write of size 4 at addr ffff88803f978630 by task syz.0.0/5338
   [  106.693173][ T5338]
   [  106.694279][ T5338] CPU: 0 UID: 0 PID: 5338 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
   [  106.694293][ T5338] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
   [  106.694300][ T5338] Call Trace:
   [  106.694308][ T5338]  <TASK>
   [  106.694314][ T5338]  dump_stack_lvl+0xe8/0x150
   [  106.694331][ T5338]  print_address_description+0x55/0x1e0
   [  106.694343][ T5338]  ? btrfs_put_root+0x2f/0x250
   [  106.694358][ T5338]  print_report+0x58/0x70
   [  106.694368][ T5338]  kasan_report+0x117/0x150
   [  106.694384][ T5338]  ? btrfs_put_root+0x2f/0x250
   [  106.694399][ T5338]  kasan_check_range+0x264/0x2c0
   [  106.694416][ T5338]  btrfs_put_root+0x2f/0x250
   [  106.694430][ T5338]  btrfs_drop_and_free_fs_root+0x160/0x210
   [  106.694447][ T5338]  btrfs_free_fs_roots+0x2f9/0x3c0
   [  106.694464][ T5338]  ? __pfx_btrfs_free_fs_roots+0x10/0x10
   [  106.694479][ T5338]  ? free_root_pointers+0x5bf/0x5f0
   [  106.694494][ T5338]  close_ctree+0x798/0x12d0
   [  106.694511][ T5338]  ? __pfx_close_ctree+0x10/0x10
   [  106.694526][ T5338]  ? _raw_spin_unlock_irqrestore+0x74/0x80
   [  106.694599][ T5338]  ? rcu_preempt_deferred_qs_irqrestore+0x906/0xbc0
   [  106.694620][ T5338]  ? __rcu_read_unlock+0x83/0xe0
   [  106.694636][ T5338]  ? btrfs_put_super+0x48/0x1c0
   [  106.694652][ T5338]  ? __pfx_btrfs_put_super+0x10/0x10
   [  106.694667][ T5338]  generic_shutdown_super+0x13d/0x2d0
   [  106.694682][ T5338]  kill_anon_super+0x3b/0x70
   [  106.694695][ T5338]  btrfs_kill_super+0x41/0x50
   [  106.694710][ T5338]  deactivate_locked_super+0xbc/0x130
   [  106.694722][ T5338]  cleanup_mnt+0x437/0x4d0
   [  106.694736][ T5338]  ? _raw_spin_unlock_irq+0x23/0x50
   [  106.694752][ T5338]  task_work_run+0x1d9/0x270
   [  106.694769][ T5338]  ? __pfx_task_work_run+0x10/0x10
   [  106.694784][ T5338]  ? do_raw_spin_unlock+0x4d/0x210
   [  106.694802][ T5338]  do_exit+0x70f/0x22c0
   [  106.694817][ T5338]  ? trace_irq_disable+0x3b/0x140
   [  106.694835][ T5338]  ? __pfx_do_exit+0x10/0x10
   [  106.694848][ T5338]  ? preempt_schedule_thunk+0x16/0x30
   [  106.694863][ T5338]  ? preempt_schedule_common+0x82/0xd0
   [  106.694878][ T5338]  ? preempt_schedule_thunk+0x16/0x30
   [  106.694892][ T5338]  do_group_exit+0x21b/0x2d0
   [  106.694906][ T5338]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
   [  106.694918][ T5338]  __x64_sys_exit_group+0x3f/0x40
   [  106.694932][ T5338]  x64_sys_call+0x221a/0x2240
   [  106.694944][ T5338]  do_syscall_64+0x174/0x580
   [  106.694954][ T5338]  ? clear_bhb_loop+0x40/0x90
   [  106.694967][ T5338]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
   [  106.694978][ T5338] RIP: 0033:0x7f958ef9ce59
   [  106.694988][ T5338] Code: Unable to access opcode bytes at 0x7f958ef9ce2f.
   [  106.694994][ T5338] RSP: 002b:00007fffd4058318 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
   [  106.695008][ T5338] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f958ef9ce59
   [  106.695015][ T5338] RDX: 00007f958c3f8000 RSI: 0000000000000000 RDI: 0000000000000000
   [  106.695022][ T5338] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007f958f1e73e0
   [  106.695028][ T5338] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
   [  106.695034][ T5338] R13: 00007f958f1e73e0 R14: 0000000000000003 R15: 00007fffd40583d0
   [  106.695046][ T5338]  </TASK>
   [  106.695050][ T5338]
   [  106.821635][ T5338] Allocated by task 1061:
   [  106.823446][ T5338]  kasan_save_track+0x3e/0x80
   [  106.825498][ T5338]  __kasan_kmalloc+0x93/0xb0
   [  106.827381][ T5338]  __kmalloc_cache_noprof+0x31c/0x660
   [  106.829525][ T5338]  btrfs_alloc_root+0x75/0x930
   [  106.831458][ T5338]  read_tree_root_path+0x127/0xb00
   [  106.833556][ T5338]  btrfs_read_tree_root+0x34/0x60
   [  106.835553][ T5338]  create_reloc_root+0x6b3/0xcb0
   [  106.837556][ T5338]  btrfs_init_reloc_root+0x2ec/0x4b0
   [  106.839557][ T5338]  record_root_in_trans+0x2ab/0x350
   [  106.841685][ T5338]  btrfs_record_root_in_trans+0x15c/0x180
   [  106.844237][ T5338]  start_transaction+0x39c/0x1820
   [  106.846638][ T5338]  btrfs_finish_one_ordered+0x88e/0x2680
   [  106.849436][ T5338]  btrfs_work_helper+0x37b/0xc20
   [  106.851549][ T5338]  process_scheduled_works+0xb5d/0x1860
   [  106.853807][ T5338]  worker_thread+0xa53/0xfc0
   [  106.855773][ T5338]  kthread+0x389/0x470
   [  106.857548][ T5338]  ret_from_fork+0x514/0xb70
   [  106.859493][ T5338]  ret_from_fork_asm+0x1a/0x30
   [  106.861504][ T5338]
   [  106.862527][ T5338] Freed by task 5339:
   [  106.864224][ T5338]  kasan_save_track+0x3e/0x80
   [  106.866180][ T5338]  kasan_save_free_info+0x46/0x50
   [  106.868371][ T5338]  __kasan_slab_free+0x5c/0x80
   [  106.870462][ T5338]  kfree+0x1c5/0x640
   [  106.872180][ T5338]  __del_reloc_root+0x341/0x3b0
   [  106.874290][ T5338]  free_reloc_roots+0x5f/0x90
   [  106.876282][ T5338]  merge_reloc_roots+0x73f/0x8a0
   [  106.878489][ T5338]  relocate_block_group+0xbcc/0xe70
   [  106.880742][ T5338]  do_nonremap_reloc+0xa8/0x5b0
   [  106.882885][ T5338]  btrfs_relocate_block_group+0x7e6/0xc40
   [  106.885336][ T5338]  btrfs_relocate_chunk+0x115/0x820
   [  106.887502][ T5338]  __btrfs_balance+0x1db0/0x2ae0
   [  106.889543][ T5338]  btrfs_balance+0xaf3/0x11b0
   [  106.891456][ T5338]  btrfs_ioctl_balance+0x3d3/0x610
   [  106.893672][ T5338]  __se_sys_ioctl+0xfc/0x170
   [  106.895530][ T5338]  do_syscall_64+0x174/0x580
   [  106.897518][ T5338]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
   [  106.900101][ T5338]
   [  106.901123][ T5338] The buggy address belongs to the object at ffff88803f978000
   [  106.901123][ T5338]  which belongs to the cache kmalloc-4k of size 4096
   [  106.906907][ T5338] The buggy address is located 1584 bytes inside of
   [  106.906907][ T5338]  freed 4096-byte region [ffff88803f978000, ffff88803f979000)
   [  106.912980][ T5338]
   [  106.914022][ T5338] The buggy address belongs to the physical page:
   [  106.916716][ T5338] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3f978
   [  106.920390][ T5338] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
   [  106.923834][ T5338] flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
   [  106.927104][ T5338] page_type: f5(slab)
   [  106.928898][ T5338] raw: 04fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
   [  106.932507][ T5338] raw: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
   [  106.936193][ T5338] head: 04fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
   [  106.939856][ T5338] head: 0000000000000000 0000000800040004 00000000f5000000 0000000000000000
   [  106.943601][ T5338] head: 04fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
   [  106.947268][ T5338] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
   [  106.950988][ T5338] page dumped because: kasan: bad access detected
   [  106.953710][ T5338] page_owner tracks the page as allocated
   [  106.956198][ T5338] page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 24, tgid 24 (kworker/u4:2), ts 105728970387, free_ts 29540875453
   [  106.964984][ T5338]  post_alloc_hook+0x22d/0x280
   [  106.966956][ T5338]  get_page_from_freelist+0x2593/0x2610
   [  106.969307][ T5338]  __alloc_frozen_pages_noprof+0x18d/0x380
   [  106.971839][ T5338]  allocate_slab+0x77/0x660
   [  106.973709][ T5338]  refill_objects+0x339/0x3d0
   [  106.975696][ T5338]  __pcs_replace_empty_main+0x321/0x720
   [  106.978136][ T5338]  __kmalloc_node_track_caller_noprof+0x572/0x7b0
   [  106.981009][ T5338]  __alloc_skb+0x2c1/0x7d0
   [  106.982983][ T5338]  nsim_dev_trap_report_work+0x29a/0xb90
   [  106.985356][ T5338]  process_scheduled_works+0xb5d/0x1860
   [  106.987710][ T5338]  worker_thread+0xa53/0xfc0
   [  106.989847][ T5338]  kthread+0x389/0x470
   [  106.991727][ T5338]  ret_from_fork+0x514/0xb70
   [  106.993722][ T5338]  ret_from_fork_asm+0x1a/0x30
   [  106.995900][ T5338] page last free pid 77 tgid 77 stack trace:
   [  106.998479][ T5338]  __free_frozen_pages+0xc1c/0xd30
   [  107.000819][ T5338]  vfree+0x1d1/0x2f0
   [  107.002631][ T5338]  delayed_vfree_work+0x55/0x80
   [  107.004848][ T5338]  process_scheduled_works+0xb5d/0x1860
   [  107.007366][ T5338]  worker_thread+0xa53/0xfc0
   [  107.009388][ T5338]  kthread+0x389/0x470
   [  107.011177][ T5338]  ret_from_fork+0x514/0xb70
   [  107.013313][ T5338]  ret_from_fork_asm+0x1a/0x30
   [  107.015454][ T5338]
   [  107.016460][ T5338] Memory state around the buggy address:
   [  107.019052][ T5338]  ffff88803f978500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   [  107.022691][ T5338]  ffff88803f978580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   [  107.026264][ T5338] >ffff88803f978600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   [  107.029721][ T5338]                                      ^
   [  107.032062][ T5338]  ffff88803f978680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   [  107.035547][ T5338]  ffff88803f978700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   [  107.038865][ T5338] ==================================================================

Fix this by resetting a root's ->reloc_root if we get an error while
trying to merge a reloc root.

Reported-by: syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/6a1ebde9.c1435f33.112120.0176.GAE@google.com/
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: fix use-after-free on reloc root
after error in insert_dirty_subvol()`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`,
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)
**Fix commit:** `83201804efa4a` (not present in this checkout)
**Verdict target:** Should this fix be backported to **this** 6.18.y
tree?

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[btrfs] [fix] use-after-free on reloc root after error in
insert_dirty_subvol()`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Reported-by:** syzbot+b3d472d13f9d7bf20669@syzkaller.appspotmail.com
  (fuzzer-found, reproducible)
- **Link:** https://lore.kernel.org/linux-
  btrfs/6a1ebde9.c1435f33.112120.0176.GAE@google.com/ (syzbot report)
- **Reviewed-by:** Qu Wenruo \<wqu@suse.com\> (btrfs maintainer)
- **Signed-off-by:** Filipe Manana, David Sterba
- No `Fixes:` tag in the committed version (v1 had `Fixes:
  7934133fae5e`)
- No `Cc: stable@vger.kernel.org` (expected for manual review)
- No `Tested-by:`

**Notable patterns:** syzbot report + KASAN slab-use-after-free stack
trace = strong YES signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** On relocation error in `insert_dirty_subvol()` (when
  `btrfs_update_reloc_root()` fails), the subvolume root's
  `->reloc_root` is left pointing at a reloc root that gets freed in
  `merge_reloc_roots()` error cleanup, but the root is never added to
  `dirty_subvol_roots`, so `clean_dirty_subvols()` does not NULL it out.
- **Symptom:** KASAN slab-use-after-free (or double-free attempt) in
  `btrfs_put_root()` during unmount via `btrfs_free_fs_roots()` →
  `btrfs_drop_and_free_fs_root()`.
- **Trigger:** Balance/relocation with I/O failure during merge
  (`errno=-5` in syzbot log).
- **Root cause:** Missing cleanup of `root->reloc_root` on the
  `merge_reloc_root()` error path before `free_reloc_roots()`.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicitly labeled as UAF fix. The
`clear_reloc_root()` helper extraction is refactoring of existing
cleanup logic, not a feature.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `fs/btrfs/relocation.c` only (~55 lines changed)
- **Functions modified:** new `clear_reloc_root()`,
  `clean_dirty_subvols()`, `merge_reloc_roots()`
- **Scope:** Single-file, surgical error-path fix

### Step 2.2: CODE FLOW CHANGE (per hunk)

**Hunk 1 — new `clear_reloc_root()`:**
- **Before:** Inline `root->reloc_root = NULL; smp_wmb();
  clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE)` in `clean_dirty_subvols()`
- **After:** Shared helper with same semantics
- **Path:** Cleanup of merged subvolume reloc roots

**Hunk 2 — `clean_dirty_subvols()`:**
- **Before:** Inline NULL/barrier/clear_bit
- **After:** Calls `clear_reloc_root(root)` — behavior unchanged

**Hunk 3 — `merge_reloc_roots()` error path:**
- **Before:** On `merge_reloc_root()` failure: re-queue reloc_root to
  local list, `goto out` → `free_reloc_roots()` frees it, but
  `root->reloc_root` still points to freed object
- **After:** On failure: `clear_reloc_root(root)` first; properly
  balance refs with `btrfs_grab_root(reloc_root)` when re-queuing;
  `btrfs_put_root(reloc_root)` to drop `root->reloc_root` ref; move
  `btrfs_put_root(root)` after success path only

### Step 2.3: BUG MECHANISM
**Record:** **Category:** Use-after-free / reference-counting bug
**Mechanism:** Reloc root freed via `free_reloc_roots()` →
`__del_reloc_root()` while `root->reloc_root` still holds a dangling
pointer. On unmount with `BTRFS_FS_ERROR` set,
`btrfs_drop_and_free_fs_root()` calls `btrfs_put_root(root->reloc_root)`
on the freed object.

### Step 2.4: FIX QUALITY
**Record:** Fix is obviously correct and minimal. Extracting
`clear_reloc_root()` preserves the existing `smp_wmb()` pairing with
`have_reloc_root()`. The added `btrfs_grab_root()` on re-queue fixes a
secondary refcount imbalance. Low regression risk — only affects error
paths during relocation merge.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Current buggy error path at lines 1864–1870 last touched by
merge commit `5d324e5159d9e` (Nov 2025); underlying logic predates that.
The early-return-on-error pattern in `insert_dirty_subvol()` is present
at lines 1448–1450 in this tree.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag in committed version. v1 referenced `Fixes:
7934133fae5e` ("btrfs: handle btrfs_update_reloc_root failure in
insert_dirty_subvol", Mar 2021). That commit object exists in the repo
but `git merge-base --is-ancestor` reports it is **not** reachable from
HEAD (likely limited/disconnected history in this autosel checkout).
Regardless, the early-return pattern **is present** in the current tree.

### Step 3.3: FILE HISTORY FOR RELATED CHANGES
**Record:** Related recent fix already in tree: `60a23d4ea169e` "fix
root leak if its reloc root is unexpected in merge_reloc_roots()" —
different bug, same function. No duplicate fix for this UAF found.

### Step 3.4: AUTHOR'S OTHER COMMITS
**Record:** Filipe Manana is an active btrfs contributor. David Sterba
is btrfs maintainer. Qu Wenruo reviewed.

### Step 3.5: DEPENDENT/PREREQUISITE COMMITS
**Record:** Standalone single patch (v1–v5 were iterations of the same
fix). `git apply --check` on `83201804efa4a` succeeds cleanly against
HEAD. No series dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c 83201804efa4a` → [PATCH v5](https://patch.msgid.l
ink/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana@sus
e.com). Series: v1 (Jun 9) → v5 (Jun 11, 2026). Committed version
matches v5.

### Step 4.2: REVIEWERS
**Record:** `b4 dig -w` — sent to `fdmanana@kernel.org`, `linux-
btrfs@vger.kernel.org`. Reviewed-by Qu Wenruo in commit and on list.

### Step 4.3: BUG REPORT
**Record:** syzbot report with full KASAN trace. Trigger:
`btrfs_ioctl_balance` → relocation → I/O error during merge → UAF on
unmount. Crash type: `KASAN: slab-use-after-free in btrfs_put_root`.

### Step 4.4: RELATED PATCHES
**Record:** v1 proposed fixing `insert_dirty_subvol()` to always add to
dirty list even on error; v4/v5 moved fix to `merge_reloc_roots()` error
path (cleaner). Final committed approach is v5.

### Step 4.5: STABLE MAILING LIST
**Record:** No explicit stable-list nomination found in available thread
excerpts. Not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `insert_dirty_subvol()`, `merge_reloc_root()`,
`merge_reloc_roots()`, `free_reloc_roots()`, `clean_dirty_subvols()`,
`clear_reloc_root()` (new), `btrfs_drop_and_free_fs_root()`

### Step 5.2: CALLERS
**Record:**
- `insert_dirty_subvol()` ← `merge_reloc_root()` (line 1661)
- `merge_reloc_root()` ← `merge_reloc_roots()` (line 1864)
- `merge_reloc_roots()` ← `relocate_block_group()` (line 3653), remap
  path (line 4198)
- `clean_dirty_subvols()` ← `relocate_block_group()` (line 3669)
- `btrfs_free_fs_roots()` ← `close_ctree()` during unmount

### Step 5.3: CALLEES
**Record:** `btrfs_update_reloc_root()`, `btrfs_grab_root()`,
`btrfs_put_root()`, `free_reloc_roots()` → `__del_reloc_root()` →
`kfree()`, `btrfs_abort_transaction()`

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:** Userspace `ioctl(BTRFS_IOC_BALANCE)` →
`btrfs_ioctl_balance()` → `__btrfs_balance()` → `btrfs_relocate_chunk()`
→ relocation merge path. **Reachable from userspace** via
balance/relocation ioctl.

### Step 5.5: SIMILAR PATTERNS
**Record:** `clean_dirty_subvols()` already does the correct `reloc_root
= NULL` + barrier + `clear_bit` for roots on the dirty list. The bug is
the missing equivalent cleanup for roots that fail before being added to
that list.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **YES.** Current tree at lines 1448–1450
(`insert_dirty_subvol` early return on error) and 1864–1870
(`merge_reloc_roots` error path without clearing `root->reloc_root`). No
`clear_reloc_root()` helper exists.

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git show 83201804efa4a | git
apply --check` passes with no conflicts.

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** `60a23d4ea169e` fixes a different leak in
`merge_reloc_roots()`. This UAF fix (`83201804efa4a`) is **not**
present.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: SUBSYSTEM AND CRITICALITY
**Record:** **Filesystem (btrfs)** — **IMPORTANT/CORE** for btrfs users.
Balance/relocation is a standard admin operation.

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** Actively maintained; recent reloc-related fixes in this tree
(`797dc567146c7`, `60a23d4ea169e`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** All btrfs users who run balance/relocation (or hit
relocation during chunk management) and encounter I/O errors during
merge. Not config-gated beyond `CONFIG_BTRFS_FS`.

### Step 8.2: TRIGGER CONDITIONS
**Record:** Relocation merge fails (I/O error `-EIO` demonstrated by
syzbot). Requires balance/relocation + subsequent unmount. Unprivileged
users can trigger via `BTRFS_IOC_BALANCE` if they have access to the
mount.

### Step 8.3: FAILURE MODE SEVERITY
**Record:** **CRITICAL** — KASAN-confirmed slab use-after-free /
potential double-free in `btrfs_put_root()` during filesystem teardown.
Memory corruption class bug with security implications.

### Step 8.4: RISK-BENEFIT
**Record:**
- **Benefit:** HIGH — prevents UAF on a standard error-recovery path
- **Risk:** LOW — ~55 lines, error-path only, reviewed by maintainer,
  applies cleanly
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- syzbot-reported, KASAN-confirmed UAF
- Reachable from userspace via balance ioctl
- Crash on unmount after relocation I/O error
- Small, surgical, single-file fix
- Reviewed by btrfs maintainer (Qu Wenruo)
- Applies cleanly to this 6.18.44 tree
- Buggy code confirmed present; fix not yet applied

**AGAINST backport:**
- Trigger requires relocation I/O failure (not everyday, but realistic)
- No concerns significant enough to block

**Unresolved:** `7934133fae5e` not reachable from HEAD in this repo's
history, but irrelevant since the buggy pattern is visibly present in
current code.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — syzbot reproducer,
   maintainer review
2. Fixes a real bug affecting users? **PASS** — confirmed UAF
3. Important issue? **PASS** — CRITICAL (UAF/double-free, security-
   relevant)
4. Small and contained? **PASS** — one file, ~55 lines, error path only
5. No new features or APIs? **PASS** — bug fix only
6. Can apply to local tree? **PASS** — `git apply --check` succeeds

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A (standard bug fix, not device-ID/quirk/build fix).

### Step 9.4: DECISION RATIONALE

This fix addresses a real, syzbot-confirmed use-after-free in btrfs
relocation error handling. The buggy code is present in Linux 6.18.44;
the fix is absent. When `btrfs_update_reloc_root()` fails during
relocation merge, the reloc root gets freed but `root->reloc_root`
remains dangling; on unmount with the filesystem in error state,
`btrfs_drop_and_free_fs_root()` dereferences the freed reloc root. The
patch correctly clears the pointer (with proper memory barrier),
balances reference counts, and applies cleanly. This is exactly the kind
of fix stable trees need.

---

## Verification

- [Phase 1] Parsed subject, tags: syzbot Reported-by, Link, Reviewed-by
  Qu Wenruo
- [Phase 1] Body describes 6-step failure sequence ending in KASAN UAF
  on unmount
- [Phase 2] Diff: 1 file, `clear_reloc_root()` helper +
  `merge_reloc_roots()` error-path fix
- [Phase 2] Verified UAF mechanism: `free_reloc_roots()` frees reloc
  root while `root->reloc_root` still set
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 3] `git merge-base --is-ancestor 83201804efa4a HEAD`: fix
  **NOT** in tree (exit 1)
- [Phase 3] `git show 83201804efa4a | git apply --check`: **passes
  cleanly**
- [Phase 3] Buggy code at `relocation.c:1448-1450` and `1864-1870`
  confirmed by read
- [Phase 4] `b4 dig -c 83201804efa4a`: v1–v5 series, v5 is final
- [Phase 4] `b4 dig -w`: linux-btrfs@vger.kernel.org CC'd
- [Phase 4] spinics v5 thread: Reviewed-by Qu Wenruo present
- [Phase 5] Call chain: `btrfs_ioctl_balance` → relocation →
  `merge_reloc_roots` → unmount
- [Phase 5] `btrfs_drop_and_free_fs_root()` at `disk-io.c:4119-4124`
  puts `reloc_root` when `BTRFS_FS_ERROR` — matches syzbot stack
- [Phase 6] `grep clear_reloc_root`: not found in tree (fix absent)
- [Phase 6] `insert_dirty_subvol` early return on
  `btrfs_update_reloc_root` error: present
- [Phase 8] Failure mode: KASAN slab-use-after-free, severity CRITICAL
- [Phase 3] UNVERIFIED: `7934133fae5e` ancestry from HEAD (merge-base
  exit 1); does not affect verdict since buggy pattern is confirmed
  present in current source

**YES**

 fs/btrfs/relocation.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f1104fa6efb3f..851cef16d4017 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1471,6 +1471,17 @@ static int insert_dirty_subvol(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static void clear_reloc_root(struct btrfs_root *root)
+{
+	root->reloc_root = NULL;
+	/*
+	 * Need barrier to ensure clear_bit() only happens after
+	 * root->reloc_root = NULL. Pairs with have_reloc_root().
+	 */
+	smp_wmb();
+	clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
+}
+
 static int clean_dirty_subvols(struct reloc_control *rc)
 {
 	struct btrfs_root *root;
@@ -1485,13 +1496,7 @@ static int clean_dirty_subvols(struct reloc_control *rc)
 			struct btrfs_root *reloc_root = root->reloc_root;
 
 			list_del_init(&root->reloc_dirty_list);
-			root->reloc_root = NULL;
-			/*
-			 * Need barrier to ensure clear_bit() only happens after
-			 * root->reloc_root = NULL. Pairs with have_reloc_root.
-			 */
-			smp_wmb();
-			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
+			clear_reloc_root(root);
 			if (reloc_root) {
 				/*
 				 * btrfs_drop_snapshot drops our ref we hold for
@@ -1876,13 +1881,32 @@ void merge_reloc_roots(struct reloc_control *rc)
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-			btrfs_put_root(root);
 			if (ret) {
-				if (list_empty(&reloc_root->root_list))
+				/*
+				 * Clear the reloc root since below we will call
+				 * free_reloc_roots(), otherwise we leave
+				 * root->reloc_root pointing to a freed reloc
+				 * root and trigger a use-after-free during
+				 * unmount or elsewhere.
+				 */
+				clear_reloc_root(root);
+				btrfs_put_root(root);
+				/*
+				 * We are adding the reloc_root to the local
+				 * reloc_roots list, so we add a ref for this
+				 * list which will be dropped below by the call
+				 * to free_reloc_roots().
+				 */
+				if (list_empty(&reloc_root->root_list)) {
 					list_add_tail(&reloc_root->root_list,
 						      &reloc_roots);
+					btrfs_grab_root(reloc_root);
+				}
+				/* Now drop the ref for root->reloc_root. */
+				btrfs_put_root(reloc_root);
 				goto out;
 			}
+			btrfs_put_root(root);
 		} else {
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root) {
-- 
2.53.0

