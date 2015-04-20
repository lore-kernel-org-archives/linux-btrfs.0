Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32868 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbDTVNG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 17:13:06 -0400
Received: by wiax7 with SMTP id x7so92978964wia.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2015 14:13:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 Apr 2015 22:13:04 +0100
Message-ID: <CAO+szGt_U9PU_Z746O8gj5wYvu-Xw4A6rWNtVFfF9o+wh9_WbA@mail.gmail.com>
Subject: Kernel BUG at fs/btrfs/ctree.c:3163
From: Francis McBratney <fmcbra@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

Reporting this here too as per the "How do I report bugs and issues?"
section on the wiki.

I managed to trigger the following BUG_ON() whilst running 'apt purge':-

[   85.635305] kernel BUG at fs/btrfs/ctree.c:3163!
[   85.635350] invalid opcode: 0000 [#1] SMP
[   85.635398] Modules linked in: nf_nat_irc nf_nat_ftp
nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat xt_NFLOG
xt_limit xt_helper xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack iptable_filter ip_tables x_tables
nfnetlink_log nfnetlink bridge stp llc dummy crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
glue_helper lrw gf128mul ablk_helper cryptd psmouse serio_raw
virtio_rng rng_core autofs4
[   85.635717] CPU: 0 PID: 1365 Comm: apt Not tainted 3.19.5-dt1 #1
[   85.635795] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.7.5.1-0-g8936dbb-20141113_115728-nilsson.home.kraxel.org
04/01/2014
[   85.635897] task: ffff88002c607530 ti: ffff880028240000 task.ti:
ffff880028240000
[   85.635952] RIP: 0010:[<ffffffff812552e1>]  [<ffffffff812552e1>]
btrfs_set_item_key_safe+0x171/0x180
[   85.636021] RSP: 0018:ffff880028243a28  EFLAGS: 00010246
[   85.636071] RAX: 0000000000000000 RBX: ffff88002b291920 RCX: 00000000001a0000
[   85.636129] RDX: 0000000000000000 RSI: ffff880028243b4e RDI: ffff880028243a47
[   85.636189] RBP: ffff880028243a36 R08: ffff88002b04f858 R09: ffff880000000000
[   85.636244] R10: 0000160000000000 R11: 0000000000001000 R12: ffff880028202000
[   85.636297] R13: 000000000000004f R14: ffff88002b04f7b8 R15: ffff880028243b4e
[   85.636349] FS:  00007fb76c086740(0000) GS:ffff88002fc00000(0000)
knlGS:0000000000000000
[   85.636407] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   85.636455] CR2: 00007fb769471594 CR3: 0000000028344000 CR4: 00000000001406f0
[   85.636511] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   85.636564] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   85.636603] Stack:
[   85.636642]  ffff88002800e8c0 39ca880028202000 006c00000000000b
ca00000000001a00
[   85.636699]  6c00000000000b39 00000000001a0000 0000000000001000
ffff88002b04f7b8
[   85.636757]  ffff88002b291920 000000000019e000 00000000001a0000
0000000001800000
[   85.636844] Call Trace:
[   85.636867]  [<ffffffff8128efb1>] ? __btrfs_drop_extents+0xbe1/0xdb0
[   85.636867]  [<ffffffff8112782e>] ? set_page_dirty+0xe/0x60
[   85.636867]  [<ffffffff812b56a4>] ? btrfs_log_changed_extents+0x284/0x5c0
[   85.636867]  [<ffffffff812590c2>] ? btrfs_insert_empty_items+0x72/0xc0
[   85.636867]  [<ffffffff812ba08d>] ? btrfs_log_inode+0x78d/0x810
[   85.636867]  [<ffffffff812ba3a9>] ? btrfs_log_inode_parent+0x1f9/0x570
[   85.636867]  [<ffffffff811801e5>] ? __sb_start_write+0x45/0xe0
[   85.636867]  [<ffffffff812bb5eb>] ? btrfs_log_dentry_safe+0x5b/0x80
[   85.636867]  [<ffffffff81290b73>] ? btrfs_sync_file+0x1d3/0x310
[   85.636867]  [<ffffffff8115365e>] ? SyS_msync+0x1fe/0x260
[   85.636867]  [<ffffffff8165988d>] ? system_call_fastpath+0x16/0x1b
[   85.636867] Code: 7c 24 1f 4c 89 fe 48 89 44 24 28 0f b6 44 24 16
88 44 24 27 48 8b 44 24 0e 48 89 44 24 1f e8 07 f3 ff ff 85 c0 0f 8f
41 ff ff ff <0f> 0b 0f 1f 44 00 00 0f 0b 66 0f 1f 44 00 00 0f 1f 44 00
00 41 00 0f 0b 66 0f 1f 44 00 00 0f 1f 44 00 00 41
[   85.636867] RIP  [<ffffffff812552e1>] btrfs_set_item_key_safe+0x171/0x180
[   85.636867]  RSP <ffff880028243a28>
[   85.637872] ---[ end trace 409d47a41cf477bf ]---

A few seconds later the system froze.  A single corrupt, temporary
file was left behind according to a manual btrfsck run, which I
zapped.  I've tried to reproduce but can't, and a very quick scan of
Google returns a single match, so this may be hard to hit.

Note: this is vanilla 3.19.5 running on a KVM guest.

And just in case it's helpful:

(#) root@apple:~
>>> mount |grep vda3
/dev/vda3 on / type btrfs (rw,nodiratime,relatime,compress=lzo,space_cache)

--
Best,
Francis
