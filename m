Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60736 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2HBAVx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 20:21:53 -0400
Received: by ghrr11 with SMTP id r11so1540657ghr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 17:21:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
References: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
Date: Wed, 1 Aug 2012 19:21:52 -0500
Message-ID: <CAKcLGm-gow-BgowGmW+kzpZZHPme3Ltr-A4NmnSA+SYdPGwdzw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: barrier before waitqueue_active
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 1, 2012 at 3:25 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> We need an smb_mb() before waitqueue_active to avoid missing wakeups.
> Before Mitch was hitting a deadlock between the ordered flushers and the
> transaction commit because the ordered flushers were waiting for more refs
> and were never woken up, so those smp_mb()'s are the most important.
> Everything else I added for correctness sake and to avoid getting bitten by
> this again somewhere else.  Thanks,
>

This patch seems to make it tougher to hit a deadlock, but I'm still
encountering intermittent deadlocks using this patch when running
multiple rsync threads.

I've also tested "Patch 2", and that has me hitting a deadlock even
quicker (when starting several copying threads).

I also found a slight performance hit using this patch.  On a 3.4.6
kernel (merged with the 3.5_rc for-linus branch), I would typically
complete my rsync test in ~265 seconds.  Also, I can't recall hitting
a deadlock on the 3.4.6 kernel (with 3.5_rc for-linus).  When using
this patch, the test would take ~310 seconds (when it didn't hit a
deadlock).

Here's the Delayed Tasks (Ctrl-SysRq-W) when using JUST this patch:

