Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36805 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757271AbcIOOIC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 10:08:02 -0400
Received: by mail-oi0-f48.google.com with SMTP id q188so70368610oia.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 07:08:02 -0700 (PDT)
MIME-Version: 1.0
From: Mark Gavalda <markgavalda@kinsta.com>
Date: Thu, 15 Sep 2016 16:08:00 +0200
Message-ID: <CAAwVk4ny29d5qEAEvv=ydGN9DudUpWDQxzusmW1FpdBpLeVDYA@mail.gmail.com>
Subject: unable to handle kernel paging request
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Bumped into the following one today; kernel 4.4.0-36-generic Ubuntu
16.4.1; CPU went to 100% and only a hard restart solved the issue.
Since then everything's back to normal.

Please let me know how can I help get to the bottom of this?

[239049.350514] BUG: unable to handle kernel paging request at 00000000d3c53de8
[239049.358107] IP: [<ffffffff810eecf9>] hrtimer_active+0x9/0x60
[239049.364127] PGD a688df067 PUD 0
[239049.367828] Oops: 0000 [#2] SMP
[239049.371543] Modules linked in: xt_recent xt_nat xt_multiport
ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt nf_conntrack_ipv6
nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 xt_limit xt_addrtype
xt_conntrack binfmt_misc veth xt_CHECKSUM iptable_mangle xt_tcpudp
ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_comment iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables
x_tables ppdev parport_pc parport serio_raw pvpanic ib_iser rdma_cm
iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi autofs4 btrfs raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 multipath linear crct10dif_pclmul
crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd psmouse virtio_scsi
[239049.457553] CPU: 24 PID: 1298718 Comm: kworker/u64:24 Tainted: G
   D         4.4.0-36-generic #55-Ubuntu
[239049.467497] Hardware name: Google Google/Google, BIOS Google 01/01/2011
[239049.474348] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[239049.481472] task: ffff8801512dee00 ti: ffff8801fd1c8000 task.ti:
ffff8801fd1c8000
[239049.489205] RIP: 0010:[<ffffffff810eecf9>]  [<ffffffff810eecf9>]
hrtimer_active+0x9/0x60
[239049.497702] RSP: 0018:ffff8801fd1cbc20  EFLAGS: 00010046
[239049.503230] RAX: 0000000000000000 RBX: 00000000d3c53db8 RCX:
0000000000000000
[239049.510569] RDX: 0000000000000000 RSI: 0000000000000003 RDI:
00000000d3c53db8
[239049.517910] RBP: ffff8801fd1cbc20 R08: ffff88336f416d00 R09:
ffff88333fe57e00
[239049.525250] R10: 00000000000000a0 R11: 0000000001b5675f R12:
ffff8807024cb628
[239049.532595] R13: ffff8802d5e5bd98 R14: 0000000000000000 R15:
0000000000000003
[239049.539938] FS:  0000000000000000(0000) GS:ffff88336f400000(0000)
knlGS:0000000000000000
[239049.548246] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[239049.554234] CR2: 00000000d3c53de8 CR3: 0000000a5e8a1000 CR4:
00000000001406e0
[239049.561576] Stack:
[239049.563812]  ffff8801fd1cbc58 ffffffff810ef249 0000000000000003
00000000d3b71a0d
[239049.571936]  00000000d3c53db8 ffff8807024cb628 ffff8802d5e5bd98
ffff8801fd1cbca8
[239049.580141]  ffffffff8182d3c1 ffffffff810c35f2 0000000100000001
0000000000000000
[239049.588300] Call Trace:
[239049.590976]  [<ffffffff810ef249>] hrtimer_try_to_cancel+0x29/0x130
[239049.597384]  [<ffffffff8182d3c1>] schedule_hrtimeout_range_clock+0xd1/0x1b0
[239049.604571]  [<ffffffff810c35f2>] ? __wake_up_common+0x52/0x90
[239049.610619]  [<ffffffff810c3669>] __wake_up+0x39/0x50
[239049.615906]  [<ffffffffc02ce324>]
btrfs_remove_ordered_extent+0x154/0x250 [btrfs]
[239049.623620]  [<ffffffffc02bc040>]
btrfs_finish_ordered_io+0x1d0/0x650 [btrfs]
[239049.630993]  [<ffffffffc02bc785>] finish_ordered_fn+0x15/0x20 [btrfs]
[239049.637666]  [<ffffffffc02e4eba>]
btrfs_scrubparity_helper+0xca/0x2f0 [btrfs]
[239049.645042]  [<ffffffffc02e516e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[239049.652239]  [<ffffffff8109a2c5>] process_one_work+0x165/0x480
[239049.658293]  [<ffffffff8109a62b>] worker_thread+0x4b/0x4c0
[239049.663984]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[239049.670196]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[239049.676420]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[239049.681514]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[239049.688260]  [<ffffffff8182e34f>] ret_from_fork+0x3f/0x70
[239049.693870]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[239049.700599] Code: 00 00 0f 1f 44 00 00 55 48 c7 47 28 10 f0 0e 81
48 89 77 58 48 89 e5 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
55 48 89 e5 <48> 8b 57 30 eb 1d 80 7f 38 00 75 32 48 3b 78 08 74 2c 39
50 04
[239049.727797] RIP  [<ffffffff810eecf9>] hrtimer_active+0x9/0x60
[239049.733868]  RSP <ffff8801fd1cbc20>
[239049.737557] CR2: 00000000d3c53de8
[239049.741535] ---[ end trace 774da4af66731bb5 ]---

Thanks,
Mark Gavalda
