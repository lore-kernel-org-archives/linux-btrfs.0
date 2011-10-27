From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up
Date: Thu, 27 Oct 2011 14:00:49 +0200
Message-ID: <20111027120049.GA19328@twin.jikos.cz>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com> <20111026151024.GB5914@twin.jikos.cz> <4EA824D2.6070801@suse.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA824D2.6070801@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2011 at 11:18:42AM -0400, Jeff Mahoney wrote:
> > and this clobber the original ret value which is returned a few
> > lines below and used in the caller.
> > 
> >> } out: free_extent_state(cached_state);
> > 
> > return ret; }
> 
> *smack*
> 
> Ugh. You're right. It avoids the corruption but signals a short write.

still crashes in xfstests/113 with the following fixup. so there may be more
occurences of the ret value clobbering, I closely reviewed only this patch.
I'll verify with just that on top.

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6223,6 +6223,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
        struct extent_state *cached_state = NULL;
        u64 lockstart, lockend;
        ssize_t ret;
+       int ret2;
        int writing = rw & WRITE;
        int write_bits = 0;
        size_t count = iov_length(iov, nr_segs);
@@ -6273,7 +6274,6 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
                                     &cached_state, GFP_NOFS);
                BUG_ON(ret < 0);
                if (ret) {
-                       int ret2;
                        ret2 = clear_extent_bit(&BTRFS_I(inode)->io_tree,
                                                lockstart, lockend,
                                                EXTENT_LOCKED | write_bits,
@@ -6292,23 +6292,21 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
                   btrfs_submit_direct, 0);

        if (ret < 0 && ret != -EIOCBQUEUED) {
-               ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
+               ret2 = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
                                       offset + iov_length(iov, nr_segs) - 1,
                                       EXTENT_LOCKED | write_bits, 1, 0,
                                       &cached_state, GFP_NOFS);
-               BUG_ON(ret < 0);
-               ret = 0;
+               BUG_ON(ret2 < 0);
        } else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
                /*
                 * We're falling back to buffered, unlock the section we didn't
                 * do IO on.
                 */
-               ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
+               ret2 = clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
                                       offset + iov_length(iov, nr_segs) - 1,
                                       EXTENT_LOCKED | write_bits, 1, 0,
                                       &cached_state, GFP_NOFS);
-               BUG_ON(ret < 0);
-               ret = 0;
+               BUG_ON(ret2 < 0);
        }
 out:
        free_extent_state(cached_state);
---

stacktrace, same as every crash before:

