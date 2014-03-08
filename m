Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41115 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaCHHgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 02:36:11 -0500
Received: from mfilter23-d.gandi.net (mfilter23-d.gandi.net [217.70.178.151])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id E434841C04F
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Mar 2014 08:36:08 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter23-d.gandi.net (mfilter23-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id MNrc8ALA1n42 for <linux-btrfs@vger.kernel.org>;
	Sat,  8 Mar 2014 08:36:07 +0100 (CET)
Received: from tethys.localnet (AMontpellier-256-1-106-82.w90-28.abo.wanadoo.fr [90.28.161.82])
	(Authenticated sender: michel@bouissou.net)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 3287E41C051
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Mar 2014 08:36:06 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Kernel BUG: btrfs send - Incremental backup
Date: Sat, 08 Mar 2014 08:35:17 +0100
Message-ID: <2853810.EcqZt5vpol@tethys>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I tried to perform an incremental backup as described in 
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup  between 2 external 
USB drives,

The 1st "btrfs send foo/snap1 | btrfs receive bar" went well, although it took 
5-6 times the time the same workload takes in ZFS.

Then "btrfs send -v -p foo/snap1 foo/snap2 | btrfs receive bar" crashed on me.

After a reboot and retry, I get a KERNEL BUG again :


# uname -a
Linux tethys 3.13.5-1-ARCH #1 SMP PREEMPT Sun Feb 23 00:25:24 CET 2014 x86_64 
GNU/Linux

btrfs send -v -p foo/snap1 foo/snap2 | btrfs receive bar


mars 08 08:22:01 tethys kernel: ------------[ cut here ]------------
mars 08 08:22:01 tethys kernel: kernel BUG at fs/btrfs/send.c:4398!
mars 08 08:22:02 tethys kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
mars 08 08:22:02 tethys kernel: Modules linked in: usb_storage md5 fuse ecb 
ecryptfs encrypted_keys hmac trusted tpm ctr ccm intel_rapl 
x86_pkg_temp_thermal rts5139(C) 
mars 08 08:22:02 tethys kernel:  usbhid hid sr_mod cdrom sd_mod atkbd libps2 
crct10dif_pclmul crct10dif_common crc32_pclmul ahci crc32c_intel 
ghash_clmulni_intel libahc
mars 08 08:22:02 tethys kernel: CPU: 0 PID: 2432 Comm: btrfs Tainted: P         
C O 3.13.5-1-ARCH #1
mars 08 08:22:02 tethys kernel: Hardware name: TOSHIBA SATELLITE L735/Base 
Board Product Name, BIOS 2.50 06/26/2012
mars 08 08:22:02 tethys kernel: task: ffff880041724800 ti: ffff88003b84a000 
task.ti: ffff88003b84a000
mars 08 08:22:02 tethys kernel: RIP: 0010:[<ffffffffa0363ba5>]  [<ffffffffa0363ba5>] 
changed_cb+0x9e5/0x9f0 [btrfs]
mars 08 08:22:02 tethys kernel: RSP: 0018:ffff88003b84bb48  EFLAGS: 00010283
mars 08 08:22:02 tethys kernel: RAX: 00000000000579d5 RBX: ffff88013279ea00 RCX: 
0000000000000060
mars 08 08:22:02 tethys kernel: RDX: ffff88003b84bc65 RSI: 00000000000579cd RDI: 
ffff88013279ea00
mars 08 08:22:02 tethys kernel: RBP: ffff88003b84bbe0 R08: ffff88003b84bc65 R09: 
0000000000000002
mars 08 08:22:02 tethys kernel: R10: ffff88005981a900 R11: 0000000000000000 R12: 
0000000000000002
mars 08 08:22:02 tethys kernel: R13: ffff88003b84bc65 R14: ffff88007c628800 R15: 
0000000000002ad1
mars 08 08:22:02 tethys kernel: FS:  00007fceade62880(0000) 
GS:ffff88014f400000(0000) knlGS:0000000000000000
mars 08 08:22:02 tethys kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
mars 08 08:22:02 tethys kernel: CR2: 00007fb4cc8c8000 CR3: 0000000041a99000 
CR4: 00000000000407f0
mars 08 08:22:02 tethys kernel: Stack:
mars 08 08:22:02 tethys kernel:  ffff88003b84bb88 ffffffffa03206ec 00000000000008ca 
ffff88005981a900
mars 08 08:22:02 tethys kernel:  0000000000000000 ffff88005981a900 
ffff88005981a870 0000000000000000
mars 08 08:22:02 tethys kernel:  ffff88003b84bbe0 ffffffffa03161e9 ffff88003b84bc76 
ffff88003b84bbe0
mars 08 08:22:02 tethys kernel: Call Trace:
mars 08 08:22:02 tethys kernel:  [<ffffffffa03206ec>] ? 
read_extent_buffer+0xbc/0x110 [btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffffa03161e9>] ? 
btrfs_get_token_32+0x59/0xe0 [btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffffa0320e81>] ? 
memcmp_extent_buffer+0xc1/0x120 [btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffffa02e1b10>] 
btrfs_compare_trees+0x790/0x970 [btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffffa03631c0>] ? 
finish_inode_if_needed+0x4e0/0x4e0 [btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffffa0364568>] btrfs_ioctl_send+0x8a8/0xc80 
[btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffffa0332afe>] btrfs_ioctl+0xfee/0x27a0 
[btrfs]
mars 08 08:22:02 tethys kernel:  [<ffffffff81096bc8>] ? __enqueue_entity+0x78/0x80
mars 08 08:22:02 tethys kernel:  [<ffffffff8109c6cb>] ? enqueue_entity+0x29b/0xa10
mars 08 08:22:02 tethys kernel:  [<ffffffff8109cf47>] ? 
enqueue_task_fair+0x107/0x540
mars 08 08:22:02 tethys kernel:  [<ffffffff8108f45a>] ? enqueue_task+0x3a/0x60
mars 08 08:22:02 tethys kernel:  [<ffffffff810902c5>] ? 
check_preempt_curr+0x75/0xa0
mars 08 08:22:02 tethys kernel:  [<ffffffff811b5fe0>] do_vfs_ioctl+0x2e0/0x4c0
mars 08 08:22:02 tethys kernel:  [<ffffffff81060d0f>] ? do_fork+0x12f/0x320
mars 08 08:22:02 tethys kernel:  [<ffffffff811b6241>] SyS_ioctl+0x81/0xa0
mars 08 08:22:02 tethys kernel:  [<ffffffff8152142d>] 
system_call_fastpath+0x1a/0x1f
mars 08 08:22:02 tethys kernel: Code: 48 8d 75 b6 45 31 c0 b9 01 00 00 00 4c 
89 e2 4c 89 f7 e8 2f eb f7 ff 85 c0 0f 89 77 ff ff ff e9 a0 fd ff ff 31 c0 e9 99 fd 
ff ff <
mars 08 08:22:02 tethys kernel: RIP  [<ffffffffa0363ba5>] changed_cb+0x9e5/0x9f0 
[btrfs]
mars 08 08:22:02 tethys kernel:  RSP <ffff88003b84bb48>
mars 08 08:22:02 tethys kernel: ---[ end trace 718b3fc11b4d9241 ]---


HTH, TIA.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

