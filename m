Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49163 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751869AbdJFX2N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 19:28:13 -0400
Date: Fri, 6 Oct 2017 16:23:39 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes for 4.14-rc4
Message-ID: <20171006232339.GA19068@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1507303159.git.dsterba@suse.com>
 <CABB28Cz_n8GgXDWcdC4+93mqAGgj+nxL7jF_Yn_J89shyHmPMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABB28Cz_n8GgXDWcdC4+93mqAGgj+nxL7jF_Yn_J89shyHmPMw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 06, 2017 at 11:25:12PM +0100, Tomasz Kłoczko wrote:
> On rc3 is possible to observe warning about possible circular locking
> dependency which I've reported on btrfs list few days ago:
>

Thanks for the report, neither this nor the one you reported on rc2
looks like a deadlock to me.

- %mmap_sem is always 'current->mm->mmap_sem',
- fsync doesn't acquire %mmap_sem, does it?

Not sure why we have a dependency here, tend to be a false one.

thanks,
-liubo

> [  101.326724] ======================================================
> [  101.326728] WARNING: possible circular locking dependency detected
> [  101.326734] 4.14.0-0.rc3.git1.1.fc28.x86_64 #1 Not tainted
> [  101.326738] ------------------------------------------------------
> [  101.326743] mysqld/1253 is trying to acquire lock:
> [  101.326747]  (&mm->mmap_sem){++++}, at: [<ffffffffbd269a9e>]
> get_user_pages_unlocked+0x5e/0x1b0
> [  101.326771]
> [  101.326775]  (&ei->dio_sem){++++}, at: [<ffffffffc02e8bdf>]
> btrfs_direct_IO+0x39f/0x400 [btrfs]
> [  101.326846]
> [  101.326851]
> [  101.326856]
> [  101.326875]        __lock_acquire+0x1107/0x11d0
> [  101.326883]        lock_acquire+0xa3/0x1f0
> [  101.326892]        down_write+0x51/0xc0
> [  101.326949]        btrfs_log_changed_extents+0x7e/0x6c0 [btrfs]
> [  101.327000]        btrfs_log_inode+0x9c1/0x11d0 [btrfs]
> [  101.327049]        btrfs_log_inode_parent+0x2df/0xad0 [btrfs]
> [  101.327096]        btrfs_log_dentry_safe+0x60/0x80 [btrfs]
> [  101.327144]        btrfs_sync_file+0x344/0x4f0 [btrfs]
> [  101.327155]        vfs_fsync_range+0x4b/0xb0
> [  101.327162]        do_fsync+0x3d/0x70
> [  101.327170]        SyS_fsync+0x10/0x20
> [  101.327179]        do_syscall_64+0x6c/0x1f0
> [  101.327185]        return_from_SYSCALL_64+0x0/0x7a
> [  101.327188]
> [  101.327204]        __lock_acquire+0x1107/0x11d0
> [  101.327212]        lock_acquire+0xa3/0x1f0
> [  101.327219]        __mutex_lock+0x7f/0xa40
> [  101.327226]        mutex_lock_nested+0x1b/0x20
> [  101.327272]        btrfs_log_inode+0x159/0x11d0 [btrfs]
> [  101.327317]        btrfs_log_inode_parent+0x2df/0xad0 [btrfs]
> [  101.327360]        btrfs_log_dentry_safe+0x60/0x80 [btrfs]
> [  101.327407]        btrfs_sync_file+0x344/0x4f0 [btrfs]
> [  101.327415]        vfs_fsync_range+0x4b/0xb0
> [  101.327422]        do_fsync+0x3d/0x70
> [  101.327429]        SyS_fsync+0x10/0x20
> [  101.327435]        do_syscall_64+0x6c/0x1f0
> [  101.327441]        return_from_SYSCALL_64+0x0/0x7a
> [  101.327444]
> [  101.327463]        __sb_start_write+0x12b/0x1a0
> [  101.327508]        start_transaction+0x368/0x4d0 [btrfs]
> [  101.327549]        btrfs_join_transaction+0x1d/0x20 [btrfs]
> [  101.327589]        delayed_ref_async_start+0x67/0xd0 [btrfs]
> [  101.327637]        btrfs_worker_helper+0x93/0x610 [btrfs]
> [  101.327640]
> [  101.327656]        __lock_acquire+0x1107/0x11d0
> [  101.327664]        lock_acquire+0xa3/0x1f0
> [  101.327671]        wait_for_completion+0x62/0x1d0
> [  101.327710]        btrfs_async_run_delayed_refs+0x163/0x180 [btrfs]
> [  101.327752]        __btrfs_end_transaction+0x1f2/0x2e0 [btrfs]
> [  101.327790]        btrfs_end_transaction+0x10/0x20 [btrfs]
> [  101.327832]        btrfs_dirty_inode+0x71/0xd0 [btrfs]
> [  101.327871]        btrfs_update_time+0x81/0xc0 [btrfs]
> [  101.327877]        touch_atime+0xab/0xd0
> [  101.327920]        btrfs_file_mmap+0x44/0x60 [btrfs]
> [  101.327927]        mmap_region+0x3a3/0x5d0
> [  101.327932]        do_mmap+0x2b6/0x410
> [  101.327938]        vm_mmap_pgoff+0xcf/0x120
> [  101.327943]        SyS_mmap_pgoff+0x1e1/0x280
> [  101.327949]        SyS_mmap+0x1b/0x30
> [  101.327955]        entry_SYSCALL_64_fastpath+0x1f/0xbe
> [  101.327958]
> [  101.327974]        check_prev_add+0x351/0x700
> [  101.327981]        __lock_acquire+0x1107/0x11d0
> [  101.327989]        lock_acquire+0xa3/0x1f0
> [  101.327996]        down_read+0x48/0xb0
> [  101.328003]        get_user_pages_unlocked+0x5e/0x1b0
> [  101.328009]        get_user_pages_fast+0x7a/0xc0
> [  101.328018]        iov_iter_get_pages+0xc9/0x300
> [  101.328026]        do_blockdev_direct_IO+0x192b/0x2940
> [  101.328034]        __blockdev_direct_IO+0x2e/0x30
> [  101.328073]        btrfs_direct_IO+0x171/0x400 [btrfs]
> [  101.328080]        generic_file_direct_write+0xa3/0x160
> [  101.328123]        btrfs_file_write_iter+0x2fb/0x610 [btrfs]
> [  101.328129]        aio_write+0x116/0x1a0
> [  101.328134]        do_io_submit+0x42d/0x940
> [  101.328139]        SyS_io_submit+0x10/0x20
> [  101.328145]        entry_SYSCALL_64_fastpath+0x1f/0xbe
> [  101.328149]
> [  101.328154] Chain exists of:
> [  101.328169]  Possible unsafe locking scenario:
> [  101.328174]        CPU0                    CPU1
> [  101.328177]        ----                    ----
> [  101.328180]   lock(&ei->dio_sem);
> [  101.328187]                                lock(&ei->log_mutex);
> [  101.328194]                                lock(&ei->dio_sem);
> [  101.328200]   lock(&mm->mmap_sem);
> [  101.328206]
> [  101.328213] 2 locks held by mysqld/1253:
> [  101.328217]  #0:  (sb_writers#10){.+.+}, at: [<ffffffffbd34a681>]
> aio_write+0x191/0x1a0
> [  101.328231]  #1:  (&ei->dio_sem){++++}, at: [<ffffffffc02e8bdf>]
> btrfs_direct_IO+0x39f/0x400 [btrfs]
> [  101.328277]
> [  101.328285] CPU: 0 PID: 1253 Comm: mysqld Not tainted
> 4.14.0-0.rc3.git1.1.fc28.x86_64 #1
> [  101.328290] Hardware name: Sony Corporation VPCSB2M9E/VAIO, BIOS
> R2087H4 06/15/2012
> [  101.328294] Call Trace:
> [  101.328304]  dump_stack+0x8e/0xd6
> [  101.328314]  print_circular_bug+0x1f6/0x2e0
> [  101.328322]  ? copy_trace+0x90/0x90
> [  101.328330]  check_prev_add+0x351/0x700
> [  101.328341]  ? rcu_read_lock_sched_held+0x22/0x80
> [  101.328348]  ? __module_address+0x2c/0xf0
> [  101.328361]  __lock_acquire+0x1107/0x11d0
> [  101.328368]  ? __lock_acquire+0x1107/0x11d0
> [  101.328376]  ? copy_trace+0x90/0x90
> [  101.328387]  lock_acquire+0xa3/0x1f0
> [  101.328395]  ? get_user_pages_unlocked+0x5e/0x1b0
> [  101.328406]  down_read+0x48/0xb0
> [  101.328412]  ? get_user_pages_unlocked+0x5e/0x1b0
> [  101.328419]  get_user_pages_unlocked+0x5e/0x1b0
> [  101.328429]  get_user_pages_fast+0x7a/0xc0
> [  101.328439]  iov_iter_get_pages+0xc9/0x300
> [  101.328450]  do_blockdev_direct_IO+0x192b/0x2940
> [  101.328459]  ? update_stack_state+0x144/0x160
> [  101.328501]  ? btrfs_endio_direct_read+0xc0/0xc0 [btrfs]
> [  101.328544]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
> [  101.328590]  ? btrfs_page_exists_in_range+0x310/0x310 [btrfs]
> [  101.328628]  ? btrfs_endio_direct_read+0xc0/0xc0 [btrfs]
> [  101.328642]  __blockdev_direct_IO+0x2e/0x30
> [  101.328649]  ? __blockdev_direct_IO+0x2e/0x30
> [  101.328687]  ? btrfs_endio_direct_read+0xc0/0xc0 [btrfs]
> [  101.328724]  btrfs_direct_IO+0x171/0x400 [btrfs]
> [  101.328760]  ? btrfs_endio_direct_read+0xc0/0xc0 [btrfs]
> [  101.328772]  generic_file_direct_write+0xa3/0x160
> [  101.328816]  btrfs_file_write_iter+0x2fb/0x610 [btrfs]
> [  101.328824]  ? rcu_read_lock_sched_held+0x79/0x80
> [  101.328833]  aio_write+0x116/0x1a0
> [  101.328843]  ? sched_clock+0x9/0x10
> [  101.328851]  ? __might_fault+0x3e/0x90
> [  101.328860]  do_io_submit+0x42d/0x940
> [  101.328865]  ? do_io_submit+0x42d/0x940
> [  101.328877]  SyS_io_submit+0x10/0x20
> [  101.328882]  ? SyS_io_submit+0x10/0x20
> [  101.328889]  entry_SYSCALL_64_fastpath+0x1f/0xbe
> [  101.328894] RIP: 0033:0x7f14cb326687
> [  101.328899] RSP: 002b:00007f14aece44a8 EFLAGS: 00000206 ORIG_RAX:
> 00000000000000d1
> [  101.328907] RAX: ffffffffffffffda RBX: 00007f14b4698000 RCX: 00007f14cb326687
> [  101.328912] RDX: 00007f14aece44b0 RSI: 0000000000000001 RDI: 00007f14c2e26000
> [  101.328916] RBP: 00007f14aece4830 R08: 00007f14aece44b0 R09: 0000000000000400
> [  101.328920] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f14b3d18630
> [  101.328925] R13: 000055f10ab6ef48 R14: 00000012406e5969 R15: 0000000000000001
> 
> 
> kloczek
> -- 
> Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
> 
> 
> On 6 October 2017 at 16:34, David Sterba <dsterba@suse.com> wrote:
> > Hi,
> >
> > we have two more fixes for bugs introduced in 4.13. The sector_t problem with
> > 32bit architecture and !LBDAF config seems serious but the number of affected
> > deployments is hopefully low.  The clashing status bits could lead to a
> > confusing in-memory state of the whole-filesystem operations if used with the
> > quota override sysfs knob.
> >
> > Please pull, thanks.
> >
> > The following changes since commit 8c6c592831a09a28428448e68fb08c6bbb8b9b8b:
> >
> >   btrfs: log csums for all modified extents (2017-09-26 14:54:16 +0200)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.14-rc4
> >
> > for you to fetch changes up to 69ad59767d094752c23c0fc180a79532fde073d0:
> >
> >   Btrfs: fix overlap of fs_info::flags values (2017-10-04 16:44:18 +0200)
> >
> > ----------------------------------------------------------------
> > Goffredo Baroncelli (1):
> >       btrfs: avoid overflow when sector_t is 32 bit
> >
> > Tsutomu Itoh (1):
> >       Btrfs: fix overlap of fs_info::flags values
> >
> >  fs/btrfs/ctree.h     | 2 +-
> >  fs/btrfs/extent_io.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
