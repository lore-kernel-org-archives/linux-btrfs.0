Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23970 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdDJSXf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 14:23:35 -0400
Date: Mon, 10 Apr 2017 11:22:28 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Diego <diegocg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BUG: KASAN: use-after-free in btrfs_map_bio
Message-ID: <20170410182228.GA15214@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <3052252.Zum4sZZp4A@archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3052252.Zum4sZZp4A@archlinux>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 10, 2017 at 07:13:46PM +0200, Diego wrote:
> In the latest git, with KASAN enabled:
> 
> [  180.560145] BUG: KASAN: use-after-free in btrfs_map_bio+0x994/0x10b0 at addr ffff8803801a76fc
> [  180.560151] Read of size 4 by task localStorage DB/924
> [  180.560160] CPU: 0 PID: 924 Comm: localStorage DB Not tainted 4.11.0-rc6-g39da7c509acf #19
> [  180.560165] Hardware name: Shuttle Inc. SH81R/FH81, BIOS 1.04 01/26/2015
> [  180.560170] Call Trace:
> [  180.560181]  dump_stack+0xd5/0x144
> [  180.560190]  ? _atomic_dec_and_lock+0xcc/0xcc
> [  180.560205]  kasan_object_err+0x21/0x90
> [  180.560212]  kasan_report+0x38b/0x980
> [  180.560219]  ? generic_make_request+0x990/0x990
> [  180.560225]  ? btrfs_map_bio+0x994/0x10b0
> [  180.560230]  ? btrfs_map_bio+0x994/0x10b0
> [  180.560239]  ? btrfs_map_bio+0x994/0x10b0
> [  180.560253]  __asan_report_load4_noabort+0x19/0x20
> [  180.560259]  btrfs_map_bio+0x994/0x10b0
> [  180.560275]  ? btrfs_rmap_block+0x1250/0x1250
> [  180.560293]  ? debug_check_no_locks_freed+0x350/0x350
> [  180.560302]  ? print_irqtrace_events+0x290/0x290
> [  180.560315]  btrfs_submit_bio_hook+0x285/0x810
> [  180.560322]  ? btrfs_merge_bio_hook+0x23a/0x4b0
> [  180.560333]  ? btrfs_readpage_end_io_hook+0x560/0x560
> [  180.560341]  submit_one_bio+0x217/0x400
> [  180.560352]  submit_extent_page+0xcc/0x4a0
> [  180.560366]  __extent_writepage_io+0x780/0xbc0
> [  180.560375]  ? end_extent_writepage+0x240/0x240
> [  180.560401]  __extent_writepage+0x73c/0xbb0
> [  180.560416]  ? __extent_writepage_io+0xbc0/0xbc0
> [  180.560426]  ? clear_page_dirty_for_io+0x3cd/0xaa0
> [  180.560435]  ? redirty_page_for_writepage+0x90/0x90
> [  180.560451]  extent_write_cache_pages.constprop.11+0x681/0xb80
> [  180.560460]  ? btrfs_sync_file+0x842/0xe10
> [  180.560475]  ? __extent_writepage+0xbb0/0xbb0
> [  180.560486]  ? print_irqtrace_events+0x290/0x290
> [  180.560509]  ? do_raw_spin_trylock+0x110/0x110
> [  180.560522]  extent_writepages+0xe3/0x170
> [  180.560530]  ? extent_write_locked_range+0x3d0/0x3d0
> [  180.560538]  ? btrfs_merge_bio_hook+0x4b0/0x4b0
> [  180.560545]  ? wbc_attach_and_unlock_inode+0x14e/0xb00
> [  180.560552]  ? lock_acquire+0x11e/0x420
> [  180.560560]  ? __writeback_single_inode+0x10c0/0x10c0
> [  180.560566]  ? __clear_extent_bit+0x4ef/0xbd0
> [  180.560576]  btrfs_writepages+0x49/0x80
> [  180.560584]  do_writepages+0x9d/0x110
> [  180.560595]  __filemap_fdatawrite_range+0x25d/0x3a0
> [  180.560603]  ? replace_page_cache_page+0x3d0/0x3d0
> [  180.560617]  ? clear_state_bit+0x840/0x840
> [  180.560626]  ? up_write+0x73/0x100
> [  180.560637]  filemap_fdatawrite_range+0x13/0x20
> [  180.560644]  btrfs_fdatawrite_range+0x54/0x130
> [  180.560653]  __btrfs_write_out_cache+0xb56/0xf10
> [  180.560669]  ? write_pinned_extent_entries+0x450/0x450
> [  180.560679]  ? debug_lockdep_rcu_enabled+0x7b/0x90
> [  180.560686]  ? do_raw_spin_trylock+0x110/0x110
> [  180.560693]  ? do_raw_spin_trylock+0x110/0x110
> [  180.560709]  ? _raw_spin_unlock+0x27/0x40
> [  180.560716]  ? lookup_free_space_inode+0x6d/0x300
> [  180.560727]  btrfs_write_out_cache+0x108/0x210
> [  180.560740]  btrfs_start_dirty_block_groups+0x631/0xfc0
> [  180.560757]  ? btrfs_force_chunk_alloc+0x40/0x40
> [  180.560765]  ? mutex_trylock+0x210/0x210
> [  180.560771]  ? btrfs_run_delayed_refs+0x484/0x710
> [  180.560787]  btrfs_commit_transaction+0x33f/0x2420
> [  180.560795]  ? trace_hardirqs_on_caller+0x46c/0x6b0
> [  180.560803]  ? trace_hardirqs_on+0xd/0x10
> [  180.560810]  ? _raw_spin_unlock_irq+0x2c/0x50
> [  180.560818]  ? btrfs_lookup_first_ordered_extent+0x148/0x2e0
> [  180.560827]  ? btrfs_apply_pending_changes+0x150/0x150
> [  180.560834]  ? btrfs_have_ordered_extents_in_range+0x30/0x30
> [  180.560849]  ? btrfs_wait_ordered_range+0xae/0x210
> [  180.560860]  btrfs_sync_file+0x842/0xe10
> [  180.560873]  ? start_ordered_ops+0x30/0x30
> [  180.560880]  ? __fget+0x50/0x4a0
> [  180.560896]  ? __fget+0x23c/0x4a0
> [  180.560906]  ? start_ordered_ops+0x30/0x30
> [  180.560914]  vfs_fsync_range+0xe8/0x3d0
> [  180.560920]  ? __fget_light+0x9a/0x250
> [  180.560927]  ? trace_hardirqs_on_caller+0x46c/0x6b0
> [  180.560938]  do_fsync+0x3d/0x70
> [  180.560948]  SyS_fdatasync+0x13/0x20
> [  180.560955]  entry_SYSCALL_64_fastpath+0x1f/0xc2
> [  180.560961] RIP: 0033:0x7f2e79004a4d
> [  180.560967] RSP: 002b:00007f2e549a0760 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> [  180.560976] RAX: ffffffffffffffda RBX: 00007f2e42c89710 RCX: 00007f2e79004a4d
> [  180.560982] RDX: 00000000000000c9 RSI: 0000000000080000 RDI: 00000000000000c9
> [  180.560987] RBP: 0000000000000046 R08: 0000000000000000 R09: 0000000000000000
> [  180.560992] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
> [  180.560997] R13: 00007f2e58bf7000 R14: 0000000000000000 R15: 0000000000000001
> [  180.561016] Object at ffff8803801a7680, in cache bio-2 size: 304
> [  180.561021] Allocated:
> [  180.561025] PID = 924
> [  180.561034]  save_stack_trace+0x1b/0x20
> [  180.561040]  kasan_kmalloc+0xee/0x190
> [  180.561046]  kasan_slab_alloc+0x12/0x20
> [  180.561054]  kmem_cache_alloc+0x108/0x4a0
> [  180.561061]  mempool_alloc_slab+0x15/0x20
> [  180.561066]  mempool_alloc+0x123/0x350
> [  180.561073]  bio_alloc_bioset+0x2b3/0xa50
> [  180.561078]  __bio_clone_bioset+0x1e3/0x1b60
> [  180.561084]  bio_clone_bioset+0x4d/0x80
> [  180.561090]  btrfs_bio_clone+0x1a/0xf0
> [  180.561096]  btrfs_map_bio+0x3aa/0x10b0
> [  180.561102]  btrfs_submit_bio_hook+0x285/0x810
> [  180.561108]  submit_one_bio+0x217/0x400
> [  180.561114]  submit_extent_page+0xcc/0x4a0
> [  180.561120]  __extent_writepage_io+0x780/0xbc0
> [  180.561126]  __extent_writepage+0x73c/0xbb0
> [  180.561133]  extent_write_cache_pages.constprop.11+0x681/0xb80
> [  180.561139]  extent_writepages+0xe3/0x170
> [  180.561144]  btrfs_writepages+0x49/0x80
> [  180.561150]  do_writepages+0x9d/0x110
> [  180.561156]  __filemap_fdatawrite_range+0x25d/0x3a0
> [  180.561162]  filemap_fdatawrite_range+0x13/0x20
> [  180.561168]  btrfs_fdatawrite_range+0x54/0x130
> [  180.561174]  __btrfs_write_out_cache+0xb56/0xf10
> [  180.561179]  btrfs_write_out_cache+0x108/0x210
> [  180.561186]  btrfs_start_dirty_block_groups+0x631/0xfc0
> [  180.561192]  btrfs_commit_transaction+0x33f/0x2420
> [  180.561198]  btrfs_sync_file+0x842/0xe10
> [  180.561204]  vfs_fsync_range+0xe8/0x3d0
> [  180.561209]  do_fsync+0x3d/0x70
> [  180.561215]  SyS_fdatasync+0x13/0x20
> [  180.561221]  entry_SYSCALL_64_fastpath+0x1f/0xc2
> [  180.561226] Freed:
> [  180.561230] PID = 924
> [  180.561236]  save_stack_trace+0x1b/0x20
> [  180.561242]  kasan_slab_free+0xb0/0x180
> [  180.561247]  kmem_cache_free+0xf5/0x5c0
> [  180.561253]  mempool_free_slab+0x17/0x20
> [  180.561259]  mempool_free+0xd3/0x1d0
> [  180.561265]  bio_free+0x134/0x1c0
> [  180.561270]  bio_put+0x88/0xd0
> [  180.561276]  btrfs_end_bio+0x2e0/0x6a0
> [  180.561282]  bio_endio+0x15d/0x200
> [  180.561288]  blk_update_request+0x21f/0xe90
> [  180.561310]  scsi_end_request+0xb6/0x730 [scsi_mod]
> [  180.561325]  scsi_io_completion+0x641/0x1b00 [scsi_mod]
> [  180.561339]  scsi_finish_command+0x3be/0x710 [scsi_mod]
> [  180.561355]  scsi_softirq_done+0x2b1/0x450 [scsi_mod]
> [  180.561361]  blk_done_softirq+0x287/0x500
> [  180.561367]  __do_softirq+0x220/0xd13
> [  180.561372] Memory state around the buggy address:
> [  180.561379]  ffff8803801a7580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  180.561384]  ffff8803801a7600: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
> [  180.561390] >ffff8803801a7680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  180.561395]                                                                 ^
> [  180.561400]  ffff8803801a7700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  180.561406]  ffff8803801a7780: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
> [  180.561410] ==================================================================
> [  180.561415] Disabling lock debugging due to kernel taint
> 
> 
> (gdb) list *btrfs_map_bio+0x994
> 0xffffffff81c4e924 is in btrfs_map_bio (fs/btrfs/volumes.c:6216).
> 6211            }
> 6212
> 6213            for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
> 6214                    dev = bbio->stripes[dev_nr].dev;
> 6215                    if (!dev || !dev->bdev ||
> 6216                        (bio_op(bio) == REQ_OP_WRITE && !dev->writeable)) {
> 6217                            bbio_error(bbio, first_bio, logical);
> 6218                            continue;
> 6219                    }

Yes, it's possible, we should use first_bio instead, I'll fix it.

Thanks for the report.

Thanks,

-liubo
