Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51604 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbaIJSRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 14:17:13 -0400
Message-ID: <54109045.8030108@urbackup.org>
Date: Wed, 10 Sep 2014 19:54:13 +0200
From: Martin Raiber <martin@urbackup.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Kernel BUG at fs/btrfs/extent-tree.c:7624 in cleaner thread
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this looks like http://www.spinics.net/lists/linux-btrfs/msg26774.html
which seems to be fixed, but it occurs on the latest stable kernel for
me (3.16.2):

[    3.648344] BTRFS info (device xvda3): metadata ratio 4
[    3.648350] BTRFS info (device xvda3): not using ssd allocation scheme
[    3.648353] BTRFS info (device xvda3): disk space caching is enabled
[   30.496630] EXT4-fs (xvda4): 2 orphan inodes deleted
[   30.496646] EXT4-fs (xvda4): recovery complete
[   30.595941] EXT4-fs (xvda4): mounted filesystem with ordered data
mode. Opts: (null)
[   31.299071] EXT4-fs (xvda5): recovery complete
[   31.431705] EXT4-fs (xvda5): mounted filesystem with ordered data
mode. Opts: (null)
[   63.830053] ------------[ cut here ]------------
[   63.830074] WARNING: CPU: 0 PID: 1181 at fs/btrfs/extent-tree.c:876
btrfs_lookup_extent_info+0x488/0x4b0 [btrfs]()
[   63.830086] Modules linked in: evdev snd_pcm snd_timer snd
x86_pkg_temp_thermal thermal_sys intel_rapl soundcore coretemp
crct10dif_pclmul crct10dif_common pcspkr crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd ext4 crc16 mbcache jbd2 btrfs xor raid6_pq
xen_netfront xen_blkfront crc32c_intel
[   63.830110] CPU: 0 PID: 1181 Comm: btrfs-cleaner Not tainted
3.16.2custom #1
[   63.830113]  0000000000000000 0000000000000009 ffffffff81508739
0000000000000000
[   63.830116]  ffffffff810675f6 ffff8800ba353ec0 ffff8800b62d6000
00000004996f4000
[   63.830120]  ffff8800b5b97f20 0000000000000000 ffffffffa00855e8
ffffea0002316848
[   63.830124] Call Trace:
[   63.830130]  [<ffffffff81508739>] ? dump_stack+0x41/0x51
[   63.830135]  [<ffffffff810675f6>] ? warn_slowpath_common+0x86/0xb0
[   63.830142]  [<ffffffffa00855e8>] ?
btrfs_lookup_extent_info+0x488/0x4b0 [btrfs]
[   63.830150]  [<ffffffffa008843e>] ? do_walk_down+0x13e/0x580 [btrfs]
[   63.830155]  [<ffffffff811857fc>] ? kmem_cache_free+0xec/0x220
[   63.830162]  [<ffffffffa0086098>] ? walk_down_proc+0x2b8/0x2e0 [btrfs]
[   63.830168]  [<ffffffffa00854bb>] ?
btrfs_lookup_extent_info+0x35b/0x4b0 [btrfs]
[   63.830176]  [<ffffffffa0088952>] ? walk_down_tree+0xd2/0x110 [btrfs]
[   63.830180]  [<ffffffff812a9812>] ? radix_tree_gang_lookup+0x82/0xb0
[   63.830187]  [<ffffffffa008c141>] ? btrfs_drop_snapshot+0x3b1/0x770
[btrfs]
[   63.830195]  [<ffffffffa00f25cf>] ?
btrfs_kill_all_delayed_nodes+0x4f/0xf0 [btrfs]
[   63.830204]  [<ffffffffa009f959>] ?
btrfs_clean_one_deleted_snapshot+0xb9/0x110 [btrfs]
[   63.830211]  [<ffffffffa0095e90>] ? cleaner_kthread+0x120/0x180 [btrfs]
[   63.830218]  [<ffffffffa0095d70>] ?
__btree_submit_bio_start+0x10/0x10 [btrfs]
[   63.830223]  [<ffffffff810888dc>] ? kthread+0xbc/0xe0
[   63.830226]  [<ffffffff81088820>] ? flush_kthread_worker+0x80/0x80
[   63.830229]  [<ffffffff8150e4fc>] ? ret_from_fork+0x7c/0xb0
[   63.830233]  [<ffffffff81088820>] ? flush_kthread_worker+0x80/0x80
[   63.830235] ---[ end trace ab9a705f0e035cf6 ]---
[   63.830240] BTRFS error (device xvda3): Missing references.
[   63.830251] ------------[ cut here ]------------
[   63.830253] kernel BUG at fs/btrfs/extent-tree.c:7624!
[   63.830255] invalid opcode: 0000 [#1] SMP
[   63.830257] Modules linked in: evdev snd_pcm snd_timer snd
x86_pkg_temp_thermal thermal_sys intel_rapl soundcore coretemp
crct10dif_pclmul crct10dif_common pcspkr crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper
ablk_helper cryptd ext4 crc16 mbcache jbd2 btrfs xor raid6_pq
xen_netfront xen_blkfront crc32c_intel
[   63.830274] CPU: 0 PID: 1181 Comm: btrfs-cleaner Tainted: G       
W     3.16.2custom #1
[   63.830277] task: ffff8800b62a9530 ti: ffff8800b6ccc000 task.ti:
ffff8800b6ccc000
[   63.830279] RIP: e030:[<ffffffffa008886d>]  [<ffffffffa008886d>]
do_walk_down+0x56d/0x580 [btrfs]
[   63.830286] RSP: e02b:ffff8800b6ccfcb8  EFLAGS: 00010292
[   63.830288] RAX: 000000000000002f RBX: ffff8800040921c0 RCX:
0000000000000006
[   63.830290] RDX: 0000000000000007 RSI: 0000000000000000 RDI:
0000000000000200
[   63.830293] RBP: ffff8800ba353920 R08: 0000000000000000 R09:
00000000000000fd
[   63.830295] R10: 000000000000472a R11: 00000000000000fc R12:
ffff8800a110e2e0
[   63.830297] R13: 0000000000000002 R14: ffff8800b62d6000 R15:
0000000000000002
[   63.830303] FS:  00007fc6b37c7880(0000) GS:ffff8800bdc00000(0000)
knlGS:0000000000000000
[   63.830305] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[   63.830307] CR2: 00007fc6b37e3000 CR3: 00000000b60da000 CR4:
0000000000042660
[   63.830310] Stack:
[   63.830311]  ffff880004092208 ffff8800b6ccfd76 0000000000000000
ffffffff811857fc
[   63.830314]  0000000000000001 0000000000000009 00000001a066e000
00000004996f4000
[   63.830318]  ffff8800b6ccfd94 0000000000051a9d ffff8800b5b97f20
0000000100001000
[   63.830321] Call Trace:
[   63.830323]  [<ffffffff811857fc>] ? kmem_cache_free+0xec/0x220
[   63.830329]  [<ffffffffa0086098>] ? walk_down_proc+0x2b8/0x2e0 [btrfs]
[   63.830335]  [<ffffffffa00854bb>] ?
btrfs_lookup_extent_info+0x35b/0x4b0 [btrfs]
[   63.830341]  [<ffffffffa0088952>] ? walk_down_tree+0xd2/0x110 [btrfs]
[   63.830344]  [<ffffffff812a9812>] ? radix_tree_gang_lookup+0x82/0xb0
[   63.830350]  [<ffffffffa008c141>] ? btrfs_drop_snapshot+0x3b1/0x770
[btrfs]
[   63.830356]  [<ffffffffa00f25cf>] ?
btrfs_kill_all_delayed_nodes+0x4f/0xf0 [btrfs]
[   63.830363]  [<ffffffffa009f959>] ?
btrfs_clean_one_deleted_snapshot+0xb9/0x110 [btrfs]
[   63.830370]  [<ffffffffa0095e90>] ? cleaner_kthread+0x120/0x180 [btrfs]
[   63.830375]  [<ffffffffa0095d70>] ?
__btree_submit_bio_start+0x10/0x10 [btrfs]
[   63.830378]  [<ffffffff810888dc>] ? kthread+0xbc/0xe0
[   63.830381]  [<ffffffff81088820>] ? flush_kthread_worker+0x80/0x80
[   63.830384]  [<ffffffff8150e4fc>] ? ret_from_fork+0x7c/0xb0
[   63.830386]  [<ffffffff81088820>] ? flush_kthread_worker+0x80/0x80
[   63.830388] Code: 01 0f 85 51 fe ff ff e9 64 fd ff ff b8 f4 ff ff ff
e9 ae fc ff ff 49 8b be f0 01 00 00 48 c7 c6 8a 93 11 a0 31 c0 e8 23 81
fe ff <0f> 0b 0f 0b 0f 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 41 57
[   63.830411] RIP  [<ffffffffa008886d>] do_walk_down+0x56d/0x580 [btrfs]
[   63.830417]  RSP <ffff8800b6ccfcb8>
[   63.830420] ---[ end trace ab9a705f0e035cf7 ]---


The problem occurrs reproducable after boot. It occurs with kernel 3.14
as well. It started occuring after I did an "btrfs quota enable", waited
a few days till it finished calculating the quota of the existing
volumes, and then (after realizing how negatively this influences
performance) doing an "btrfs quota disable".
btrfs scrub finishes without checksum errors.

System info:

Linux debian-backup 3.16.2custom #1 SMP Tue Sep 9 17:50:21 CEST 2014
x86_64 GNU/Linux (self-build latest stable kernel)

Btrfs v3.14.1 (from debian I guess)

Label: none  uuid: 240a03ce-7956-432d-a1a1-3183f8ece517
        Total devices 1 FS bytes used 1.64TiB
        devid    1 size 2.00TiB used 1.93TiB path /dev/xvda3

Data, single: total=1.84TiB, used=1.60TiB
System, DUP: total=40.00MiB, used=220.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=44.50GiB, used=42.31GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=408.00KiB

Regards,
Martin
