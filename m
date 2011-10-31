From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 07/66] btrfs: clear_extent_bit error push-up [other BUG hit]
Date: Mon, 31 Oct 2011 16:41:39 +0100
Message-ID: <20111031154139.GF19328@twin.jikos.cz>
References: <20111025010236.322699279@suse.com> <20111025010851.368992601@suse.com> <20111026151024.GB5914@twin.jikos.cz> <4EA824D2.6070801@suse.com> <20111027120049.GA19328@twin.jikos.cz> <20111031150754.GE19328@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jeff Mahoney <jeffm@suse.com>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111031150754.GE19328@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

[18300.906594] ------------[ cut here ]------------
[18300.910518] kernel BUG at fs/btrfs/inode.c:1592!
[18300.910518] invalid opcode: 0000 [#1] SMP
[18300.910518] CPU 1
[18300.910518] Modules linked in: btrfs loop aoe [last unloaded: btrfs]
[18300.910518]
[18300.910518] Pid: 1853, comm: btrfs-fixup-0 Tainted: G        W   3.1.0-rc9-default+ #63 Intel Corporation Santa Rosa platform/Matanzas
[18300.910518] RIP: 0010:[<ffffffffa017a8f2>]  [<ffffffffa017a8f2>] btrfs_writepage_fixup_worker+0x152/0x160 [btrfs]
[18300.910518] RSP: 0018:ffff880000095da0  EFLAGS: 00010246
[18300.910518] RAX: 0000000000000000 RBX: ffff88007d8894f8 RCX: ffff880075e3a928
[18300.910518] RDX: 0000000000005958 RSI: 0000000000000001 RDI: ffff8800431fbad8
[18300.910518] RBP: ffff880000095df0 R08: 0000000000000000 R09: 0000000000000000
[18300.910518] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000306000
[18300.910518] R13: ffff8800431fbbe8 R14: 0000000000000000 R15: 0000000000306fff
[18300.910518] FS:  0000000000000000(0000) GS:ffff88007e600000(0000) knlGS:0000000000000000
[18300.910518] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[18300.910518] CR2: 00007fe2024f9000 CR3: 0000000064037000 CR4: 00000000000006e0
[18300.910518] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18300.910518] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18300.910518] Process btrfs-fixup-0 (pid: 1853, threadinfo ffff880000094000, task ffff88000e3f4d80)
[18300.910518] Stack:
[18300.910518]  ffff88007947fbc0 ffff8800431fb8b0 ffff88007940b190 ffff8800689b7c38
[18300.910518]  ffff880000095dd0 ffff88007940b140 ffff88007947fbf0 ffff88007940b158
[18300.910518]  ffff880000095e40 ffff88007940b190 ffff880000095ea0 ffffffffa01a1e34
[18300.910518] Call Trace:
[18300.910518]  [<ffffffffa01a1e34>] worker_loop+0xb4/0x520 [btrfs]
[18300.910518]  [<ffffffffa01a1d80>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[18300.910518]  [<ffffffff8107cf26>] kthread+0xa6/0xb0
[18300.910518]  [<ffffffff81a1e584>] kernel_thread_helper+0x4/0x10
[18300.910518]  [<ffffffff81a146e0>] ? _raw_spin_unlock_irq+0x30/0x40
[18300.910518]  [<ffffffff81097c7d>] ? trace_hardirqs_on+0xd/0x10
[18300.910518]  [<ffffffff81a14eb4>] ? retint_restore_args+0x13/0x13
[18300.910518]  [<ffffffff8107ce80>] ? __init_kthread_worker+0x70/0x70
[18300.910518]  [<ffffffff81a1e580>] ? gs_change+0x13/0x13
[18300.910518] Code: 00 48 8b 7d b8 48 8d 4d c8 41 b8 50 00 00 00 4c 89 fa 4c 89 e6 e8 6f a3 01 00 eb b6 0f 0b 48 89 df e8 b3 dd f7 e0 0f 1f 00 eb 95 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41
[18300.910518] RIP  [<ffffffffa017a8f2>] btrfs_writepage_fixup_worker+0x152/0x160 [btrfs]
[18300.910518]  RSP <ffff880000095da0>
[18301.262194] ---[ end trace de089b9ceb00d1b9 ]---

1583         ordered = btrfs_lookup_ordered_extent(inode, page_start);
1584         if (ordered) {
1585                 unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start,
1586                                      page_end, &cached_state, GFP_NOFS);
1587                 unlock_page(page);
1588                 btrfs_start_ordered_extent(inode, ordered, 1);
1589                 goto again;
1590         }
1591
1592         BUG();

1593         ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
1594                                         &cached_state);
1595         BUG_ON(ret < 0);
1596         ClearPageChecked(page);
1597 out:
1598         unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
1599                              &cached_state, GFP_NOFS);
1600 out_page:
1601         unlock_page(page);
1602         page_cache_release(page);
1603         kfree(fixup);
1604 }


during xfstests/209 (and 10 seconds after I sent the previous mail of course).


david
