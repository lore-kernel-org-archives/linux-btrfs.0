Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:33760 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaIGQoy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Sep 2014 12:44:54 -0400
Received: from sal69-4-78-192-172-15.fbxo.proxad.net ([78.192.172.15] helo=boolette)
	by licorne.daevel.fr with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <olivier.bonvalet@daevel.fr>)
	id 1XQfV7-0007dg-3x
	for linux-btrfs@vger.kernel.org; Sun, 07 Sep 2014 18:39:41 +0200
Message-ID: <1410107980.2832.41.camel@localhost>
Subject: Linux 3.14.18 : kernel BUG at fs/btrfs/file.c:890!
From: Olivier Bonvalet <olivier.bonvalet@daevel.fr>
To: linux-btrfs@vger.kernel.org
Date: Sun, 07 Sep 2014 18:39:40 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I still have kernel BUG with recent btrfs fixes :

Sep  6 20:29:12 cm kernel: [ 6987.378592] ------------[ cut here ]------------
Sep  6 20:29:12 cm kernel: [ 6987.378613] kernel BUG at fs/btrfs/file.c:890!
Sep  6 20:29:12 cm kernel: [ 6987.378630] invalid opcode: 0000 [#1] SMP 
Sep  6 20:29:12 cm kernel: [ 6987.378647] Modules linked in: ip6table_mangle nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_DSCP iptable_mangle xt_LOG xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_tables nf_conntrack iTCO_wdt ehci_pci iTCO_vendor_support ehci_hcd i2c_i801 evdev i2c_core lpc_ich mfd_core battery video button btrfs xor raid6_pq dm_mod raid1 md_mod sg sd_mod crc_t10dif crct10dif_common ahci libahci e1000e libata ptp scsi_mod pps_core xhci_hcd fan thermal
Sep  6 20:29:12 cm kernel: [ 6987.378806] CPU: 7 PID: 9462 Comm: btrfs-endio-wri Not tainted 3.14-dae-intel #1
Sep  6 20:29:12 cm kernel: [ 6987.378835] Hardware name: Digicube sas DediCube/DQ77MK, BIOS MKQ7710H.86A.0058.2013.0226.1541 02/26/2013
Sep  6 20:29:12 cm kernel: [ 6987.378868] task: ffff8800d09d9010 ti: ffff8801f5c38000 task.ti: ffff8801f5c38000
Sep  6 20:29:12 cm kernel: [ 6987.378898] RIP: 0010:[<ffffffffa017716f>]  [<ffffffffa017716f>] __btrfs_drop_extents+0x685/0x953 [btrfs]
Sep  6 20:29:12 cm kernel: [ 6987.378947] RSP: 0018:ffff8801f5c39c40  EFLAGS: 00010297
Sep  6 20:29:12 cm kernel: [ 6987.378964] RAX: 0000000020a4f000 RBX: 0000000020a6f000 RCX: 0000000020a4f000
Sep  6 20:29:12 cm kernel: [ 6987.378985] RDX: 0000000000000030 RSI: ffff8801edd8b5a6 RDI: ffff8801edd8b000
Sep  6 20:29:12 cm kernel: [ 6987.379005] RBP: ffff8801da452d60 R08: 0000000000001000 R09: ffff8801f5c39c00
Sep  6 20:29:12 cm kernel: [ 6987.379026] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801f1b42470
Sep  6 20:29:12 cm kernel: [ 6987.379047] R13: 0000000000000000 R14: 00000000000005a6 R15: ffff8800d5543000
Sep  6 20:29:12 cm kernel: [ 6987.379067] FS:  0000000000000000(0000) GS:ffff88021e3c0000(0000) knlGS:0000000000000000
Sep  6 20:29:12 cm kernel: [ 6987.379097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep  6 20:29:12 cm kernel: [ 6987.379115] CR2: 00000000015e06d0 CR3: 000000000160b000 CR4: 00000000001407e0
Sep  6 20:29:12 cm kernel: [ 6987.379135] Stack:
Sep  6 20:29:12 cm kernel: [ 6987.379148]  0000000020800000 0000000020ea4000 0000001200000020 0000000020a4f000
Sep  6 20:29:12 cm kernel: [ 6987.379182]  ffff8800c0f6eba0 00000133f2f16000 ffff8800c11035d8 0000000000000000
Sep  6 20:29:12 cm kernel: [ 6987.379214]  0000001e00000000 0000000000000001 00000000000018f6 000000000000b000
Sep  6 20:29:12 cm kernel: [ 6987.379245] Call Trace:
Sep  6 20:29:12 cm kernel: [ 6987.379262]  [<ffffffff810cee61>] ? ____cache_alloc+0x38/0x271
Sep  6 20:29:12 cm kernel: [ 6987.379289]  [<ffffffffa016acd0>] ? insert_reserved_file_extent.constprop.60+0x85/0x269 [btrfs]
Sep  6 20:29:12 cm kernel: [ 6987.379329]  [<ffffffffa016f1a7>] ? btrfs_finish_ordered_io+0x21d/0x3af [btrfs]
Sep  6 20:29:12 cm kernel: [ 6987.379367]  [<ffffffffa018b40b>] ? worker_loop+0x175/0x4ba [btrfs]
Sep  6 20:29:12 cm kernel: [ 6987.379389]  [<ffffffff81368197>] ? __schedule+0x310/0x47a
Sep  6 20:29:12 cm kernel: [ 6987.379415]  [<ffffffffa018b296>] ? btrfs_queue_worker+0x269/0x269 [btrfs]
Sep  6 20:29:12 cm kernel: [ 6987.379438]  [<ffffffff81046ad3>] ? kthread+0xa7/0xaf
Sep  6 20:29:12 cm kernel: [ 6987.379458]  [<ffffffff81040000>] ? flush_workqueue_prep_pwqs+0xff/0x14f
Sep  6 20:29:12 cm kernel: [ 6987.379480]  [<ffffffff81046a2c>] ? __kthread_parkme+0x5b/0x5b
Sep  6 20:29:12 cm kernel: [ 6987.379500]  [<ffffffff8136eebc>] ? ret_from_fork+0x7c/0xb0
Sep  6 20:29:12 cm kernel: [ 6987.379521]  [<ffffffff81046a2c>] ? __kthread_parkme+0x5b/0x5b
Sep  6 20:29:12 cm kernel: [ 6987.379539] Code: 0f 82 85 01 00 00 83 7c 24 14 00 75 11 8b 7d 40 c7 44 24 14 01 00 00 00 89 7c 24 44 eb 13 8b 54 24 44 03 54 24 14 3b 55 40 74 02 <0f> 0b ff 44 24 14 83 7c 24 48 00 75 2b 80 7c 24 63 00 74 24 48 
Sep  6 20:29:12 cm kernel: [ 6987.379628] RIP  [<ffffffffa017716f>] __btrfs_drop_extents+0x685/0x953 [btrfs]
Sep  6 20:29:12 cm kernel: [ 6987.379666]  RSP <ffff8801f5c39c40>
Sep  6 20:29:12 cm kernel: [ 6987.379824] ---[ end trace 88011934e4908482 ]---

Olivier

PS : I already upload image of this system on 03 september, at
https://daevel.fr/img/btrfs-image.out (5.7GB)
(md5 hash ee5559ab31368aba60c259ce3b5b9504)