[ 1741.840468] ------------[ cut here ]------------
[ 1741.844015] kernel BUG at drivers/scsi/scsi_lib.c:988!
[ 1741.844015] invalid opcode: 0000 [#1] SMP
[ 1741.844015] CPU 0
[ 1741.844015] Modules linked in: loop btrfs aoe
[ 1741.844015]
[ 1741.844015] Pid: 9220, comm: aio-stress Tainted: G        W   3.1.0-rc9-default+ #63 Intel Corporation Santa Rosa platform/Matanzas
[ 1741.844015] RIP: 0010:[<ffffffff815f25ef>]  [<ffffffff815f25ef>] scsi_init_sgtable+0x5f/0x70
[ 1741.844015] RSP: 0018:ffff880078cd7c18  EFLAGS: 00010006
[ 1741.844015] RAX: 0000000000000004 RBX: ffff88005d9a97d8 RCX: 00000000ffffffff
[ 1741.844015] RDX: 0000000000000008 RSI: 0000000000008000 RDI: ffff8800545eba20
[ 1741.844015] RBP: ffff880078cd7c28 R08: ffff880037a7ab38 R09: 6db6db6db6db6db7
[ 1741.844015] R10: 00000000ffffffff R11: ffff880079e1f480 R12: ffff880079e1f480
[ 1741.844015] R13: ffff880037a7ab38 R14: 0000000000000020 R15: ffff8800379d6000
[ 1741.844015] FS:  00007fc8b64cb700(0000) GS:ffff88007e400000(0000) knlGS:0000000000000000
[ 1741.844015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1741.844015] CR2: 00007fc8c45a0cf0 CR3: 00000000517af000 CR4: 00000000000006f0
[ 1741.844015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1741.844015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1741.844015] Process aio-stress (pid: 9220, threadinfo ffff880078cd6000, task ffff880066c24c40)
[ 1741.844015] Stack:
[ 1741.844015]  ffff88005d9a9780 ffff880079e1f480 ffff880078cd7c78 ffffffff815f284d
[ 1741.844015]  ffff88005d9a9780 ffff8800379db080 ffff880078cd7c78 ffff880079e1f480
[ 1741.844015]  ffff8800379db000 ffff880037a7ab38 ffff8800379db000 ffff8800379d6000
[ 1741.844015] Call Trace:
[ 1741.844015]  [<ffffffff815f284d>] scsi_init_io+0x3d/0x150
[ 1741.844015]  [<ffffffff815f29d9>] scsi_setup_fs_cmnd+0x79/0xe0
[ 1741.844015]  [<ffffffff81600947>] sd_prep_fn+0x157/0xe40
[ 1741.844015]  [<ffffffff8133aedc>] blk_peek_request+0xbc/0x240
[ 1741.844015]  [<ffffffff815f1f7b>] scsi_request_fn+0x5b/0x4e0
[ 1741.844015]  [<ffffffff813370bb>] queue_unplugged+0x4b/0xd0
[ 1741.844015]  [<ffffffff8133b4b5>] blk_flush_plug_list+0x1f5/0x280
[ 1741.844015]  [<ffffffff8133b558>] blk_finish_plug+0x18/0x50
[ 1741.844015]  [<ffffffff8118afe3>] do_io_submit+0x253/0x760
[ 1741.844015]  [<ffffffff8118b500>] sys_io_submit+0x10/0x20
[ 1741.844015]  [<ffffffff81a1d302>] system_call_fastpath+0x16/0x1b
[ 1741.844015] Code: 24 38 4c 89 e6 48 8b 13 e8 cf d0 d4 ff 3b 43 08 77 19 89 43 08 41 8b 44 24 54 89 43 10 31 c0 5b 41 5c c9 c3 b8 02 00 00 00 eb f4 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5
[ 1741.844015] RIP  [<ffffffff815f25ef>] scsi_init_sgtable+0x5f/0x70
[ 1741.844015]  RSP <ffff880078cd7c18>
[ 1742.146710] BUG: spinlock lockup on CPU#1, aio-stress/9205, ffff880037a7b1e0
[ 1742.146710] Pid: 9205, comm: aio-stress Tainted: G        W   3.1.0-rc9-default+ #63
[ 1742.146710] Call Trace:
[ 1742.146710]  [<ffffffff81362736>] do_raw_spin_lock+0xf6/0x150
[ 1742.146710]  [<ffffffff81a14106>] _raw_spin_lock+0x56/0x70
[ 1742.146710]  [<ffffffff8133b477>] ? blk_flush_plug_list+0x1b7/0x280
[ 1742.146710]  [<ffffffff8133b477>] blk_flush_plug_list+0x1b7/0x280
[ 1742.146710]  [<ffffffff8133b558>] blk_finish_plug+0x18/0x50
[ 1742.146710]  [<ffffffff8118afe3>] do_io_submit+0x253/0x760
[ 1742.146710]  [<ffffffff8118b500>] sys_io_submit+0x10/0x20
[ 1742.146710]  [<ffffffff81a1d302>] system_call_fastpath+0x16/0x1b
[ 1742.149745] BUG: spinlock lockup on CPU#0, btrfs-submit-0/9187, ffff880037a7b1e0
[ 1742.149745] Pid: 9187, comm: btrfs-submit-0 Tainted: G        W   3.1.0-rc9-default+ #63
[ 1742.149745] Call Trace:
[ 1742.149745]  [<ffffffff81362736>] do_raw_spin_lock+0xf6/0x150
[ 1742.149745]  [<ffffffff81a1486f>] ? _raw_spin_lock_irq+0x1f/0x80
[ 1742.149745]  [<ffffffff81a148b2>] _raw_spin_lock_irq+0x62/0x80
[ 1742.149745]  [<ffffffff8133b784>] ? __make_request+0x1f4/0x330
[ 1742.149745]  [<ffffffff8133b784>] __make_request+0x1f4/0x330
[ 1742.149745]  [<ffffffff8133778d>] generic_make_request+0x1cd/0x520
[ 1742.149745]  [<ffffffff81092952>] ? print_lock_contention_bug+0x22/0xf0
[ 1742.149745]  [<ffffffff81337b5a>] submit_bio+0x7a/0xf0
[ 1742.149745]  [<ffffffff8136283e>] ? do_raw_spin_unlock+0x5e/0xb0
[ 1742.149745]  [<ffffffffa005cc84>] run_scheduled_bios+0x264/0x550 [btrfs]
[ 1742.149745]  [<ffffffffa005cf85>] pending_bios_fn+0x15/0x20 [btrfs]
[ 1742.149745]  [<ffffffffa0063f54>] worker_loop+0xb4/0x500 [btrfs]
[ 1742.149745]  [<ffffffffa0063ea0>] ? btrfs_queue_worker+0x340/0x340 [btrfs]
[ 1742.149745]  [<ffffffff8107cf26>] kthread+0xa6/0xb0
[ 1742.149745]  [<ffffffff81a1e584>] kernel_thread_helper+0x4/0x10
[ 1742.149745]  [<ffffffff81a14eb4>] ? retint_restore_args+0x13/0x13
[ 1742.149745]  [<ffffffff8107ce80>] ? __init_kthread_worker+0x70/0x70
[ 1742.149745]  [<ffffffff81a1e580>] ? gs_change+0x13/0x13

