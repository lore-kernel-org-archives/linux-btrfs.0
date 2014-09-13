Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43491 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaIMQpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Sep 2014 12:45:31 -0400
Received: from mfilter25-d.gandi.net (mfilter25-d.gandi.net [217.70.178.153])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 8F5B8A80AF
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 18:45:28 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter25-d.gandi.net (mfilter25-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id nc8JHD5I+M5S for <linux-btrfs@vger.kernel.org>;
	Sat, 13 Sep 2014 18:45:26 +0200 (CEST)
Received: from tethys.localnet (AMontpellier-656-1-400-218.w90-28.abo.wanadoo.fr [90.28.184.218])
	(Authenticated sender: michel@bouissou.net)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B731AA80AC
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Sep 2014 18:45:26 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Kernel BUG during balance with 3.16.2-1-ARCH
Date: Sat, 13 Sep 2014 18:45:13 +0200
Message-ID: <1916043.6h3l6ijslb@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Kernel being 3.16.2-1-ARCH

I had the following kernel bug while running "btrfs balance /" without further 
arguments on my laptop (the command ended in "segmentation fault").

(Another question would be : why does the "btrfs balance" command hold the 
terminal when the work itself seems to be backgrounded...?)

I has to restart the machine brutally, the balance automatically resumed and 
it still twice ended in yet another KERNEL BUG, forcing me to brutally power 
cycle the machine twice again. Nothing made it to syslog these 2 times.

Another reboot and the machine finished the balance without further crashing... 
And now looks quite happy with :


root@tethys:~# btrfs fi sh /dev/mapper/VG1-TETHYS
Label: 'TETHYS'  uuid: 9a1ca6f4-1c1b-4a62-a84b-b388066084dc
        Total devices 1 FS bytes used 594.70GiB
        devid    1 size 845.00GiB used 600.06GiB path /dev/mapper/VG1-TETHYS

Btrfs v3.16


root@tethys:~# btrfs fi df /
Data, single: total=593.00GiB, used=592.32GiB
System, DUP: total=32.00MiB, used=72.00KiB
Metadata, DUP: total=3.50GiB, used=2.38GiB
unknown, single: total=512.00MiB, used=0.00




sept. 13 16:20:01 tethys kernel: ------------[ cut here ]------------
sept. 13 16:20:02 tethys kernel: WARNING: CPU: 3 PID: 2452 at fs/btrfs/extent-
tree.c:876 btrfs_lookup_extent_info+0x471/0x4c0 [btrfs]()
sept. 13 16:20:02 tethys kernel: Modules linked in: md5 fuse ecryptfs 
encrypted_keys sha1_ssse3 sha1_generic hmac trusted tpm ctr ccm uvcvideo btusb 
videobuf2_vmalloc v
sept. 13 16:20:02 tethys kernel:  ecb cbc algif_skcipher af_alg btrfs xor 
raid6_pq dm_crypt dm_mod sd_mod crc_t10dif sr_mod cdrom atkbd libps2 
crct10dif_pclmul crct10di
sept. 13 16:20:02 tethys kernel: CPU: 3 PID: 2452 Comm: btrfs Tainted: P           
O  3.16.2-1-ARCH #1
sept. 13 16:20:02 tethys kernel: Hardware name: TOSHIBA SATELLITE L735/Base 
Board Product Name, BIOS 2.50 06/26/2012
sept. 13 16:20:02 tethys kernel:  0000000000000000 00000000faaf8272 
ffff880123e2f7e8 ffffffff8152afec
sept. 13 16:20:02 tethys kernel:  0000000000000000 ffff880123e2f820 ffffffff8106e45d 
ffff88012f1d9360
sept. 13 16:20:02 tethys kernel:  ffff880123924800 00000159602c4000 
ffff8800763f4780 0000000000000001
sept. 13 16:20:02 tethys kernel: Call Trace:
sept. 13 16:20:03 tethys kernel:  [<ffffffff8152afec>] dump_stack+0x4d/0x6f
sept. 13 16:20:03 tethys kernel:  [<ffffffff8106e45d>] 
warn_slowpath_common+0x7d/0xa0
sept. 13 16:20:03 tethys kernel:  [<ffffffff8106e58a>] 
warn_slowpath_null+0x1a/0x20
sept. 13 16:20:03 tethys kernel:  [<ffffffffa0180a71>] 
btrfs_lookup_extent_info+0x471/0x4c0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa0181315>] walk_down_proc+0x1d5/0x330 
[btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01841e3>] walk_down_tree+0x73/0x110 
[btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa0187d84>] 
btrfs_drop_snapshot+0x3f4/0x7e0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01eda09>] 
merge_reloc_roots+0xe9/0x270 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01edf9e>] 
relocate_block_group+0x40e/0x6d0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01ee446>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01c2383>] 
btrfs_relocate_chunk.isra.28+0x63/0x740 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01708e1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa0175c1d>] ? 
btrfs_search_slot+0x4dd/0xa70 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01bceab>] ? 
release_extent_buffer+0x2b/0xd0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01bd3bf>] ? 
free_extent_buffer+0x4f/0xa0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01c58bb>] btrfs_balance+0x98b/0xf50 
[btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01ccd49>] 
btrfs_ioctl_balance+0x169/0x3c0 [btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffffa01d2428>] btrfs_ioctl+0x588/0x28f0 
[btrfs]
sept. 13 16:20:03 tethys kernel:  [<ffffffff8117d0a2>] ? 
handle_mm_fault+0xa92/0x1090
sept. 13 16:20:03 tethys kernel:  [<ffffffff811cd122>] ? final_putname+0x22/0x50
sept. 13 16:20:03 tethys kernel:  [<ffffffff811d23d2>] ? 
user_path_at_empty+0x72/0xd0
sept. 13 16:20:03 tethys kernel:  [<ffffffff8105c52c>] ? 
__do_page_fault+0x2ec/0x600
sept. 13 16:20:03 tethys kernel:  [<ffffffff81180a21>] ? vma_link+0xc1/0xd0
sept. 13 16:20:03 tethys kernel:  [<ffffffff811a5e0a>] ? 
kmem_cache_alloc+0x16a/0x170
sept. 13 16:20:03 tethys kernel:  [<ffffffff811d4a70>] do_vfs_ioctl+0x2d0/0x4b0
sept. 13 16:20:03 tethys kernel:  [<ffffffff811d4cd1>] SyS_ioctl+0x81/0xa0
sept. 13 16:20:03 tethys kernel:  [<ffffffff81530d69>] 
system_call_fastpath+0x16/0x1b
sept. 13 16:20:03 tethys kernel: ---[ end trace 0d167f9224a7341b ]---



