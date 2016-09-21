Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36237 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbcIUJxw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 05:53:52 -0400
Received: by mail-oi0-f42.google.com with SMTP id t83so53574779oie.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 02:53:51 -0700 (PDT)
MIME-Version: 1.0
From: Mark Gavalda <markgavalda@kinsta.com>
Date: Wed, 21 Sep 2016 11:53:50 +0200
Message-ID: <CAAwVk4k91Q91jTJoGHPNSjtDruGQ4qHSa-srB2xRWMvmQ=bTBQ@mail.gmail.com>
Subject: kernel BUG at /build/linux-a2WvEb/linux-4.4.0/fs/btrfs/inode.c:3258
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Just bumped into this, let me know if you need more info:

[160997.651655] ------------[ cut here ]------------
[160997.656497] kernel BUG at
/build/linux-a2WvEb/linux-4.4.0/fs/btrfs/inode.c:3258!
[160997.664083] invalid opcode: 0000 [#1] SMP
[160997.668604] Modules linked in: ufs msdos xfs xt_recent xt_nat
xt_multiport ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 xt_limit
xt_addrtype xt_conntrack binfmt_misc veth xt_CHECKSUM iptable_mangle
xt_tcpudp ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_comment iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables
x_tables ppdev parport_pc parport pvpanic serio_raw ib_iser rdma_cm
iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi autofs4 btrfs raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 multipath linear crct10dif_pclmul
crc32_pclmul aesni_intel aes_x86_64
[160997.748543]  lrw gf128mul glue_helper ablk_helper cryptd psmouse virtio_scsi
[160997.755223] CPU: 7 PID: 395996 Comm: fail2ban-server Not tainted
4.4.0-36-generic #55-Ubuntu
[160997.763848] Hardware name: Google Google Compute Engine/Google
Compute Engine, BIOS Google 01/01/2011
[160997.773273] task: ffff880d4f73ee00 ti: ffff880417b0c000 task.ti:
ffff880417b0c000
[160997.780946] RIP: 0010:[<ffffffffc0186b4d>]  [<ffffffffc0186b4d>]
btrfs_orphan_add+0x10d/0x1e0 [btrfs]
[160997.790504] RSP: 0018:ffff880417b0fe08  EFLAGS: 00010286
[160997.796010] RAX: 00000000ffffffe4 RBX: ffff88025bd43000 RCX:
00000000ffffffe4
[160997.803332] RDX: 0000000000000001 RSI: 0000000000040000 RDI:
ffff880dfeba0200
[160997.810653] RBP: ffff880417b0fe38 R08: 0000000000000000 R09:
0000000000000001
[160997.817975] R10: ffffea0015749880 R11: 0000000000000000 R12:
ffff880771fe9150
[160997.825313] R13: ffff88025bd433f8 R14: ffff8807b42ff720 R15:
0000000000000001
[160997.832637] FS:  00007f20bf3ad700(0000) GS:ffff880e073c0000(0000)
knlGS:0000000000000000
[160997.840915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[160997.846847] CR2: 00007fff016e8de8 CR3: 0000000cfaec1000 CR4:
00000000001406e0
[160997.854173] Stack:
[160997.856391]  ffff880700000001 0000000000000000 ffff8807b42ff720
ffff88025bd43000
[160997.864475]  ffff880771fe9150 ffff88070d5ea4d8 ffff880417b0fe70
ffffffffc018afb4
[160997.872607]  ffff880d89a0c900 ffff88070d5ea4d8 ffff880771fe9150
ffff880417b0fee0
[160997.880666] Call Trace:
[160997.883339]  [<ffffffffc018afb4>] btrfs_unlink+0xa4/0xb0 [btrfs]
[160997.889544]  [<ffffffff8121a151>] vfs_unlink+0xf1/0x1a0
[160997.894960]  [<ffffffff8138d1eb>] ? apparmor_path_unlink+0x1b/0x20
[160997.901339]  [<ffffffff8121d749>] do_unlinkat+0x279/0x2d0
[160997.906928]  [<ffffffff8121e206>] SyS_unlink+0x16/0x20
[160997.912263]  [<ffffffff8182dfb2>] entry_SYSCALL_64_fastpath+0x16/0x71
[160997.918891] Code: 41 5e 41 5f 5d c3 31 d2 eb 84 45 31 ff eb 92 49
8b 54 24 40 eb b7 4c 89 e6 4c 89 f7 89 55 d0 e8 0a fe fd ff 85 c0 8b
55 d0 74 85 <0f> 0b be 07 00 00 00 48 89 df e8 84 fa fd ff 48 85 c0 0f
84 b0
[160997.945676] RIP  [<ffffffffc0186b4d>] btrfs_orphan_add+0x10d/0x1e0 [btrfs]
[160997.952947]  RSP <ffff880417b0fe08>
[160997.957719] ---[ end trace 1aeb484018da7058 ]---

Thanks,
Mark
