From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: 3.4-rc6: delayed alloc deadlock...
Date: Wed, 09 May 2012 09:20:42 +0800
Message-ID: <4FA9C66A.80900@cn.fujitsu.com>
References: <CAMVG2st1p8xkgOj7dknGSNtX5y42tv_tmnsUjZFQkMP3dXa9rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Jeff Mahoney <jeffm@suse.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2st1p8xkgOj7dknGSNtX5y42tv_tmnsUjZFQkMP3dXa9rw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2012 04:56 PM, Daniel J Blueman wrote:

> Delayed allocation ref mutexes are taken [1] inside
> btrfs_commit_transaction. A later call fails and jumps to the
> cleanup_transaction label (transaction.c:1501) with these mutexes
> still held causing deadlock [2] when they are reacquired.
> 
> Either we can introduce an earlier label (cleanup_transaction_lock)
> and function to unlock these mutexes or can tweak
> btrfs_destroy_delayed_refs to conditionally use mutex_try_lock.
> 
> What is the suggested approach?
> 


Hi Daniel,

I prefer mutex_try_lock, just as other places do.

You can give it a try. :)

thanks,
liubo

> Thanks,
>   Daniel
> 
> --- [1]
> 
> btrfs_commit_transaction -> btrfs_run_delayed_refs ->
> run_clustered_refs -> btrfs_delayed_ref_lock -> struct
> btrfs_delayed_ref_head -> mutex
> 
> --- [2]
> 
> btrfs bad tree block start 0 39845888
> btrfs bad tree block start 0 39845888
> btrfs: run_one_delayed_ref returned -5
> WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xa6/0xc0 [btrfs]()
> Hardware name: Latitude E5420
> btrfs: Transaction aborted
> Modules linked in: brd nls_iso8859_1 nls_cp437 vfat fat dm_crypt
> dm_mod kvm_intel kvm coretemp binfmt_misc microcode uvcvideo
> videobuf2_core videodev videobuf2_vmalloc videobuf2_memops iwlwifi
> btrfs i915 cfbcopyarea cfbimgblt cfbfillrect video usb_storage
> Pid: 14985, comm: btrfs-endio-wri Tainted: G        W    3.4.0-rc6-debug #14
> Call Trace:
>  [<ffffffff8103c5ca>] warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8103c6a1>] warn_slowpath_fmt+0x41/0x50
>  [<ffffffff8108e9cd>] ? __lock_release+0xad/0xd0
>  [<ffffffffa0094c76>] __btrfs_abort_transaction+0xa6/0xc0 [btrfs]
>  [<ffffffffa00a87a6>] btrfs_run_delayed_refs+0x296/0x300 [btrfs]
>  [<ffffffffa00b9ad7>] __btrfs_end_transaction+0xa7/0x360 [btrfs]
>  [<ffffffffa00b9df0>] btrfs_end_transaction+0x10/0x20 [btrfs]
>  [<ffffffffa00c049d>] btrfs_finish_ordered_io+0x17d/0x3b0 [btrfs]
>  [<ffffffff8108f505>] ? trace_hardirqs_on_caller+0x105/0x190
>  [<ffffffffa00c06e5>] btrfs_writepage_end_io_hook+0x15/0x20 [btrfs]
>  [<ffffffffa00dbbb8>] end_extent_writepage+0x58/0x100 [btrfs]
>  [<ffffffffa00dbcc4>] end_bio_extent_writepage+0x64/0x90 [btrfs]
>  [<ffffffff81147458>] bio_endio+0x18/0x30
>  [<ffffffffa00b1efc>] end_workqueue_fn+0x3c/0x50 [btrfs]
>  [<ffffffffa00e8cc6>] worker_loop+0x86/0x330 [btrfs]
>  [<ffffffffa00e8c40>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
>  [<ffffffff8105da6e>] kthread+0x8e/0xa0
>  [<ffffffff815b1b94>] kernel_thread_helper+0x4/0x10
>  [<ffffffff815b0259>] ? retint_restore_args+0xe/0xe
>  [<ffffffff8105d9e0>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff815b1b90>] ? gs_change+0xb/0xb
> ---[ end trace df06b72f93439fa3 ]---
> BTRFS warning (device ram1): Aborting unused transaction.
> btrfs bad tree block start 0 39845888
> btrfs bad tree block start 0 39845888
> btrfs: run_one_delayed_ref returned -5
> BTRFS error (device ram1) in btrfs_run_delayed_refs:2454: IO failure
> btrfs is forced readonly
> BTRFS warning (device ram1): Skipping commit of aborted transaction.
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.4.0-rc6-debug #14 Tainted: G        W
> ---------------------------------------------
> btrfs/18749 is trying to acquire lock:
>  (&head_ref->mutex){+.+...}, at: [<ffffffffa00b22a9>]
> btrfs_destroy_delayed_refs.isra.96+0xf9/0x210 [btrfs]
> 
> but task is already holding lock:
>  (&head_ref->mutex){+.+...}, at: [<ffffffffa00fce07>]
> btrfs_delayed_ref_lock+0x37/0x140 [btrfs]
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&head_ref->mutex);
>   lock(&head_ref->mutex);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by btrfs/18749:
>  #0:  (&type->i_mutex_dir_key#4/1){+.+.+.}, at: [<ffffffffa00eb86e>]
> btrfs_mksubvol+0x4e/0x1a0 [btrfs]
>  #1:  (&fs_info->subvol_sem){++++..}, at: [<ffffffffa00eb927>]
> btrfs_mksubvol+0x107/0x1a0 [btrfs]
>  #2:  (&head_ref->mutex){+.+...}, at: [<ffffffffa00fce07>]
> btrfs_delayed_ref_lock+0x37/0x140 [btrfs]
> 
> stack backtrace:
> Pid: 18749, comm: btrfs Tainted: G        W    3.4.0-rc6-debug #14
> Call Trace:
>  [<ffffffff8108b913>] print_deadlock_bug+0xf3/0x100
>  [<ffffffff8108bb02>] check_deadlock.isra.29+0x1e2/0x1f0
>  [<ffffffff8108d443>] validate_chain.isra.33+0x383/0x510
>  [<ffffffff8108dff8>] __lock_acquire+0x388/0x900
>  [<ffffffff8108ea95>] lock_acquire+0x55/0x70
>  [<ffffffffa00b22a9>] ? btrfs_destroy_delayed_refs.isra.96+0xf9/0x210 [btrfs]
>  [<ffffffff815ad38b>] mutex_lock_nested+0x6b/0x340
>  [<ffffffffa00b22a9>] ? btrfs_destroy_delayed_refs.isra.96+0xf9/0x210 [btrfs]
>  [<ffffffff8108e9cd>] ? __lock_release+0xad/0xd0
>  [<ffffffffa00b22a9>] btrfs_destroy_delayed_refs.isra.96+0xf9/0x210 [btrfs]
>  [<ffffffffa00b5682>] btrfs_cleanup_one_transaction+0x12/0x100 [btrfs]
>  [<ffffffffa00b8976>] cleanup_transaction+0x76/0xf0 [btrfs]
>  [<ffffffffa00b91f1>] btrfs_commit_transaction+0xf1/0x900 [btrfs]
>  [<ffffffff8105e250>] ? __init_waitqueue_head+0x60/0x60
>  [<ffffffffa00eb7eb>] create_snapshot.isra.46+0x1ab/0x1e0 [btrfs]
>  [<ffffffffa00eb955>] btrfs_mksubvol+0x135/0x1a0 [btrfs]
>  [<ffffffff811158e0>] ? files_lglock_local_lock+0x70/0x70
>  [<ffffffffa00ebaea>] btrfs_ioctl_snap_create_transid+0x12a/0x190 [btrfs]
>  [<ffffffffa00ec8b0>] btrfs_ioctl_snap_create_v2.constprop.57+0xe0/0xf0 [btrfs]
>  [<ffffffff815ae241>] ? __schedule+0x351/0x8b0
>  [<ffffffffa00eee39>] btrfs_ioctl+0x409/0x770 [btrfs]
>  [<ffffffff81128767>] do_vfs_ioctl+0x87/0x340
>  [<ffffffff81128a6a>] sys_ioctl+0x4a/0x80
>  [<ffffffff815b09a2>] system_call_fastpath+0x16/0x1b


