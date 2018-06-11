Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:44662 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932710AbeFKJu4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 05:50:56 -0400
Received: by mail-vk0-f65.google.com with SMTP id x4-v6so11889504vkx.11
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jun 2018 02:50:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <e315b073-05f9-7280-d1ee-4d0456085720@oracle.com>
References: <cover.1528125657.git.dsterba@suse.com> <CAL3q7H7iLCPxA01811RJK-bEiRPAGJdTrHLogJr2a3Sq1g0k4g@mail.gmail.com>
 <e315b073-05f9-7280-d1ee-4d0456085720@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 11 Jun 2018 10:50:54 +0100
Message-ID: <CAL3q7H6EwxMVCM7-cfwb119eCaYAaVo3Go64jE99Z9y04igV5w@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 4.18
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 11, 2018 at 9:14 AM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
> On 06/10/2018 12:21 AM, Filipe Manana wrote:
>>
>> On Mon, Jun 4, 2018 at 4:43 PM, David Sterba <dsterba@suse.com> wrote:
>>>
>>> Hi,
>>>
>>> there are some new features and a usual load of cleanups, more details
>>> below.
>>>
>>> Specifically, there's a set of new non-privileged ioctls to allow
>>> subvolume listing.  It works but still needs a security review as it's a
>>> new interface and we might need to do some tweaks to the data
>>> structures. The fixes could be considred regressions but may touch the
>>> interfaces too.
>>>
>>> Currently there are no merge conflicts but linux-next has reported a few
>>> in the past, originating from other *FS trees.
>>>
>>> Please pull, thanks.
>>>
>>> ---
>>>
>>> User visible features:
>>>
>>> - added support for the ioctl FS_IOC_FSGETXATTR, per-inode flags,
>>> successor
>>>    of GET/SETFLAGS; now supports only existing flags: append, immutable,
>>>    noatime, nodump, sync
>>>
>>> - 3 new unprivileged ioctls to allow users to enumerate subvolumes
>>>
>>> - dedupe syscall implementation does not restrict the range to 16MiB,
>>> though it
>>>    still splits the whole range to 16MiB chunks
>>>
>>> - on user demand, rmdir() is able to delete an empty subvolume, export
>>> the
>>>    capability in sysfs
>>>
>>> - fix inode number types in tracepoints, other cleanups
>>>
>>> - send: improved speed when dealing with a large removed directory,
>>>    measurements show decrease from 2000 minutes to 2 minutes on a
>>> directory with
>>>    2 million entries
>>>
>>> - pre-commit check of superblock to detect a mysterious in-memory
>>> corruption
>>>
>>> - log message updates
>>>
>>>
>>> Other changes:
>>>
>>> - orphan inode cleanup improved, does no keep long-standing reservations
>>> that
>>>    could lead up to early ENOSPC in some cases
>>>
>>> - slight improvement of handling snapshotted NOCOW files by avoiding some
>>>    unnecessary tree searches
>>>
>>> - avoid OOM when dealing with many unmergeable small extents at flush
>>> time
>>>
>>> - speedup conversion of free space tree representations from/to
>>> bitmap/tree
>>>
>>> - code refactoring, deletion, cleanups
>>>    - delayed refs
>>>    - delayed iput
>>>    - redundant argument removals
>>>    - memory barrier cleanups
>>>    - remove a redundant mutex supposedly excluding several ioctls to run
>>> in
>>>      parallel
>>>
>>> - new tracepoints for blockgroup manipulation
>>>
>>> - more sanity checks of compressed headers
>>>
>>> ----------------------------------------------------------------
>>> The following changes since commit
>>> b04e217704b7f879c6b91222b066983a44a7a09f:
>>>
>>>    Linux 4.17-rc7 (2018-05-27 13:01:47 -0700)
>>>
>>> are available in the Git repository at:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>>> for-4.18-tag
>>>
>>> for you to fetch changes up to 23d0b79dfaed2305b500b0215b0421701ada6b1a:
>>>
>>>    btrfs: Add unprivileged version of ino_lookup ioctl (2018-05-31
>>> 11:35:24 +0200)
>>>
>>> ----------------------------------------------------------------
>>> Al Viro (1):
>>>        btrfs: take the last remnants of ->d_fsdata use out
>>>
>>> Anand Jain (19):
>>>        btrfs: add comment about BTRFS_FS_EXCL_OP
>>>        btrfs: rename struct btrfs_fs_devices::list
>>>        btrfs: cleanup __btrfs_open_devices() drop head pointer
>>>        btrfs: rename __btrfs_close_devices to close_fs_devices
>>>        btrfs: rename __btrfs_open_devices to open_fs_devices
>>>        btrfs: cleanup find_device() drop list_head pointer
>>>        btrfs: cleanup btrfs_rm_device() promote fs_devices pointer
>>>        btrfs: move btrfs_raid_type_names values to btrfs_raid_attr table
>>>        btrfs: move btrfs_raid_group values to btrfs_raid_attr table
>>>        btrfs: move btrfs_raid_mindev_errorvalues to btrfs_raid_attr table
>>>        btrfs: reduce uuid_mutex critical section while scanning devices
>>>        btrfs: use existing cur_devices, cleanup btrfs_rm_device
>>>        btrfs: document uuid_mutex uasge in read_chunk_tree
>>>        btrfs: replace uuid_mutex by device_list_mutex in
>>> btrfs_open_devices
>>
>>
>> This change (commit 542c5908abfe84f7b4c1717492ecc92ea0ea328d, "btrfs:
>> replace uuid_mutex by device_list_mutex in btrfs_open_devices"), at
>> the very least
>> introduces a lockdep warning:
>>
>> [  865.021049] ======================================================
>> [  865.021950] WARNING: possible circular locking dependency detected
>> [  865.022828] 4.17.0-rc7-btrfs-next-59+ #1 Not tainted
>> [  865.023491] ------------------------------------------------------
>> [  865.024342] fsstress/27897 is trying to acquire lock:
>> [  865.025070] 0000000099260c12 (&fs_info->reloc_mutex){+.+.}, at:
>> btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.026369]
>> [  865.026369] but task is already holding lock:
>> [  865.027206] 000000008dc17c22 (&mm->mmap_sem){++++}, at:
>> vm_mmap_pgoff+0x77/0xe8
>> [  865.028251]
>> [  865.028251] which lock already depends on the new lock.
>> [  865.028251]
>> [  865.029482]
>> [  865.029482] the existing dependency chain (in reverse order) is:
>> [  865.030523]
>> [  865.030523] -> #7 (&mm->mmap_sem){++++}:
>> [  865.031241]        _copy_to_user+0x1e/0x63
>> [  865.031745]        filldir+0x9e/0xef
>> [  865.032285]        dir_emit_dots+0x3b/0xbd
>> [  865.032881]        dcache_readdir+0x22/0xbb
>> [  865.033502]        iterate_dir+0xa3/0x13e
>> [  865.034131]        __do_sys_getdents+0xa1/0x106
>> [  865.034821]        do_syscall_64+0x51/0x5f
>> [  865.035423]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.036212]
>> [  865.036212] -> #6 (&sb->s_type->i_mutex_key#4){++++}:
>> [  865.037155]        start_creating+0x65/0xd2
>> [  865.037752]        debugfs_create_dir+0xc/0x9b
>> [  865.038374]        blk_mq_debugfs_register+0x30/0xec
>> [  865.039083]        blk_register_queue+0x11e/0x199
>> [  865.039753]        __device_add_disk+0x36d/0x44b
>> [  865.040434]        sd_probe_async+0xf6/0x19f [sd_mod]
>> [  865.041136]        async_run_entry_fn+0x34/0xe0
>> [  865.041811]        process_one_work+0x295/0x4b8
>> [  865.042446]        worker_thread+0x1ab/0x25e
>> [  865.043032]        kthread+0xf5/0xfa
>> [  865.043568]        ret_from_fork+0x3a/0x50
>> [  865.044163]
>> [  865.044163] -> #5 (&q->sysfs_lock){+.+.}:
>> [  865.044916]        blk_mq_sysfs_unregister+0x1d/0x53
>> [  865.045576]        blk_mq_realloc_hw_ctxs+0x2e/0x410
>> [  865.046209]        blk_mq_init_allocated_queue+0xaf/0x40d
>> [  865.046853]        blk_mq_init_queue+0x34/0x50
>> [  865.047494]        loop_add+0xf9/0x27f [loop]
>> [  865.048110]        param_set_lid_init_state+0x8e/0x94 [button]
>> [  865.048867]        do_one_initcall+0x11b/0x2de
>> [  865.049509]        do_init_module+0x5b/0x1ff
>> [  865.050077]        load_module+0x1c78/0x22b5
>> [  865.050669]        __do_sys_finit_module+0x7b/0x86
>> [  865.051288]        do_syscall_64+0x51/0x5f
>> [  865.051886]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.052700]
>> [  865.052700] -> #4 (loop_index_mutex){+.+.}:
>> [  865.053473]        lo_open+0x17/0x47 [loop]
>> [  865.054046]        __blkdev_get+0x145/0x42a
>> [  865.054649]        blkdev_get+0x1aa/0x2e9
>> [  865.055187]        do_dentry_open+0x17a/0x288
>> [  865.055843]        path_openat+0x534/0x699
>> [  865.056438]        do_filp_open+0x4d/0xa3
>> [  865.057026]        do_sys_open+0x69/0xee
>> [  865.057631]        do_syscall_64+0x51/0x5f
>> [  865.058227]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.058971]
>> [  865.058971] -> #3 (&bdev->bd_mutex){+.+.}:
>> [  865.059785]        __blkdev_get+0x409/0x42a
>> [  865.060377]        blkdev_get+0x1aa/0x2e9
>> [  865.060942]        blkdev_get_by_path+0x2c/0x5f
>> [  865.061555]        btrfs_get_bdev_and_sb+0x1b/0x97 [btrfs]
>> [  865.062264]        open_fs_devices+0x81/0x1f6 [btrfs]
>> [  865.063030]        btrfs_open_devices+0x5c/0x74 [btrfs]
>> [  865.063803]        btrfs_mount_root+0x1f7/0x45c [btrfs]
>> [  865.064554]        mount_fs+0x64/0x10b
>> [  865.065116]        vfs_kern_mount+0x68/0xce
>> [  865.069630]        btrfs_mount+0x12e/0x764 [btrfs]
>> [  865.070361]        mount_fs+0x64/0x10b
>> [  865.070962]        vfs_kern_mount+0x68/0xce
>> [  865.071613]        do_mount+0x6e5/0x973
>> [  865.072161]        ksys_mount+0x72/0x97
>> [  865.072732]        __x64_sys_mount+0x21/0x24
>> [  865.073356]        do_syscall_64+0x51/0x5f
>> [  865.073928]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.074687]
>> [  865.074687] -> #2 (&fs_devs->device_list_mutex){+.+.}:
>> [  865.075596]        btrfs_run_dev_stats+0x37/0x2fe [btrfs]
>> [  865.076339]        commit_cowonly_roots+0x87/0x261 [btrfs]
>> [  865.076921]        btrfs_commit_transaction+0x3b8/0x760 [btrfs]
>> [  865.077691]        btrfs_create_uuid_tree+0x9e/0x106 [btrfs]
>> [  865.078476]        open_ctree+0x1c1c/0x1ef9 [btrfs]
>> [  865.079140]        btrfs_mount_root+0x342/0x45c [btrfs]
>> [  865.079796]        mount_fs+0x64/0x10b
>> [  865.080297]        vfs_kern_mount+0x68/0xce
>> [  865.080902]        btrfs_mount+0x12e/0x764 [btrfs]
>> [  865.081566]        mount_fs+0x64/0x10b
>> [  865.082165]        vfs_kern_mount+0x68/0xce
>> [  865.082778]        do_mount+0x6e5/0x973
>> [  865.083308]        ksys_mount+0x72/0x97
>> [  865.083869]        __x64_sys_mount+0x21/0x24
>> [  865.084453]        do_syscall_64+0x51/0x5f
>> [  865.084991]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.085746]
>> [  865.085746] -> #1 (&fs_info->tree_log_mutex){+.+.}:
>> [  865.086729]        btrfs_commit_transaction+0x366/0x760 [btrfs]
>> [  865.087580]        btrfs_create_uuid_tree+0x9e/0x106 [btrfs]
>> [  865.088412]        open_ctree+0x1c1c/0x1ef9 [btrfs]
>> [  865.089092]        btrfs_mount_root+0x342/0x45c [btrfs]
>> [  865.089752]        mount_fs+0x64/0x10b
>> [  865.090256]        vfs_kern_mount+0x68/0xce
>> [  865.090895]        btrfs_mount+0x12e/0x764 [btrfs]
>> [  865.091564]        mount_fs+0x64/0x10b
>> [  865.092090]        vfs_kern_mount+0x68/0xce
>> [  865.092662]        do_mount+0x6e5/0x973
>> [  865.093224]        ksys_mount+0x72/0x97
>> [  865.093789]        __x64_sys_mount+0x21/0x24
>> [  865.094344]        do_syscall_64+0x51/0x5f
>> [  865.094887]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.095579]
>> [  865.095579] -> #0 (&fs_info->reloc_mutex){+.+.}:
>> [  865.096401]        __mutex_lock+0x81/0x3ee
>> [  865.097026]        btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.097885]        start_transaction+0x29f/0x377 [btrfs]
>> [  865.098679]        btrfs_dirty_inode+0x3c/0xbb [btrfs]
>> [  865.099349]        touch_atime+0x82/0xa1
>> [  865.099899]        btrfs_file_mmap+0x2d/0x44 [btrfs]
>> [  865.100590]        mmap_region+0x27b/0x421
>> [  865.101153]        do_mmap+0x3f0/0x492
>> [  865.101673]        vm_mmap_pgoff+0xa1/0xe8
>> [  865.102167]        ksys_mmap_pgoff+0x18d/0x1b1
>> [  865.102641]        do_syscall_64+0x51/0x5f
>> [  865.103126]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.103914]
>> [  865.103914] other info that might help us debug this:
>> [  865.103914]
>> [  865.105096] Chain exists of:
>> [  865.105096]   &fs_info->reloc_mutex --> &sb->s_type->i_mutex_key#4
>> --> &mm->mmap_sem
>> [  865.105096]
>> [  865.106636]  Possible unsafe locking scenario:
>> [  865.106636]
>> [  865.107435]        CPU0                    CPU1
>> [  865.108071]        ----                    ----
>> [  865.108725]   lock(&mm->mmap_sem);
>> [  865.109243]
>> lock(&sb->s_type->i_mutex_key#4);
>> [  865.110144]                                lock(&mm->mmap_sem);
>> [  865.110961]   lock(&fs_info->reloc_mutex);
>> [  865.111568]
>> [  865.111568]  *** DEADLOCK ***
>> [  865.111568]
>> [  865.112401] 3 locks held by fsstress/27897:
>> [  865.112953]  #0: 000000008dc17c22 (&mm->mmap_sem){++++}, at:
>> vm_mmap_pgoff+0x77/0xe8
>> [  865.113955]  #1: 00000000bf2b52fc (sb_writers#11){.+.+}, at:
>> touch_atime+0x3b/0xa1
>> [  865.115020]  #2: 00000000a7121e15 (sb_internal#2){.+.+}, at:
>> start_transaction+0x1b6/0x377 [btrfs]
>> [  865.116274]
>> [  865.116274] stack backtrace:
>> [  865.116937] CPU: 3 PID: 27897 Comm: fsstress Not tainted
>> 4.17.0-rc7-btrfs-next-59+ #1
>> [  865.118063] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
>> [  865.119676] Call Trace:
>> [  865.120092]  dump_stack+0x5f/0x86
>> [  865.120641]  print_circular_bug.isra.21+0x1c7/0x1d4
>> [  865.121367]  __lock_acquire+0xb97/0xf09
>> [  865.121929]  ? lock_acquire+0x16a/0x1af
>> [  865.122524]  lock_acquire+0x16a/0x1af
>> [  865.123101]  ? btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.123854]  __mutex_lock+0x81/0x3ee
>> [  865.124438]  ? btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.125233]  ? module_assert_mutex_or_preempt+0x13/0x2d
>> [  865.126011]  ? btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.126839]  ? join_transaction+0x376/0x38d [btrfs]
>> [  865.127545]  ? btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.128277]  btrfs_record_root_in_trans+0x43/0x62 [btrfs]
>> [  865.129022]  start_transaction+0x29f/0x377 [btrfs]
>> [  865.129726]  btrfs_dirty_inode+0x3c/0xbb [btrfs]
>> [  865.130326]  touch_atime+0x82/0xa1
>> [  865.130863]  btrfs_file_mmap+0x2d/0x44 [btrfs]
>> [  865.131533]  mmap_region+0x27b/0x421
>> [  865.132081]  do_mmap+0x3f0/0x492
>> [  865.132561]  vm_mmap_pgoff+0xa1/0xe8
>> [  865.133097]  ksys_mmap_pgoff+0x18d/0x1b1
>> [  865.133540]  ? do_syscall_64+0x12/0x5f
>> [  865.134059]  do_syscall_64+0x51/0x5f
>> [  865.134648]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [  865.135358] RIP: 0033:0x7f88758e2ad3
>> [  865.135909] RSP: 002b:00007ffd668823e8 EFLAGS: 00000246 ORIG_RAX:
>> 0000000000000009
>> [  865.136928] RAX: ffffffffffffffda RBX: 000000000001e000 RCX:
>> 00007f88758e2ad3
>> [  865.137804] RDX: 0000000000000002 RSI: 000000000000a7ef RDI:
>> 0000000000000000
>> [  865.138734] RBP: 0000000000000000 R08: 0000000000000003 R09:
>> 000000000001e000
>> [  865.139668] R10: 0000000000000002 R11: 0000000000000246 R12:
>> 0000000000000002
>> [  865.140601] R13: 000000000000a7ef R14: 0000000000000002 R15:
>> 0000000000000003
>>
>> I haven't looked enough to see if it's really possible to deadlock.
>> Also, after a quick glance, specially after reading
>> the locking rules comment at the top of volumes.c which says:
>>
>>   * uuid_mutex (global lock)
>>   * ------------------------
>>   * protects the fs_uuids list that tracks all per-fs fs_devices,
>> resulting from
>>   * the SCAN_DEV ioctl registration or from mount either implicitly (the
>> first
>>   * device) or requested by the device= mount option
>>   *
>>   * the mutex can be very coarse and can cover long-running operations
>>   *
>>   * protects: updates to fs_devices counters like missing devices, rw
>> devices,
>>   * seeding, structure cloning, openning/closing devices at mount/umount
>> time
>>
>> generates some confusion since btrfs_open_devices(), after that
>> commit, no longer takes the uuid_mutex and it
>> updates some fs_devices counters (opened, open_devices, etc).
>
>
>  As uuid_mutex is a global fs_uuids lock for the per fsid operations
>  doesn't make any sense.
>
>  This problem is reproducible only for-4.18, misc-next if fine.
>  I am looking deeper.