sept. 13 16:20:03 tethys kernel: ------------[ cut here ]------------
sept. 13 16:20:03 tethys kernel: kernel BUG at fs/btrfs/extent-tree.c:7519!
sept. 13 16:20:03 tethys kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
sept. 13 16:20:04 tethys kernel: Modules linked in: md5 fuse ecryptfs 
encrypted_keys sha1_ssse3 sha1_generic hmac trusted tpm ctr ccm uvcvideo btusb 
videobuf2_vmalloc v
sept. 13 16:20:04 tethys kernel:  ecb cbc algif_skcipher af_alg btrfs xor 
raid6_pq dm_crypt dm_mod sd_mod crc_t10dif sr_mod cdrom atkbd libps2 
crct10dif_pclmul crct10di
sept. 13 16:20:04 tethys kernel: CPU: 3 PID: 2452 Comm: btrfs Tainted: P        
W  O  3.16.2-1-ARCH #1
sept. 13 16:20:04 tethys kernel: Hardware name: TOSHIBA SATELLITE L735/Base 
Board Product Name, BIOS 2.50 06/26/2012
sept. 13 16:20:04 tethys kernel: task: ffff8801481c1460 ti: ffff880123e2c000 
task.ti: ffff880123e2c000
sept. 13 16:20:04 tethys kernel: RIP: 0010:[<ffffffffa0181457>]  [<ffffffffa0181457>] 
walk_down_proc+0x317/0x330 [btrfs]
sept. 13 16:20:04 tethys kernel: RSP: 0018:ffff880123e2f8e8  EFLAGS: 00010246
sept. 13 16:20:04 tethys kernel: RAX: 0000000000000000 RBX: ffff88013306a540 
RCX: 0000000000000000
sept. 13 16:20:04 tethys kernel: RDX: 00000000c4052b03 RSI: ffff88012f1d9360 
RDI: ffffffffa0170a66
sept. 13 16:20:04 tethys kernel: RBP: ffff880123e2f928 R08: 000000000001c060 
R09: ffff880037a72300
sept. 13 16:20:04 tethys kernel: R10: ffff880123924800 R11: ffff8800763f4780 R12: 
0000000000000002
sept. 13 16:20:04 tethys kernel: R13: ffff88012f1d9480 R14: ffff88001a71a6f0 R15: 
0000000000000002
sept. 13 16:20:04 tethys kernel: FS:  00007fc5c3b76880(0000) 
GS:ffff88014f4c0000(0000) knlGS:0000000000000000
sept. 13 16:20:04 tethys kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
sept. 13 16:20:04 tethys kernel: CR2: 00007f5d86a75000 CR3: 0000000123e57000 
CR4: 00000000000407e0
sept. 13 16:20:04 tethys kernel: Stack:
sept. 13 16:20:04 tethys kernel:  ffff88013306a590 ffff880123924800 ffff8800763f4780 
ffff88012f1d9480
sept. 13 16:20:04 tethys kernel:  0000000000000002 ffff88013306a540 
ffff8801239249df ffff880123924800
sept. 13 16:20:04 tethys kernel:  ffff880123e2f978 ffffffffa01841e3 ffff8800763f4780 
0000000123924800
sept. 13 16:20:04 tethys kernel: Call Trace:
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01841e3>] walk_down_tree+0x73/0x110 
[btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa0187d84>] 
btrfs_drop_snapshot+0x3f4/0x7e0 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01eda09>] 
merge_reloc_roots+0xe9/0x270 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01edf9e>] 
relocate_block_group+0x40e/0x6d0 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01ee446>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01c2383>] 
btrfs_relocate_chunk.isra.28+0x63/0x740 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01708e1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa0175c1d>] ? 
btrfs_search_slot+0x4dd/0xa70 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01bceab>] ? 
release_extent_buffer+0x2b/0xd0 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01bd3bf>] ? 
free_extent_buffer+0x4f/0xa0 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01c58bb>] btrfs_balance+0x98b/0xf50 
[btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01ccd49>] 
btrfs_ioctl_balance+0x169/0x3c0 [btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffffa01d2428>] btrfs_ioctl+0x588/0x28f0 
[btrfs]
sept. 13 16:20:04 tethys kernel:  [<ffffffff8117d0a2>] ? 
handle_mm_fault+0xa92/0x1090
sept. 13 16:20:04 tethys kernel:  [<ffffffff811cd122>] ? final_putname+0x22/0x50
sept. 13 16:20:04 tethys kernel:  [<ffffffff811d23d2>] ? 
user_path_at_empty+0x72/0xd0
sept. 13 16:20:04 tethys kernel:  [<ffffffff8105c52c>] ? 
__do_page_fault+0x2ec/0x600
sept. 13 16:20:04 tethys kernel:  [<ffffffff81180a21>] ? vma_link+0xc1/0xd0
sept. 13 16:20:04 tethys kernel:  [<ffffffff811a5e0a>] ? 
kmem_cache_alloc+0x16a/0x170
sept. 13 16:20:04 tethys kernel:  [<ffffffff811d4a70>] do_vfs_ioctl+0x2d0/0x4b0
sept. 13 16:20:04 tethys kernel:  [<ffffffff811d4cd1>] SyS_ioctl+0x81/0xa0
sept. 13 16:20:04 tethys kernel:  [<ffffffff81530d69>] 
system_call_fastpath+0x16/0x1b
sept. 13 16:20:04 tethys kernel: Code: 20 38 05 00 e9 78 fe ff ff 0f 1f 00 0f 0b 
66 0f 1f 44 00 00 0f 0b 66 0f 1f 44 00 00 0f 0b 4c 89 f7 e8 ae 3a 05 00 8b 45 
d0 eb aa 
sept. 13 16:20:04 tethys kernel: RIP  [<ffffffffa0181457>] 
walk_down_proc+0x317/0x330 [btrfs]
-- Reboot --


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

