From: Josef Bacik <jbacik@redhat.com>
Subject: Re: btrfs crash
Date: Sat, 23 Aug 2008 15:20:11 -0400
Message-ID: <20080823192011.GB664@unused.rdu.redhat.com>
References: <1219498666.17115.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Priit Laes <plaes@plaes.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219498666.17115.7.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 23, 2008 at 04:37:46PM +0300, Priit Laes wrote:
> Hey!
> 
> Got following crash while copying files to btrfs partition with latest
> unstable btrfs.
> Partition itself is a 6GB image residing on ext3 partition.
> 
> 
> cp used greatest stack depth: 3504 bytes left
> space info full 1
> allocation failed flags 1
> ------------[ cut here ]------------
> kernel BUG
> at /var/tmp/portage/sys-fs/btrfs-9999/work/kernel-unstable/extent-tree.c:2136!
> invalid opcode: 0000 [1] SMP 
> CPU 0 
> Modules linked in: btrfs [last unloaded: btrfs]
> Pid: 247, comm: pdflush Not tainted 2.6.27-rc4 #2
> RIP: 0010:[<ffffffffa000c3ba>]  [<ffffffffa000c3ba>]
> __alloc_chunk_for_shrink+0x942/0x97d [btrfs]
> RSP: 0018:ffff88007e293850  EFLAGS: 00010282
> RAX: 000000000000001d RBX: 0000000000000001 RCX: 0000000000000000
> RDX: 0000000103af6a67 RSI: 0000000000000086 RDI: ffffffff8150db50
> RBP: ffff88007e2938c0 R08: ffff88007e2936a0 R09: 0000000100000000
> R10: 0000005168576094 R11: ffff880001018a80 R12: ffff880074d12000
> R13: ffff880071c10c00 R14: 0000000000001000 R15: ffff8800620585b0
> FS:  0000000000000000(0000) GS:ffffffff8158e2c0(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000c1fdf8 CR3: 0000000048075000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process pdflush (pid: 247, threadinfo ffff88007e292000, task
> ffff88007e123020)
> Stack:  0000000000000000 ffff88007e293980 0000000000000000
> 0000000000000000
>  0000000000000001 0000000000000246 0000000000000000 0000000000000000
>  0000000000001000 0000000000000000 ffff880071c10c00 0000000000000000
> Call Trace:
>  [<ffffffffa000c453>] btrfs_reserve_extent+0x5e/0xb49 [btrfs]
>  [<ffffffffa0017a38>] btrfs_force_ra+0x94c/0x19fd [btrfs]
>  [<ffffffff8104416a>] ? enqueue_hrtimer+0xe3/0xf1
>  [<ffffffffa0017e24>] btrfs_force_ra+0xd38/0x19fd [btrfs]
>  [<ffffffffa00289d9>] ? find_lock_delalloc_range+0x1df/0x226 [btrfs]
>  [<ffffffffa002ae7c>] clear_extent_buffer_dirty+0x2dc/0x727 [btrfs]
>  [<ffffffff81065e87>] ? find_get_pages_tag+0x3e/0xd9
>  [<ffffffff81071419>] ? __dec_zone_page_state+0x1e/0x20
>  [<ffffffff8106c468>] write_cache_pages+0x1b4/0x318
>  [<ffffffffa001c57c>] ? __btrfs_submit_bio_hook+0x0/0x4e [btrfs]
>  [<ffffffffa002ad0e>] ? clear_extent_buffer_dirty+0x16e/0x727 [btrfs]
>  [<ffffffff81132141>] ? rb_insert_color+0x69/0xe6
>  [<ffffffffa00287da>] extent_writepages+0x32/0x52 [btrfs]
>  [<ffffffffa0018bd4>] ? btrfs_get_extent+0x0/0x73e [btrfs]
>  [<ffffffffa0018bb2>] btrfs_writepages+0x23/0x25 [btrfs]
>  [<ffffffff8106c619>] do_writepages+0x28/0x38
>  [<ffffffff810a9e4a>] __writeback_single_inode+0x184/0x394
>  [<ffffffff810270ad>] ? hrtick_start_fair+0x135/0x16b
>  [<ffffffff810aa4c7>] generic_sync_sb_inodes+0x2a0/0x3de
>  [<ffffffff810aa85c>] writeback_inodes+0x8b/0xdd
>  [<ffffffff8106cb81>] background_writeout+0x92/0xcb
>  [<ffffffff8106d13c>] pdflush+0x143/0x1f1
>  [<ffffffff8106caef>] ? background_writeout+0x0/0xcb
>  [<ffffffff8106cff9>] ? pdflush+0x0/0x1f1
>  [<ffffffff81041a41>] kthread+0x49/0x76
>  [<ffffffff8100ceb9>] child_rip+0xa/0x11
>  [<ffffffff81027176>] ? pick_next_task_fair+0x93/0xa3
>  [<ffffffff810419f8>] ? kthread+0x0/0x76
>  [<ffffffff8100ceaf>] ? child_rip+0x0/0x11
> 
> 
> Code: 85 08 01 00 00 4c 89 f2 48 8b 70 20 e8 0d f5 ff ff e9 91 fe ff ff
> 85 c0 74 15 48 89 de 48 c7 c7 04 20 03 a0 31 c0 e8 d8 19 37 e1 <0f> 0b
> eb fe 48 8b 45 18 49 8b bd 08 01 00 00 48 8b 30 48 83 c7 
> RIP  [<ffffffffa000c3ba>] __alloc_chunk_for_shrink+0x942/0x97d [btrfs]
>  RSP <ffff88007e293850>
> ---[ end trace 55b30c81761fd934 ]---
> pdflush used greatest stack depth: 3208 bytes left
> 
>

You "ran out of space" :).  Looks like you ran out of data space, should
probably make the volume bigger.  Thanks,

Josef
