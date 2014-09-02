Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59260 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaIBJlc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 05:41:32 -0400
Received: by mail-wg0-f45.google.com with SMTP id k14so6485616wgh.4
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 02:41:31 -0700 (PDT)
MIME-Version: 1.0
From: Peter Waller <peter@scraperwiki.com>
Date: Tue, 2 Sep 2014 10:40:50 +0100
Message-ID: <CAFChkqvhMZzoxb7XuCOiWEcv+MKnkzZwL-JmYd_y8jUizM7ixA@mail.gmail.com>
Subject: Oops in release_extent_buffer
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Further to the old thread: "Machine lockup due to btrfs-transaction on
AWS EC2 Ubuntu 14.04":

http://thread.gmane.org/gmane.comp.file-systems.btrfs/37224

Since I have done a nightly rebalance and ensured plenty of
unallocated space, the main 3 btrfs machines have behaved themselves
for almost a month, except for two outages.

One of them had an oops during routine operation, which is reproduced
below. After this oops the BTRFS filesystem appeared to be blocked for
all subsequent FS operations leading to resource exhaustion and the
machine becoming unresponsive.

For now the machine seems stable after a reboot, with the exception of
on boot hundreds of messages of this form appearing, which I do not
take to be fatal.

> BTRFS error (device dm-0): free space inode generation (0) did not match free space cache generation (254928)

Please advise if this situation is likely to worsen and/or if any
remedial action can be taken.

Thanks,

- Peter

[954589.208141] ------------[ cut here ]------------
[954589.210906] kernel BUG at /home/apw/COD/linux/fs/btrfs/
extent_io.c:4334!
[954589.212057] invalid opcode: 0000 [#1] SMP
[954589.212057] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs
msdos jfs xfs libcrc32c tcp_diag inet_diag dm_crypt ppdev xen_fbfront
fb_sys_fops syscopyarea sysfillrect sysimgblt i2c_piix4 serio_raw
parport_pc parport isofs mac_hid softdog iptable_filter xt_owner
ip_tables x_tables btrfs xor raid6_pq crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd psmouse floppy
[954589.212057] CPU: 0 PID: 15811 Comm: python Not tainted
3.15.7-031507-generic #201407281235
[954589.212057] Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/23/2014
[954589.212057] task: ffff880009da9930 ti: ffff8800a8214000 task.ti:
ffff8800a8214000
[954589.212057] RIP: 0010:[<ffffffffa0110be3>]  [<ffffffffa0110be3>]
btrfs_release_extent_buffer_page.constprop.47+0xf3/0x100 [btrfs]
[954589.212057] RSP: 0018:ffff8800a82179d8  EFLAGS: 00010202
[954589.212057] RAX: 0000000000000001 RBX: ffff88013db9e140 RCX:
000000000000003b
[954589.212057] RDX: 0000000000000000 RSI: 0000000042de42dc RDI:
ffff88013db9e140
[954589.212057] RBP: ffff8800a82179f8 R08: ffff88006ed82910 R09:
ffff8800a82179b0
[954589.212057] R10: ffff88006ed82b10 R11: 0000000000000000 R12:
0000000000000005
[954589.212057] R13: ffff8801e44ff000 R14: ffff880043f45a00 R15:
ffff8800a8217af2
[954589.276098] FS:  00007f1eef4a3740(0000) GS:ffff8801efc00000(0000)
knlGS:0000000000000000
[954589.276098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[954589.276098] CR2: 00007f8ab166d000 CR3: 0000000195399000 CR4:
00000000001406f0
[954589.276098] Stack:
[954589.276098]  ffff88013db9e140 ffff8801e44ffd78 ffff8801e44ff000
ffff880043f45a00
[954589.276098]  ffff8800a8217a28 ffffffffa0110c59 ffff8800a8217a88
ffff88013db9e140
[954589.276098]  ffff88001dd48c60 ffff88001dd48c60 ffff8800a8217a48
ffffffffa0110d02
[954589.276098] Call Trace:
[954589.276098]  [<ffffffffa0110c59>] release_extent_buffer+0x69/0xe0 [btrfs]
[954589.276098]  [<ffffffffa0110d02>]
free_extent_buffer.part.39+0x32/0x90 [btrfs]
[954589.276098]  [<ffffffffa01111b5>] free_extent_buffer+0x35/0x40 [btrfs]
[954589.276098]  [<ffffffffa00c777a>] btrfs_release_path+0x2a/0xb0 [btrfs]
[954589.276098]  [<ffffffffa00e3f55>] btrfs_csum_file_blocks+0x495/0x6d0 [btrfs]
[954589.276098]  [<ffffffffa01111b5>] ? free_extent_buffer+0x35/0x40 [btrfs]
[954589.276098]  [<ffffffffa012b0bf>] log_one_extent.isra.22+0x3ef/0x690 [btrfs]
[954589.276098]  [<ffffffffa012b4e0>]
btrfs_log_changed_extents+0x180/0x200 [btrfs]
[954589.276098]  [<ffffffffa012dc61>] btrfs_log_inode+0x6a1/0x700 [btrfs]
[954589.276098]  [<ffffffffa00f4514>] ? btrfs_submit_bio_hook+0xb4/0x1d0 [btrfs]
[954589.276098]  [<ffffffff8177a6b6>] ? mutex_lock+0x16/0x37
[954589.276098]  [<ffffffffa012f062>] btrfs_log_inode_parent+0x122/0x300 [btrfs]
[954589.276098]  [<ffffffffa0130050>] btrfs_log_dentry_safe+0x50/0x80 [btrfs]
[954589.276098]  [<ffffffffa01009e5>] btrfs_sync_file+0x1b5/0x310 [btrfs]
[954589.276098]  [<ffffffff81202945>] do_fsync+0x55/0x80
[954589.276098]  [<ffffffff81202d10>] SyS_fsync+0x10/0x20
[954589.276098]  [<ffffffff817858bf>] tracesys+0xe1/0xe6
[954589.276098] Code: 49 8b 04 24 a8 10 75 27 49 8b 04 24 f6 c4 20 75
20 f0 41 80 64 24 01 f7 49 c7 44 24 30 00 00 00 00 4c 89 e7 e8 6f c3
05 e1 eb b6 <0f> 0b 0f 0b 0f 0b 0f 0b 0f 1f 44 00 00 0f 1f 44 00 00 55
48 89
[954589.276098] RIP  [<ffffffffa0110be3>]
btrfs_release_extent_buffer_page.constprop.47+0xf3/0x100 [btrfs]
[954589.276098]  RSP <ffff8800a82179d8>
[954589.373775] ---[ end trace 02f0d47f7b1de9c0 ]---
