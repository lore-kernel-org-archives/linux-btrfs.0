Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46026 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750934AbdBBTDa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 14:03:30 -0500
Date: Thu, 2 Feb 2017 11:03:23 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix assertion failure when freeing block groups
 at close_ctree()
Message-ID: <20170202190323.GC6550@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1485990088-6840-1-git-send-email-fdmanana@kernel.org>
 <20170202181951.GA6550@localhost.localdomain>
 <CAL3q7H5eMX6mvsF3aPVUR8yEF3PNY8La+eagSc9B4XMo2ZaBoA@mail.gmail.com>
 <20170202185320.GB6550@localhost.localdomain>
 <CAL3q7H7S_8ehg_sHpb5gt8o10_cD+A8AFrPdj-TWiqCNbshQBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7S_8ehg_sHpb5gt8o10_cD+A8AFrPdj-TWiqCNbshQBA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 06:58:03PM +0000, Filipe Manana wrote:
> On Thu, Feb 2, 2017 at 6:53 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Thu, Feb 02, 2017 at 06:32:01PM +0000, Filipe Manana wrote:
> >> On Thu, Feb 2, 2017 at 6:19 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >> > On Wed, Feb 01, 2017 at 11:01:28PM +0000, fdmanana@kernel.org wrote:
> >> >> From: Filipe Manana <fdmanana@suse.com>
> >> >>
> >> >> At close_ctree() we free the block groups and then only after we wait for
> >> >> any running worker kthreads to finish and shutdown the workqueues. This
> >> >> behaviour is racy and it triggers an assertion failure when freeing block
> >> >> groups because while we are doing it we can have for example a block group
> >> >> caching kthread running, and in that case the block group's reference
> >> >> count is greater than 1, leading to an assertion failure:
> >> >>
> >> >> [19041.198004] assertion failed: atomic_read(&block_group->count) == 1, file: fs/btrfs/extent-tree.c, line: 9799
> >> >> [19041.200584] ------------[ cut here ]------------
> >> >> [19041.201692] kernel BUG at fs/btrfs/ctree.h:3418!
> >> >> [19041.202830] invalid opcode: 0000 [#1] PREEMPT SMP
> >> >> [19041.203929] Modules linked in: btrfs xor raid6_pq dm_flakey dm_mod crc32c_generic ppdev sg psmouse acpi_cpufreq pcspkr parport_pc evdev tpm_tis parport tpm_tis_core i2c_piix4 i2c_core tpm serio_raw processor button loop autofs4 ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix virtio_pci libata virtio_ring virtio e1000 scsi_mod floppy [last unloaded: btrfs]
> >> >> [19041.208082] CPU: 6 PID: 29051 Comm: umount Not tainted 4.9.0-rc7-btrfs-next-36+ #1
> >> >> [19041.208082] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
> >> >> [19041.208082] task: ffff88015f028980 task.stack: ffffc9000ad34000
> >> >> [19041.208082] RIP: 0010:[<ffffffffa03e319e>]  [<ffffffffa03e319e>] assfail.constprop.41+0x1c/0x1e [btrfs]
> >> >> [19041.208082] RSP: 0018:ffffc9000ad37d60  EFLAGS: 00010286
> >> >> [19041.208082] RAX: 0000000000000061 RBX: ffff88015ecb4000 RCX: 0000000000000001
> >> >> [19041.208082] RDX: ffff88023f392fb8 RSI: ffffffff817ef7ba RDI: 00000000ffffffff
> >> >> [19041.208082] RBP: ffffc9000ad37d60 R08: 0000000000000001 R09: 0000000000000000
> >> >> [19041.208082] R10: ffffc9000ad37cb0 R11: ffffffff82f2b66d R12: ffff88023431d170
> >> >> [19041.208082] R13: ffff88015ecb40c0 R14: ffff88023431d000 R15: ffff88015ecb4100
> >> >> [19041.208082] FS:  00007f44f3d42840(0000) GS:ffff88023f380000(0000) knlGS:0000000000000000
> >> >> [19041.208082] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> >> [19041.208082] CR2: 00007f65d623b000 CR3: 00000002166f2000 CR4: 00000000000006e0
> >> >> [19041.208082] Stack:
> >> >> [19041.208082]  ffffc9000ad37d98 ffffffffa035989f ffff88015ecb4000 ffff88015ecb5630
> >> >> [19041.208082]  ffff88014f6be000 0000000000000000 00007ffcf0ba6a10 ffffc9000ad37df8
> >> >> [19041.208082]  ffffffffa0368cd4 ffff88014e9658e0 ffffc9000ad37e08 ffffffff811a634d
> >> >> [19041.208082] Call Trace:
> >> >> [19041.208082]  [<ffffffffa035989f>] btrfs_free_block_groups+0x17f/0x392 [btrfs]
> >> >> [19041.208082]  [<ffffffffa0368cd4>] close_ctree+0x1c5/0x2e1 [btrfs]
> >> >> [19041.208082]  [<ffffffff811a634d>] ? evict_inodes+0x132/0x141
> >> >> [19041.208082]  [<ffffffffa034356d>] btrfs_put_super+0x15/0x17 [btrfs]
> >> >> [19041.208082]  [<ffffffff8118fc32>] generic_shutdown_super+0x6a/0xeb
> >> >> [19041.208082]  [<ffffffff8119004f>] kill_anon_super+0x12/0x1c
> >> >> [19041.208082]  [<ffffffffa0343370>] btrfs_kill_super+0x16/0x21 [btrfs]
> >> >> [19041.208082]  [<ffffffff8118fad1>] deactivate_locked_super+0x3b/0x68
> >> >> [19041.208082]  [<ffffffff8118fb34>] deactivate_super+0x36/0x39
> >> >> [19041.208082]  [<ffffffff811a9946>] cleanup_mnt+0x58/0x76
> >> >> [19041.208082]  [<ffffffff811a99a2>] __cleanup_mnt+0x12/0x14
> >> >> [19041.208082]  [<ffffffff81071573>] task_work_run+0x6f/0x95
> >> >> [19041.208082]  [<ffffffff81001897>] prepare_exit_to_usermode+0xa3/0xc1
> >> >> [19041.208082]  [<ffffffff81001a23>] syscall_return_slowpath+0x16e/0x1d2
> >> >> [19041.208082]  [<ffffffff814c607d>] entry_SYSCALL_64_fastpath+0xab/0xad
> >> >> [19041.208082] Code: c7 ae a0 3e a0 48 89 e5 e8 4e 74 d4 e0 0f 0b 55 89 f1 48 c7 c2 0b a4 3e a0 48 89 fe 48 c7 c7 a4 a6 3e a0 48 89 e5 e8 30 74 d4 e0 <0f> 0b 55 31 d2 48 89 e5 e8 d5 b9 f7 ff 5d c3 48 63 f6 55 31 c9
> >> >> [19041.208082] RIP  [<ffffffffa03e319e>] assfail.constprop.41+0x1c/0x1e [btrfs]
> >> >> [19041.208082]  RSP <ffffc9000ad37d60>
> >> >> [19041.279264] ---[ end trace 23330586f16f064d ]---
> >> >>
> >> >> This started happening as of kernel 4.8, since commit f3bca8028bd9
> >> >> ("Btrfs: add ASSERT for block group's memory leak") introduced these
> >> >> assertions.
> >> >>
> >> >> So fix this by freeing the block groups only after waiting for all
> >> >> worker kthreads to complete and shutdown the workqueues.
> >> >
> >> > This looks good to me, but I don't understand how that could happen, if
> >> > a block group is being cached by the caching worker thread, the block
> >> > group cache has been marked as BTRFS_CACHE_STARTED so we should wait on
> >> > wait_block_group_cache_done() in btrfs_free_block_groups() before
> >> > getting to the ASSERT.  Maybe something else broke?
> >>
> >> Simple. Look at extent-tree.c:caching_kthread() - the the caching
> >
> > caching_thread() vs caching_kthread(), free space cache vs inode cache,
> > confusing helper names...
> >
> >> state is updated (to error or finished), but only much later (at the
> >> very end) the kthread drops its ref count on the block group. So the
> >> assertion you added in commit f3bca8028bd9 fails because the block
> >> group's ref count is 2 and not 1.
> >
> > I see.
> >
> > It doens't make sense to load cache when we're closing the FS, and
> > looks like it's not necessary to put btrfs_free_block_group at the very
> > end of caching_thread(), we could free it before waking up waiters.
> 
> It would still be racy. The task calling free_block_groups() could
> just have seen the caching state set to finished/error just after the
> caching kthread set it and before it unlocked the block group's
> spinlock or before/while it calls free_excluded_extents() for example.
> Iow, make the wakeup after the call to put would still not make it
> safe.

Right, make sense.

Since you've made a v2, reviewed-by will be there.

Thanks,

-liubo
> 
> >
> >> So nothing broke, just the assertion made an incorrect assumption. But
> >> I think it's good having that and the other assertions in place to
> >> detect issues, that's why the patch doesn't remove it/them and makes
> >> them safe instead.
> >>
> >
> > +1.
> >
> > Thanks,
> >
> > -liubo
> >
> >> >
> >> > Thanks,
> >> >
> >> > -liubo
> >> >>
> >> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >> >> ---
> >> >>  fs/btrfs/disk-io.c | 9 +++++++--
> >> >>  1 file changed, 7 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> >> index 066d9b9..a90e40e 100644
> >> >> --- a/fs/btrfs/disk-io.c
> >> >> +++ b/fs/btrfs/disk-io.c
> >> >> @@ -3985,8 +3985,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
> >> >>
> >> >>       btrfs_put_block_group_cache(fs_info);
> >> >>
> >> >> -     btrfs_free_block_groups(fs_info);
> >> >> -
> >> >>       /*
> >> >>        * we must make sure there is not any read request to
> >> >>        * submit after we stopping all workers.
> >> >> @@ -3994,6 +3992,13 @@ void close_ctree(struct btrfs_fs_info *fs_info)
> >> >>       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> >> >>       btrfs_stop_all_workers(fs_info);
> >> >>
> >> >> +     /*
> >> >> +      * Free block groups only after stopping all workers, since we could
> >> >> +      * have block group caching kthreads running, and therefore they could
> >> >> +      * race with us if we freed the block groups before stopping them.
> >> >> +      */
> >> >> +     btrfs_free_block_groups(fs_info);
> >> >> +
> >> >>       clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
> >> >>       free_root_pointers(fs_info, 1);
> >> >>
> >> >> --
> >> >> 2.7.0.rc3
> >> >>
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
