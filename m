Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:49765 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaICMJq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 08:09:46 -0400
Received: from local.plusdinfo.com ([82.232.160.30] helo=olivierb.plug)
	by licorne.daevel.fr with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <ob@daevel.fr>)
	id 1XP9Ic-0003aO-Ch
	for linux-btrfs@vger.kernel.org; Wed, 03 Sep 2014 14:04:30 +0200
Message-ID: <1409745869.21602.21.camel@localhost>
Subject: kernel BUG at fs/btrfs/relocation.c:1065 in 3.14.16 to 3.17-rc3
From: Olivier Bonvalet <ob@daevel.fr>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Wed, 03 Sep 2014 14:04:29 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs partition which throw kernel BUG, even with linux
3.17-rc3 (I tried 3.14.16, 3.16.1 and 3.17-rc3 kernels) :

[   45.058466] ------------[ cut here ]------------
[   45.058539] kernel BUG at fs/btrfs/relocation.c:1065!
[   45.058578] invalid opcode: 0000 [#1] SMP 
[   45.058655] Modules linked in: nf_conntrack iTCO_wdt iTCO_vendor_support i2c_i801 lpc_ich ehci_pci i2ccore ehci_hcd mfd_core evdev battery ie31200_edac edac_core video button btrfs xor raid6_pq dm_mod raid1 md_mod sg sd_mod crc_t10dif crct10dif_common thermal ahci libahci libata scsi_mod xhci_hcd e1000e fan ptp pps_core
[   45.059500] CPU: 2 PID: 1740 Comm: btrfs-balance Not tainted 3.17-rc3-dae-intel #1
[   45.059550] Hardware name: Digicube sas DediCube/DQ77MK, BIOS MKQ7710H.86A.0058.2013.0226.1541 02/26/2013
[   45.059602] task: ffff8802151c17e0 ti: ffff8802105ec000 task.ti: ffff8802105ec000
[   45.059652] RIP: 0010:[<ffffffffa019fcf8>]  [<ffffffffa019fcf8>] build_backref_tree+0xa3d/0xcf6 [btrfs]
[   45.059739] RSP: 0018:ffff8802105efaf0  EFLAGS: 00010246
[   45.059776] RAX: ffff8802105efb00 RBX: ffff880213b83800 RCX: ffff880210565d10
[   45.059816] RDX: ffff8802105efb68 RSI: ffff8802105efb68 RDI: ffff880210565d10
[   45.059857] RBP: ffff880210565d10 R08: ffff88021313fc40 R09: 0000000000001000
[   45.059896] R10: 0000160000000000 R11: 6db6db6db6db6db7 R12: ffff8800d114d310
[   45.059937] R13: ffff8802105efb78 R14: ffff8800d114d2c0 R15: ffff88021313fc40
[   45.059977] FS:  0000000000000000(0000) GS:ffff88021e280000(0000) knlGS:0000000000000000
[   45.060028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.060066] CR2: 00007f2fc9c649b8 CR3: 0000000001611000 CR4: 00000000001407e0
[   45.060105] Stack:
[   45.060138]  ffff88021d5fc890 ffff88021417d890 0000000000000000 ffff8802105efb68
[   45.060264]  0000000100000005 ffff880213b83920 ffff8802105efb78 00ffffffa015ecd1
[   45.060392]  ffff8800d114d400 ffff8800d114d240 ffff880210464220 ffff880210565d40
[   45.060516] Call Trace:
[   45.060556]  [<ffffffffa01a11ff>] ? relocate_tree_blocks+0x15f/0x430 [btrfs]
[   45.060607]  [<ffffffffa019cd78>] ? tree_insert+0x44/0x47 [btrfs]
[   45.060656]  [<ffffffffa019e2ba>] ? add_tree_block+0x112/0x13c [btrfs]
[   45.060702]  [<ffffffffa01a1ff7>] ? relocate_block_group+0x26d/0x4a6 [btrfs]
[   45.060753]  [<ffffffffa0179014>] ? btrfs_wait_ordered_roots+0x18f/0x1ab [btrfs]
[   45.060812]  [<ffffffffa01a2384>] ? btrfs_relocate_block_group+0x154/0x265 [btrfs]
[   45.060872]  [<ffffffffa0181d01>] ? btrfs_relocate_chunk.isra.29+0x52/0x55d [btrfs]
[   45.060932]  [<ffffffffa018fdc8>] ? btrfs_set_lock_blocking_rw+0xa8/0xaa [btrfs]
[   45.060988]  [<ffffffffa0145680>] ? btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
[   45.061039]  [<ffffffffa017767f>] ? btrfs_get_token_64+0x75/0xcf [btrfs]
[   45.061088]  [<ffffffffa017e201>] ? release_extent_buffer+0x26/0x96 [btrfs]
[   45.061170]  [<ffffffffa0184965>] ? btrfs_balance+0x9e3/0xb78 [btrfs]
[   45.061263]  [<ffffffffa0184afa>] ? btrfs_balance+0xb78/0xb78 [btrfs]
[   45.061314]  [<ffffffffa0184b49>] ? balance_kthread+0x4f/0x6d [btrfs]
[   45.061360]  [<ffffffff8104704b>] ? kthread+0xa7/0xaf
[   45.061420]  [<ffffffff81040000>] ? SyS_old_getrlimit+0x21/0xcb
[   45.061460]  [<ffffffff81046fa4>] ? __kthread_parkme+0x5b/0x5b
[   45.061501]  [<ffffffff813834ec>] ? ret_from_fork+0x7c/0xb0
[   45.061541]  [<ffffffff81046fa4>] ? __kthread_parkme+0x5b/0x5b
[   45.061579] Code: 26 a8 02 74 0d 4c 89 e7 e8 3c e1 ff ff 41 80 66 71 fd 49 8b 46 58 49 89 6e 58 4c 89 65 00 48 89 45 08 48 89 28 eb c0 a8 10 75 02 <0f> 0b 83 e0 01 39 44 24 10 0f 84 20 ff ff ff 0f 0b 49 8b 46 58 
[   45.063148] RIP  [<ffffffffa019fcf8>] build_backref_tree+0xa3d/0xcf6 [btrfs]
[   45.063219]  RSP <ffff8802105efaf0>
[   45.063260] ---[ end trace c396e96e4d1a5697 ]---

I have dump the FS with btrfs-image, but don't know where to push that.
So you can download it at : https://daevel.fr/img/btrfs-image.out
(near 6GB, md5sum ee5559ab31368aba60c259ce3b5b9504)