What about the unprotected updates (increments) to fs_devices->opened
and fs_devices->open_devices?
Other functions are accessing/updating them while holding the uuid mutex.

>
>  Thanks for the report.
>
> -Anand
>
>
>
>
>> Always reproducible by running btrfs/004 from fstests.
>>
>>
>>>        btrfs: drop uuid_mutex in btrfs_dev_replace_finishing
>>>        btrfs: drop uuid_mutex in btrfs_destroy_dev_replace_tgtdev
>>>        btrfs: use common variable for fs_devices in
>>> btrfs_destroy_dev_replace_tgtdev
>>>        btrfs: add prefix "balance:" for log messages
>>>        btrfs: fix describe_relocation when printing unknown flags
>>>
>>> Chengguang Xu (1):
>>>        btrfs: return original error code when failing from option parsing
>>>
>>> Colin Ian King (1):
>>>        btrfs: send: fix spelling mistake: "send_in_progres" ->
>>> "send_in_progress"
>>>
>>> David Sterba (38):
>>>        btrfs: tracepoints, use correct type for inode number
>>>        btrfs: tracepoints, use %llu instead of %Lu
>>>        btrfs: tracepoints, drop unnecessary ULL casts
>>>        btrfs: tracepoints, fix whitespace in strings
>>>        btrfs: tracepoints, use extended format with UUID where possible
>>>        btrfs: tests: pass fs_info to extent_map tests
>>>        btrfs: use fs_info for btrfs_handle_em_exist tracepoint
>>>        btrfs: squeeze btrfs_dev_replace_continue_on_mount to its caller
>>>        btrfs: make success path out of btrfs_init_dev_replace_tgtdev more
>>> clear
>>>        btrfs: export and rename free_device
>>>        btrfs: move btrfs_init_dev_replace_tgtdev to dev-replace.c and
>>> make static
>>>        btrfs: move volume_mutex to callers of btrfs_rm_device
>>>        btrfs: move clearing of EXCL_OP out of __cancel_balance
>>>        btrfs: add proper safety check before resuming dev-replace
>>>        btrfs: add sanity check when resuming balance after mount
>>>        btrfs: cleanup helpers that reset balance state
>>>        btrfs: remove wrong use of volume_mutex from
>>> btrfs_dev_replace_start
>>>        btrfs: kill btrfs_fs_info::volume_mutex
>>>        btrfs: track running balance in a simpler way
>>>        btrfs: move and comment read-only check in btrfs_cancel_balance
>>>        btrfs: drop lock parameter from update_ioctl_balance_args and
>>> rename
>>>        btrfs: use mutex in btrfs_resume_balance_async
>>>        btrfs: open code set_balance_control
>>>        btrfs: remove redundant btrfs_balance_control::fs_info
>>>        btrfs: introduce conditional wakeup helpers
>>>        btrfs: add barriers to btrfs_sync_log before log_commit_wait
>>> wakeups
>>>        btrfs: replace waitqueue_actvie with cond_wake_up
>>>        btrfs: rename btrfs_update_iflags to reflect which flags it
>>> touches
>>>        btrfs: rename btrfs_mask_flags to reflect which flags it touches
>>>        btrfs: rename check_flags to reflect which flags it touches
>>>        btrfs: rename btrfs_flags_to_ioctl to reflect which flags it
>>> touches
>>>        btrfs: add helpers for FS_XFLAG_* conversion
>>>        btrfs: add FS_IOC_FSGETXATTR ioctl
>>>        btrfs: add FS_IOC_FSSETXATTR ioctl
>>>        btrfs: unify naming of flags variables for SETFLAGS and XFLAGS
>>>        btrfs: use kvzalloc for EXTENT_SAME temporary data
>>>        btrfs: tests: add helper for error messages and update them
>>>        btrfs: tests: drop newline from test_msg strings
>>>
>>> Ethan Lien (2):
>>>        btrfs: lift some btrfs_cross_ref_exist checks in nocow path
>>>        btrfs: balance dirty metadata pages in btrfs_finish_ordered_io
>>>
>>> Gu JinXiang (2):
>>>        btrfs: drop unused parameter qgroup_reserved
>>>        btrfs: drop useless member qgroup_reserved of
>>> btrfs_pending_snapshot
>>>
>>> Gu Jinxiang (3):
>>>        btrfs: remove unused fs_info parameter
>>>        btrfs: do reverse path readahead in btrfs_shrink_device
>>>        btrfs: propagate failures of __exclude_logged_extent to upper
>>> caller
>>>
>>> Howard McLauchlan (3):
>>>        btrfs: clean up le_bitmap_{set, clear}()
>>>        btrfs: optimize free space tree bitmap conversion
>>>        btrfs: remove unused le_test_bit()
>>>
>>> Kees Cook (1):
>>>        btrfs: raid56: Remove VLA usage
>>>
>>> Liu Bo (7):
>>>        Btrfs: add parent_transid parameter to veirfy_level_key
>>>        Btrfs: remove superfluous free_extent_buffer in
>>> read_block_for_search
>>>        Btrfs: use more straightforward extent_buffer_uptodate check
>>>        Btrfs: move get root out of btrfs_search_slot to a helper
>>>        Btrfs: grab write lock directly if write_lock_level is the max
>>> level
>>>        Btrfs: remove always true check in unlock_up
>>>        Btrfs: remove unused check of skip_locking
>>>
>>> Lu Fengqi (3):
>>>        btrfs: drop unused space_info parameter from create_space_info
>>>        btrfs: Remove fs_info argument from btrfs_uuid_tree_add
>>>        btrfs: Remove fs_info argument from btrfs_uuid_tree_rem
>>>
>>> Misono Tomohiro (5):
>>>        btrfs: Move may_destroy_subvol() from ioctl.c to inode.c
>>>        btrfs: Factor out the main deletion process from
>>> btrfs_ioctl_snap_destroy()
>>>        btrfs: Allow rmdir(2) to delete an empty subvolume
>>>        btrfs: sysfs: Add entry which shows if rmdir can work on
>>> subvolumes
>>>        btrfs: use error code returned by btrfs_read_fs_root_no_name in
>>> search ioctl
>>>
>>> Nikolay Borisov (54):
>>>        btrfs: Replace owner argument in add_pinned_bytes with a boolean
>>>        btrfs: Drop delayed_refs argument from btrfs_check_delayed_seq
>>>        btrfs: Use while loop instead of labels in
>>> __endio_write_update_ordered
>>>        btrfs: Fix lock release order
>>>        btrfs: Consolidate error checking for btrfs_alloc_chunk
>>>        btrfs: Sink extent_tree arguments in try_release_extent_mapping
>>>        btrfs: Remove map argument from try_release_extent_state
>>>        btrfs: Remove redundant tree argument from extent_readpages
>>>        btrfs: Use list_empty instead of list_empty_careful
>>>        btrfs: Remove tree argument from extent_writepages
>>>        btrfs: Remove btrfs_wait_and_free_delalloc_work
>>>        btrfs: Drop add_delayed_ref_head fs_info parameter
>>>        btrfs: Drop fs_info parameter from add_delayed_data_ref
>>>        btrfs: Drop fs_info parameter from btrfs_merge_delayed_refs
>>>        btrfs: Remove delayed_iput parameter of btrfs_start_delalloc_roots
>>>        btrfs: Remove delayed_iput parameter from
>>> btrfs_start_delalloc_inodes
>>>        btrfs: Remove delay_iput parameter from __start_delalloc_inodes
>>>        btrfs: Remove delayed_iput member from btrfs_delalloc_work
>>>        btrfs: Unexport btrfs_alloc_delalloc_work
>>>        btrfs: Remove devid parameter from btrfs_rmap_block
>>>        btrfs: Factor out common delayed refs init code
>>>        btrfs: Use init_delayed_ref_common in add_delayed_tree_ref
>>>        btrfs: Use init_delayed_ref_common in add_delayed_data_ref
>>>        btrfs: Open-code add_delayed_tree_ref
>>>        btrfs: Open-code add_delayed_data_ref
>>>        btrfs: Introduce init_delayed_ref_head
>>>        btrfs: Use init_delayed_ref_head in add_delayed_ref_head
>>>        btrfs: split delayed ref head initialization and addition
>>>        btrfs: Add assert in __btrfs_del_delalloc_inode
>>>        btrfs: Make btrfs_init_dummy_trans initialize trans' fs_info field
>>>        btrfs: Remove fs_info argument from add_block_group_free_space
>>>        btrfs: Remove fs_info argument from __add_block_group_free_space
>>>        btrfs: Remove fs_info argument from __add_to_free_space_tree
>>>        btrfs: Remove fs_info parameter from add_new_free_space_info
>>>        btrfs: Remove fs_info argument from add_new_free_space
>>>        btrfs: Remove fs_info parameter from remove_block_group_free_space
>>>        btrfs: Remove fs_info argument from convert_free_space_to_bitmaps
>>>        btrfs: Remove fs_info parameter from convert_free_space_to_extents
>>>        btrfs: Remove fs_info argument from update_free_space_extent_count
>>>        btrfs: Remove fs_info argument from modify_free_space_bitmap
>>>        btrfs: Remove fs_info argument from add_free_space_extent
>>>        btrfs: Remove fs_info argument from remove_free_space_extent
>>>        btrfs: Remove fs_info argument from __remove_from_free_space_tree
>>>        btrfs: Remove fs_info argument from remove_from_free_space_tree
>>>        btrfs: Remove fs_info argument from add_to_free_space_tree
>>>        btrfs: Remove fs_info argument from populate_free_space_tree
>>>        btrfs: Unexport and rename btrfs_invalidate_inodes
>>>        btrfs: Remove stale comment about select_delayed_ref
>>>        btrfs: Remove fs_info argument from alloc_reserved_tree_block
>>>        btrfs: Simplify alloc_reserved_tree_block interface
>>>        btrfs: Pass btrfs_delayed_extent_op to alloc_reserved_tree_block
>>>        btrfs: Streamline shared ref check in alloc_reserved_tree_block
>>>        btrfs: Factor out read portion of btrfs_get_blocks_direct
>>>        btrfs: Factor out write portion of btrfs_get_blocks_direct
>>>
>>> Omar Sandoval (16):
>>>        Btrfs: update stale comments referencing vmtruncate()
>>>        Btrfs: fix error handling in btrfs_truncate_inode_items()
>>>        Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
>>>        Btrfs: stop creating orphan items for truncate
>>>        Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
>>>        Btrfs: delete dead code in btrfs_orphan_commit_root()
>>>        Btrfs: don't return ino to ino cache if inode item removal fails
>>>        Btrfs: refactor btrfs_evict_inode() reserve refill dance
>>>        Btrfs: fix ENOSPC caused by orphan items reservations
>>>        Btrfs: get rid of unused orphan infrastructure
>>>        Btrfs: renumber BTRFS_INODE_ runtime flags and switch to enums
>>>        Btrfs: reserve space for O_TMPFILE orphan item deletion
>>>        Btrfs: allow empty subvol= again
>>>        Btrfs: fix clone vs chattr NODATASUM race
>>>        Btrfs: fix memory and mount leak in btrfs_ioctl_rm_dev_v2()
>>>        Btrfs: clean up error handling in btrfs_truncate()
>>>
>>> Qu Wenruo (15):
>>>        btrfs: print-tree: Add eb locking status output for debug build
>>>        btrfs: trace: Remove unnecessary fs_info parameter for
>>> btrfs__reserve_extent event class
>>>        btrfs: trace: Add trace points for unused block groups
>>>        btrfs: trace: Allow trace_qgroup_update_counters() to record old
>>> rfer/excl value
>>>        btrfs: qgroup: Allow trace_btrfs_qgroup_account_extent() to record
>>> its transid
>>>        btrfs: Move btrfs_check_super_valid() to avoid forward declaration
>>>        btrfs: Refactor btrfs_check_super_valid
>>>        btrfs: Do super block verification before writing it to disk
>>>        btrfs: qgroup: Search commit root for rescan to avoid missing
>>> extent
>>>        btrfs: qgroup: Finish rescan when hit the last leaf of extent tree
>>>        btrfs: compression: Add linux/sizes.h for compression.h
>>>        btrfs: lzo: document the compressed data format
>>>        btrfs: lzo: Add header length check to avoid potential
>>> out-of-bounds access
>>>        btrfs: lzo: Harden inline lzo compressed extent decompression
>>>        btrfs: qgroup: show more meaningful qgroup_rescan_init error
>>> message
>>>
>>> Robbie Ko (2):
>>>        btrfs: incremental send, move allocation until it's needed in
>>> orphan_dir_info
>>>        btrfs: incremental send, improve rmdir performance for large
>>> directory
>>>
>>> Su Yue (3):
>>>        btrfs: rename btrfs_get_block_group_info and make it static
>>>        btrfs: return error value if create_io_em failed in cow_file_range
>>>        btrfs: return ENOMEM if path allocation fails in
>>> btrfs_cross_ref_exist
>>>
>>> Timofey Titovets (3):
>>>        Btrfs: split btrfs_extent_same
>>>        Btrfs: dedupe_file_range ioctl: remove 16MiB restriction
>>>        Btrfs: reuse cmp workspace in EXTENT_SAME ioctl
>>>
>>> Tomohiro Misono (4):
>>>        btrfs: sysfs: Use enum/define value for feature array definitions
>>>        btrfs: Add unprivileged ioctl which returns subvolume information
>>>        btrfs: Add unprivileged ioctl which returns subvolume's ROOT_REF
>>>        btrfs: Add unprivileged version of ino_lookup ioctl
>>>
>>>   fs/btrfs/btrfs_inode.h                 |   22 +-
>>>   fs/btrfs/compression.c                 |    7 +-
>>>   fs/btrfs/compression.h                 |    2 +
>>>   fs/btrfs/ctree.c                       |  123 +--
>>>   fs/btrfs/ctree.h                       |   76 +-
>>>   fs/btrfs/delayed-inode.c               |    9 +-
>>>   fs/btrfs/delayed-ref.c                 |  275 +++----
>>>   fs/btrfs/delayed-ref.h                 |    5 +-
>>>   fs/btrfs/dev-replace.c                 |  150 +++-
>>>   fs/btrfs/disk-io.c                     |  391 +++++----
>>>   fs/btrfs/extent-tree.c                 |  253 +++---
>>>   fs/btrfs/extent_io.c                   |   62 +-
>>>   fs/btrfs/extent_io.h                   |   20 +-
>>>   fs/btrfs/extent_map.c                  |    6 +-
>>>   fs/btrfs/extent_map.h                  |    3 +-
>>>   fs/btrfs/free-space-cache.c            |    6 +-
>>>   fs/btrfs/free-space-tree.c             |  192 +++--
>>>   fs/btrfs/free-space-tree.h             |    8 -
>>>   fs/btrfs/inode.c                       | 1371
>>> ++++++++++++++++----------------
>>>   fs/btrfs/ioctl.c                       | 1210
>>> ++++++++++++++++++----------
>>>   fs/btrfs/locking.c                     |   34 +-
>>>   fs/btrfs/lzo.c                         |   76 +-
>>>   fs/btrfs/ordered-data.c                |   14 +-
>>>   fs/btrfs/print-tree.c                  |   21 +
>>>   fs/btrfs/qgroup.c                      |   69 +-
>>>   fs/btrfs/raid56.c                      |   38 +-
>>>   fs/btrfs/relocation.c                  |    8 +-
>>>   fs/btrfs/scrub.c                       |    1 +
>>>   fs/btrfs/send.c                        |   46 +-
>>>   fs/btrfs/super.c                       |    7 +-
>>>   fs/btrfs/sysfs.c                       |   52 +-
>>>   fs/btrfs/sysfs.h                       |    4 +-
>>>   fs/btrfs/tests/btrfs-tests.c           |    4 +-
>>>   fs/btrfs/tests/btrfs-tests.h           |    6 +-
>>>   fs/btrfs/tests/extent-buffer-tests.c   |   56 +-
>>>   fs/btrfs/tests/extent-io-tests.c       |   75 +-
>>>   fs/btrfs/tests/extent-map-tests.c      |   90 ++-
>>>   fs/btrfs/tests/free-space-tests.c      |  177 +++--
>>>   fs/btrfs/tests/free-space-tree-tests.c |  129 +--
>>>   fs/btrfs/tests/inode-tests.c           |  312 ++++----
>>>   fs/btrfs/tests/qgroup-tests.c          |  100 +--
>>>   fs/btrfs/transaction.c                 |   15 +-
>>>   fs/btrfs/transaction.h                 |    1 -
>>>   fs/btrfs/tree-log.c                    |   28 +-
>>>   fs/btrfs/uuid-tree.c                   |   10 +-
>>>   fs/btrfs/volumes.c                     |  506 ++++++------
>>>   fs/btrfs/volumes.h                     |   24 +-
>>>   include/trace/events/btrfs.h           |  323 ++++----
>>>   include/uapi/linux/btrfs.h             |   97 +++
>>>   49 files changed, 3579 insertions(+), 2935 deletions(-)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