[ 1568.794030] SysRq : Show Blocked State
[ 1568.794101]   task                        PC stack   pid father
[ 1568.794123] btrfs-endio-wri D ffff88012579c000     0  3845      2 0x00000000
[ 1568.794128]  ffff8801254f3c20 0000000000000046 ffff8801254f2000
ffff8801241b5a80
[ 1568.794132]  0000000000012280 ffff8801254f3fd8 0000000000012280
0000000000004000
[ 1568.794136]  ffff8801254f3fd8 0000000000012280 ffff880129af16a0
ffff8801241b5a80
[ 1568.794140] Call Trace:
[ 1568.794179]  [<ffffffffa0068785>] ? memcpy_extent_buffer+0x159/0x17a [btrfs]
[ 1568.794200]  [<ffffffffa0082ab7>] ? find_ref_head+0xa3/0xc6 [btrfs]
[ 1568.794220]  [<ffffffffa008343c>] ? btrfs_find_ref_cluster+0xdd/0x117 [btrfs]
[ 1568.794225]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.794241]  [<ffffffffa003fc86>] btrfs_run_delayed_refs+0x269/0x3f0 [btrfs]
[ 1568.794246]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.794265]  [<ffffffffa004fdc4>] __btrfs_end_transaction+0xca/0x283 [btrfs]
[ 1568.794283]  [<ffffffffa004ffda>] btrfs_end_transaction+0x15/0x17 [btrfs]
[ 1568.794302]  [<ffffffffa00555da>] btrfs_finish_ordered_io+0x2e4/0x334 [btrfs]
[ 1568.794306]  [<ffffffff8103b980>] ? run_timer_softirq+0x2d4/0x2d4
[ 1568.794325]  [<ffffffffa005563f>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 1568.794344]  [<ffffffffa0070ef8>] worker_loop+0x188/0x4e0 [btrfs]
[ 1568.794365]  [<ffffffffa0070d70>] ? btrfs_queue_worker+0x275/0x275 [btrfs]
[ 1568.794384]  [<ffffffffa0070d70>] ? btrfs_queue_worker+0x275/0x275 [btrfs]
[ 1568.794387]  [<ffffffff8104ac37>] kthread+0x89/0x91
[ 1568.794391]  [<ffffffff8162fd74>] kernel_thread_helper+0x4/0x10
[ 1568.794395]  [<ffffffff8104abae>] ? kthread_freezable_should_stop+0x57/0x57
[ 1568.794398]  [<ffffffff8162fd70>] ? gs_change+0xb/0xb
[ 1568.794400] btrfs-transacti D ffff88009912ba50     0  3851      2 0x00000000
[ 1568.794403]  ffff8801241cfc70 0000000000000046 ffff8801241ce000
ffff8801248cda80
[ 1568.794407]  0000000000012280 ffff8801241cffd8 0000000000012280
0000000000004000
[ 1568.794411]  ffff8801241cffd8 0000000000012280 ffff8801254b8000
ffff8801248cda80
[ 1568.794415] Call Trace:
[ 1568.794436]  [<ffffffffa0066646>] ? extent_writepages+0x53/0x5d [btrfs]
[ 1568.794455]  [<ffffffffa005357b>] ?
uncompress_inline.clone.33+0x15f/0x15f [btrfs]
[ 1568.794459]  [<ffffffff810c9ada>] ? pagevec_lookup_tag+0x24/0x2e
[ 1568.794478]  [<ffffffffa0052e0e>] ? btrfs_writepages+0x27/0x29 [btrfs]
[ 1568.794481]  [<ffffffff810c90b1>] ? do_writepages+0x20/0x29
[ 1568.794485]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.794505]  [<ffffffffa0061547>]
btrfs_start_ordered_extent+0xde/0xfa [btrfs]
[ 1568.794508]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.794529]  [<ffffffffa0061984>] ?
btrfs_lookup_first_ordered_extent+0x65/0x99 [btrfs]
[ 1568.794549]  [<ffffffffa0061a6a>] btrfs_wait_ordered_range+0xb2/0xda [btrfs]
[ 1568.794569]  [<ffffffffa0061bcc>]
btrfs_run_ordered_operations+0x13a/0x1c1 [btrfs]
[ 1568.794587]  [<ffffffffa004f5f5>]
btrfs_commit_transaction+0x287/0x960 [btrfs]
[ 1568.794606]  [<ffffffffa00502b1>] ? start_transaction+0x2d5/0x310 [btrfs]
[ 1568.794609]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.794627]  [<ffffffffa004913b>] transaction_kthread+0x187/0x258 [btrfs]
[ 1568.794644]  [<ffffffffa0048fb4>] ? btrfs_alloc_root+0x42/0x42 [btrfs]
[ 1568.794661]  [<ffffffffa0048fb4>] ? btrfs_alloc_root+0x42/0x42 [btrfs]
[ 1568.794664]  [<ffffffff8104ac37>] kthread+0x89/0x91
[ 1568.794668]  [<ffffffff8162fd74>] kernel_thread_helper+0x4/0x10
[ 1568.794671]  [<ffffffff8104abae>] ? kthread_freezable_should_stop+0x57/0x57
[ 1568.794674]  [<ffffffff8162fd70>] ? gs_change+0xb/0xb
[ 1568.794676] flush-btrfs-1   D ffff88012579c000     0  3857      2 0x00000000
[ 1568.794680]  ffff880037125670 0000000000000046 ffff880037124000
ffff8801254b8000
[ 1568.794684]  0000000000012280 ffff880037125fd8 0000000000012280
0000000000004000
[ 1568.794687]  ffff880037125fd8 0000000000012280 ffffffff81c13410
ffff8801254b8000
[ 1568.794691] Call Trace:
[ 1568.794711]  [<ffffffffa0082ab7>] ? find_ref_head+0xa3/0xc6 [btrfs]
[ 1568.794731]  [<ffffffffa008343c>] ? btrfs_find_ref_cluster+0xdd/0x117 [btrfs]
[ 1568.794735]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.794750]  [<ffffffffa003fc86>] btrfs_run_delayed_refs+0x269/0x3f0 [btrfs]
[ 1568.794754]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.794772]  [<ffffffffa004fdc4>] __btrfs_end_transaction+0xca/0x283 [btrfs]
[ 1568.794790]  [<ffffffffa004ffda>] btrfs_end_transaction+0x15/0x17 [btrfs]
[ 1568.794809]  [<ffffffffa005607e>] cow_file_range+0x3fa/0x453 [btrfs]
[ 1568.794829]  [<ffffffffa00635a6>] ? __set_extent_bit+0x3ce/0x403 [btrfs]
[ 1568.794848]  [<ffffffffa00569d7>] run_delalloc_range+0xbc/0x38f [btrfs]
[ 1568.794868]  [<ffffffffa006485f>] ?
find_lock_delalloc_range.clone.26+0x18b/0x1b0 [btrfs]
[ 1568.794889]  [<ffffffffa0065d1d>] __extent_writepage+0x200/0x600 [btrfs]
[ 1568.794909]  [<ffffffffa006528d>] ? end_extent_writepage+0x5b/0x5b [btrfs]
[ 1568.794913]  [<ffffffff810bf853>] ? find_get_pages_tag+0xf8/0x134
[ 1568.794934]  [<ffffffffa00662e4>]
extent_write_cache_pages.clone.16.clone.29+0x1c7/0x30c [btrfs]
[ 1568.794952]  [<ffffffffa0051c2f>] ? __btrfs_submit_bio_done+0x1d/0x1d [btrfs]
[ 1568.794971]  [<ffffffffa0051c12>] ? btrfs_submit_bio_hook+0x122/0x122 [btrfs]
[ 1568.794991]  [<ffffffffa0062284>] ? submit_one_bio+0x8d/0x97 [btrfs]
[ 1568.795011]  [<ffffffffa006663b>] extent_writepages+0x48/0x5d [btrfs]
[ 1568.795023]  [<ffffffffa005357b>] ?
uncompress_inline.clone.33+0x15f/0x15f [btrfs]
[ 1568.795023]  [<ffffffffa0052e0e>] btrfs_writepages+0x27/0x29 [btrfs]
[ 1568.795023]  [<ffffffff810c90b1>] do_writepages+0x20/0x29
[ 1568.795023]  [<ffffffff8112e343>]
__writeback_single_inode.clone.22+0x48/0x11c
[ 1568.795023]  [<ffffffff8112e8ab>] writeback_sb_inodes+0x1f0/0x332
[ 1568.795023]  [<ffffffff8112ea65>] __writeback_inodes_wb+0x78/0xb9
[ 1568.795023]  [<ffffffff8112ebec>] wb_writeback+0x146/0x23e
[ 1568.795023]  [<ffffffff81121cfd>] ? get_nr_inodes+0x48/0x5f
[ 1568.795023]  [<ffffffff8112f48a>] wb_do_writeback+0x154/0x1b0
[ 1568.795023]  [<ffffffff8112f574>] bdi_writeback_thread+0x8e/0x1f1
[ 1568.795023]  [<ffffffff8112f4e6>] ? wb_do_writeback+0x1b0/0x1b0
[ 1568.795023]  [<ffffffff8112f4e6>] ? wb_do_writeback+0x1b0/0x1b0
[ 1568.795023]  [<ffffffff8104ac37>] kthread+0x89/0x91
[ 1568.795023]  [<ffffffff8162fd74>] kernel_thread_helper+0x4/0x10
[ 1568.795023]  [<ffffffff8104abae>] ? kthread_freezable_should_stop+0x57/0x57
[ 1568.795023]  [<ffffffff8162fd70>] ? gs_change+0xb/0xb
[ 1568.795023] btrfs-endio-wri D ffff88012579c000     0  3899      2 0x00000000
[ 1568.795023]  ffff880124ea5c20 0000000000000046 ffff880124ea4000
ffff8800a3015a80
[ 1568.795023]  0000000000012280 ffff880124ea5fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff880124ea5fd8 0000000000012280 ffff8800a30143e0
ffff8800a3015a80
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa0068785>] ? memcpy_extent_buffer+0x159/0x17a [btrfs]
[ 1568.795023]  [<ffffffffa0082ab7>] ? find_ref_head+0xa3/0xc6 [btrfs]
[ 1568.795023]  [<ffffffffa008343c>] ? btrfs_find_ref_cluster+0xdd/0x117 [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa003fc86>] btrfs_run_delayed_refs+0x269/0x3f0 [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa004fdc4>] __btrfs_end_transaction+0xca/0x283 [btrfs]
[ 1568.795023]  [<ffffffffa004ffda>] btrfs_end_transaction+0x15/0x17 [btrfs]
[ 1568.795023]  [<ffffffffa00555da>] btrfs_finish_ordered_io+0x2e4/0x334 [btrfs]
[ 1568.795023]  [<ffffffff8103b980>] ? run_timer_softirq+0x2d4/0x2d4
[ 1568.795023]  [<ffffffffa005563f>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 1568.795023]  [<ffffffffa0070ef8>] worker_loop+0x188/0x4e0 [btrfs]
[ 1568.795023]  [<ffffffffa0070d70>] ? btrfs_queue_worker+0x275/0x275 [btrfs]
[ 1568.795023]  [<ffffffff8104ac37>] kthread+0x89/0x91
[ 1568.795023]  [<ffffffff8162fd74>] kernel_thread_helper+0x4/0x10
[ 1568.795023]  [<ffffffff8104abae>] ? kthread_freezable_should_stop+0x57/0x57
[ 1568.795023]  [<ffffffff8162fd70>] ? gs_change+0xb/0xb
[ 1568.795023] rsync           D 0000000000000000     0  3996   3989 0x00000000
[ 1568.795023]  ffff88010cd05ca8 0000000000000082 ffff88010cd04000
ffff88011368ad40
[ 1568.795023]  0000000000012280 ffff88010cd05fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88010cd05fd8 0000000000012280 ffffffff81c13410
ffff88011368ad40
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  3997   3993 0x00000000
[ 1568.795023]  ffff88010cd07ca8 0000000000000082 ffff88010cd06000
ffff880109a816a0
[ 1568.795023]  0000000000012280 ffff88010cd07fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88010cd07fd8 0000000000012280 ffff880129af16a0
ffff880109a816a0
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  3998   3991 0x00000000
[ 1568.795023]  ffff88011f6f1ca8 0000000000000082 ffff88011f6f0000
ffff880125d55a80
[ 1568.795023]  0000000000012280 ffff88011f6f1fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011f6f1fd8 0000000000012280 ffff880129af16a0
ffff880125d55a80
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  3999   3994 0x00000000
[ 1568.795023]  ffff88011f6f3ca8 0000000000000086 ffff88011f6f2000
ffff880109a843e0
[ 1568.795023]  0000000000012280 ffff88011f6f3fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011f6f3fd8 0000000000012280 ffff880129af16a0
ffff880109a843e0
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4000   3990 0x00000000
[ 1568.795023]  ffff88011cbb9ca8 0000000000000086 ffff88011cbb8000
ffff880109a80000
[ 1568.795023]  0000000000012280 ffff88011cbb9fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011cbb9fd8 0000000000012280 ffff88011368ad40
ffff880109a80000
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4001   3992 0x00000000
[ 1568.795023]  ffff88011cbbbca8 0000000000000086 ffff88011cbba000
ffff8801254b96a0
[ 1568.795023]  0000000000012280 ffff88011cbbbfd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011cbbbfd8 0000000000012280 ffff880129af16a0
ffff8801254b96a0
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa005012e>] ? start_transaction+0x152/0x310 [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4002   3995 0x00000000
[ 1568.795023]  ffff88011dd67ca8 0000000000000082 ffff88011dd66000
ffff88012885da80
[ 1568.795023]  0000000000012280 ffff88011dd67fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011dd67fd8 0000000000012280 ffffffff81c13410
ffff88012885da80
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005126d>] __unlink_start_trans+0x94/0x404 [btrfs]
[ 1568.795023]  [<ffffffff810384a3>] ? inode_capable+0x15/0x1a
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffffa00577bb>] btrfs_unlink+0x2c/0xac [btrfs]
[ 1568.795023]  [<ffffffff81116c8f>] vfs_unlink+0x78/0xdd
[ 1568.795023]  [<ffffffff811189e8>] do_unlinkat+0xe6/0x178
[ 1568.795023]  [<ffffffff8110de68>] ? fput+0x1e8/0x1f7
[ 1568.795023]  [<ffffffff8110ac43>] ? filp_close+0x70/0x7b
[ 1568.795023]  [<ffffffff81119c7c>] sys_unlink+0x16/0x18
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4004   3998 0x00000000
[ 1568.795023]  ffff88011a9adb68 0000000000000086 ffff88011a9ac000
ffff8801248cad40
[ 1568.795023]  0000000000012280 ffff88011a9adfd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011a9adfd8 0000000000012280 ffff880109a816a0
ffff8801248cad40
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffff8105136f>] ? in_group_p+0x31/0x33
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005b47d>] btrfs_create+0x3a/0x1e0 [btrfs]
[ 1568.795023]  [<ffffffff8111ff3d>] ? d_splice_alias+0xcc/0xd8
[ 1568.795023]  [<ffffffff81116a86>] vfs_create+0x9c/0xf5
[ 1568.795023]  [<ffffffff81118e62>] do_last+0x2b9/0x807
[ 1568.795023]  [<ffffffff811194af>] path_openat+0xcc/0x37f
[ 1568.795023]  [<ffffffff81119864>] do_filp_open+0x3d/0x89
[ 1568.795023]  [<ffffffff810fe9b0>] ? kmem_cache_alloc+0x31/0x104
[ 1568.795023]  [<ffffffff81123bb4>] ? alloc_fd+0x74/0x103
[ 1568.795023]  [<ffffffff8110c09d>] do_sys_open+0x10f/0x1a1
[ 1568.795023]  [<ffffffff8110c150>] sys_open+0x21/0x23
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4006   3997 0x00000000
[ 1568.795023]  ffff88011475dbb8 0000000000000086 ffff88011475c000
ffff880128995a80
[ 1568.795023]  0000000000012280 ffff88011475dfd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011475dfd8 0000000000012280 ffffffff81c13410
ffff880128995a80
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffff81116008>] ? generic_permission+0x86/0x209
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005a8d0>] btrfs_rename+0x1bd/0x5af [btrfs]
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffff81116e9f>] ? vfs_rename+0xbe/0x3df
[ 1568.795023]  [<ffffffff8111705d>] vfs_rename+0x27c/0x3df
[ 1568.795023]  [<ffffffff8111a072>] sys_renameat+0x1ac/0x259
[ 1568.795023]  [<ffffffff81122f26>] ? notify_change+0x2a2/0x2b8
[ 1568.795023]  [<ffffffff811197e3>] ? user_path_at_empty+0x61/0x92
[ 1568.795023]  [<ffffffff81124e45>] ? mntput_no_expire+0x3f/0x138
[ 1568.795023]  [<ffffffff81124f68>] ? mntput+0x2a/0x2c
[ 1568.795023]  [<ffffffff811156a6>] ? path_put+0x22/0x26
[ 1568.795023]  [<ffffffff8111a13a>] sys_rename+0x1b/0x1d
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4007   3996 0x00000000
[ 1568.795023]  ffff88010c7cdbb8 0000000000000086 ffff88010c7cc000
ffff8801289916a0
[ 1568.795023]  0000000000012280 ffff88010c7cdfd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88010c7cdfd8 0000000000012280 ffff880129af16a0
ffff8801289916a0
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005a8d0>] btrfs_rename+0x1bd/0x5af [btrfs]
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffff81116e9f>] ? vfs_rename+0xbe/0x3df
[ 1568.795023]  [<ffffffff8111705d>] vfs_rename+0x27c/0x3df
[ 1568.795023]  [<ffffffff8111a072>] sys_renameat+0x1ac/0x259
[ 1568.795023]  [<ffffffff81122f26>] ? notify_change+0x2a2/0x2b8
[ 1568.795023]  [<ffffffff811197e3>] ? user_path_at_empty+0x61/0x92
[ 1568.795023]  [<ffffffff81124e45>] ? mntput_no_expire+0x3f/0x138
[ 1568.795023]  [<ffffffff81124f68>] ? mntput+0x2a/0x2c
[ 1568.795023]  [<ffffffff811156a6>] ? path_put+0x22/0x26
[ 1568.795023]  [<ffffffff8111a13a>] sys_rename+0x1b/0x1d
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] rsync           D 0000000000000000     0  4008   4001 0x00000000
[ 1568.795023]  ffff88011ae33bb8 0000000000000086 ffff88011ae32000
ffff8801296a2d40
[ 1568.795023]  0000000000012280 ffff88011ae33fd8 0000000000012280
0000000000004000
[ 1568.795023]  ffff88011ae33fd8 0000000000012280 ffff880128995a80
ffff8801296a2d40
[ 1568.795023] Call Trace:
[ 1568.795023]  [<ffffffffa003cb51>] ? get_alloc_profile+0x4e/0x50 [btrfs]
[ 1568.795023]  [<ffffffffa003cb82>] ? btrfs_get_alloc_profile+0x2f/0x31 [btrfs]
[ 1568.795023]  [<ffffffffa003db7f>] ?
reserve_metadata_bytes.clone.57+0x339/0x66c [btrfs]
[ 1568.795023]  [<ffffffff8162d58c>] schedule+0x64/0x66
[ 1568.795023]  [<ffffffffa004ee57>]
wait_current_trans.clone.26+0xac/0xdd [btrfs]
[ 1568.795023]  [<ffffffff8104b10e>] ? wake_up_bit+0x2a/0x2a
[ 1568.795023]  [<ffffffffa0050157>] start_transaction+0x17b/0x310 [btrfs]
[ 1568.795023]  [<ffffffff81116008>] ? generic_permission+0x86/0x209
[ 1568.795023]  [<ffffffffa0050553>] btrfs_start_transaction+0x13/0x15 [btrfs]
[ 1568.795023]  [<ffffffffa005a8d0>] btrfs_rename+0x1bd/0x5af [btrfs]
[ 1568.795023]  [<ffffffff81116127>] ? generic_permission+0x1a5/0x209
[ 1568.795023]  [<ffffffff81116e9f>] ? vfs_rename+0xbe/0x3df
[ 1568.795023]  [<ffffffff8111705d>] vfs_rename+0x27c/0x3df
[ 1568.795023]  [<ffffffff8111a072>] sys_renameat+0x1ac/0x259
[ 1568.795023]  [<ffffffff81122f26>] ? notify_change+0x2a2/0x2b8
[ 1568.795023]  [<ffffffff811197e3>] ? user_path_at_empty+0x61/0x92
[ 1568.795023]  [<ffffffff81124e45>] ? mntput_no_expire+0x3f/0x138
[ 1568.795023]  [<ffffffff81124f68>] ? mntput+0x2a/0x2c
[ 1568.795023]  [<ffffffff811156a6>] ? path_put+0x22/0x26
[ 1568.795023]  [<ffffffff8111a13a>] sys_rename+0x1b/0x1d
[ 1568.795023]  [<ffffffff8162ec92>] system_call_fastpath+0x16/0x1b
[ 1568.795023] Sched Debug Version: v0.10, 3.5.0-baseline+ #1
[ 1568.795023] ktime                                   : 1568797.341765
[ 1568.795023] sched_clk                               : 1568905.405572
[ 1568.795023] cpu_clk                                 : 1568795.023448
[ 1568.795023] jiffies                                 : 4296236090
[ 1568.795023] sched_clock_stable                      : 0
[ 1568.795023]
[ 1568.795023] sysctl_sched
[ 1568.795023]   .sysctl_sched_latency                    : 12.000000
[ 1568.795023]   .sysctl_sched_min_granularity            : 1.500000
[ 1568.795023]   .sysctl_sched_wakeup_granularity         : 2.000000
[ 1568.795023]   .sysctl_sched_child_runs_first           : 0
[ 1568.795023]   .sysctl_sched_features                   : 24119
[ 1568.795023]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[ 1568.795023]
[ 1568.795023] cpu#0, 2666.627 MHz
[ 1568.795023]   .nr_running                    : 0
[ 1568.795023]   .load                          : 0
[ 1568.795023]   .nr_switches                   : 2092841
[ 1568.795023]   .nr_load_updates               : 319578
[ 1568.795023]   .nr_uninterruptible            : -79
[ 1568.795023]   .next_balance                  : 4296.235984
[ 1568.795023]   .curr->pid                     : 0
[ 1568.795023]   .clock                         : 1568792.396031
[ 1568.795023]   .cpu_load[0]                   : 0
[ 1568.795023]   .cpu_load[1]                   : 0
[ 1568.795023]   .cpu_load[2]                   : 0
[ 1568.795023]   .cpu_load[3]                   : 0
[ 1568.795023]   .cpu_load[4]                   : 0
[ 1568.795023]   .yld_count                     : 21
[ 1568.795023]   .sched_count                   : 2345950
[ 1568.795023]   .sched_goidle                  : 683438
[ 1568.795023]   .avg_idle                      : 1000000
[ 1568.795023]   .ttwu_count                    : 1179205
[ 1568.795023]   .ttwu_local                    : 432796
[ 1568.795023]
[ 1568.795023] cfs_rq[0]:/
[ 1568.795023]   .exec_clock                    : 122611.778679
[ 1568.795023]   .MIN_vruntime                  : 0.000001
[ 1568.795023]   .min_vruntime                  : 155427.205936
[ 1568.795023]   .max_vruntime                  : 0.000001
[ 1568.795023]   .spread                        : 0.000000
[ 1568.795023]   .spread0                       : 0.000000
[ 1568.795023]   .nr_spread_over                : 817
[ 1568.795023]   .nr_running                    : 0
[ 1568.795023]   .load                          : 0
[ 1568.795023]   .load_avg                      : 0.000000
[ 1568.795023]   .load_period                   : 0.000000
[ 1568.795023]   .load_contrib                  : 0
[ 1568.795023]   .load_tg                       : 0
[ 1568.795023]
[ 1568.795023] rt_rq[0]:
[ 1568.795023]   .rt_nr_running                 : 0
[ 1568.795023]   .rt_throttled                  : 0
[ 1568.795023]   .rt_time                       : 0.000000
[ 1568.795023]   .rt_runtime                    : 950.000000
[ 1568.795023]
[ 1568.795023] runnable tasks:
[ 1568.795023]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[ 1568.795023] ----------------------------------------------------------------------------------------------------------
[ 1568.795023]
[ 1568.795023] cpu#1, 2666.627 MHz
[ 1568.795023]   .nr_running                    : 0
[ 1568.795023]   .load                          : 0
[ 1568.795023]   .nr_switches                   : 2079916
[ 1568.795023]   .nr_load_updates               : 319982
[ 1568.795023]   .nr_uninterruptible            : 94
[ 1568.795023]   .next_balance                  : 4296.235484
[ 1568.795023]   .curr->pid                     : 0
[ 1568.795023]   .clock                         : 1568784.396001
[ 1568.795023]   .cpu_load[0]                   : 0
[ 1568.795023]   .cpu_load[1]                   : 0
[ 1568.795023]   .cpu_load[2]                   : 0
[ 1568.795023]   .cpu_load[3]                   : 0
[ 1568.795023]   .cpu_load[4]                   : 0
[ 1568.795023]   .yld_count                     : 4
[ 1568.795023]   .sched_count                   : 2308965
[ 1568.795023]   .sched_goidle                  : 690586
[ 1568.795023]   .avg_idle                      : 1000000
[ 1568.795023]   .ttwu_count                    : 1159413
[ 1568.795023]   .ttwu_local                    : 419527
[ 1568.795023]
[ 1568.795023] cfs_rq[1]:/autogroup-12
[ 1568.795023]   .exec_clock                    : 320.130894
[ 1568.795023]   .MIN_vruntime                  : 0.000001
[ 1568.795023]   .min_vruntime                  : 1163.780537
[ 1568.795023]   .max_vruntime                  : 0.000001
[ 1568.795023]   .spread                        : 0.000000
[ 1568.795023]   .spread0                       : -154263.425399
[ 1568.795023]   .nr_spread_over                : 178
[ 1568.795023]   .nr_running                    : 0
[ 1568.795023]   .load                          : 0
[ 1568.795023]   .load_avg                      : 2559.999744
[ 1568.795023]   .load_period                   : 5.241463
[ 1568.795023]   .load_contrib                  : 488
[ 1568.795023]   .load_tg                       : 488
[ 1568.795023]   .se->exec_start                : 1568778.912838
[ 1568.795023]   .se->vruntime                  : 183270.984759
[ 1568.795023]   .se->sum_exec_runtime          : 320.130894
[ 1568.795023]   .se->statistics.wait_start     : 0.000000
[ 1568.795023]   .se->statistics.sleep_start    : 0.000000
[ 1568.795023]   .se->statistics.block_start    : 0.000000
[ 1568.795023]   .se->statistics.sleep_max      : 0.000000
[ 1568.795023]   .se->statistics.block_max      : 0.000000
[ 1568.795023]   .se->statistics.exec_max       : 1.000806
[ 1568.795023]   .se->statistics.slice_max      : 0.030516
[ 1568.795023]   .se->statistics.wait_max       : 2.745282
[ 1568.795023]   .se->statistics.wait_sum       : 8.576517
[ 1568.795023]   .se->statistics.wait_count     : 1446
[ 1568.795023]   .se->load.weight               : 2
[ 1568.795023]
[ 1568.795023] cfs_rq[1]:/
[ 1568.795023]   .exec_clock                    : 120018.151379
[ 1568.795023]   .MIN_vruntime                  : 0.000001
[ 1568.795023]   .min_vruntime                  : 183276.982041
[ 1568.795023]   .max_vruntime                  : 0.000001
[ 1568.795023]   .spread                        : 0.000000
[ 1568.795023]   .spread0                       : 27849.776105
[ 1568.795023]   .nr_spread_over                : 1197
[ 1568.795023]   .nr_running                    : 0
[ 1568.795023]   .load                          : 0
[ 1568.795023]   .load_avg                      : 0.000000
[ 1568.795023]   .load_period                   : 0.000000
[ 1568.795023]   .load_contrib                  : 0
[ 1568.795023]   .load_tg                       : 0
[ 1568.795023]
[ 1568.795023] rt_rq[1]:
[ 1568.795023]   .rt_nr_running                 : 0
[ 1568.795023]   .rt_throttled                  : 0
[ 1568.795023]   .rt_time                       : 0.000000
[ 1568.795023]   .rt_runtime                    : 950.000000
[ 1568.795023]
[ 1568.795023] runnable tasks:
[ 1568.795023]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[ 1568.795023] ----------------------------------------------------------------------------------------------------------
[ 1568.795023]
