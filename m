Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:35864 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753893AbdAKRN4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 12:13:56 -0500
Received: by mail-qt0-f180.google.com with SMTP id k15so431142211qtg.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Jan 2017 09:13:55 -0800 (PST)
MIME-Version: 1.0
From: Angel Shtilianov <angel.shtilianov@siteground.com>
Date: Wed, 11 Jan 2017 19:13:54 +0200
Message-ID: <CAJM9R-JcOgmzYZPMHqFFp8cXDgsyah6KaV5M80x=9NNZ3znhiw@mail.gmail.com>
Subject: btrfs: account_page_dirtied -> __percpu_counter_add kernel crash
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I am observing periodic crashes with signature below on kernel 4.4.26.
wb is extracted from page (see mm/page-writeback.c, void
account_page_dirtied() ):
                inode_attach_wb(inode, page);
                wb = inode_to_wb(inode);
We are crasing in
__inc_wb_stat(wb, WB_RECLAIMABLE), which calls __add_wb_stat(wb, item,
1), which then calls  __percpu_counter_add(&wb->stat[item], amount,
WB_STAT_BATCH);

So actually the lock is:
wb->stat[WB_RECLAIMABLE].lock

[6716239.938412] BUG: unable to handle kernel paging request at 0000000000015e9a
[6716239.938782] IP: [<ffffffff8109b785>] queued_spin_lock_slowpath+0xe5/0x160
[6716239.939076] PGD 16b070067 PUD 2cea00067 PMD 0
[6716239.939485] Oops: 0002 [#1] SMP
[6716239.939834] Modules linked in: xt_multiport dm_snapshot
dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio btrfs raid6_pq
xor loop iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat xt_CT iptable_raw nf_conntrack_ipv6 nf_defrag_ipv6
xt_state nf_conntrack ip6table_filter ip6_tables zfs(PO) zavl(PO)
zcommon(PO) znvpair(PO) spl(O) zunicode(PO) ext2 ib_umad sb_edac
edac_core i2c_i801 lpc_ich mfd_core shpchp ioatdma igb i2c_algo_bit
ses enclosure ipmi_devintf ipmi_si ipmi_msghandler tcp_scalable ib_qib
dca ib_mad ib_core ib_addr ipv6
[6716239.944558] CPU: 7 PID: 23338 Comm: btrfs Tainted: P        W  O
  4.4.26-clouder1 #3
[6716239.944950] Hardware name: Supermicro X10DRi/X10DRi, BIOS 1.1 04/14/2015
[6716239.945184] task: ffff88046cec6e00 ti: ffff8801a8f1c000 task.ti:
ffff8801a8f1c000
[6716239.945570] RIP: 0010:[<ffffffff8109b785>]  [<ffffffff8109b785>]
queued_spin_lock_slowpath+0xe5/0x160
[6716239.946025] RSP: 0018:ffff8801a8f1f9a8  EFLAGS: 00010006
[6716239.946253] RAX: 00000000000019bb RBX: ffff880466f363a0 RCX:
0000000000015e9a
[6716239.946639] RDX: ffff88047fcf5b00 RSI: 0000000000200000 RDI:
ffff880466f363a0
[6716239.947036] RBP: ffff8801a8f1f9a8 R08: 0000000000000001 R09:
0000000000000000
[6716239.947420] R10: ffff88026d966210 R11: 0000000000000000 R12:
0000000000000097
[6716239.947802] R13: 00000000fffffeff R14: ffff88017d5e1d68 R15:
ffff88047f881000
[6716239.952193] FS:  00007f99e3058880(0000) GS:ffff88047fce0000(0000)
knlGS:0000000000000000
[6716239.952582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[6716239.952810] CR2: 0000000000015e9a CR3: 000000032bd3a000 CR4:
00000000001406e0
[6716239.953190] Stack:
[6716239.953407]  ffff8801a8f1f9c8 ffffffff81614ed0 0000000000000102
ffff880466f363a0
[6716239.954038]  ffff8801a8f1f9f0 ffffffff8131d1b0 ffff880466f36340
00000000ffffffff
[6716239.954669]  ffffea000f44d640 ffff8801a8f1fa28 ffffffff811353a6
ffffea000f44d640
[6716239.955298] Call Trace:
[6716239.955521]  [<ffffffff81614ed0>] _raw_spin_lock_irqsave+0x40/0x50
[6716239.955753]  [<ffffffff8131d1b0>] __percpu_counter_add+0x40/0x70
[6716239.955982]  [<ffffffff811353a6>] account_page_dirtied+0xb6/0x1a0
[6716239.956209]  [<ffffffff81135511>] __set_page_dirty_nobuffers+0x81/0x140
[6716239.956458]  [<ffffffffa0685cbe>] btrfs_set_page_dirty+0xe/0x10 [btrfs]
[6716239.956690]  [<ffffffff8113455d>] set_page_dirty+0x3d/0x60
[6716239.956928]  [<ffffffffa0696dc9>] btrfs_dirty_pages+0x79/0xa0 [btrfs]
[6716239.957184]  [<ffffffffa06c7c5b>]
__btrfs_write_out_cache.isra.23+0x37b/0x420 [btrfs]
[6716239.957577]  [<ffffffffa06c886a>] btrfs_write_out_cache+0x8a/0xf0 [btrfs]
[6716239.957816]  [<ffffffffa067322d>]
btrfs_start_dirty_block_groups+0x1ed/0x3f0 [btrfs]
[6716239.958210]  [<ffffffffa068415e>]
btrfs_commit_transaction+0x14e/0xa60 [btrfs]
[6716239.958602]  [<ffffffffa0684b0a>] ? start_transaction+0x9a/0x4e0 [btrfs]
[6716239.958842]  [<ffffffffa06b8a9e>] btrfs_mksubvol+0x4ce/0x4e0 [btrfs]
[6716239.959070]  [<ffffffff81094580>] ? wait_woken+0xb0/0xb0
[6716239.959304]  [<ffffffffa06b8c3f>]
btrfs_ioctl_snap_create_transid+0x18f/0x1a0 [btrfs]
[6716239.959707]  [<ffffffffa06b8de7>]
btrfs_ioctl_snap_create_v2+0x107/0x170 [btrfs]
[6716239.960102]  [<ffffffffa06bd5ca>] btrfs_ioctl+0x171a/0x2710 [btrfs]
[6716239.960330]  [<ffffffff8115a252>] ? handle_mm_fault+0xca2/0x19c0
[6716239.960557]  [<ffffffff811ac6bf>] do_vfs_ioctl+0x30f/0x560
[6716239.960786]  [<ffffffff811ac989>] SyS_ioctl+0x79/0x90
[6716239.961012]  [<ffffffff8161531b>] entry_SYSCALL_64_fastpath+0x16/0x6e
[6716239.961238] Code: 87 47 02 c1 e0 10 85 c0 74 3d 48 89 c1 c1 e8 12
48 c1 e9 0c 83 e8 01 83 e1 30 48 98 48 81 c1 00 5b 01 00 48 03 0c c5
40 d4 cd 81 <48> 89 11 8b 42 08 85 c0 75 12 f3 90 8b 42 08 85 c0 74 f7
8b 0f
[6716239.965810] RIP  [<ffffffff8109b785>] queued_spin_lock_slowpath+0xe5/0x160
[6716239.966100]  RSP <ffff8801a8f1f9a8>
[6716239.966319] CR2: 0000000000015e9a

Has someone seen something like that ?

Best regards,
Angel
