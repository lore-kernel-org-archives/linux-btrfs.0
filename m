From: Thierry Noret <tnoret@yahoo.fr>
Subject: kernel BUG at fs/btrfs/tree-log.c:820!
Date: Sun, 05 Jun 2011 20:34:32 +0200
Message-ID: <4DEBCC38.30007@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Since my computer has switch off with hard reset, I can't mount my home 
directory.
/ is btrfs too and there is no problem
Kernel-2.6.38-R6
I've try with 2.6.39 and same problem

Thanks

T.Noret

------------[ cut here ]------------
kernel BUG at fs/btrfs/tree-log.c:820!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1/alignment_offset
CPU 7
Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek fglrx(P) 
snd_hda_intel snd_hda_codec ath9k ath9k_common xhci_hcd ath9k_hw 
uvcvideo videodev i2c_i801 i7core_edac v4l2_compat_ioctl32 asus_laptop 
atl1c snd_hwdep snd_pcm snd_timer snd snd_page_alloc ath sparse_keymap
Pid: 1821, comm: mount Tainted: P            2.6.38-gentoo-r6 #1 ASUSTeK 
Computer Inc.         N61Jq/N61Jq
RIP: 0010:[<ffffffff8120726f>]  [<ffffffff8120726f>] 
add_inode_ref+0x4af/0x4c0
RSP: 0018:ffff88013d86d8e8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 00000000fffb9a44
RDX: ffffffff81660240 RSI: ffffffff811d3540 RDI: ffff88013ccc25a0
RBP: 0000000000000097 R08: fea53429e2fd5403 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88013d86db88
R13: ffff88013fbe7ee0 R14: 0000000000000009 R15: ffff88013d86da08
FS:  00007fee197f1740(0000) GS:ffff8800bb3c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007feb06b2a0f0 CR3: 000000013da18000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 1821, threadinfo ffff88013d86c000, task 
ffff88013d01f580)
Stack:
ffff88013d86d8e8 000000003d86d8e8 ffffffff811cb0f0 0000000000000000
ffff88013e7af800 ffff88013f893090 ffff88013e7ae800 ffff88013fbe7ee0
0000000000000000 ffff88013ccc28f8 ffff88013f930810 ffff88013fbe7ee0
Call Trace:
[<ffffffff811cb0f0>] ? btree_get_extent+0x0/0x1c0
[<ffffffff811f7303>] ? read_extent_buffer+0xc3/0x1d0
[<ffffffff81209340>] ? replay_one_buffer+0x2d0/0x3a0
[<ffffffff8120824d>] ? walk_down_log_tree+0x37d/0x530
[<ffffffff81208503>] ? walk_log_tree+0x103/0x280
[<ffffffff8120b218>] ? btrfs_recover_log_trees+0x228/0x310
[<ffffffff81209070>] ? replay_one_buffer+0x0/0x3a0
[<ffffffff811cf554>] ? open_ctree+0x1254/0x15e0
[<ffffffff8127ac86>] ? vsnprintf+0x496/0x650
[<ffffffff811ac810>] ? btrfs_set_super+0x0/0x20
[<ffffffff811accfe>] ? btrfs_mount+0x38e/0x4d0
[<ffffffff810e704e>] ? vfs_kern_mount+0x6e/0x1d0
[<ffffffff811001ee>] ? get_fs_type+0x3e/0xd0
[<ffffffff810e7223>] ? do_kern_mount+0x53/0x120
[<ffffffff81103746>] ? do_mount+0x456/0x820
[<ffffffff810bea8f>] ? memdup_user+0x3f/0x80
[<ffffffff81103eca>] ? sys_mount+0x9a/0xf0
[<ffffffff81002dfb>] ? system_call_fastpath+0x16/0x1b
Code: b8 67 ef ff 48 8b 7c 24 68 e8 ae 67 ef ff 31 c0 48 81 c4 98 00 00 
00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 b8 fe ff ff ff eb e7 0f 0b <0f> 0b 
0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 1f 44 00 00 41 57 41 56
RIP  [<ffffffff8120726f>] add_inode_ref+0x4af/0x4c0
RSP <ffff88013d86d8e8>
---[ end trace a525b4b72005f64a ]---

